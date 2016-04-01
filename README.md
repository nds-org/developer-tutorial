# NDS Labs Developer Tutorial
This repository contains several tutorials describing how to create custom [service specs](https://github.com/nds-org/ndslabs-specs).

This allows you to import new stacks and services to be launched from [NDS Labs](https://github.com/nds-org/ndslabs).

## NDS Labs Setup
There are a few automated steps involved in setting up your own instance of NDS Labs.

### System Shell
The system-shell is a small docker image that contains everything needed to begin running your own instance of NDS Labs in minutes:
```bash
$ eval $(docker run --rm -it ndslabs/system-shell usage docker)
```

You should see Docker begin to pull the image. Once all layers of the image are pulled, you will dropped into the system-shell container:
```bash
Unable to find image 'ndslabs/system-shell:latest' locally
latest: Pulling from ndslabs/system-shell
ff12aecbe22a: Already exists
287750ad6625: Already exists
ca98bdf222fa: Already exists
a3ed95caeb02: Already exists
97ef68d67ea6: Pull complete
8c53c989a967: Pull complete
79d911a06f41: Pull complete
807cecd8f466: Pull complete
7f887f3746f8: Pull complete
0cadab32de06: Pull complete
aff97fd2a6c1: Pull complete
Digest: sha256:4128fff8a0234ee6cc25d077b7f607358e681370e5a483b6c89fe1a3dfc3e77e
Status: Downloaded newer image for ndslabs/system-shell:latest
[root@default NDSLabsSystem ] / # 
```

### Start Kubernetes
From the system-shell, run the following command to start running a local single-node Kubernetes cluster:
```bash
kube-up.sh
```

You can then execute `kubectl get svc,rc,pods` in order to see the status of your cluster.

Once everything is up and running, the output should look as follows:
```bash
# kubectl get svc,rc,pods                  
NAME                      CLUSTER-IP   EXTERNAL-IP   PORT(S)     AGE
kubernetes                10.0.0.1     <none>        443/TCP     1m
NAME                      READY        STATUS        RESTARTS   AGE
k8s-etcd-127.0.0.1        1/1          Running       0          1m
k8s-master-127.0.0.1      4/4          Running       3          1m
k8s-proxy-127.0.0.1       1/1          Running       0          1m
```

### Start NDS Labs
Still inside of system-shell, run the following command to start running NDS Labs:
```bash
ndslabs-up.sh
```

```bash
# kubectl get svc,rc,pods                  
NAME                      CLUSTER-IP   EXTERNAL-IP   PORT(S)     AGE
kubernetes                10.0.0.1     <none>        443/TCP     3m
ndslabs-apiserver         10.0.0.184   nodes         30001/TCP   1m
ndslabs-gui               10.0.0.242   nodes         80/TCP      1m
NAME                      DESIRED      CURRENT       AGE
ndslabs-apiserver         1            1             1m
ndslabs-gui               1            1             1m
NAME                      READY        STATUS        RESTARTS   AGE
k8s-etcd-127.0.0.1        1/1          Running       0          3m
k8s-master-127.0.0.1      4/4          Running       3          3m
k8s-proxy-127.0.0.1       1/1          Running       0          3m
ndslabs-apiserver-pikrf   1/1          Running       0          1m
ndslabs-gui-urpqz         1/1          Running       0          1m
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
Now, run the following command to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f spec.json
```

You will be prompted for the admin password (default is "admin") in order to add a service.

Reloading the UI should show your new service(s) listed and ready to add!

### Examples
Obtain a local copy of this tutorial by running
```bash
git clone https://github.com/nds-org/developer-tutorial.git
```

#### 1.) Cowsay
An extremely simple example to demonstrate authoring an NDS Labs service spec.

View the [cowsay/](https://github.com/nds-org/developer-tutorial/tree/master/cowsay) folder for more information.

#### 2.) Cloud9 IDE
A slightly more complicated example, Cloud9 introduces the notion of "volumes" and how to persist data in a Docker Container

View the [cloud9/](https://github.com/nds-org/developer-tutorial/tree/master/cloud9) folder for more information.

#### 3.) OwnCloud
This example mimics that of an actual stack that might be included in NDS Labs.

View the [owncloud/](https://github.com/nds-org/developer-tutorial/tree/master/owncloud) folder for more information.
