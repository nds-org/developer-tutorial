# NDSLabs Developer Tutorial

## Prerequisites

### System Shell
The system-shell is a small docker image that contains everything needed to begin running your own instance of NDSLabs in minutes:
```bash
eval $(docker run --rm -it ndslabs/system-shell usage docker)
```

### Start Kubernetes
From the system-shell, run the following command to start running a local single-node Kubernetes cluster:
```bash
kube-up.sh
```

### Start NDSLabs
Still inside of system-shell, run the following command to start running NDSLabs:
```bash
nds-labs-up.sh
``` 

Now that we have a 

#### Clowder Tool Server (Optional)
If you wish to experiment with the "Tool Server" addon for Clowder, you can run your own instance of the Tool Server:
```bash
toolsrv.sh
```

Make sure to specify the **Public IP** of any Clowder instances you want to communicate with this Tool Server.

This can be done from the "Advanced Configuration" section of the Configuration Wizard.

## Customizing NDSLabs
Now that you have your own instance of NDSLabs running, its time to customize it!

### Docker Image
The first thing you will need is a docker image.

You can find plenty of images on hub.docker.com, including all images used in NDSLabs.

You can build an image yourself from source by executing the following command:
```bash
docker build -t [REPOSITORY_NAME/]IMAGE_NAME[:VERSION_TAG] .
```

#### Sharing Images
If you have an account on Docker Hub, you can push this image to make it available to NDSLabs and others to reuse.

```bash
docker login
docker push REPOSITORY/IMAGE[:VERSION]
```

NOTE: If VERSION is not specified, "latest" is assumed.

## NDSLabs Spec
The **spec** is our way of telling NDSLabs what an image needs in order to run. 
```js
{
  "key": "A unique identifier for this service. May not contain spaces.",
  "label": "How this service should appear in the UI",
  "image": A docker image, formatted as "repository/image:version",
}
```


### Loading a Custom Spec into NDSLabs
Run the following command to log into the NDSLabs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDSLabs:
```bash
ndslabsctl add service -f cowsay.json

### Examples
Obtain a local copy of this tutorial by running
```bash
git clone https://github.com/nds-org/developer-tutorial.git
```

#### Cowsay
An extremely simple example to demonstrate authoring an NDSLabs service spec.

View the **cowsay/** folder for more information.

#### Cloud9 IDE
A slightly more complicated example, Cloud9 introduces the notion of "volumes" and how to persist data in a Docker Container

View the **cloud9/** folder for more information.

#### OwnCloud
This example mimics that of an actual stack that might be included in NDSLabs.

View the **owncloud/** folder for more information.
