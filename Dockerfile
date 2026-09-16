FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=800x600

# প্যাকেজ ও প্রয়োজনীয় টুলস ইনস্টল
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

# পাসওয়ার্ড ছাড়া অটো-স্টার্ট কনফিগারেশন
RUN mkdir -p /root/.vnc && \
    echo "securitytypes=None" > /root/.vnc/config && \
    echo '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup && \
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 8080

# সার্ভার রান কমান্ড
CMD ["sh", "-c", "vncserver :1 -geometry ${RESOLUTION} -depth 16 -SecurityTypes None && websockify --web=/usr/share/novnc/ 8080 localhost:5901"]
