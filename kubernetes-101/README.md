## Kubernetes 101

This is based on the excellent [Kubernetes 101](http://kubernetes.io/docs/user-guide/walkthrough/) tutorial.
 
# What you'll learn
* How to use kubectl
* How to create Pods, Replication Controllers and Services
 
# What you'll need
* NDS Labs system shell

# Starting Kubernetes

You'll first need to start your local Kubernetes services using the kube-up.sh provided in the (NDS Labs system shell)[https://github.com/nds-org/ndslabs/blob/master/docs/setup.md].


# Creating a Pod

In this first example, you'll create a simple Kubernetes Pod specification. 

In your favorite editor, create a file called "nginx-pod.yaml":

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```

This specifies a Pod with a single nginx container running on port 80. Nginx is a commonly used web server.

Create the Pod using kubectl:

```
kubectl create pod -f nginx-pod.yaml

pod "nginx" created
```

List your running pods:
```
kubectl get pods

NAME                   READY     STATUS              RESTARTS   AGE
nginx                  0/1       ContainerCreating   0          23s
```

If you've never run the nginx container, Kubernetes will download it. Once it's ready, you should see:
```
NAME                   READY     STATUS              RESTARTS   AGE
nginx                  1/1       Running   0          4s
```

Access your running pod:
```
kubectl get pod nginx --template {{.status.podIP}}
172.17.0.1

curl http://$(kubectl get pod nginx --template {{.status.podIP}})
```

This will output the HTML of the running nginx instance.

Delete the pod:
```
kubectl delete pod nginx
```

And wait until it stops:

List your running pods:
```
kubectl get pods
```

You should no longer see the nginx Pod.

# Creating a Replication Controller

You would rarely run a Pod alone. One of Kubernete's strengths is it's ability to keep containers up and running seamlessly. So now we'll move our Pod specification into a replication controller.

Using your favorite editor, create a file called "nginx-rc.yaml":

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-rc
spec:
  replicas: 2
  # selector identifies the set of Pods that this
  # replication controller is responsible for managing
  selector:
    app: nginx
  template:
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

This specifies a replication controller that will run two replicas if the nginx container.

Create the Replication Controller using kubectl:

```
kubectl create -f nginx-rc.yaml

replicationcontroller "nginx-rc" created
```

List your running replication controllers and pods:
```
kubectl get rc,pods

NAME                   DESIRED   CURRENT   AGE
nginx-rc               2         2         15s
NAME                   READY     STATUS    RESTARTS   AGE
nginx-rc-3abli         1/1       Running   0          15s
nginx-rc-hk9iy         1/1       Running   0          15s
```

You now see a replication controller and two nginx pods.

Access one of the running pods:
```
kubectl get pod nginx-rc-3abli --template {{.status.podIP}}
172.17.0.9

curl http://$(kubectl get pod nginx-rc-3abli --template {{.status.podIP}})
```

Delete the pod:
```
kubectl delete pod nginx-rc-3abli
```

List your running pods:
```
kubectl get pods

NAME                   READY     STATUS    RESTARTS   AGE
nginx-rc-hk9iy         1/1       Running   0          1m
nginx-rc-q0ak1         1/1       Running   0
```

And you can see that the replication controller has done it's job -- keeping two replicas running.

Now, you might wonder whether the new Pod has the same address as the old -- it doesn't:

```
kubectl get pod nginx-rc-q0aki --template {{.status.podIP}}
172.17.0.10
```

# Starting a service

The central purpose of Kubernetes is to manage containers in a cluster environment. This includes scheduling resources, scaling, and load-balancing.  Pods and their associated containers may be moved to different nodes in a cluster for a variety of reasons. Services are provided as a stable interface to these ephemeral pods.


Create a file called nginx-svc.yaml with the following:

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  ports:
  - port: 8000 # the port that this service should serve on
    # the container on each pod to connect to, can be a name
    # (e.g. 'www') or a number (e.g. 80)
    targetPort: 80
    protocol: TCP
  # just like the selector in the replication controller,
  # but this time it identifies the set of pods to load balance
  # traffic to.
  selector:
    app: nginx
```

This defines a service interface to the existing replication controller. The service will listen on port 8000, but forward traffic to the container on port 80.

Create the service:
```
kubectl create -f nginx-svc.yaml

service "nginx-service" created
```

List available services:
```
kubetl get svc
```
NAME            CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
nginx-service   10.0.0.32    <none>        8000/TCP   18s
```

You can now access the containers load-balanced by the service:
```
curl 10.0.0.32:8000
```

Now delete the service and replication controller. Deleting the replication controller also deletes the pods.
```
kubectl delete svc nginx-service
kubectl delete rc nginx-rc
```

# Next steps

This has been a very brief introduction to Kubernetes.  For more information, see the Kubernetes 101 and 201 tutorials:
* http://kubernetes.io/docs/user-guide/walkthrough/k8s101/
* http://kubernetes.io/docs/user-guide/walkthrough/k8s201/
