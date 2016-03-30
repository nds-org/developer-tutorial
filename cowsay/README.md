# NDSLabs Cowsay Example

## Docker Image
The first thing you will need is a docker image. You can find plenty of images on hub.docker.com.

Let's use a very simple example to start: **ndslabs/cowsay-php**.

You can build this image yourself from source by executing the following command:
```bash
docker build -t ndslabs/cowsay-php .
```

## NDSLabs Spec
Now that we have a Docker image for our service, we need to wrap it in a spec:
```js
{
    "key": "cowsay",
    "label": "NDSLabs Cowsay Example",
    "image": "ndslabs/cowsay-php:latest",
    "description": "An example of a custom spec loaded into NDSLabs",
    "access": "external",
    "display": "stack",
    "ports": [
        { "port": 80, "protocol": "http" }
    ]
}
```

The above spec defines how NDSLabs will use the "cowsay-php" image that we built above.

### Loading a Custom Spec into NDSLabs
Run the following command to log into the NDSLabs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDSLabs:
```bash
ndslabsctl add service -f cowsay.json
``

### Testing the Spec
Now that we have our spec loaded, let's try to create an instance of it in NDSLabs!

Navigate your browser to your instance of NDSLabs. You should now see your new service listed on the left-side.

Choose "Add" next to your newly-added service and step through the wizard.

Start up the stack once it has been created, navigate to its endpoint, and admire your cow and all its majesty.
