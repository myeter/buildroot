#!/bin/bash

rm $(pwd)/output/target/etc/init.d/S10libmali -f
rm $(pwd)/output/target/usr/lib/libmali.so.1 -f
rm $(pwd)/output/target/usr/lib/libmali-midgard*.so -f
cp $(pwd)/board/yeacreate/870a/libmali.so.1 $(pwd)/output/target/usr/lib/
cp $(pwd)/output/host/arm-buildroot-linux-gnueabihf/sysroot/sbin/ldconfig $(pwd)/output/target/sbin/
cp $(pwd)/board/yeacreate/870a/pulse/client.conf $(pwd)/output/target/etc/pulse/
cp $(pwd)/board/yeacreate/870a/pulse/daemon.conf $(pwd)/output/target/etc/pulse/
cp $(pwd)/board/yeacreate/870a/pulse/default.pa $(pwd)/output/target/etc/pulse/
cp $(pwd)/board/yeacreate/870a/pulse/system.pa $(pwd)/output/target/etc/pulse/
cp $(pwd)/board/yeacreate/870a/pulse/S50pulseaudio $(pwd)/output/target/etc/init.d/S50pulseaudio
rm $(pwd)/output/target/var/spool -f
mkdir -p $(pwd)/output/target/var/spool/cron/crontabs
mkdir -p $(pwd)/output/target/var/spool/fontconfig


exit 0
