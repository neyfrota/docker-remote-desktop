# docker desktop

My effort to create a simple remote desktop packed as docker container

* Main entrance only by SSH
* VNC server (local only. need ssh tunnel to access)
* Container user defined by env variables (uid, group, username, password)


## build
```
docker build -t docker-desktop .
```

## run

```
docker run -d \
-e "uid=1000" \
-e "gid=1000" \
-e "username=user" \
-e "password=password" \
-e "resolution=800x600" \
-v /tmp/docker-desktop-home:/home \
-p 22:22 \
docker-desktop
```

## env variables

* uid: container unix user numeric id (default 1000)
* gid: container unix group numeric id (default 1000)
* group: container unix group name (default user)
* username: container unix user name (default user)
* password: container unix user password (default password)
* resolution: vnc geometry (default 1024x768)
