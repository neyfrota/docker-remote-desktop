#!/bin/bash
echo "==============================================="
echo "docker build"
echo "==============================================="


echo "Update system"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

echo "Install packages"
apt-get install -y software-properties-common openssh-server dnsutils curl sudo vim net-tools
apt-add-repository -y ppa:ubuntu-mate-dev/ppa
apt-add-repository -y ppa:ubuntu-mate-dev/trusty-mate
apt-get update -y
apt-get install -y vnc4server mate-desktop-environment-core
#apt-get install -y vnc4server mate-desktop-environment-extras
#apt-get install -y vnc4server mate-desktop-environment


#
# clean the house
echo "Clean system"
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
