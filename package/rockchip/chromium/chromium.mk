################################################################################
#
# Chromium
#
################################################################################
CHROMIUM_VERSION = 79.0.3945.79
CHROMIUM_SITE_METHOD = local
CHROMIUM_SITE = $(TOPDIR)/../external/chromium

CHROMIUM_WRAPPER_EXTRA_ARGS=CHROME_EXTRA_ARGS+=" --no-sandbox --gpu-sandbox-start-early --ignore-gpu-blacklist --disable-features=TranslateUI"

ifeq ($(call qstrip,$(BR2_ARCH)),arm)
    CHROMIUM_ARCH := armhf
endif

ifeq ($(call qstrip,$(BR2_ARCH)),aarch64)
    CHROMIUM_ARCH := aarch64
endif

define CHROMIUM_INSTALL_TARGET_CMDS
    touch $(TARGET_DIR)/dev/video-dec0
    tar zxvf $(@D)/chromium-ozone-wayland_79.0.3945.79/$(BR2_ARCH)/chromium-ozone-wayland_$(CHROMIUM_ARCH).tgz -C $(TARGET_DIR)/
    sed -i '/^CHROME_EXTRA_ARGS=/a\$(CHROMIUM_WRAPPER_EXTRA_ARGS)' $(TARGET_DIR)/usr/lib/chromium/chromium-wrapper
endef

$(eval $(generic-package))
