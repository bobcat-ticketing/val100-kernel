FROM debian:stable
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential libncurses5-dev gcc bc curl git lzop u-boot-tools
