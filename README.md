# docker desktop

My effort to create a simple remote desktop packed as docker container

* Main entrance only by SSH
* VNC server (ssh tunnel to access)
* Installed with my desired apps (nicotine, transmission etc)
* Container user defined by env variables (uid, group, username, password)


## build
```
docker build -t docker-desktop .
```

## run

```
docker run -d \
-e "UID=1000" \
-e "GUI=1000" \
-e "username=user" \
-e "password=password" \
-e "resolution=800x600" \
-v /tmp/docker-desktop-home:/home \
-p 22:22 \
docker-desktop
```

## env variables

* UID: container unix user numeric id (default 1000)
* GID: container unix group numeric id (default 1000)
* group: container unix group name (default user)
* username: container unix user name (default user)
* password: container unix user password (default password)
* resolution: vnc geometry (default 1024x768)
