#!/bin/bash
echo "==============================================="
echo "Start docker desktop"
echo "==============================================="

# -----------------------
# Cleanup env variables
# -----------------------
export uid=${uid:=33}
export gid=${gid:=33}
export group=${group:=www-data}
export username=${username:=user}
export password=${password:=password}
export resolution=${resolution:=1024x768}
#echo uid=$uid
#echo gid=$gid
#echo username=$username
#echo password=$password
#echo resolution=$resolution
# todo: validate env to avoid hack


# -----------------------
# setup system
# -----------------------
echo "Setup system"
rm -f /tmp/SSLCertificateFile
if [[ -z "${SSLCertificateFile}" ]]; then
	cp -f /etc/ssl/certs/ssl-cert-snakeoil.pem /tmp/SSLCertificateFile
else
	echo "$SSLCertificateFile" > /tmp/SSLCertificateFile
fi
#
rm -f /tmp/SSLCertificateKeyFile
if [[ -z "${SSLCertificateKeyFile}" ]]; then
	cp -f /etc/ssl/private/ssl-cert-snakeoil.key /tmp/SSLCertificateKeyFile
else
	echo "$SSLCertificateKeyFile" > /tmp/SSLCertificateKeyFile
fi
#
rm -f /tmp/SSLCertificateChainFile
if [[ -z "${SSLCertificateChainFile}" ]]; then
	cp -f /etc/ssl/certs/ssl-cert-snakeoil.pem /tmp/SSLCertificateChainFile
else
	echo "$SSLCertificateChainFile" > /tmp/SSLCertificateChainFile
fi
rm -f /tmp/SSLCertificate.pem
cat /tmp/SSLCertificateKeyFile >> /tmp/SSLCertificate.pem
cat /tmp/SSLCertificateFile >> /tmp/SSLCertificate.pem
cat /tmp/SSLCertificateChainFile >> /tmp/SSLCertificate.pem



# -----------------------
# add user
# -----------------------
echo "Create user"
groupadd --gid $gid $group
useradd --home-dir /home/$username --create-home --non-unique --gid $gid --uid $uid --no-user-group --shell /bin/bash $username
chpasswd <<<"$username:$password"
usermod -aG sudo $username
mkdir -p /home/$username 
chown $username.$gid  /home/$username/


# -----------------------
# config vnc
# -----------------------
echo "Create vnc user config"
mkdir -p /home/$username/.vnc 
mkdir -p /home/$username/.config
mkdir -p /home/$username/.ssh
rm -f /home/$username/.vnc/passwd
rm -f /home/$username/.vnc/xstartup
rm -f /home/$username/.vnc/*.log
rm -f /home/$username/.vnc/*.pid
rm -f /home/$username/.Xauthority
echo "unset SESSION_MANAGER" > /home/$username/.vnc/xstartup
echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/$username/.vnc/xstartup
echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup" >> /home/$username/.vnc/xstartup
echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources" >> /home/$username/.vnc/xstartup
echo "/usr/bin/lxterm &" >> /home/$username/.vnc/xstartup
echo "xsetroot -solid grey" >> /home/$username/.vnc/xstartup
echo "/usr/bin/mate-session &" >> /home/$username/.vnc/xstartup
touch /home/$username/.vnc/passwd
chmod a-rwx,u+rw /home/$username/.vnc/passwd
chmod a-rwx,u+rwx /home/$username/.vnc/xstartup
chown -Rf $username.$gid  /home/$username/.config
chown -Rf $username.$gid  /home/$username/.vnc
chown -Rf $username.$gid  /home/$username/.ssh


# -----------------------
# start vnc
# -----------------------
echo "Start vnc "
su $username -c "vncserver -kill :1 " 2>/dev/null
su $username -c "vncserver -kill :0 " 2>/dev/null
pkill Xvnc4
su $username -c "id; env; pwd; vncserver :0 -name webdesktop -nolisten tcp -localhost -geometry $resolution -depth 24 -SecurityTypes none "

# -----------------------
echo "Start novnc "
# -----------------------
/app/noVNC/utils/launch.sh --cert /tmp/SSLCertificate.pem --ssl-only 


# -----------------------
# oops... we fail...
# -----------------------
echo "Instance stoped"
if [ "$development" = "true" ]; then
    echo "Holding instance up for debug."
    while :; do
      date
      sleep 300
    done
fi
echo "Holding instance for 30s to avoid restart-flood"
sleep 30
echo "Exit instance"



