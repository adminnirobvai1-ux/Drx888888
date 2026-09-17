FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=800x600
ENV BRAND_NAME="Dark Killer"

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
    && rm -rf /var/lib/apt/lists/*

# ১. আপনার গিটহাবের ব্যানার ডাউনলোড এবং সিস্টেমের সব ডিফল্ট ওয়ালপেপার রিপ্লেস করা
RUN mkdir -p /usr/share/backgrounds/xfce /usr/share/images/desktop-base && \
    curl -fsSL "https://raw.githubusercontent.com/adminnirobvai1-ux/drx/refs/heads/main/1789570402521.png" -o /usr/share/backgrounds/custom_bg.png && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-blue.jpg && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-stripes.png && \
    cp /usr/share/backgrounds/custom_bg.png /usr/share/backgrounds/xfce/xfce-teal.jpg && \
    find /usr/share/backgrounds -type f -exec cp /usr/share/backgrounds/custom_bg.png {} + 2>/dev/null || true

# ২. XFCE কনফিগারেশনে আগে থেকেই আপনার ব্যানার সেট করে রাখা (যাতে খোলার সাথে সাথেই অটো বসে)
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
      <property name="monitorVirtual1" type="empty">\n\
        <property name="workspace0" type="empty">\n\
          <property name="image-style" type="int" value="5"/>\n\
          <property name="last-image" type="string" value="/usr/share/backgrounds/custom_bg.png"/>\n\
        </property>\n\
      </property>\n\
    </property>\n\
  </property>\n\
</channel>' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml && \
    cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /root/.config/xfce4/xfconf/xfce-perchannel-xml/

# ৩. টার্মিনাল ও সিস্টেমে Dark Killer ব্র্যান্ডিং যুক্ত করা
RUN echo 'export PS1="\[\e[1;31m\][Dark-Killer]\[\e[0m\]:\w# "' >> /root/.bashrc && \
    echo 'echo -e "\n============================================\n   Welcome to Dark Killer Remote Desktop\n============================================\n"' >> /root/.bashrc

# ৪. নো-পাসওয়ার্ড VNC কনফিগারেশন এবং স্টার্টআপ অটো-স্ক্রিপ্ট
RUN mkdir -p /root/.vnc && \
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

# ৫. ব্রাউজার ট্যাব ও টাইটেলে Dark Killer সেট করা
RUN sed -i 's/<title>noVNC<\/title>/<title>Dark Killer<\/title>/g' /usr/share/novnc/vnc.html && \
    sed -i 's/noVNC/Dark Killer/g' /usr/share/novnc/vnc.html

# ৬. যেকোনো পোর্ট সাপোর্ট ও স্টার্টআপ
CMD ["sh", "-c", "rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* && vncserver :1 -geometry ${RESOLUTION} -depth 24 -SecurityTypes None && TARGET_PORT=${PORT:-8080} && websockify --web=/usr/share/novnc/ ${TARGET_PORT} localhost:5901"]
