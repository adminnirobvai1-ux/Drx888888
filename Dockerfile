FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=1280x720
ENV BRAND_NAME="Dark Killer"

# আপনার কাছে কোনো বাংলাদেশী প্রক্সি থাকলে নিচে বসাতে পারেন (ঐচ্ছিক)
# উদাহরণ: ENV BD_PROXY="103.xxx.xxx.xxx:8080"
ENV BD_PROXY=""

# প্রয়োজনীয় প্যাকেজ ইনস্টল
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
    socat \
    && rm -rf /var/lib/apt/lists/*

# ফায়ারফক্সে অটোমেটিক Urban VPN (বাংলাদেশ সার্ভার সাপোর্টেড) ও সিকিউর DNS কনফিগারেশন
RUN mkdir -p /usr/lib/firefox/distribution && \
    echo '{\n\
  "policies": {\n\
    "Preferences": {\n\
      "network.trr.mode": 2,\n\
      "network.trr.uri": "https://mozilla.cloudflare-dns.com/dns-query",\n\
      "network.dns.echconfig.enabled": true\n\
    },\n\
    "ExtensionSettings": {\n\
      "urbanvpn@urbanvpn.com": {\n\
        "installation_mode": "force_installed",\n\
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/urban-vpn/latest.xpi"\n\
      }\n\
    }\n\
  }\n\
}' > /usr/lib/firefox/distribution/policies.json

# ব্যানার ডাউনলোড ও ব্যাকগ্রাউন্ড রিপ্লেস
RUN mkdir -p /usr/share/backgrounds/xfce /usr/share/images/desktop-base && \
    curl -fsSL "https://raw.githubusercontent.com/adminnirobvai1-ux/drx/refs/heads/main/1789570402521.png" -o /usr/share/backgrounds/custom_bg.png && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-blue.jpg && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-stripes.png && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-teal.jpg && \
    find /usr/share/backgrounds -type f -exec cp /usr/share/backgrounds/custom_bg.png {} + 2>/dev/null || true

# ব্যানার ফিট কনফিগারেশন (Aspect Ratio ঠিক রেখে ফিট)
RUN mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml /root/.config/xfce4/xfconf/xfce-perchannel-xml && \
    echo '<?xml version="1.0" encoding="UTF-8"?>\n\
<channel name="xfce4-desktop" version="1.0">\n\
  <property name="backdrop" type="empty">\n\
    <property name="screen0" type="empty">\n\
      <property name="monitor0" type="empty">\n\
        <property name="workspace0" type="empty">\n\
          <property name="image-style" type="int" value="5"/>\n\
          <property name="last-image" type="string" value="/usr/share/backgrounds/custom_bg.png"/>\n\
        </property>\n\
      </property>\n\
    </property>\n\
  </property>\n\
</channel>' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml && \
    cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/

# টার্মিনালে Dark Killer ব্র্যান্ডিং
RUN echo 'export PS1="\[\e[1;31m\][Dark-Killer]\[\e[0m\]:\w# "' >> /root/.bashrc && \
    echo 'echo -e "\n============================================\n   Welcome to Dark Killer Remote Desktop\n============================================\n"' >> /root/.bashrc

# VNC ও স্টার্টআপ কনফিগারেশন (Xauthority ওয়ার্নিং ফিক্স)
RUN mkdir -p /root/.vnc && \
    touch /root/.Xauthority && \
    echo "securitytypes=None" > /root/.vnc/config && \
    echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
export DISPLAY=:1\n\
( \n\
  sleep 2\n\
  for p in $(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep "last-image"); do \n\
    xfconf-query -c xfce4-desktop -p "$p" -s /usr/share/backgrounds/custom_bg.png 2>/dev/null \n\
  done \n\
  for p in $(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep "image-style"); do \n\
    xfconf-query -c xfce4-desktop -p "$p" -s 5 2>/dev/null \n\
  done \n\
  xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-title -s "Dark Killer" --create -t string 2>/dev/null \n\
  xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-button-title -s true --create -t bool 2>/dev/null \n\
) &\n\
exec startxfce4' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# ব্রাউজার টাইটেল Dark Killer ও অটো-স্কেল
RUN sed -i 's/<title>noVNC<\/title>/<title>Dark Killer<\/title>/g' /usr/share/novnc/vnc.html && \
    sed -i "s/'resize', 'off'/'resize', 'scale'/g" /usr/share/novnc/app/ui.js 2>/dev/null || true

EXPOSE 8080 8081 8082 8083 8084 8085 8086 8087 8088 8089 6080 6081 6082 6083 6084 6085 6086 6087 6088 6089

# মাল্টি-পোর্ট লিসেনিং ও স্টার্টআপ
CMD ["sh", "-c", "rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* && touch /root/.Xauthority && vncserver :1 -geometry ${RESOLUTION} -depth 24 -SecurityTypes None && for p in 8081 8082 8083 8084 8085 8086 8087 8088 8089 6080 6081 6082 6083 6084 6085 6086 6087 6088 6089; do socat TCP-LISTEN:$p,fork,reuseaddr TCP:localhost:8080 2>/dev/null & done && if [ -n \"$PORT\" ] && [ \"$PORT\" != \"8080\" ]; then socat TCP-LISTEN:$PORT,fork,reuseaddr TCP:localhost:8080 2>/dev/null & fi && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
