FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=1024x768
ENV BRAND_NAME="Dark Killer"

# প্রয়োজনীয় প্যাকেজ ও টুলস ইনস্টল
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    firefox \
    dbus-x11 \
    feh \
    && rm -rf /var/lib/apt/lists/*

# ব্যানার/লোগো ডাউনলোড ও ওয়ালপেপার সেটআপ
RUN mkdir -p /usr/share/backgrounds/custom && \
    curl -fsSL "https://raw.githubusercontent.com/adminnirobvai1-ux/drx/refs/heads/main/1789570402521.png" -o /usr/share/backgrounds/custom/wallpaper.png

# নো-পাসওয়ার্ড VNC কনফিগারেশন এবং XFCE বুট স্ক্রিপ্ট
RUN mkdir -p /root/.vnc && \
    echo "securitytypes=None" > /root/.vnc/config && \
    echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
export DISPLAY=:1\n\
feh --bg-scale /usr/share/backgrounds/custom/wallpaper.png &\n\
exec startxfce4' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# ব্র্যান্ড নেম দিয়ে টাইটেল কাস্টমাইজেশন
RUN sed -i 's/<title>noVNC<\/title>/<title>Dark Killer<\/title>/g' /usr/share/novnc/vnc.html

EXPOSE 8080

# স্টার্টআপ কমান্ড
CMD ["sh", "-c", "rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* && vncserver :1 -geometry ${RESOLUTION} -depth 24 -SecurityTypes None && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
