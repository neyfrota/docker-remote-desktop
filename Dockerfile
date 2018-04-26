#
# we like ubuntu :)
# https://github.com/phusion/baseimage-docker
FROM ubuntu:16.04
#
# our ID
MAINTAINER NEYFROTA <ney@frota.net>
LABEL version="0.1"
LABEL description="Docker desktop"
#
# copy what we need
COPY app /app
#
# all deploy inteligence lives at this script
RUN ["/bin/bash", "/app/docker/build.sh"]
#
#VOLUME [ "/etc" ]
#
# expose ports
EXPOSE 6080
#
# start all the magic
ENTRYPOINT ["/app/docker/entrypoint.sh"]

