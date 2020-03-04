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
# WebOS
# This is the WebOS for Ntablet.
# It's also a test DEMO for Ntablet.
# Depends on Chromium and php
# It's a laravel base system, VUE as UI.
# http://yeacreate.com
# support@yeacreate.com
################################################################################
WEBOS_SITE = https://github.com/yeacreate-opensources/WebOS.git
WEBOS_VERSION = webos-1.0.1.0
WEBOS_SITE_METHOD = git
WEBOS_SUBMODULES = YES
WEBOS_DEPENDENCIES += \
	wiringnt-php \
	chromium

define WEBOS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home/
	cp -R $(@D)/db $(TARGET_DIR)/home/
	cp -R $(@D)/php $(TARGET_DIR)/home/
endef

$(eval $(generic-package))

