#!/bin/bash

groupmod -o -g $AUDIO_GID audio
groupmod -o -g $VIDEO_GID video
if [ $GID != $(echo `id -g wechat`) ]; then
    groupmod -o -g $GID wechat
fi
if [ $UID != $(echo `id -u wechat`) ]; then
    usermod -o -u $UID wechat
fi
chown wechat:wechat /WeChatFiles

su wechat;

# 启动 Xvfb
Xvfb $DISPLAY -screen 0 $VNC_RESOLUTION &
sleep 5

echo "启动 $APP"
"/opt/deepinwine/apps/Deepin-$APP/run.sh"
sleep 5

# 启动 x11vnc
xauth generate :1 . trusted
x11vnc -xkb -noxrecord -noxfixes -noxdamage -display $DISPLAY -auth guess -rfbauth /etc/x11vnc.pass -forever -bg -rfbport $VNC_PORT -bg -o /var/log/x11vnc.log

# 启动websockify，将WebSocket连接转发到x11vnc
/noVNC/utils/novnc_proxy --vnc localhost:5900

sleep 300

# 进入无限等待状态
tail -f /dev/null

# while test -n "`pidof WeChat.exe`"
# do
#     sleep 60
# done
# echo "退出"

