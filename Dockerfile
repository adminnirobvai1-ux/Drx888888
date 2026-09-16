FROM dorowu/ubuntu-desktop-lxde-vnc:focal

# সিস্টেম আপডেট ও প্রয়োজনীয় প্যাকেজ (Git, Python3, Pip, Curl, Wget) ইনস্টল
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    nano \
    && rm -rf /var/lib/apt/lists/*

# সর্বশেষ Google Chrome ইনস্টল
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# ক্রোম যাতে ক্র্যাশ না করে এবং আইকনে ক্লিক করলেই ওপেন হয় তার ফিক্স
RUN sed -i 's|exec -a "$0" "$HERE/chrome" "$@"|exec -a "$0" "$HERE/chrome" "$@" --no-sandbox --disable-dev-shm-usage --disable-gpu|g' /opt/google/chrome/google-chrome

# স্ক্রিনের রেজোলিউশন (Full HD 1024x768)
ENV RESOLUTION=1024x768

EXPOSE 80

CMD ["/startup.sh"]
