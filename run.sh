xhost +
docker run -d --name wechat --device /dev/snd --ipc="host" \
 -p 6080:6080 \
 -v /tmp/.X11-unix:/tmp/.X11-unix \
 -v $HOME/WeChatFiles:/WeChatFiles \
 -e XMODIFIERS=@im=fcitx5 \
 -e QT_IM_MODULE=fcitx5 \
 -e GTK_IM_MODULE=fcitx5 \
 -e AUDIO_GID=`getent group audio | cut -d: -f3` \
 -e GID=`id -g` \
 -e UID=`id -u` \
yuriko/wechat
