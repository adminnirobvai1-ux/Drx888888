FROM ubuntu:20.04

# ডিপেন্ডেন্সি ও নন-ইন্টারেক্টিভ মোড সেটআপ
ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=1024x768

# বেসিক টুলস ও কী-ম্যানেজমেন্ট টুলস ইনস্টল
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg \
    ca-certificates \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    git \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome রিপোজিটরির ভ্যালিড সাইনিং কী যোগ ও Chrome ইনস্টল
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-chrome.gpg \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# VNC ও স্টার্টআপ কনফিগারেশন
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NO_VNC_PORT=8080

EXPOSE 8080

# স্ক্রিন রেজোলিউশন ও সার্ভার রান কমান্ড
CMD ["sh", "-c", "vncserver :1 -geometry ${RESOLUTION} -depth 24 && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
