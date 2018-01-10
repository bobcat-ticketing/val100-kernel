VERSION=	3.14.14

SOURCE_URL=	https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-$(VERSION).tar.gz
SOURCE_TGZ=	linux-$(VERSION).tar.gz
SOURCE_DIR=	linux-$(VERSION)

PATCH_URL=	http://downloads.access-is.com/Vasttrafik/access_val130.zip
PATCH_ZIP=	access_val130.zip
PATCH_FILE=	access_val130.patch

KERNEL_CONFIG=	val100_kernel_config

CLEANFILES=	$(SOURCE_TGZ) $(PATCH_ZIP) $(PATCH_FILE)


all: fetch patch

fetch: $(SOURCE_TGZ) $(PATCH_ZIP)

extract: $(SOURCE_DIR)

patch: $(SOURCE_DIR) $(PATCH_FILE)
	-(cd $(SOURCE_DIR); patch -p2 -f < ../$(PATCH_FILE))
	cp $(KERNEL_CONFIG) $(SOURCE_DIR)/.config

$(SOURCE_TGZ):
	curl -o $@ $(SOURCE_URL)

$(SOURCE_DIR): $(SOURCE_TGZ)
	tar xzf $(SOURCE_TGZ)

$(PATCH_ZIP):
	curl -o $@ $(PATCH_URL)

$(PATCH_FILE):
	unzip $(PATCH_ZIP)

clean:
	rm -fr $(SOURCE_DIR)
	rm -f $(PATCH_FILE)

realclean: clean
	rm -f $(CLEANFILES)
