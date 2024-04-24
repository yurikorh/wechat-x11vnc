FROM bestwu/wine:i386

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps deepin.com.wechat git ca-certificates \
    net-tools x11-xserver-utils x11vnc xvfb xauth python3 python3-numpy && \
    apt-get -y autoremove --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && \
    find /var/cache -type f -delete && \
    find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && \
    find /usr/share/man -type f -delete

RUN x11vnc -storepasswd 12345678 /etc/x11vnc.pass && \
    touch /root/.Xauthority

# 克隆noVNC和websockify
RUN update-ca-certificates && \
    git clone https://github.com/novnc/noVNC.git /noVNC \
    && git clone https://github.com/novnc/websockify.git /noVNC/utils/websockify

# 设置noVNC的默认配置
RUN ln -s /noVNC/vnc.html /noVNC/index.html

ENV APP=WeChat \
    AUDIO_GID=63 \
    VIDEO_GID=39 \
    GID=1000 \
    UID=1000

RUN groupadd -o -g $GID wechat && \
    groupmod -o -g $AUDIO_GID audio && \
    groupmod -o -g $VIDEO_GID video && \
    useradd -d "/home/wechat" -m -o -u $UID -g wechat -G audio,video wechat && \
    mkdir /WeChatFiles && \
    chown -R wechat:wechat /WeChatFiles && \
    ln -s "/WeChatFiles" "/home/wechat/WeChat Files"

VOLUME ["/WeChatFiles"]

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    VNC_RESOLUTION=1024x768x16

EXPOSE 6080
