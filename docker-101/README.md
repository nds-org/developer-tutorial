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

For example:
```
docker run --rm ndslabs/cowsay cowsay Hello
 _______
< Hello >
 -------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Or even:
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

This starts an interactive shell.  You can now run commands, install packages, edit files, etc.  But remember -- since the container was started with "--rm", when you exit your changes will be lost!

## Committing changes

It is possible to change the contents of a container and commit those changes to an image.  In this case, we do not want to use the "--rm" flag:

```
docker run -it ndslabs/cowsay sh
```

Once in the interactive shell, you can install additional packages:
```
apt-get install -y fortunes
```

Running the new command, you should see something like:
```
fortune

This bag is recyclable.
```

Exit out of the shell and use "docker ps -a" to find the container:
```
docker ps -a 

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
f31a89705ee2        ndslabs/cowsay      "sh"                56 seconds ago      Exited (0) 6 seconds ago                       cranky_almeida
```

You can commit your changes using "docker commit <CONTAINER ID>"
```
docker commit f31a89705ee2
```

This will create a new image:
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
<none>              <none>              09e96c21ffa1        12 seconds ago      175.9 MB
ndslabs/cowsay      latest              7f30ada4c040        42 minutes ago      170.9 MB
```

You'll want to tag the image for future use:
```
docker tag 09e96c21ffa1 myfortune
```

And you can now run a container based on your new image:
```
docker run --rm myfortune fortune

Tell me what to think!!!
```

## Creating a Dockerfile

Another way to change an image is to create a new Dockerfile. In this example, we'll combine our efforts above.

On your local system, create a new file called Dockerfile:

```
FROM debian:jessie

RUN apt-get update -y && apt-get install -y fortune cowsay

ENV PATH $PATH:/usr/games

CMD fortune -a | cowsay
```

We'll add the fortune package and change the default command

## Building the image

Once you have a Dockerfile, you can build a local image:
```
docker build -t fortunecow .
```

There's too much output to post here, but you should see the 4 steps in the Dockerfile.  You can see the resulting image by:

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
fortunecow          latest              3ac3a1461552        19 seconds ago      172.9 MB
fortune             latest              09e96c21ffa1        5 minutes ago       175.9 MB
ndslabs/cowsay      latest              7f30ada4c040        48 minutes ago      170.9 MB
```

And you can run a container based on the new image:
```
docker run --rm fortunecow
 ______________________________________
< Today is what happened to yesterday. >
 --------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```


## Sharing your images

If you have an account on Docker Hub, you can push this image to make it available to NDS Labs and others to reuse.

```
docker tag IMAGE USERNAME/IMAGE[:VERSION]
docker login
docker push USERNAME/IMAGE[:VERSION]
```

NOTE: If VERSION is not specified, "latest" is assumed.

For example:

```
docker tag fortunecow <user>/fortunecow
docker push <user>/fortunecow
```


## Next steps

Those are just the basics.  See the Docker tutorials and "docker --help" for more information.
