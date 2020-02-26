###################################################
##       .(@@@@@@@@@@@@@@@@@@@@@@@@@@@@(.        ##
##     *@.                              .@(      ##
##     @#                      *%(       *@      ##
##     @#                     &.  &.     *@      ##
##     @#       ,@&@.           @*       *@      ##
##     @#       *@  @%          @*       *@      ##
##     @#       *@   *@.        @*       *@      ##
##     @#       *@     @(       @*       *@      ##
##     @#       *@      #@      @*      #( &.    ##
##     @#       *@        @/    @*       ,(      ##
##     #&       *@         %&   @*               ##
##       #@@@@@@@*    #@.   ,@, @*               ##
##             #&       *@#   %@&     .@%        ##
##       *@    #&         .@%           *@*      ##
##      %&     #&           ,@#           &@     ##
##     @/      #&                   #@     (@.   ##
##   @&        #&                   &%      ,@(  ##
##  ,          (@,                 #@.           ##
##                @@@@@@@@@@@@@@@@@              ##
###################################################
################################################################################
#
# WiringNT-PHP
# http://yeacreate.com
# support@yeacreate.com
################################################################################


WIRINGNT_PHP_SITE = https://github.com/yeacreate-opensources/WiringNT-PHP.git
WIRINGNT_PHP_VERSION = master
WIRINGNT_PHP_SITE_METHOD = git
WIRINGNT_PHP_SUBMODULES = YES
WIRINGNT_PHP_DEPENDENCIES += \
	wiringnt \
	php

define WIRINGNT_PHP_BUILD_CMDS
	$(TARGET_MAKE_ENV)  $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define WIRINGNT_PHP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -j1 -C $(@D) install DESTDIR=$(TARGET_DIR)
	if [ -z `cat $(TARGET_DIR)/etc/php.ini | grep "wiringpi.so"` ]; then \
		sed '/extension=php_xsl.dll/a\extension=wiringpi.so' $(TARGET_DIR)/etc/php.ini > $(TARGET_DIR)/etc/b.txt; \
		mv $(TARGET_DIR)/etc/b.txt $(TARGET_DIR)/etc/php.ini; \
	fi
endef

$(eval $(generic-package))

