# NDSLabs Example: Cloud9 IDE

## Docker Image
The first thing you will need is a docker image. You can find plenty of images on hub.docker.com.

Let's use a very simple example to start: **ndslabs/cloud9**.

You can build this image yourself from source by executing the following command:
```bash
docker build -t ndslabs/cloud9 .
```

## NDSLabs Spec
Now that we have a Docker image for our service, we need to wrap it in a spec:
```js
{
    "key": "cloud9",
    "label": "Cloud9 IDE",
    "image": "ndslabs/cloud9:latest",
    "description": "A web-based IDE running on Node.js",
    "access": "external",
    "display": "stack",
    "ports": [
        { "port": 80, "protocol": "http" }
    ],
    "volumeMounts": [
      { "name": "cloud9", "mountPath": "/workspace" }
    ]
}
```

The above spec defines how NDSLabs will use the "cloud9" image that we built above.

### Loading Cloud9 into NDSLabs
Run the following command to log into the NDSLabs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDSLabs:
```bash
ndslabsctl add service -f cloud9.json
```

### Testing Cloud9
Now that we have our cloud9 spec loaded, let's try to create an instance of it in NDSLabs!

Navigate your browser to your instance of NDSLabs. You should now see "Cloud9 IDE" listed with the other services.

Choose "Add" next to "Cloud9 IDE" and step through the wizard.

Start up the "Cloud9 IDE" stack once it has been created and navigate to its endpoint.

You should now be taken to the Cloud9 interface, where you will be able to create and edit any files that exist on the volume that we defined above!

### Persisted Volumes
Although it will be initially empty, you can use the console at the bottom of the editor to execute git commands.

Create a new file called "test" and place some text into it.

Shut down the stack and restart it and you should still see the "test" file that you created prior to restarting!
