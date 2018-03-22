DOCKER_DIR=	docker
DOCKER_WORKDIR=	/home/bob
DOCKER_IMAGE=	builder
DOCKER_USER=	bob

LINUX_BRANCH=		v3.14.14.access-is
LINUX_REPO_NAME=	val100-linux
LINUX_REPO_URL=		https://github.com/kirei/$(LINUX_REPO_NAME)
LINUX_ZIP_URL=		https://codeload.github.com/kirei/$(LINUX_REPO_NAME)/zip/$(LINUX_BRANCH)
LINUX_ZIP_FILE=		linux.zip
LINUX_DIR=		$(DOCKER_DIR)/linux

BUILDROOT_BRANCH=	2015.05.access-is
BUILDROOT_REPO_NAME=	val100-buildroot
BUILDROOT_REPO_URL=	https://github.com/kirei/$(BUILDROOT_REPO_NAME)
BUILDROOT_ZIP_URL=	https://codeload.github.com/kirei/$(BUILDROOT_REPO_NAME)/zip/$(BUILDROOT_BRANCH)
BUILDROOT_ZIP_FILE=	buildroot.zip
BUILDROOT_DIR=		$(DOCKER_DIR)/buildroot


all: extract container

extract: linux buildroot

fetch: $(LINUX_ZIP_FILE) $(BUILDROOT_ZIP_FILE)

linux: $(LINUX_DIR)

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

$(LINUX_DIR): $(DOCKER_DIR) $(LINUX_ZIP_FILE)
	#git clone --single-branch --branch $(LINUX_BRANCH) $(LINUX_REPO_URL) $(LINUX_DIR)
	unzip -d $(DOCKER_DIR) $(LINUX_ZIP_FILE)
	mv $(DOCKER_DIR)/$(LINUX_REPO_NAME)-* $(DOCKER_DIR)/linux


$(BUILDROOT_DIR): $(DOCKER_DIR) $(BUILDROOT_ZIP_FILE)
	#git clone --single-branch --branch $(BUILDROOT_BRANCH) $(BUILDROOT_REPO_URL) $(BUILDROOT_DIR)
	unzip -d $(DOCKER_DIR) $(BUILDROOT_ZIP_FILE)
	mv $(DOCKER_DIR)/$(BUILDROOT_REPO_NAME)-* $(DOCKER_DIR)/buildroot

$(LINUX_ZIP_FILE):
	curl -o $@ $(LINUX_ZIP_URL)

$(BUILDROOT_ZIP_FILE):
	curl -o $@ $(BUILDROOT_ZIP_URL)

clean:
	rm -fr $(LINUX_DIR)
	rm -fr $(BUILDROOT_DIR)
	rm -fr $(DOCKER_DIR)

realclean: clean
	rm -f *.zip
