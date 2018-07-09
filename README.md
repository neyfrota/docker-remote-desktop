# Docker remote desktop

My effort to create a simple remote desktop packed as docker container

![Screenshot](screenshot.png "Screenshot")

* Public access only over SSH (safe and secure)
* Local [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) server (need ssh tunnel to access)
* Simple [Mate desktop](https://mate-desktop.org/) for fast remote access
* My basic apps (firefox, nicotine, transmission, baobab, vlc, etc)
* Free [Resilio sync](https://www.resilio.com/individuals/) (local UI at http://127.0.0.1:8888)
* Container user defined by env variables (uid, group, username, password)

## run

Use docker hub public image. Git pull this repo is not need.  
```
docker run -d -p 22:22 neyfrota/remote-desktop
```

## ssh connect

```
ssh user@127.0.0.1
```

## vnc connect

SSH connect with port forward at 5900. Leave this connection active.
```
ssh -L5900:127.0.0.1:5900 user@localhost
```
Connect vnc viewer local (port 5900 is default)
```
gvncviewer 127.0.0.1
```
(todo: research vnc apps with included ssh port forward for android/ios)


## env variables

* uid: container unix user numeric id (default 1000)
* gid: container unix group numeric id (default 1000)
* group: container unix group name (default user)
* username: container unix user name (default user)
* password: container unix user password (default password)
* resolution: vnc geometry (default 1024x768)

## examples

Define custom user and set home folder at host for data persistence.
```
docker run -d \
-e "username=customuser" \
-e "password=custompassword" \
-v /tmp/user-folder-at-host:/home/customuser \
-p 22:22 \
neyfrota/remote-desktop
```

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

## local build

If need, you can download this repo, review code and build local

```
git clone https://github.com/neyfrota/docker-remote-desktop.git
cd docker-remote-desktop/
docker build -t neyfrota/remote-desktop .
```
