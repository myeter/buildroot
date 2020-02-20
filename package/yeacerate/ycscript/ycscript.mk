################################################################################
#
# Yea Create script
# base on rkscript
#
################################################################################

YCSCRIPT_SITE_METHOD = local
YCSCRIPT_LICENSE = MIT
YCSCRIPT_USB_CONFIG_FILE = $(TARGET_DIR)/etc/init.d/.usb_config
YCSCRIPT_SERVICE_CONFIG_FILE = $(TARGET_DIR)/etc/service.conf
YCSCRIPT_SSH_DIR = $(TARGET_DIR)/root/.ssh
YCSCRIPT_HOME_DIR = $(TARGET_DIR)/home
YCSCRIPT_SITE = $(TOPDIR)/package/yeacerate/ycscript/src


define YCSCRIPT_BUILD_CMDS
	$(INSTALL) -D -m 0644 ${YCSCRIPT_SITE}/*.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/fstab $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/wpa_supplicant.conf $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/dnsmasq.conf $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/S* $(TARGET_DIR)/etc/init.d/
	rm $(TARGET_DIR)/etc/init.d/S80phpwebserver

	if test -e $(YCSCRIPT_USB_CONFIG_FILE) ; then \
		rm $(YCSCRIPT_USB_CONFIG_FILE) ; \
	fi
	touch $(YCSCRIPT_USB_CONFIG_FILE)
	if test -e $(YCSCRIPT_SERVICE_CONFIG_FILE) ; then \
		rm $(YCSCRIPT_SERVICE_CONFIG_FILE) ; \
	fi
	touch $(YCSCRIPT_SERVICE_CONFIG_FILE)
	touch $(TARGET_DIR)/root/first

	if [ -z `cat $(TARGET_DIR)/etc/inittab | grep "/sbin/swapon"` ]; then \
		sed '/::sysinit:\/bin\/hostname/a\::sysinit:\/sbin\/swapon -a' $(TARGET_DIR)/etc/inittab > $(TARGET_DIR)/etc/inittab.txt; \
		mv $(TARGET_DIR)/etc/inittab.txt $(TARGET_DIR)/etc/inittab; \
	fi

	if [ -z `cat $(TARGET_DIR)/etc/inittab | grep "::respawn:/sbin/getty -L ttyS2 115200 vt100"` ]; then \
		sed '/respawn:\/sbin\/getty/a\::respawn:\/sbin\/getty -L ttyS2 115200 vt100' $(TARGET_DIR)/etc/inittab > $(TARGET_DIR)/etc/inittab.txt; \
		mv $(TARGET_DIR)/etc/inittab.txt $(TARGET_DIR)/etc/inittab; \
	fi
endef

ifeq ($(BR2_PACKAGE_IONCUBE),y)
define ADD_IONCUBE
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/ioncube_loader_lin_7.1.so $(TARGET_DIR)/usr/lib/php/extensions/no-debug-non-zts-20160303/;
	if [ -z `cat $(TARGET_DIR)/etc/php.ini | grep "ioncube_loader"` ]; then \
		sed '/extension=php_xsl.dll/a\zend_extension=ioncube_loader_lin_7.1.so' $(TARGET_DIR)/etc/php.ini > $(TARGET_DIR)/etc/b.txt; \
		mv $(TARGET_DIR)/etc/b.txt $(TARGET_DIR)/etc/php.ini; \
	fi
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_IONCUBE
endif

ifeq ($(BR2_PACKAGE_PHPWEBSERVER),y)
define ADD_PHPWEBSERVER
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/S80phpwebserver $(TARGET_DIR)/etc/init.d/S80phpwebserver
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_PHPWEBSERVER
endif

ifeq ($(BR2_PACKAGE_CNFONT),y)
define ADD_CNFONT
	mkdir -p $(TARGET_DIR)/usr/share/fonts/arphic
	mkdir -p $(TARGET_DIR)/usr/share/fonts/droid
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/fonts/arphic/uming.ttc $(TARGET_DIR)/usr/share/fonts/arphic/
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/fonts/droid/DroidSansFallbackFull.ttf $(TARGET_DIR)/usr/share/fonts/droid/
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_CNFONT
endif

ifeq ($(BR2_PACKAGE_PHPWEBSERVER),y)
define ADD_YCSERVICE_WEBSERVER
	echo "Web_service:/usr/bin/php -S:/bin/sh /etc/init.d/S80phpwebserver restart:sleep 1s" >> $(TARGET_DIR)/etc/service.conf
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_YCSERVICE_WEBSERVER
endif

ifeq ($(BR2_PACKAGE_PHP_SAPI_FPM),y)
define ADD_YCSERVICE_PHPFPM
	echo "php_fpm_service:/etc/php-fpm.conf:/bin/sh /etc/init.d/S49php-fpm restart:sleep 1s" >> $(TARGET_DIR)/etc/service.conf
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_YCSERVICE_PHPFPM
endif


ifeq ($(BR2_PACKAGE_YCSERVICE),y)
define ADD_YCSERVICE
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/service.sh $(TARGET_DIR)/usr/bin/service.sh
	echo "wpa_supplicant:/usr/sbin/wpa_supplicant:/bin/sh /etc/init.d/S81wpa_supplicant restart:sleep 2s" >> $(TARGET_DIR)/etc/service.conf
	echo "dcron_service:/usr/sbin/crond:/bin/sh /etc/init.d/S90dcron restart:sleep 1s" >> $(TARGET_DIR)/etc/service.conf
	echo "Chromium_service:/usr/bin/chromium:/bin/sh /etc/init.d/S91chromium restart:sleep 5s" >> $(TARGET_DIR)/etc/service.conf

	if [ -z `cat $(TARGET_DIR)/etc/inittab | grep "service.sh"` ]; then \
		sed '/::respawn:\/sbin\/getty -L ttyS2 115200/a\:23456:respawn:\/bin\/sh \/usr\/bin\/service.sh > /dev/null' \
		$(TARGET_DIR)/etc/inittab > $(TARGET_DIR)/etc/inittab.txt; \
		mv $(TARGET_DIR)/etc/inittab.txt $(TARGET_DIR)/etc/inittab; \
	fi
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_YCSERVICE
endif


$(eval $(generic-package))
