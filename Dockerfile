FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV DISPLAY=:1

# ১. সিস্টেম টুলস, XFCE4, কালারফুল আইকন এবং মিসিং X11 ফন্টস ইনস্টল (ফিক্সড এরর সমাধান)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    curl \
    wget \
    git \
    dbus-x11 \
    x11-xserver-utils \
    xauth \
    xfonts-base \
    xfonts-75dpi \
    xfonts-100dpi \
    xfonts-scalable \
    papirus-icon-theme \
    python3 \
    python3-pip \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ২. পাইথন অটোমেশন প্যাকেজ
RUN pip3 install selenium requests

# ৩. কাস্টম লোগো ও ফেভআইকন ডাউনলোড
RUN mkdir -p /usr/share/novnc/images/icons /root/.vnc
RUN curl -L -s -o /usr/share/novnc/images/custom_logo.png "https://raw.githubusercontent.com/adminnirobvai1-ux/Pi/refs/heads/main/IMG_20260917_235840_557.jpg"

# ফেভআইকন ও সাইড আইকন রিপ্লেস
RUN cp /usr/share/novnc/images/custom_logo.png /usr/share/novnc/favicon.ico && \
    cp /usr/share/novnc/images/custom_logo.png /usr/share/novnc/app/images/icons/novnc-192x192.png 2>/dev/null || true

# ৪. ওয়েব ইন্টারফেস টাইটেল, Dark Killer নাম ও টেলিগ্রাম বাটন ইনজেকশন
RUN sed -i 's/<title>.*<\/title>/<title>DRX-TM | Dark Killer<\/title>/g' /usr/share/novnc/vnc.html

RUN sed -i '/<div class="noVNC_logo"/a \
<div style="color: #00f2fe; font-size: 22px; font-weight: 900; margin: 15px 0 10px 0; text-align: center; text-shadow: 0 0 15px #00f2fe; letter-spacing: 2px;">DARK KILLER</div>' /usr/share/novnc/vnc.html

RUN sed -i '/id="noVNC_connect_button"/a \
<div style="margin-top: 18px; text-align: center;">\
  <a href="https://t.me/DARK67HACK" target="_blank" id="custom_tg_btn">📢 JOIN TELEGRAM CHANNEL</a>\
</div>' /usr/share/novnc/vnc.html

# ৫. নিয়ন ব্লু গোল লোগো, পালস বাটন ও টেলিগ্রাম বাটনের CSS
RUN echo '\n\
/* --- DRX-TM BRANDING CSS --- */\n\
#noVNC_connect_dlg .noVNC_logo {\n\
    background-image: url("images/custom_logo.png") !important;\n\
    background-repeat: no-repeat !important;\n\
    background-position: center !important;\n\
    background-size: cover !important;\n\
    width: 140px !important;\n\
    height: 140px !important;\n\
    margin: 5px auto 0 auto !important;\n\
    border-radius: 50% !important;\n\
    border: 3px solid #00f2fe !important;\n\
    box-shadow: 0 0 25px rgba(0, 242, 254, 0.8), inset 0 0 10px rgba(0, 242, 254, 0.5) !important;\n\
    font-size: 0 !important;\n\
}\n\
#noVNC_connect_button {\n\
    background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%) !important;\n\
    color: #ffffff !important;\n\
    font-weight: 800 !important;\n\
    font-size: 15px !important;\n\
    border: none !important;\n\
    border-radius: 30px !important;\n\
    padding: 12px 32px !important;\n\
    box-shadow: 0 0 15px rgba(0, 198, 255, 0.6) !important;\n\
    cursor: pointer !important;\n\
    animation: neon-pulse 1.8s infinite alternate !important;\n\
    transition: transform 0.2s ease !important;\n\
}\n\
#noVNC_connect_button:hover {\n\
    transform: scale(1.06) !important;\n\
}\n\
#custom_tg_btn {\n\
    display: inline-block;\n\
    background: linear-gradient(135deg, #0088cc 0%, #005f8f 100%);\n\
    color: #ffffff;\n\
    text-decoration: none;\n\
    font-size: 13px;\n\
    font-weight: 700;\n\
    padding: 10px 24px;\n\
    border-radius: 25px;\n\
    border: 1px solid #00c6ff;\n\
    box-shadow: 0 0 12px rgba(0, 136, 204, 0.6);\n\
    transition: 0.3s all ease;\n\
}\n\
#custom_tg_btn:hover {\n\
    box-shadow: 0 0 20px rgba(0, 242, 254, 0.9);\n\
    transform: translateY(-2px);\n\
}\n\
@keyframes neon-pulse {\n\
    0% { box-shadow: 0 0 8px rgba(0, 242, 254, 0.4); }\n\
    100% { box-shadow: 0 0 25px rgba(0, 242, 254, 0.9); }\n\
}\n\
' >> /usr/share/novnc/app/styles/base.css

