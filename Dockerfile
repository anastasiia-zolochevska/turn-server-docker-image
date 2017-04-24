FROM ubuntu:16.04
MAINTAINER Anastasia Zolochevska <anastasiia.zolochevska@gmail.com>

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

EXPOSE 3478

RUN echo 'deb http://ftp.us.debian.org/debian jessie main' | tee --append /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install dnsutils
RUN apt-get -y install coturn

ENTRYPOINT ["bash", "deploy-turnserver.sh"]                                