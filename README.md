# Voting app

This guide contains step-by-step instructions on how to deploy a microservices to GKE. The microservices we're going to deploy is [an example voting app from Official Docker Samples](https://github.com/dockersamples/example-voting-app).

## Prerequisites

- You have a Google Cloud account
- You have enabled the "Kubernetes Engine API" in your Google Cloud Project

## Procedures

1. Create a standard, single-zone GKE cluster with HttpLoadBalancing add-on disabled
2. Deploy redis to GKE
3. Deploy postgres to GKE with auto-provision PersistentVolume
4. Deploy Voting App, Result App, and Worker

## 01. Create a standard, single-zone GKE cluster with HttpLoadBalancing add-on disabled

Refer to `01-create-cluster.sh` for commands to create GKE cluster. The script is for reference only, **not for execution**.

## 02. Deploy redis to GKE

```bash
kubectl apply -f manifest/redis.yaml
```

## References

- How to create a single-zone cluster: https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-zonal-cluster
- How to use GitHub issue: https://www.youtube.com/watch?v=tPfnOfjLUf8
- Adding a task list to GitHub issue: https://docs.github.com/en/issues/tracking-your-work-with-issues/quickstart#adding-a-task-list
- How to name an PR: https://se-education.org/guides/conventions/github.html
- Git ignore examples: https://github.com/github/gitignore