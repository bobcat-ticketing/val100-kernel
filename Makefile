VERSION=	3.14.14

SOURCE_URL=	https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-$(VERSION).tar.gz
SOURCE_TGZ=	linux-$(VERSION).tar.gz
SOURCE_DIR=	linux-$(VERSION)

PATCH_URL=	http://downloads.access-is.com/Vasttrafik/access_val130.zip
PATCH_ZIP=	access_val130.zip
PATCH_FILE=	access_val130.patch

DOCKER_DIR=	docker
DOCKER_WORKDIR=	/usr/src/linux
DOCKER_IMAGE=	builder
DOCKER_USER=	root

KERNEL_CONFIG=	val100_kernel_config.txt

CLEANFILES=	$(SOURCE_TGZ) $(PATCH_ZIP) $(PATCH_FILE)


all: fetch patch

fetch: $(SOURCE_TGZ) $(PATCH_ZIP)

extract: $(SOURCE_DIR)

patch: $(SOURCE_DIR) $(PATCH_FILE)
	-(cd $(SOURCE_DIR); patch -p2 -f < ../$(PATCH_FILE))
	-(cd $(SOURCE_DIR)/include/linux; ln -s compiler-gcc4.h compiler-gcc6.h)
	cp $(KERNEL_CONFIG) $(SOURCE_DIR)/.config
	(cd $(SOURCE_DIR); make savedefconfig)

$(DOCKER_DIR):
	mkdir $(DOCKER_DIR)

container: $(DOCKER_DIR)
	cp Dockerfile $(DOCKER_DIR)
	docker build -t $(DOCKER_IMAGE) $(DOCKER_DIR)

compile:
	docker run -it --rm \
		--user $(DOCKER_USER) \
		--volume `pwd`/$(SOURCE_DIR):$(DOCKER_WORKDIR) \
		--workdir $(DOCKER_WORKDIR) \
		 $(DOCKER_IMAGE) /bin/bash

$(SOURCE_TGZ):
	curl -o $@ $(SOURCE_URL)

$(SOURCE_DIR): $(SOURCE_TGZ)
	tar xzf $(SOURCE_TGZ)

$(PATCH_ZIP):
	curl -o $@ $(PATCH_URL)

$(PATCH_FILE): $(PATCH_ZIP)
	unzip $(PATCH_ZIP)

clean:
	rm -fr $(SOURCE_DIR)
	rm -fr $(DOCKER_DIR)
	rm -f $(PATCH_FILE)

realclean: clean
	rm -f $(CLEANFILES)
