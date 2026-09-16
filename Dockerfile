FROM ubuntu:20.04

# ডিপেন্ডেন্সি ও নন-ইন্টারেক্টিভ মোড
ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=1024x768

# প্যাকেজ আপডেট ও ফায়ারফক্সসহ প্রয়োজনীয় টুলস ইনস্টল
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    firefox \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# VNC ও পোর্ট কনফিগারেশন
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NO_VNC_PORT=8080

EXPOSE 8080

# স্ক্রিন রেজোলিউশন ও সার্ভার রান কমান্ড
CMD ["sh", "-c", "vncserver :1 -geometry ${RESOLUTION} -depth 24 && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
