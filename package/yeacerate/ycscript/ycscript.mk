################################################################################
#
# Yea Create script
# base on rkscript
#
################################################################################

YCSCRIPT_SITE_METHOD = local
YCSCRIPT_LICENSE = MIT
YCSCRIPT_USB_CONFIG_FILE = $(TARGET_DIR)/etc/init.d/.usb_config
YCSCRIPT_SSH_DIR = $(TARGET_DIR)/root/.ssh
YCSCRIPT_HOME_DIR = $(TARGET_DIR)/home
YCSCRIPT_SITE = $(TOPDIR)/package/yeacerate/ycscript/src


define YCSCRIPT_BUILD_CMDS
	$(INSTALL) -D -m 0644 ${YCSCRIPT_SITE}/*.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/fstab $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/wpa_supplicant.conf $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/dnsmasq.conf $(TARGET_DIR)/etc/
	$(INSTALL) -D -m 0755 -D ${YCSCRIPT_SITE}/S* $(TARGET_DIR)/etc/init.d/
	rm $(TARGET_DIR)/etc/init.d/S90phpwebserver

	if test -e $(YCSCRIPT_USB_CONFIG_FILE) ; then \
		rm $(YCSCRIPT_USB_CONFIG_FILE) ; \
	fi
	touch $(YCSCRIPT_USB_CONFIG_FILE)
	touch $(TARGET_DIR)/root/first

endef

ifeq ($(BR2_PACKAGE_INKEY2),y)
define ADD_INKEY2
	if [ ! -d $(YCSCRIPT_HOME_DIR) ]; then \
		mkdir $(YCSCRIPT_HOME_DIR) ; \
	fi
	if [ ! -d $(YCSCRIPT_SSH_DIR) ]; then \
		mkdir $(YCSCRIPT_SSH_DIR) ; \
	fi
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/authorized_keys $(TARGET_DIR)/root/.ssh/
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_INKEY2
endif

ifeq ($(BR2_PACKAGE_IONCUBE),y)
define ADD_IONCUBE
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/ioncube_loader_lin_7.1.so $(TARGET_DIR)/usr/lib/php/extensions/no-debug-non-zts-20160303/
	sed '/extension=php_xsl.dll/a\zend_extension=ioncube_loader_lin_7.1.so' $(TARGET_DIR)/etc/php.ini > $(TARGET_DIR)/etc/b.txt
	mv $(TARGET_DIR)/etc/b.txt $(TARGET_DIR)/etc/php.ini
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_IONCUBE
endif

ifeq ($(BR2_PACKAGE_PHPWEBSERVER),y)
define ADD_PHPWEBSERVER
	$(INSTALL) -D -m 0644 -D ${YCSCRIPT_SITE}/S90phpwebserver $(TARGET_DIR)/etc/init.d/S90phpwebserver
endef
YCSCRIPT_POST_BUILD_HOOKS += ADD_PHPWEBSERVER
endif


$(eval $(generic-package))
