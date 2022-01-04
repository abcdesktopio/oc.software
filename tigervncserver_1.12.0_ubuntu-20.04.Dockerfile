FROM ubuntu:20.04
RUN mkdir -p /deb
COPY tigervncserver_1.12.0_ubuntu-20.04_amd64.deb /deb
