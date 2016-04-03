# Example 3: [ownCloud](https://owncloud.org/) + [MySQL](https://www.mysql.com/)

In the [Cloud9 example](https://github.com/nds-org/developer-tutorial/tree/master/example-2-cloud9), we learned how to define persisted volumes in the NDS Labs service spec. Now let's try a realistic example using some services we would like to eventually see in NDS Labs: **owncloud** and **mysql**.

In this example we will introduce specifying dependencies between services, and how to define environment variables to handle custom configuration.

## Docker Image
Since this example uses official images, there is nothing to build.

But what if the image will not work with NDS Labs out of the box and requires slight customization?

There are 2 options readily available if we want to customize an existing Docker image. 

### Option 1: Create a Dockerfile from a Base Image
Create a Dockerfile that starts with `FROM owncloud:latest`. You can then make any additions or customizations that we would like, build a new image from this Dockerfile, and push it to Docker Hub.

We have provided an example of such a [Dockerfile](https://github.com/nds-org/developer-tutorial/blob/master/owncloud/Dockerfile).

You can build this image by running the following command:
```bash
docker build -t owncloud .
```

### Option 2: Run, Modify, and Commit
Jump into a running container using `docker exec -it <container name or id> /bin/bash` to modify a running container in-place.

You can then use: 
* `docker diff <sourceContainer>` allows you to view the changes you've made to the container since it started running
* `docker commit <sourceContainer> <targetImage>` will save the changes from this container into a new image

### Pushing to Docker Hub
If you have created a [Docker Hub](hub.docker.com) account, you can push this image up there for NDS Labs to pull down.

```bash
docker tag owncloud USERNAME/owncloud
docker login
docker push USERNAME/owncloud
```

**NOTE:** If you have already successfully executed `docker login` on this machine, you will not need to log in again.

## NDS Labs Spec
Now that we have a Docker image for our service, we need to tell NDS Labs how to run this image.

For this, we will need to wrap it in a [JSON service spec](https://opensource.ncsa.illinois.edu/confluence/display/NDS/NDS+Labs+Service+Specification).

The following spec defines how NDS Labs will use the "owncloud" image:
```js
{
  "key": "owncloud",
  "label": "ownCloud",
  "image": "USERNAME/owncloud:latest",
  "description": "A self-hosted file sync and share server",
  "access": "external",
  "display": "stack",
  "depends": [
    { "key": "mysql", "required": false }
  ],
  "ports": [
    { "port": 80, "protocol": "http" }
  ],
  "volumeMounts": [
    { "name": "owncloud", "mountPath": "/var/www/owncloud" }
  ]
}
```

NOTE: If you don't have a USERNAME from [Docker Hub](hub.docker.com), simply use **ndslabs** in place of **USERNAME** above to pull down and run our pre-built example image.

### Dependencies
You might have noticed the **depends** section in the spec above: this defines a "service dependency".

Dependencies can be either **required** or optional.

The following spec defines how NDS Labs will use the optional "mysql" dependency:
```js
{
    "key": "mysql",
    "label": "MySQL",
    "image": "mysql:latest",
    "description": "An open-source relational database management system",
    "access": "internal",
    "display": "standalone",
    "config": [
      { "name": "MYSQL_ROOT_PASSWORD", "value": "",         "label": "Root Password", "canOverride": false, "isPassword": true  },
      { "name": "MYSQL_DATABASE",      "value": "owncloud", "label": "Database",      "canOverride": false, "isPassword": false },
      { "name": "MYSQL_USER",          "value": "username", "label": "Username",      "canOverride": true,  "isPassword": false },
      { "name": "MYSQL_PASSWORD",      "value": "",         "label": "Password",      "canOverride": true,  "isPassword": true  }
    ],
    "ports": [
        { "port": 3306, "protocol": "tcp" }
    ],
    "volumeMounts": [
      { "name": "mysql", "mountPath": "/var/lib/mysql" }
    ]
}
```

### Environment Variables
The above spec includes another new section: **config**, which contains an array of configuration options. This allows you to specify environment variables, as well as their default values, that should be passed in when running the image.

You can specify the following to customize your configuration options:
* name: the key of the environment variable to be created
* value: the default value to associate with this environment variable
* label: how should this environment varibale be displayed in the UI?
* canOverride: should the user be allowed to input their own value for this field?
* isPassword: should the UI treat this field as a password? 
  * This will allow the user to generate random values for this field

### Loading ownCloud and MySQL into NDS Labs
Run the following command from the system-shell to load this custom spec into NDS Labs:
```bash
ndslabsctl add service -f mysql.json
ndslabsctl add service -f owncloud.json
```

You will be prompted for the admin password (default: "admin") in order to add a service.

Reloading the UI will show your new service(s) listed and ready to add from the left-side pane.

### Testing OwnCloud
Now that we have our owncloud spec loaded, let's try to create an instance of it in NDS Labs!

0. If you're not already running your own instance of NDS Labs, check out our [Setup Documentation](https://github.com/nds-org/ndslabs/blob/master/docs/setup.md).
1. Navigate your browser to `http://YOUR_IP:30000` (create a project if necessary) and log in. 
2. You should now see "ownCloud" listed with the other services on the left side of the page.
3. Click the **+** button beside "ownCloud" and step through the wizard to configure ownCloud:
  * Choose a name your stack appropriately and click **Next**.
  * You will be given the option to select MySQL, but do not select it. Click **Next**.
  * Choose a size to use for the volume that will attach to this service.
    * If previous volumes matching this service exist, and are not currently attached to another service, the wizard will offer to reuse them.
  * Confirm that your stack looks correct and click **Confirm**
  * You will see your new "ownCloud" stack appear in the **Stacks** tab of the UI
4. Click the name of the stack to expand the accordion and show a more fine-grained status.
5. Click the "Launch Stack" button at the bottom-right of the pane.
6. Wait for the stack to start.
  * NOTE: this may take several minutes the first time, as Docker will pull the image before running it. 
7. Once the stack has started, navigate to its endpoint by click the link to the right of the service name.
8. A new tab will open, where you will be taken to the ownCloud self-installation web interface.
  * Enter the username and password that you would like to use for the ownCloud administrator.
  * Once you have chosen your admin credentials, click **Finish Setup**.
9. You should then be brought to your ownCloud instance's home page, where you will be able to upload new files and view existing files existing on the attached volume.
10. Upload a test file somewhere into ownCloud using the **+** button at the top-left of the screen.

### Testing ownCloud + MySQL
We've tested our ownCloud spec, but what about the MySQL integration?

0. If you're not already running your own instance of NDS Labs, check out our [Setup Documentation](https://github.com/nds-org/ndslabs/blob/master/docs/setup.md).
1. Navigate your browser to `http://YOUR_IP:30000` (create a project if necessary) and log in. 
2. You should now see "ownCloud" listed with the other services on the left side of the page.
3. Click the **+** button beside "ownCloud" and step through the wizard to configure ownCloud:
  * Choose a name your stack appropriately and click **Next**.
  * Now, select MySQL as an optional service and click **Next**.
  * The wizard will now prompt you to enter passwords necessary for MySQL, as specified by the "Config" in the spec above. Because we specified "isPassword" above, you can click the button on the right to generate a secure random password.
    * Clicking **Advanced Configuration** will also allow you to set the database and username that MySQL will use, if want to change the default values.
  * Choose a size to use for the volumes that will attach to these services.
    * The numbers of the top-right of the colored panel will allow you to switch between the volume requirements for this stack, if more than one exist.
    * You will be asked to create one volume each for ownCloud and MySQL.
    * If previous volumes matching these services exist, and are not currently attached to another service, the wizard will offer to reuse them.
  * Confirm that your stack looks correct and click **Confirm**.
  * You will see your new "ownCloud" stack appear in the **Stacks** tab of the UI.
4. Click the name of the stack to expand the accordion and show a more fine-grained status.
  * You will see MySQL listed beneath the ownCloud in te Service List.
5. Click the "Launch Stack" button at the bottom-right of the pane.
6. Wait for the stack to start.
  * NOTE: this may take several minutes the first time, as Docker will pull the image before running it. 
7. Once the stack has started, navigate to its endpoint by click the link to the right of the service name.
8. A new tab will open, where you will be taken to the ownCloud self-installation web interface.
  * Enter the username and password that you would like to use for the ownCloud administrator.
  * During the setup, be sure to expand the "Storage & database".
  * Choose **MySQL / MariaDB** to specify your MySQL instance details.
  * You will be prompted to enter the database, username, and password that you specified while configuring MySQL, as well as the address of the running instance.
    * Back at the NDS Labs interface, click the **Config** button to the right of the service name under your ownCloud stack. 
    * The database, username, and password are listed under "Environment".
    * The address where ownCloud can reach MySQL is listed under "Endpoints" as the "Internal Address".
    * NOTE: This MySQL instance is not exposed to the public internet, so there is no "External Address" listed.
  * Once you have entered the details of the running MySQL instance, click **Finish Setup**.
9. You should then be brought to your ownCloud instance's home page, where you will be able to upload new files and view existing files existing on the attached volume.
10. Upload a test file somewhere into ownCloud using the **+** button at the top-left of the screen.
11. To verify that MySQL is receiving updates from ownCloud, let's find a reference to the file you just uploaded in the MySQL database. 
  * Jump over to your terminal and execute `docker ps | grep mysql` to locate the running MySQL container and grab its container id.
  * Execute `docker exec -it <container id> mysql -u owncloud -p` and enter the MySQL password for the "owncloud" user. This will drop you into the container at the mysql shell.
    * Click the **Config** button to the right of the service name under your ownCloud stack and copy / paste the MySQL password into the prompt. 
  * Execute the following query to verify that your new file upload was persisted to MySQL `select path from owncloud.oc_filecache order by path;`.
  * You should see all of your files, including the newly-uploaded file, ordered by file path and listed in the output.

## Success!
Congratulations! You made it through the entire tutorial.

You should now have everything you need to start authoring your own images and services specs to add to NDS Labs.
