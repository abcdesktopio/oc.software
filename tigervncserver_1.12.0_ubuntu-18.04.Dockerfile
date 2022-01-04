FROM ubuntu:18.04
RUN mkdir -p /deb
COPY tigervncserver_1.12.0_ubuntu-18.04_amd64.deb /deb