# ৬. রঙিন টার্মিনাল ব্যানার (DRX-TM) এবং প্রম্পট কনফিগারেশন
RUN echo '\n\
clear\n\
echo -e "\033[1;36m===================================================================\033[0m"\n\
echo -e "\033[1;31m8888888b.  8888888b.  Y88b   d88P     88888888888 888b     d888 \033[0m"\n\
echo -e "\033[1;31m888  \"Y88b 888   Y88b  Y88b d88P          888     8888b   d8888 \033[0m"\n\
echo -e "\033[1;33m888    888 888    888   Y88o88P           888     88888b.d88888 \033[0m"\n\
echo -e "\033[1;33m888    888 888   d88P    Y888P            888     888Y88888P888 \033[0m"\n\
echo -e "\033[1;32m888    888 8888888P\"     d888b            888     888 Y888P 888 \033[0m"\n\
echo -e "\033[1;32m888    888 888 T88b     d88888b  888888   888     888  Y8P  888 \033[0m"\n\
echo -e "\033[1;34m888  .d88P 888  T88b   d88P Y88b          888     888   \"   888 \033[0m"\n\
echo -e "\033[1;35m8888888P\"  888   T88b d88P   Y88b         888     888       888 \033[0m"\n\
echo -e "\033[1;36m===================================================================\033[0m"\n\
echo -e "\033[1;32m   [+] Developer : Dark Killer | DRX-TM Desktop v2.0               \033[0m"\n\
echo -e "\033[1;35m   [+] Telegram  : https://t.me/DARK67HACK                         \033[0m"\n\
echo -e "\033[1;36m===================================================================\033[0m\n"\n\
export PS1="\\[\\033[1;31m\\][\\033[1;33mDRX\\033[1;32m-TM\\]\\033[1;36m:\\w\\[\\033[0m\\]\\$ "\n\
' >> /root/.bashrc

# ৭. উইন্ডো বর্ডারে নিয়ন ব্লু গ্লো স্টাইলিং (GTK 3.0)
RUN mkdir -p /root/.config/gtk-3.0 && echo '\n\
window.csd decoration, window.solid-csd decoration {\n\
    box-shadow: 0 0 10px #00f2fe;\n\
    border: 2px solid #00f2fe;\n\
}\n\
#XfcePanelWindow {\n\
    background-color: rgba(18, 18, 24, 0.95);\n\
    border-top: 2px solid #00f2fe;\n\
}\n\
' >> /root/.config/gtk-3.0/gtk.css

# ৮. Xstartup কনফিগারেশন ও কালারফুল Papirus আইকন প্যাক সক্রিয় করা
RUN echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" --create -t string 2>/dev/null || true\n\
startxfce4 &\n\
' > /root/.vnc/xstartup && chmod +x /root/.vnc/xstartup

# ৯. মূল এন্ট্রি স্ক্রিপ্ট
RUN echo '#!/bin/bash\n\
rm -rf /tmp/.X* /tmp/.x*\n\
mkdir -p /root/.vnc\n\
echo "123456" | vncpasswd -f > /root/.vnc/passwd\n\
chmod 600 /root/.vnc/passwd\n\
vncserver :1 -geometry 1280x720 -depth 24\n\
websockify --web=/usr/share/novnc/ 0.0.0.0:${PORT:-8080} localhost:5901\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
