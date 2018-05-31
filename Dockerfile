
# we like ubuntu :)
# ...but can try https://github.com/phusion/baseimage-docker
FROM ubuntu:16.04

# about us
MAINTAINER NEYFROTA <ney@frota.net>
LABEL version="0.1"
LABEL description="Docker desktop"

# copy our files
COPY Dockerfiles /Dockerfiles

# build
RUN ["/bin/bash", "/Dockerfiles/build.sh"]

# define volumes
#VOLUME [ "/home" ]

# expose ports
EXPOSE 22

# start all the magic
ENTRYPOINT ["/Dockerfiles/entrypoint.sh"]
