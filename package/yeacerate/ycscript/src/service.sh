#!/bin/sh
#
# power by Yea Create simon@yeacreate.com
# keep some service working
#
#
#

file="/etc/service.conf";
tmp_file="/tmp/servic.txt"


check_service()
{
service_pid=`/bin/ps | /bin/grep "$2" | /bin/grep -v "grep" | /usr/bin/awk '{print $1}'`;
#echo $web_service

if [ "$service_pid" != "" ];then
	echo "The id of $1 is $service_pid";
else
	##echo -e "$1 is downed !\nI'm going to restart it...";
	eval $f3;
	eval $f4;
fi
}

readservice()
{
text=`cat $file | sed '/^$/d' > $tmp_file`;
while IFS=: read -r f1 f2 f3 f4
do
	##echo -e "service name is $f1 , key words is: $f2 , restart scripts is: $f3", sleep after restart is: $f4;
	check_service $f1 $f2 $f3 $f4;
done < $tmp_file
}


if [ ! -f "/tmp/service.lock" ];then
##echo "just booted, waiting for 10s";
sleep 10s;
/bin/touch /tmp/service.lock;
fi

while [ 1 ]
do
	readservice;
	sleep 1s;
done
