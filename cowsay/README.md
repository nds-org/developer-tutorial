# Example 1: [Cowsay](https://en.wikipedia.org/wiki/Cowsay)

Let's use a very simple example to start: **cowsay-php**.

In this example you will be introduced to the basics of Docker, including building and pushing images to be reused by others, as well as the NDS Labs service specification which tells NDS Labs how to run the image.

## Docker Basics
Start learning Docker with the [official Getting Started guide](https://docs.docker.com/linux/)!

## Docker Image
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

### Pushing to Docker Hub
If you have created a [Docker Hub](hub.docker.com) account, you can push this image up there for NDS Labs to pull down.

```bash
docker tag cowsay-php USERNAME/cowsay-php
docker login
docker push USERNAME/cowsay-php
```

**NOTE:** If you have already successfully executed `docker login` on this machine, you will not need to log in again.

## NDS Labs Spec
Now that we have a Docker image for our service, we need to tell NDS Labs how to run this image.

For this, we will need to wrap it in a [JSON service spec](https://opensource.ncsa.illinois.edu/confluence/display/NDS/NDS+Labs+Service+Specification), like the one below:
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

The above spec defines how NDS Labs will use the **cowsay-php** image that we built above.

NOTE: If you don't have a USERNAME from [Docker Hub](hub.docker.com), simply use **ndslabs** in place of **USERNAME** above to pull down and run our pre-built example image.

### Loading Cowsay into NDS Labs
Now, run the following command from the system-shell to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f cowsay.json
```

You will be prompted for the admin password (default: "admin") in order to add a service.

Reloading the UI will show your new service(s) listed and ready to add from the left-side pane.

### Testing Cowsay
Now that we have our cowsay spec loaded, let's try to create an instance of it in NDS Labs!

0. If you're not already running your own instance of NDS Labs, check out our [Setup Documentation](https://github.com/nds-org/ndslabs/blob/master/docs/setup.md).
1. Navigate your browser to `http://YOUR_IP:30000` and log in. 
2. You should now see "Cowsay" listed with the other services.
3. Click the **+** button beside "Cowsay" and step through the wizard to configure Cowsay:
  * Choose a name your stack appropriately and click **Next**.
  * Confirm that your stack looks correct and click **Confirm**
  * You will see your new "Cowsay" stack appear in the **Stacks** tab of the UI
4. Click the name of the stack to expand the accordion and show a more fine-grained status.
5. Click the "Launch Stack" button at the bottom-right of the pane.
6. Wait for the stack to start.
  * NOTE: this may take several minutes the first time, as Docker will pull the image before running it. 
7. Once the stack has started, navigate to its endpoint by click the link to the right of the service name.
8. A new tab will open, where you will be able to admire your cow in all its majesty

## Next Steps
You might notice that this simple example contains only static data, and nothing that would require long-term storage.

But what happens when we want to save this data between container restarts?

Now that you've gotten your hands dirty, let's move to a slightly more complex example where you will be introduced to persisted volumes: [the Cloud9 IDE](https://github.com/nds-org/developer-tutorial/tree/master/cloud9).
