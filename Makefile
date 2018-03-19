DOCKER_DIR=	docker
DOCKER_WORKDIR=	/home/bob
DOCKER_IMAGE=	builder
DOCKER_USER=	bob

SOURCE_VERSION=		3.14.14
SOURCE_URL=		https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-$(SOURCE_VERSION).tar.gz
SOURCE_TGZ=		linux-$(SOURCE_VERSION).tar.gz
SOURCE_DIR=		$(DOCKER_DIR)/linux-$(SOURCE_VERSION)

BUILDROOT_REPO=		https://github.com/kirei/val100-buildroot
BUILDROOT_BRANCH=	2015.05.access-is
BUILDROOT_DIR=		$(DOCKER_DIR)/buildroot
BUILDROOT_WORKDIR=	/usr/src/buildroot

PATCH_URL=	http://downloads.access-is.com/Vasttrafik/access_val130.zip
PATCH_ZIP=	access_val130.zip
PATCH_FILE=	access_val130.patch

CLEANFILES=	$(SOURCE_TGZ) $(PATCH_ZIP) $(PATCH_FILE)


all: fetch extract patch

fetch: $(SOURCE_TGZ) $(PATCH_ZIP)

extract: source buildroot

patch: $(SOURCE_DIR) $(PATCH_FILE)
	-(cd $(SOURCE_DIR); patch -p2 -f < ../../$(PATCH_FILE))

source: $(SOURCE_DIR)

buildroot: $(BUILDROOT_DIR)

$(DOCKER_DIR):
	mkdir $(DOCKER_DIR)

container: $(DOCKER_DIR) buildroot
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

$(BUILDROOT_DIR): $(DOCKER_DIR)
	git clone --single-branch --branch $(BUILDROOT_BRANCH) $(BUILDROOT_REPO) $(BUILDROOT_DIR)

$(PATCH_ZIP):
	curl -o $@ $(PATCH_URL)

$(PATCH_FILE): $(PATCH_ZIP)
	unzip $(PATCH_ZIP)

clean:
	rm -fr $(DOCKER_DIR)
	rm -fr $(SOURCE_DIR)
	rm -f $(PATCH_FILE)

realclean: clean
	rm -f $(CLEANFILES)
