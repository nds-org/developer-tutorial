# Example 1: Cowsay

## Docker Image
The first thing you will need is a docker image. You can find plenty of images on hub.docker.com.

Let's use a very simple example to start: **cowsay-php**.

You can build this image yourself from source by executing the following command:
```bash
docker build -t cowsay-php .
```

### Pushing to Docker Hub
If you have created a [Docker Hub](hub.docker.com) account, you can push this image up there for NDS Labs to pull down.

```bash
docker tag cowsay-php USERNAME/cowsay-php
docker login
docker push USERNAME/cowsay-php
```

## NDS Labs Spec
Now that we have a Docker image for our service, we need to wrap it in a spec:
```js
{
    "key": "cowsay",
    "label": "Cowsay",
    "image": "USERNAME/cowsay-php:latest",
    "description": "An example of a custom spec loaded into NDS Labs",
    "access": "external",
    "display": "stack",
    "ports": [
        { "port": 80, "protocol": "http" }
    ]
}
```

The above spec defines how NDS Labs will use the "cowsay-php" image that we built above.

NOTE: If you don't have a USERNAME from [Docker Hub](hub.docker.com), simply use **ndslabs** in place of the USERNAME above.

### Loading Cowsay into NDS Labs
Run the following command to log into the NDS Labs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDSLabs:
```bash
ndslabsctl add service -f cowsay.json
```

### Testing Cowsay
Now that we have our cowsay spec loaded, let's try to create an instance of it in NDSLabs!

Navigate your browser to your instance of NDS Labs. You should now see "Cowsay" listed with the other services.

Choose "Add" next to "Cowsay" and step through the wizard.

Start up the "Cowsay" stack once it has been created, navigate to its endpoint, and admire your cow in all its majesty.
