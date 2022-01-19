#!/bin/bash
echo "==============================================="
echo "docker build"
echo "==============================================="

echo "Update/upgrade system"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

echo "Install basic tools"
apt-get install -y software-properties-common openssh-server dnsutils curl sudo vim net-tools dconf-cli

echo "Add extra repository"
apt-add-repository -y ppa:ubuntu-mate-dev/ppa
apt-add-repository -y ppa:ubuntu-mate-dev/trusty-mate
add-apt-repository -y ppa:webupd8team/atom
echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
wget -qO - https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add -

echo "Update"
apt-get update -y

echo "Install packages"
apt-get install -y vnc4server mate-desktop-environment firefox nicotine transmission baobab vlc
# this one fail :(  atom pinta

echo "Clean system"
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
