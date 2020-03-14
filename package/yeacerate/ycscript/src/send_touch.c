/*
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
# send_touch
# License:GUN/GPL
# http://yeacreate.com
# simon@yeacreate.com
# This featrue is used for send a virtual touch for fixing the chromium no sound issue.
# This feature must be used in kiosk mode(it's touching position [0,0]).
# Debug infos:
# hexdump /dev/input/by-path/platform-ff160000.i2c-event
#
#-------------------------------------------------------------------------------
#touch once, and we can get
#timer(序号)	|seconds(秒)	|microseconds(微秒）|type |code |value
#0000180 		|5645 5e6b 		|ad2e 0001 			|0003 |0039 |0000 0000	//EV_ABS,ABS_MT_TRACKING_ID,0x00  //开始跟踪
#0000190 		|5645 5e6b 		|ad2e 0001 			|0003 |0035 |02ce 0000	//EV_ABS,ABS_MT_POSITION_X,0x2ce	//传入x坐标
#00001a0 		|5645 5e6b 		|ad2e 0001 			|0003 |0036 |02c6 0000	//EV_ABS,ABS_MT_POSITION_Y,0x2c6	//传入y坐标
#00001b0 		|5645 5e6b 		|ad2e 0001 			|0003 |0030 |0018 0000	//EV_ABS,ABS_MT_TOUCH_MAJOR,0x18	//传入触摸压力
#00001c0 		|5645 5e6b 		|ad2e 0001 			|0003 |0032 |0018 0000	//EV_ABS,ABS_MT_WIDTH_MAJOR,0x18	//传入触摸面积
#00001d0 		|5645 5e6b 		|ad2e 0001 			|0000 |0000 |0000 0000	 //EV_SYN //同步
#00001e0 		|5645 5e6b 		|76bb 0003 			|0003 |0039 |ffff ffff  //EV_ABS、ABS_MT_TRACKING_ID,0xffff  //结束跟踪
#00001f0 		|5645 5e6b 		|76bb 0003 			|0000 |0000 |0000 0000  //EV_SYN //同步
#-------------------------------------------------------------------------------
# And we found it must use ABS_MT_SLOT , and EV_KEY(BTN_TOUCH) from the kernel driver.
# Or it would not send 0003 |0039 |ffff ffff
################################################################################
 */

#include <stdio.h>
#include <linux/input.h>
#include <fcntl.h>
#include <sys/time.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define event_num "/dev/input/by-path/platform-ff160000.i2c-event" // please comfirm the device having the write permission


void touch(int fd)
{
	struct input_event event;
	gettimeofday(&event.time, 0);

	event.type = EV_ABS;
	event.value = 0;
	event.code = ABS_MT_SLOT;
	write(fd, &event, sizeof(event));

	event.type = EV_KEY;
	event.value = 1;
	event.code = BTN_TOUCH;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = 1;
	event.code = ABS_MT_POSITION_X;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = 1;
	event.code = ABS_MT_POSITION_Y;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = 1;
	event.code = ABS_MT_TOUCH_MAJOR;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = 1;
	event.code = ABS_MT_WIDTH_MAJOR;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = 0;
	event.code = ABS_MT_TRACKING_ID;
	write(fd, &event, sizeof(event));

	event.type = EV_SYN;
	event.value = 0;
	event.code = SYN_REPORT;
	write(fd, &event, sizeof(event));


	memset(&event, 0, sizeof(event));
	gettimeofday(&event.time, 0);


	event.type = EV_ABS;
	event.value = 0;
	event.code = ABS_MT_SLOT;
	write(fd, &event, sizeof(event));

	event.type = EV_KEY;
	event.value = 0;
	event.code = BTN_TOUCH;
	write(fd, &event, sizeof(event));

	event.type = EV_ABS;
	event.value = -1;
	event.code = ABS_MT_TRACKING_ID;
	write(fd, &event, sizeof(event));

	event.type = EV_SYN;
	event.value = 0;
	event.code = SYN_REPORT;
	write(fd, &event, sizeof(event));
}


int main(int argc, char **argv)
{
	int fd_kbd = -1;

	// please comfirm the device having the write permission
	fd_kbd = open(event_num, O_RDWR);
	if(fd_kbd <= 0) {
		printf("Can not open touch screen input file\n");
		return -1;
	}

	touch(fd_kbd);

	close(fd_kbd);
	return 0;
}
