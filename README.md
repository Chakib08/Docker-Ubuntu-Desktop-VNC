# Docker-Ubuntu-Desktop-VNC
Docker contrainer with Ubuntu desktop gnome image


# Running the container
You can follow all the steps on [the docker hub repository](https://hub.docker.com/repository/docker/mohamedlaminek/ubuntu-desktop-vnc/general) to run the ubuntu desktop contrainer and get access to it through VNC Viewer


# Building the docker image from scratch
1. Clone the github repository
```
$ git clone -b docker/ubuntu-18.04 git@github.com:Chakib08/Docker-Ubuntu-Desktop-VNC.git
```

2. Build the docker image
```
$ cd Docker-Ubuntu-Desktop-VNC/
$ docker build -t your-ubuntu-desktop:18.04 .
```
3. Run the container
```
$ docker run -t --name ubuntu-desktop your-ubuntu-desktop:18.04
```  
