# NDS Labs Developer Tutorial
This repository contains several tutorials describing how to create custom [service specs](https://github.com/nds-org/ndslabs-specs).

This allows you to import new stacks and services to be launched from [NDS Labs](https://github.com/nds-org/ndslabs).

## NDS Labs Setup
To set up your own instance of NDS Labs, see [NDS Labs: setup.md](https://github.com/nds-org/ndslabs/blob/master/docs/setup.md).

## Customizing NDS Labs
Now that you have your own instance of NDS Labs running, its time to customize it!

In order to load a custom service into NDS Labs, only two things are needed:
* A [Docker](https://docs.docker.com/linux/) Image
* A [JSON spec](https://opensource.ncsa.illinois.edu/confluence/display/NDS/NDS+Labs+Service+Specification) describing the Image

### Docker Image
The first thing you will need is a Docker image.

You can find plenty of images on [Docker Hub](hub.docker.com), including all images used in NDS Labs.

#### New to Docker?
Never heard of Docker? Start [here](https://docs.docker.com/linux/)! 

#### Authoring a Dockerfile
Can't find an existing image for your service? You may need to create a Dockerfile describing how to build an image of the desired code.

Never built a Docker image? Try the [Cowsay](https://github.com/nds-org/developer-tutorial/blob/master/README.md#1-cowsay) example below.

More information regarding best practices for authoring a Dockerfile can be found [here](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

#### Building an Image
Once you have a Dockerfile for an image, you can build an image yourself by executing the following command:
```bash
docker build -t [REPOSITORY/]IMAGE[:VERSION] .
```

#### Sharing Your Images
If you have an account on Docker Hub, you can push this image to make it available to NDS Labs and others to reuse.

```bash
docker tag IMAGE USERNAME/IMAGE[:VERSION]
docker login
docker push USERNAME/IMAGE[:VERSION]
```

NOTE: If VERSION is not specified, "latest" is assumed.

### NDS Labs Spec
A [service spec](https://github.com/nds-org/ndslabs-specs) is our way of telling NDS Labs what an image needs in order to run.

Several examples are included to walk you through what's involved in creating a spec.

#### Loading a Custom Spec into NDS Labs
Now, run the following command to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f spec.json
```

You will be prompted for the admin password (default: "admin") in order to add a service.

Reloading the UI should show your new service(s) listed and ready to add from the left-side pane.

### Examples
Obtain a local copy of this tutorial by running
```bash
git clone https://github.com/nds-org/developer-tutorial.git /usr/local/lib/tutorial
cd /usr/local/lib/tutorial
```

#### 1.) Cowsay
An extremely simple example, [Cowsay](https://github.com/nds-org/developer-tutorial/tree/master/cowsay) introduces Docker and demonstrates what goes into authoring the most basic NDS Labs service spec.

#### 2.) Cloud9 IDE
A slightly more advanced example, [Cloud9](https://github.com/nds-org/developer-tutorial/tree/master/cloud9) introduces the notion of "volumes" into our spec and demonstrates how to persist data between Docker container restarts.

#### 3.) OwnCloud
The most complex example, [ownCloud](https://github.com/nds-org/developer-tutorial/tree/master/owncloud), mimics that of an actual stack that might be included in NDS Labs, introducing how to define dependencies and configuration options in the spec.
