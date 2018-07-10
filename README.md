# Docker remote desktop

My effort to create a simple remote desktop packed as docker container

![Screenshot](screenshot.jpg "Screenshot")

* Public access only over SSH (safe and secure)
* Local [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) server (need ssh tunnel to access)
* Simple [Mate desktop](https://mate-desktop.org/) for fast remote access
* My basic apps (firefox, nicotine, transmission, baobab, vlc, etc)
* Free [Resilio sync](https://www.resilio.com/individuals/) (local UI at http://127.0.0.1:8888)
* Container user defined by env variables (uid, group, username, password)

# Start

Use docker hub public image. Git pull this repo is not need.  
```
docker run -d -p 22:22 neyfrota/remote-desktop
```

# SSH connect

```
ssh user@localhost
```

# VNC connect

VNC is not public available. We need SSH tunnel and port forward VNC traffic.

This increase setup complexity but guarantee a safe and protected VNC connection

### linux command line

This command connect to ssh, create a tunnel, launch vnc viewer and then disconnect SSH at end of VNC connection.

```
ssh -f -o ExitOnForwardFailure=yes -L5900:127.0.0.1:5900 user@localhost sleep 10 && gvncviewer 127.0.0.1
```
_(replace user and localhost with host you want connect)_

### to do

(research vnc apps with ssh port forward for android/ios/win/osx)

# Persistence

By default, instance data are ephemeral. 
This is a feature, not a bug.
We need some actions to persist user files and user password across usage.

### files persistence 

We can mount user home at host for data persistence.
```
docker run -d \
-e "username=customuser" \
-e "password=custompassword" \
-v /tmp/user-folder-at-host:/home/customuser \
-p 22:22 \
neyfrota/remote-desktop
```

### password persistence 

(todo)

# Details

### env variables

* uid: container unix user numeric id (default 1000)
* gid: container unix group numeric id (default 1000)
* group: container unix group name (default user)
* username: container unix user name (default user)
* password: container unix user password (default password)
* resolution: vnc geometry (default 1024x768)

### examples

A full usage example
```
docker run -d \
-e "uid=1000" \
-e "gid=1000" \
-e "username=user" \
-e "password=password" \
-e "resolution=800x600" \
-v /tmp/docker-desktop-home:/home \
-p 22:22 \
neyfrota/remote-desktop
```

### local build

If need, you can download this repo, review code and build local

```
git clone https://github.com/neyfrota/docker-remote-desktop.git
cd docker-remote-desktop/
docker build -t neyfrota/remote-desktop .
```
