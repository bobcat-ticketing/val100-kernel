DOCKER_DIR=	docker
DOCKER_WORKDIR=	/usr/src/linux
DOCKER_IMAGE=	builder
DOCKER_USER=	bob

SOURCE_VERSION=		3.14.14
SOURCE_URL=		https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-$(SOURCE_VERSION).tar.gz
SOURCE_TGZ=		linux-$(SOURCE_VERSION).tar.gz
SOURCE_DIR=		$(DOCKER_DIR)/linux-$(SOURCE_VERSION)

BUILDROOT_VERSION=	2015.05
BUILDROOT_URL=		https://buildroot.org/downloads/buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_TGZ=		buildroot-$(BUILDROOT_VERSION).tar.gz
BUILDROOT_DIR=		$(DOCKER_DIR)/buildroot-$(BUILDROOT_VERSION)
BUILDROOT_WORKDIR=	/usr/src/buildroot

PATCH_URL=	http://downloads.access-is.com/Vasttrafik/access_val130.zip
PATCH_ZIP=	access_val130.zip
PATCH_FILE=	access_val130.patch

DOCKER_DIR=	docker
DOCKER_WORKDIR=	/home/bob
DOCKER_IMAGE=	builder
DOCKER_USER=	bob

KERNEL_CONFIG=	val100_kernel_config.txt

CLEANFILES=	$(SOURCE_TGZ) $(PATCH_ZIP) $(PATCH_FILE)


all: fetch extract patch

fetch: $(SOURCE_TGZ) $(PATCH_ZIP) $(BUILDROOT_TGZ)

extract: $(SOURCE_DIR) $(BUILDROOT_DIR)

patch: $(SOURCE_DIR) $(PATCH_FILE)
	-(cd $(SOURCE_DIR); patch -p2 -f < ../../$(PATCH_FILE))

$(DOCKER_DIR):
	mkdir $(DOCKER_DIR)

container: $(DOCKER_DIR)
	cp Dockerfile build.sh val*.txt $(DOCKER_DIR)
	docker build -t $(DOCKER_IMAGE) $(DOCKER_DIR)

compile:
	docker run -it --rm \
		--user $(DOCKER_USER) \
		--workdir $(DOCKER_WORKDIR) \
		 $(DOCKER_IMAGE) /bin/bash

$(SOURCE_TGZ):
	curl -o $@ $(SOURCE_URL)

$(SOURCE_DIR): $(SOURCE_TGZ) $(DOCKER_DIR)
	tar --extract --gunzip -C $(DOCKER_DIR) -f $(SOURCE_TGZ)

$(BUILDROOT_TGZ):
	curl -o $@ $(BUILDROOT_URL)

$(BUILDROOT_DIR): $(BUILDROOT_TGZ) $(DOCKER_DIR)
	tar --extract --gunzip -C $(DOCKER_DIR) -f $(BUILDROOT_TGZ)

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
