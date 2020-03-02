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
# enable_screen
# http://yeacreate.com
# support@yeacreate.com
# This featrue is used for wake up the screen via a virtual keycode
################################################################################
 */

#include <stdio.h>
#include <linux/input.h>
#include <fcntl.h>
#include <sys/time.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define event_num "/dev/input/event2" // please comfirm the device having the write permission
#define keycode 205	//the keycode to be sent

//按键模拟，按键包含按下和松开两个环节
void simulate_key(int fd, int kval)
{
	struct input_event event;
	gettimeofday(&event.time, 0);

	//按下kval键
	event.type = EV_KEY;
	event.value = 1;
	event.code = kval;
	write(fd, &event, sizeof(event));

	//同步，也就是把它报告给系统
	event.type = EV_SYN;
	event.value = 0;
	event.code = SYN_REPORT;
	write(fd, &event, sizeof(event));

	memset(&event, 0, sizeof(event));
	gettimeofday(&event.time, 0);

	//松开kval键
	event.type = EV_KEY;
	event.value = 0;
	event.code = kval;
	write(fd, &event, sizeof(event));

	//同步，也就是把它报告给系统
	event.type = EV_SYN;
	event.value = 0;
	event.code = SYN_REPORT;
	write(fd, &event, sizeof(event));
}


int main(int argc, char **argv)
{
	int fd_kbd = -1;
	int i = 0;
	int count = 0;

	// please comfirm the device having the write permission
	fd_kbd = open(event_num, O_RDWR);
	if(fd_kbd <= 0) {
		printf("Can not open keyboard input file\n");
		return -1;
	}

	if (argc > 1){
		if (!strcmp(argv[1],"-h") || !strcmp(argv[1],"-help")){
			printf("The usage of enable_screen is: enable_screen [Timing]\n");
			printf("	enable_screen	--Send virtual once\n");
			printf("	enable_screen 10	--Send virtual in loop every 10 seconds\n");
		}else{
			count = atoi(argv[1]);
			if (count < 1) count=0;
			printf("Timing is:%d\n",count);

			if (count < 1){
				simulate_key(fd_kbd, keycode);//send a virtual keycode(205)
			}else{
				while(1){
				simulate_key(fd_kbd, keycode);//send a virtual keycode(205)
				sleep(count);
				}

			}

		}
	}else{
		simulate_key(fd_kbd, keycode);//send a virtual keycode(205)
	}
	close(fd_kbd);
	return 0;
}
