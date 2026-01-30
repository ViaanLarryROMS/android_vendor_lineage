# ===============================
# Project Aether versioning
# ===============================

PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 2

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Build type handling (keep Lineage logic)
ifndef LINEAGE_BUILDTYPE
    ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^LINEAGE_||g')
        LINEAGE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Force sane build types
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LINEAGE_BUILDTYPE)),)
    LINEAGE_BUILDTYPE := UNOFFICIAL
    LINEAGE_EXTRAVERSION :=
endif

ifeq ($(LINEAGE_BUILDTYPE),UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        LINEAGE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

# This is where ZIP name & version string come from
LINEAGE_VERSION_SUFFIX := \
    $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)$(LINEAGE_EXTRAVERSION)-$(LINEAGE_BUILD)

# Internal version (used by updater / props)
LINEAGE_VERSION := \
    $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# Display version (About phone)
LINEAGE_DISPLAY_VERSION := \
    Project-Aether-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)

# System properties (branding)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aether.name=Project-Aether \
    ro.aether.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.aether.releasetype=$(LINEAGE_BUILDTYPE) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
