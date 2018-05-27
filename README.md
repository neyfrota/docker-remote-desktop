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
  -e "username=neyfrota" \
	-e "password=password" \
	-v /tmp/remote-user-neyfrota:/home/neyfrota \
	-p 22:22 \
	docker-desktop
```

## env variables

* UID: unix user numeric id (default 1000)
* GID: unix group numeric id (default 1000)
* group: unix group name (default user)
* username: unix user name (default user)
* password: unix user password (default password)
* resolution: vnc geometry (default 1024x768)
