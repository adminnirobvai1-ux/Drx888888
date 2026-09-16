FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# পরিবেশ ভেরিয়েবল সেটআপ
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Dhaka
ENV PORT=3000

# গুগল ক্রোম ইনস্টল করার কমান্ড
RUN apt-get update && apt-get install -y wget && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    apt-get clean

EXPOSE 3000
