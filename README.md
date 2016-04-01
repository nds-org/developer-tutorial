# NDS Labs Developer Tutorial
This repository contains several tutorials describing how to create custom [service specs](https://github.com/nds-org/ndslabs-specs).

This allows you to import new stacks and services to be launched from [NDS Labs](https://github.com/nds-org/ndslabs).

## NDS Labs Setup
There are a few automated steps involved in setting up your own instance of NDS Labs.

### System Shell
The system-shell is a small docker image that contains everything needed to begin running your own instance of NDS Labs in minutes:
```bash
eval $(docker run --rm -it ndslabs/system-shell usage docker)
```

### Start Kubernetes
From the system-shell, run the following command to start running a local single-node Kubernetes cluster:
```bash
kube-up.sh
```

### Start NDS Labs
Still inside of system-shell, run the following command to start running NDS Labs:
```bash
ndslabs-up.sh
``` 

#### Clowder Tool Server (Optional)
If you wish to experiment with the "Tool Server" addon for Clowder, you can run your own instance of the Tool Server from the system-shell:
```bash
toolsrv.sh
```

Make sure to specify the **Public IP** of any Clowder instances you want to communicate with this Tool Server.

This can be done from the "Advanced Configuration" section of the Configuration Wizard.

## Customizing NDS Labs
Now that you have your own instance of NDS Labs running, its time to customize it!

In order to load a custom service into NDS Labs, only two things are needed:
* A Docker Image
* A JSON spec describing the Docker Image

### Docker Image
The first thing you will need is a docker image.

You can find plenty of images on hub.docker.com, including all Docker images used in NDS Labs.

#### Authoring a Dockerfile
Can't find an existing image for your service?

Some Dockerfile examples are included in this tutorial to get your started.

More information regarding best practices for authoring a Dockerfile can be found here: https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

#### Building an Image
You can build an image yourself from a Dockerfile by executing the following command:
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
The **spec** is our way of telling NDS Labs what an image needs in order to run.

Listed below are all possible fields of a spec (NOTE: you do **not** need to define sections that you do not plan to use):
```js
{
  "key": "A unique identifier for this service - may only contain lowercase alpha-numeric characters",
  "label": "How this service should appear in the UI",
  "image": "A docker image, formatted as repository/image:version",
  "description": "A short description of what this service does that will appear in the UI",
  "access": "external if browser needs to access, internal if other services need to access, none otherwise",
  "display": "stack if it should be displayed at the top-level in the UI, standalone if it should be displayed under the 'Show Standalones' checkbox in the UI, none otherwise",
  "depends": [
    {
      "key": "The key of another service that this spec depends on",
      "required": "True if this dependency is required. False if it is optional",
      "shareConfig": "True if any config from the dependency should be copied into this one"
    },
      ...
  ],
  "config": [
    {
      "name": "Name of the environment variable to set inside of this container",
      "value": "Value of the environment variable",
      "label": "The label for this property that will appear in the UI",
      "isPassword": "True if this variable reprents a password - this tells the UI to generate a password box and to allow the user to generate a random value for this field",
      "canOverride": "True if this variable can be overridden by the user, if they so desire"
    },
      ...
  ],
  "ports": [
    {
      "port": "A port number to expose",
      "protocol": "The protocol of this exposed port  must be lowercase (i.e. http, tcp, udp, etc)"
    },
      ...
  ],
  "volumeMounts": [
    {
      "name": "The unique identifier of this volume mount - this must match an existing volume",
      "mountPath": "The absolute path of the destination inside of the container"
    },
      ...
  ],
  "readinessProbe": {
    "type": "Must be one of http / tcp",
    "path": "For HTTP probes, the full address / path to probe",
    "port": "The port number to query",
    "initialDelay": "How long to wait before starting the probe",
    "timeout": "How long to wait before stopping the probe"
  }
}
```

#### Loading a Custom Spec into NDS Labs
Run the following command to log into the NDS Labs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f spec.json
```

Now reloading the UI should show your new service(s) listed and ready to add!

### Examples
Obtain a local copy of this tutorial by running
```bash
git clone https://github.com/nds-org/developer-tutorial.git
```

#### 1.) Cowsay
An extremely simple example to demonstrate authoring an NDS Labs service spec.

View the **cowsay/** folder for more information.

#### 2.) Cloud9 IDE
A slightly more complicated example, Cloud9 introduces the notion of "volumes" and how to persist data in a Docker Container

View the **cloud9/** folder for more information.

#### 3.) OwnCloud
This example mimics that of an actual stack that might be included in NDS Labs.

View the **owncloud/** folder for more information.
