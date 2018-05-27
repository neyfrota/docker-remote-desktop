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
COPY Docker-build.sh /
COPY Docker-entrypoint.sh /
#
# all deploy inteligence lives at this script
RUN ["/bin/bash", "/Docker-build.sh"]
#
#VOLUME [ "/etc" ]
#
# expose ports
EXPOSE 22
#
# start all the magic
ENTRYPOINT ["/Docker-entrypoint.sh"]
