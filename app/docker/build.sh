#!/bin/bash
echo "==============================================="
echo "build docker desktop"
echo "==============================================="


echo "Update system"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y 
apt-get upgrade -y 


echo "Install packages"
apt-get install -y vim net-tools software-properties-common vnc4server novnc
apt-get install -y apache2 apache2-utils dnsutils curl 
apt-add-repository ppa:ubuntu-mate-dev/xenial-mate -y 
apt-get update
apt-get install -y mate

echo "Setup system"
rm -Rf  /etc/rc3.d/*apache* # disable apache. We just need certs
mkdir -p /etc/skel
cp -Rf /app/skel/ /etc/

#
# clean the house
echo "Clean system"
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*




