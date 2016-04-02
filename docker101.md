# Docker 101

This tutorial is based largely on the excellent Docker [Getting Started](https://docs.docker.com/linux/step_four/) materials.

## Prerequisites
* Access to a system running Docker

## What you'll learn
In this tutorial, you'll learn how to:
* Run an existing Docker image
* Modify and commit changes to an image
* Build an image from a Dockerfile
* Push an image to Dockerhub 

## Finding images on Dockerhub

* Open a browser to go to http://hub.docker.com
* Use the search box to find the ndslabs "cowsay" image
* (You should end up at https://hub.docker.com/r/ndslabs/cowsay/)

Look at the Dockerfile -- it is a set of instructions used to build the image:

```
FROM debian:jessie

RUN apt-get update -y && apt-get install -y cowsay

ENV PATH $PATH:/usr/games

CMD ["cowsay", "Hi"]
```

* FROM: This is the base image used by the image. Base images can be any Linux flavor including Debian, Ubuntu, and CentOS.
* RUN: Installs the ubiquitous "cowsay" utility 
* ENV: Sets the PATH environment variable
* CMD: The default command for running containers


## Starting a container from an existing image

Open a shell/terminal and run:

```
docker run --rm ndslabs/cowsay
```

The first time you run a container, the image and any dependencies are downloaded. You should see output similar to:

```
Unable to find image 'ndslabs/cowsay:latest' locally
latest: Pulling from ndslabs/cowsay
73e8d4f6bf84: Pull complete
040bf8e08425: Pull complete
6649a5e013b4: Pull complete
93a35b983d41: Pull complete
7f30ada4c040: Pull complete
Digest: sha256:9501c74dbc9c6f7b67764071476bcacbf7e5a18b0857d96b46920f0431493e0b
Status: Downloaded newer image for ndslabs/cowsay:latest
 ____
< Hi >
 ----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

The next time you run the command, the images are cached, so you should simply see:

```
docker run --rm ndslabs/cowsay
 ____
< Hi >
 ----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Note: The "--rm" flag tells Docker to delete the container when execution completes.  If you don't do this, the containers will stick around after exiting. You can see this with the "docker ps -a" command. 

You can see the images in your image cache using "docker images":
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ndslabs/cowsay      latest              7f30ada4c040        35 minutes ago      170.9 MB
```

## Running a different command

The CMD instruction specifies only the default command. You can run any other command -- as long as it's installed in the container:

```
docker run --rm ndslabs/cowsay ls /usr/games
cowsay
cowthink
```

## Connecting to a container

Sometimes you might want to connect or "shell" into a running container. 

```
docker run --rm -it ndslabs/cowsay sh
```

This starts an interactive shell.  You can now run commands, install packages, edit files, etc.  Remember -- since the container was started with "--rm", when you exit your changes will be lost!

## Stopping, Removing, and Attaching
