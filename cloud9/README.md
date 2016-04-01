# Example 2: [Cloud9 IDE](https://c9.io/)

In the [Cowsay example](https://github.com/nds-org/developer-tutorial/tree/master/cowsay), we learned how to use Docker, and authored our first custom service spec. Now let's try a slightly more complex example: **cloud9**.

In this example you will be introduced to the concept of "persisted volumes" and how to preserve data between Docker container restarts.

Normally, when a Docker container restarts, any changes to that container's file system are discarded. But what if we want to preserve some data in the container? A good example of this is a database container, which would be fairly useless if it did retain the data during a container restart.

## Docker Image
You can build the **cloud9** image yourself from source by executing the following command:
```bash
docker build -t cloud9 .
```

Once the build is complete, running `docker images` should show your newly built image:
```bash
$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
cloud9                                     latest              b2ae47399cbf        45 hours ago        838.3 MB
```

### Pushing to Docker Hub
If you have created a [Docker Hub](hub.docker.com) account, you can push this image up there for NDS Labs to pull down.

```bash
docker tag cloud9 USERNAME/cloud9
docker login
docker push USERNAME/cloud9
```

**NOTE:** If you have already successfully executed `docker login` on this machine, you will not need to log in again.

## NDS Labs Spec
Now that we have a Docker image for our service, we need to tell NDS Labs how to run this image.

For this, we will need to wrap it in a [JSON service spec](https://opensource.ncsa.illinois.edu/confluence/display/NDS/NDS+Labs+Service+Specification), like the one below:
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

NOTE: If you don't have a USERNAME from [Docker Hub](hub.docker.com), simply use **ndslabs** in place of **USERNAME** above to pull down and run our pre-built example image.

### Volume Mounts
The above spec defines how NDSLabs will use the "cloud9" image that we built above.

The **volumeMounts** field tells us the path of any data that we would want to retain between restarts.

NOTE: **mountPath** must be an absolute path.

### Loading Cloud9 into NDS Labs
Run the following command from the system-shell to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f cloud9.json
```

You will be prompted for the admin password (default: "admin") in order to add a service.

Reloading the UI will show your new service(s) listed and ready to add from the left-side pane.

### Testing Cloud9
Now that we have our cloud9 spec loaded, let's try to create an instance of it in NDS Labs!

0. If you're not already running your own instance of NDS Labs, check out our [Setup Documentation](https://github.com/nds-org/ndslabs/blob/master/docs/setup.md).
1. Navigate your browser to `http://YOUR_IP:30000` and log in. 
2. You should now see "Cloud9 IDE" listed with the other services.
3. Click the **+** button beside "Cloud9 IDE" and step through the wizard to configure Cloud9:
  * Choose a name your stack appropriately and click **Next**.
  * Choose a size to use for the volume that will attach to this service.
    * You will be asked to reuse any detached volumes for this service, if any such volumes exist.
  * Confirm that your stack looks correct and click **Confirm**
  * You will see your new "Cloud9 IDE" stack appear in the **Stacks** tab of the UI
4. Click the name of the stack to expand the accordion and show a more fine-grained status.
5. Click the "Launch Stack" button at the bottom-right of the pane.
6. Wait for the stack to start.
  * NOTE: this may take several minutes the first time, as Docker will pull the image before running it. 
7. Once the stack has started, navigate to its endpoint by click the link to the right of the service name.
8. A new tab will open, where you will be able to taken to the Cloud9 IDE interface, where you will be able to create and edit any files that exist on the volume that we defined above.

#### Testing Persisted Volumes
You can use the console at the bottom of the editor to execute Git commands, allowing you to clone source repositories, modify them, and commit/push your changes back. Although your workspace will be initially empty, you can create new files and edit them as you see fit. These new files will be saved across container restarts.

Try it for yourself:
1. Create a new file called "test" and place some text into it.
2. Shut down the cloud9 stack.
3. Once it has fully shut down, start the cloud9 stack up once again.
4. Once the stack has restarted, navigate to its endpoint by click the link to the right of the service name.
5. A new tab will open, where you will be able to taken to the Cloud9 IDE interface, where should see your workspace exactly as you left it.

## Next Steps
Now that you have been introduced to persisted volumes and how to define them in a spec, let's move to a realistic example of a service to add: [ownCloud](https://github.com/nds-org/developer-tutorial/tree/master/owncloud).
