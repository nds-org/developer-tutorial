# Developer Support Example
This tutorial details workflows for developing applications within Labs Workbench.

## Fair Warning
Please be advised that Labs Workbench is still in beta, and should not be used to house critical or sensitive data.

See [Appectable Use Policy](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Acceptable+Use+Policy) for more details.

# Docker Basics
Start learning Docker with our [Docker 101](docker-101/README.md) tutorial.

## Sign Up for Docker Hub
If you don't already have an account, and wish to push your own custom images as a part of this tutorial, please register for an account on [Docker Hub](hub.docker.com).

# Running Docker in Labs Workbench
We offer several developer environments that allow you to build, tag, and push your own Docker images:
* Docker Web Terminal
* Cloud9 IDE with Docker support

Start up one of these environments to gain access to a Docker-enabled terminal.

We will start with a very simple example: **cowsay-php**.

In this example you will:
* Learn the basics of using Docker
* Using a Docker-enabled environment, build and push an image that can be consumed by Labs Workbench
* Run any image from Docker Hub using Labs Workbench (using the Add/Edit Spec view)

See a [video](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Feature+Overview#FeatureOverview-Dockerbuild/tag/push) of this feature in action!

## Building Docker Images

The first thing you will need is a docker image. You can find plenty of images on [Docker Hub](hub.docker.com), but we've provided the most simple of examples to illustrate the process of building an image from a Dockerfile.

You can build the **cowsay-php** image yourself from source by executing the following command:
```bash
docker build -t cowsay-php .
```

Once the build is complete, running `docker images` should show your newly built image:
```bash
$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
cowsay-php                                 latest              bf5dbf5675ef        46 hours ago        534.9 MB
```

## Pushing to Docker Hub
If you have created a [Docker Hub](hub.docker.com) account, you can push this image to Docker Hub.

Login to your Docker Hub account:
```bash
docker login
```

**WARNING:** Your credentials will be stored in this environment, but only you will be able to access them.

Tag the image with a memorable name and push it:
```bash
docker tag cowsay-php USERNAME/cowsay-php
docker push USERNAME/cowsay-php
```

Any image that has been pushed to Docker Hub can then be pulled and run by Labs Workbench.

## Running Cowsay in Labs Workbench
Now that we have a Docker image for our service, we need to tell Labs Workbench how to run this image by creating a JSON spec for it.

Luckily, the UI provides an easy way to create and edit these specs.

## Testing Cowsay in Labs Workbench
Now that we have our cowsay spec loaded, let's try to create an instance of it in Labs Workbench!

1. Import the above JSON spec into your personal catalog
2. You should now see "Cowsay" listed with the other services.
3. Click the **Add** button beneath cowsay in the catalog
4. Click the **View** button to navigate to your dashboard of added appliations.
5. Expand the Cowsay accordion header to see a more fine-grained status.
5. Click the "Launch" button at the bottom-right of the accordion pane.
6. Wait for the application to start.
  * NOTE: this may take several minutes the first time, as Docker will pull the image before running it. 
7. Once the application has started, navigate to its endpoint by click the link to the right of the service name.
8. A new tab will open, where you will be able to admire your cow in all its majesty.

See a [video](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Feature+Overview#FeatureOverview-Developmentenvironment-simpleexample) of this feature in action!

# A More Complex Example: Clowder Extractors
For many projects, setting up a developer environment to build and test the source of a particular application can often be more tedious and error-prone than installing the software itself.

Labs Workbench seeks to mitigate this problem by providing developer environments that come preloaded with all of the necessary dependencies.

For example:
* The pyClowder flavor of the pyCharm IDE that allows users to quickly get started writing their own extractors for Clowder
* The Cloud9 Java IDE with its built-in Maven support allows you to modify and build Dataverse with relative ease
* The Cloud9 Python IDE can be used to easily make modification to the backend api of the NDS Analysis Toolbox
* The Cloud9 Node.js IDE can be used to quickly start developing any Node.js application, such as the frontend portions of Labs Workbench or the NDS Analysis Toolbox
* The Cloud9 Go IDE can be used to develop the Labs Workbench API server itself
* With **novnc** / **xpra** Docker base images, adding your favorite graphical desktop applications is a snap!

See a [video](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Feature+Overview#FeatureOverview-Developmentenvironment-Clowderextractordevelopment) of this feature in action!

# An Even More Complex Example: Securely access remote development services while developing locally
If you'd rather use your desktop IDE than develop in the cloud, we offer a service called **HTTP Tunnel** (based on [Chisel](https://github.com/jpillora/chisel)).

1. Start the Chisel application in Labs Workbench
2. Download and install the Chisel client
3. Use the client to connect to your running Chisel application in Workbench

A secure tunnel will be established to the private subnet used by Labs Workbench.

This will allow you to develop locally against remotely running instances of MySQL, MongoDB, PostgreSQL, RabbitMQ or any other Docker-ized service - without exposing them to the public internet!

See a [video](https://nationaldataservice.atlassian.net/wiki/display/NDSC/Feature+Overview#FeatureOverview-Developmentenvironment-remoteaccess) of this feature in action!