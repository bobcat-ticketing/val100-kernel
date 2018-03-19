#FROM ubuntu:16.04
FROM debian:stable

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
	autoconf \
	automake \
	bc \
	bison \
	build-essential \
	cpio \
	curl \
	cvs \
	flex \
	gawk \
	gcc \
	git \
	gperf \
	libexpat-dev \
	libncurses5-dev \
	libtool \
	locales-all \
	lzop \
	patch \
	pkg-config \
	python \
	python-dev \
	screen \
	texinfo \
	u-boot-tools \
	unzip \
	wget

RUN useradd -u 4242 -c "Bob the Builder" bob

ENV BUILDROOT_DIR=buildroot
ENV LINUX_DIR=linux-3.14.14
ENV BR2_CONFIG=/home/bob/val130_config.txt

COPY --chown=bob $BUILDROOT_DIR /usr/src/buildroot
COPY --chown=bob $LINUX_DIR /usr/src/linux
COPY --chown=bob *_config.txt /home/bob/
COPY --chown=bob build.sh /home/bob/

#WORKDIR /usr/src/buildroot
#USER bob
