# NDSLabs Cowsay Example

## Docker Image
The first thing you will need is a docker image. You can find plenty of images on hub.docker.com.

Let's use a very simple example to start: **ndslabs/cowsay-php**.

You can build this image yourself from source by executing the following command:
```bash
docker build -t ndslabs/cowsay-php .
```

If you have an account on Docker Hub, you can push this image to make it available to NDSLabs and others to reuse.

```bash
docker login
docker push REPOSITORY/IMAGE[:VERSION]
```

## NDSLabs Spec
Now that we have a Docker image for our service, we need to wrap it in a spec.

```js

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
```