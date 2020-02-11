#!/bin/bash
mkdir -p /tmp/.xdg && chmod 0700 /tmp/.xdg;
touch /dev/video-dec0;
export XDG_RUNTIME_DIR=/tmp/.xdg;
#chromium --no-sandbox --gpu-sandbox-start-early --ozone-platform=wayland --ignore-gpu-blacklist --enable-wayland-ime
#chromium --no-sandbox --gpu-sandbox-start-early --ozone-platform=wayland --ignore-gpu-blacklist --kiosk
#chromium  --enable-gpu --enable-gpu-memory-buffer-video-frames --enable-accelerated-2d-canvas --enable-accelerated-vpx-decode --enable-native-gpu-memory-buffers --enable-zero-copy --gpu-no-context-lost --user-data-dir=/home/root/.chromium/ --disable-infobars --disable-session-crashed-bubble --ignore-certificate-errors --ignore-gpu-blacklist --no-sandbox --window-position=0,0 --no-first-run --in-process-gpu --gpu-sandbox-start-early --ozone-platform=wayland
chromium --no-sandbox --gpu-sandbox-start-early --ozone-platform=wayland --ignore-gpu-blacklist

