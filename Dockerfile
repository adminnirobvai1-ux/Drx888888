FROM dorowu/ubuntu-desktop-lxde-vnc:focal

ENV RESOLUTION=1280x720
EXPOSE 80

CMD ["/startup.sh"]
