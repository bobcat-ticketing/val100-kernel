#FROM ubuntu:16.04
FROM debian:stable

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential libncurses5-dev gcc bc curl git lzop u-boot-tools wget cpio python unzip locales-all
RUN useradd -u 4242 -c "Bob the Builder" bob

ENV BUILDROOT_DIR=buildroot-2015.05
ENV LINUX_DIR=linux-3.14.14
ENV BR2_CONFIG=/home/bob/val130_config.txt

COPY --chown=bob $BUILDROOT_DIR /usr/src/buildroot
COPY --chown=bob $LINUX_DIR /usr/src/linux
COPY --chown=bob *_config.txt /home/bob/
COPY --chown=bob build.sh /home/bob/

#WORKDIR /usr/src/buildroot
#USER bob
