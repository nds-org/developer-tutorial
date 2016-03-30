# NDSLabs Developer Tutorial

## Prerequisites

### System Shell
The sysmtem-shell is a small docker image that contains everything needed to begin running your own instance of NDSLabs in minutes:
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

### Clone This Repository
Obtain a local copy of this tutorial by running
```bash
git clone https://github.com/nds-org/developer-tutorial.git
```

### Cowsay
An extremely simple example to introduce Docker and the NDSLabs service spec.
