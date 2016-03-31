# Example 3: ownCloud

Finally, here is a more complex and realistic example: **owncloud** + **mysql**.

## Docker Image
Since this example uses only official images, there is nothing to build.

If we want to customize these official images, we can create a Dockerfile that starts with `FROM owncloud:latest` or `FROM mysql:latest`.

We can then make any additions or customizations that we would like, build this new image, and push it to Docker Hub.

We would then simply need to change the "image" tag below to point at the image we just pushed in order to use it in this spec.

## NDSLabs Spec
The following spec defines how NDSLabs will use the "owncloud" image:
```js
{
    "key": "owncloud",
    "label": "ownCloud",
    "image": "owncloud:latest",
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

The following spec defines how NDSLabs will use the "mysql" image:
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

### Loading ownCloud and MySQL into NDSLabs
Run the following command to log into the NDSLabs CLI as admin:
```bash
ndslabsctl login admin
```

NOTE: The default admin password is "admin"

Then, run the following command to load this custom spec into NDSLabs:
```bash
ndslabsctl add service -f mysql.json
ndslabsctl add service -f owncloud.json
```

### Testing ownCloud
Now that we have our custom specs loaded, let's try to create an instance of "ownCloud" in NDSLabs!

Navigate your browser to your instance of NDSLabs. You should now see "ownCloud" listed with the other services.

Checking the "show standalones" checkbox should show that MySQL is addable from the interface as well.

Choose "Add" next to "ownCloud" and step through the wizard. You should be asked if you want to enable the MySQL option along the way.

Be sure to configure MySQL's user/password configruration, as ownCloud will ask you for those values while finishing its setup.

Start up the "ownCloud" stack once it has been created, navigate to its endpoint, and continue through the ownCloud setup using their web interface.

### Testing MySQL integration
Part of the setup for ownCloud will ask the user to enter their MySQL configuration info.

This can be found by clicking the "View Config" button next to MySQL in the ownCloud stack service list.
