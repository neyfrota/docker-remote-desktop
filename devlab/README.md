# Development Lab

Resources to run "Docker remote desktop" in development mode to hack/edit

### Start devlab

* tested at linux/ubuntu (no idea about others)
* make sure you have docker
* make sure all exported ports are free (22)
* make sure your user (from host) has ~/.ssh/id_rsa.pub and ~/.ssh/id_rsa set
* clone this repo
* enter repo folder then devlab folder
* run `./devlab` to known status and commands
* run `./devlab build` to build devlab instance
* run `./devlab start` to start devlab instance for user 'user' and pubKey from ~/.ssh/id_rsa
* run `./devlab log` to see log in real time
* run `./devlab console ` to enter console at devlab image
* WARNING: check `/tmp/home/user` folder. All user data is stored there. track usage in your system

### Test ssh connection

Ssh to localhost using default user.

`ssh user@localhost`

### Test VNC connection

Ssh to localhost using default user with VNC port forward.

`ssh -L5900:127.0.0.1:5900 user@localhost`

Now open VNC client and connect to localhost.

`gvncviewer localhost`
