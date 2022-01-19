#!/bin/bash
echo "==============================================="
echo "docker entrypoint"
echo "==============================================="

env >/tmp/env.out

echo "Set variables"
export uid=${uid:-1000}
export gid=${gid:-1000}
export group=${group:=user}
export username=${username:=user}
export resolution=${resolution:=1024x768}
# todo: validate env to avoid hack


echo "Create user $username ($uid)"
echo "Create group $group ($gid)"
groupadd --gid $gid $group
useradd --home-dir /home/$username --no-create-home --non-unique --gid $gid --uid $uid --no-user-group --shell /bin/bash $username
#chpasswd <<<"$username:$password"
#export password=""
usermod -aG sudo $username
mkdir -p /home/$username
mkdir -p /home/$username/Desktop
mkdir -p /home/$username/.config
chown -f $username.$group  /home/$username/
chown -f $username.$group  /home/$username/Desktop
chown -Rf $username.$group  /home/$username/.ssh
chown -f $username.$group  /home/$username/.config
if [[ -e /home/$username/.config/dconf.dump ]]
then
	echo "Accept user config"
	rm -f /home/$username/.config/dconf.dump
	touch /home/$username/.config/dconf.dump # dummy file
	chown -Rf $username.$group  /home/$username/.config/dconf.dump
else
	echo "Create user config"
	rm -f /home/$username/.config/dconf.dump
	cp /Dockerfiles/dconf.dump /home/$username/.config/dconf.dump
	chown -Rf $username.$group  /home/$username/.config/dconf.dump
fi


mkdir -p /home/$username/.ssh
touch /home/$username/.ssh/authorized_keys
if [[ -z "${pubkey}" ]]; then
	echo "No pubkey specified. I hope is already set"
else
	echo "Use pubkey from env variables"
	grep -qF -- "$pubkey" "/home/$username/.ssh/authorized_keys" || echo "$pubkey" >> "/home/$username/.ssh/authorized_keys"

fi
chown -Rf $username.$group  /home/$username/.ssh
chmod -Rf a-rwx,u+rX  /home/$username/.ssh
chmod -Rf a-rwx,u+rX  /home/$username/.ssh/authorized_keys


echo "Defaults	env_reset" > /etc/sudoers
echo "Defaults	mail_badpass" >> /etc/sudoers
echo "Defaults	secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin\"" >> /etc/sudoers
echo "root	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "%admin ALL=(ALL) ALL" >> /etc/sudoers
echo "%sudo	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "$username	ALL=(ALL:ALL) ALL" >> /etc/sudoers



echo "Start local vnc with resolution $resolution"
mkdir -p /home/$username/.vnc
rm -f /home/$username/.vnc/passwd
rm -f /home/$username/.vnc/xstartup
rm -f /home/$username/.vnc/*.log
rm -f /home/$username/.vnc/*.pid
rm -f /home/$username/.Xauthority
echo '#!/bin/sh' > /home/$username/.vnc/xstartup
echo "unset SESSION_MANAGER" >> /home/$username/.vnc/xstartup
echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/$username/.vnc/xstartup
echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup" >> /home/$username/.vnc/xstartup
echo "[ -r /home/$username/.Xresources ] && xrdb /home/$username/.Xresources" >> /home/$username/.vnc/xstartup
#echo "x-terminal-emulator  &" >> /home/$username/.vnc/xstartup
echo "xsetroot -solid grey" >> /home/$username/.vnc/xstartup
echo "dconf load / < /home/$username/.config/dconf.dump " >> /home/$username/.vnc/xstartup
echo "mate-session &" >> /home/$username/.vnc/xstartup
touch /home/$username/.vnc/passwd
chown -Rf $username.$group  /home/$username/.vnc
chmod a-rwx,u+rw /home/$username/.vnc/passwd
chmod a-rwx,u+rwx /home/$username/.vnc/xstartup
su $username -c "vncserver -kill :1 " 2>/dev/null
su $username -c "vncserver -kill :0 " 2>/dev/null
pkill Xvnc4
su $username -c "vncserver :0 -name desktop -nolisten tcp -localhost -geometry $resolution -depth 24 -SecurityTypes none "





echo "Start ssh at port :22"
/etc/init.d/ssh stop
/etc/init.d/ssh start



echo "Holding instance up."
while :; do
  date
  sleep 300
done
