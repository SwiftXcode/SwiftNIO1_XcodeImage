# Makefile
# Copyright © 2018 ZeeZide GmbH. All rights reserved.

include /usr/local/lib/swift-xcode/makefiles/swift-xcode-config.make

ifeq ($(SWIFT_ABI_LIB_INSTALL_DIR),)
  # macOS seems to use this for modmaps: /usr/lib/swift/macosx/x86_64/
  # and this for the dylibs: /usr/lib/swift/macosx/
  # FIXME: we changed this to the TARGET, needs to be:
  #   /usr/local/lib/swift4.0/x86_64-apple-macosx10.13
  # and we need to allow configuration on what we build for.
  SWIFT_ABI_LIB_INSTALL_DIR=$(prefix)/lib/$(SWIFT_ABI_RELDIR)/$(TARGET)
endif
