# Troubleshooting tips

## Errors during startup or shutdown

If a service is having problems during the startup or shutdown phase, there are a few things you can do.

First, using the ndslabsctl, try to stop the stack:

```
ndslabsctl login <user>
ndslabsctl list stacks
ndslabsctl stop <sid>
```

You can also stop the underlying resources in Kubernetes:

```
kubectl --namespace=<user> get svc,rc,pod
kubectl delete svc <service>
kubectl delete rc <service>
kubectl delete pod <pod>
```
