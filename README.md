# Voting app

This guide contains step-by-step instructions on how to deploy a microservices to GKE. The microservices we're going to deploy is [an example voting app from Official Docker Samples](https://github.com/dockersamples/example-voting-app).

## Prerequisites

- You have a Google Cloud account
- You have enabled the "Kubernetes Engine API" in your Google Cloud Project

## Procedures

1. Create a standard, single-zone GKE cluster with HttpLoadBalancing add-on disabled
2. Deploy Redis to GKE
3. Deploy PostgreSQL to GKE with Dynamic Volume Provisioning
4. Deploy Voting App, Result App, and Worker

## 01. Create a standard, single-zone GKE cluster with HttpLoadBalancing add-on disabled

Refer to `01-create-cluster.sh` for commands to create GKE cluster. The script is for reference only, **not for execution**.

## 02. Deploy Redis to GKE

```bash
kubectl apply -f manifest/redis.yaml
```

## 03. Deploy PostgreSQL to GKE with Dynamic Volume Provisioning

```bash
kubectl apply -f manifest/postgresql-pvc.yaml
kubectl apply -f manifest/postgresql.yaml
```

## 04. Deploy Voting App, Result App, and Worker

```bash
kubectl apply -f manifest/voting.yaml
kubectl apply -f manifest/result.yaml
kubectl apply -f manifest/worker.yaml
```

### (Fixed) ERR01: PersistentVolume is not automatically provisioned

#### Things to try

👉 Describe the Pod to see if it's created

```bash
kubectl describe po postgresql
# ERR02
# 0/3 nodes are available: 3 Insufficient cpu. preemption: 0/3 nodes are available: 3 No preemption victims found for incoming pod..
```

👉 Investigate nodes to see if they're overcommitted. There're two ways to do this:

- (Recommended) Open Google Cloud Web UI - click on the cluster name - navigate to the "NODES" tab - Under the "Nodes" section, you can see how resources are allocated.
- Or, using command-line: `kubectl describe nodes <node-name>`

#### Reason

The default Storage Class `standard-rwo` uses `volumeBindingMode: WaitForFirstConsumer`. This volume binding mode will delay the binding and provisioning of a `PersistentVolume` until a Pod using the `PersistentVolumeClaim` is created.

### (Fixed) ERR02

This is a strange issue. To fix it, remove the `resources.limits` in the K8s manifest.

After removing `resources.limits`, the "Visual Studio Code Kubernetes Tools" extension will warn about missing "resource limits" configuration. To disable this warning, add the following to the extension setting, then restart VS Code.

```json
{
  "vs-kubernetes": {
    "disable-linters": [
      "resource-limits"
    ]
  }
}
```

## References

- How to create a single-zone cluster: https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster
- How to use GitHub issue: https://www.youtube.com/watch?v=tPfnOfjLUf8
- Adding a task list to GitHub issue: https://docs.github.com/en/issues/tracking-your-work-with-issues/quickstart#adding-a-task-list
- How to name an PR: https://se-education.org/guides/conventions/github.html
- Git ignore examples: https://github.com/github/gitignore
- Wait for first consumer: https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes#waitforfirstconsumer
- Persistent Volume and Dynamic Provisioning: https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes
- Docker example voting app: https://github.com/dockersamples/example-voting-app
- Redis as an in memory data structure store: https://redis.io/docs/get-started/data-store/
- How to deploy Postgres on Kubernetes as a Statefulset: https://kodekloud.com/blog/deploy-postgresql-kubernetes/
- Configure a Pod to use PersistentVolume: https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
- KodeKloud | Kubernetes Crash Course: Learn the Basics and Build a Microservice Application: https://youtu.be/XuSQU5Grv1g?t=3927&si=Jr7wb-do_9zQan0y