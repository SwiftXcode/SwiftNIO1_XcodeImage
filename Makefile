# Makefile
# Copyright © 2018-2019 ZeeZide GmbH. All rights reserved.

include config.make

PACKAGE = SwiftNIO1
MAJOR=0
MINOR=9
SUBMINOR=7

PACKAGE_TARBALL_NAME=$(PACKAGE)-$(MAJOR).$(MINOR).$(SUBMINOR).image
PACKAGE_TARBALL_LATEST=$(PACKAGE).image
PACKAGE_TARBALL=$(SWIFT_BUILD_DIR)/$(PACKAGE_TARBALL_LATEST)

PROJECT_SERVER_TEMPLATES_DIR = templates/Project\ Templates/Server
FILE_SERVER_TEMPLATES_DIR    = templates/File\ Templates/Server


# entry points

all : build-image

clean : clean-image

distclean : clean
	rm -rf .build Package.resolved


install : all install-templates install-image

uninstall : uninstall-templates uninstall-image

lint : lint-templates


resolve :
	rm -rf Package.resolved
	rm -rf .build
	swift package resolve

# image

# SWIFT_XCODE_IMAGING=yes swift xcode build
build-image :
	SA_IMAGE=$(PACKAGE) swift xcode image

clean-image:
	swift xcode clean

install-image: all make-abi-install-dir
	$(INSTALL) $(PACKAGE_TARBALL) $(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_NAME)
	( cd $(SWIFT_ABI_LIB_INSTALL_DIR); \
	  ln -sf $(PACKAGE_TARBALL_NAME) $(PACKAGE_TARBALL_LATEST) )

uninstall-image:
	rm -f "$(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_NAME)"
	rm -f "$(SWIFT_ABI_LIB_INSTALL_DIR)/$(PACKAGE_TARBALL_LATEST)"

make-abi-install-dir :
	$(MKDIR_P) $(SWIFT_ABI_LIB_INSTALL_DIR)


# templates
#
#   this is a little crappy, but I couldn't figure our how to deal properly
#   with spaces in Makefiles ;-)

lint-templates :
	$(XML_LINTER) $(PROJECT_SERVER_TEMPLATES_DIR)/Swift\ NIO.xctemplate/TemplateInfo.plist

install-templates : lint-templates \
	install-project-server-templates	\
	install-file-server-templates
	swift-xcode-link-templates --replacedirs

uninstall-templates : \
	uninstall-project-server-templates	\
	uninstall-file-server-templates
	swift-xcode-link-templates --deletelinks


install-project-server-templates : uninstall-project-server-templates
	$(MKDIR_P) $(XCODE_TEMPLATE_PROJECT_SERVER_SOURCE_DIR)
	$(INSTALL_R) \
		$(PROJECT_SERVER_TEMPLATES_DIR)/Swift\ NIO.xctemplate \
		$(XCODE_TEMPLATE_PROJECT_SERVER_SOURCE_DIR)/

uninstall-project-server-templates :
	$(UNINSTALL_R) \
		$(XCODE_TEMPLATE_PROJECT_SERVER_SOURCE_DIR)/Swift\ NIO.xctemplate

install-file-server-templates : uninstall-file-server-templates

uninstall-file-server-templates :
