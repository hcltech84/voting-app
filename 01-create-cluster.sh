#!/bin/bash

# Install Google Cloud CLI or upgrade if already installed
if ! command -v -- gcloud > /dev/null 2>&1; then
  brew install --cask google-cloud-sdk
else
  gcloud components updates
fi

# Initialize Google Cloud CLI
gcloud init

# Declare envars
source .env.local

# Create a new Google Cloud project
gcloud projects create $PROJECT_ID --name=$PROJECT_NAME

# Enable Billing for new project
gcloud alpha billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT_ID

# Enable Kubernetes API for new project
SERVICE_NAME=container.googleapis.com
gcloud services enable $SERVICE_NAME --project=$PROJECT_ID

# Create a standard, single-zone cluster with `HttpLoadBalancing` add-on disabled.
gcloud container clusters create $CLUSTER_NAME --addons="HorizontalPodAutoscaling" --zone $ZONE --project $PROJECT_ID
# --addons="HorizontalPodAutoscaling"
#   As we'll use Ingress Nginx rather than GKE Ingress, `HttpLoadBalancing` add-on should be disabled to prevents 
#   GKE Ingress to process Ingress resources.
#   The default addons are `"HttpLoadBalancing, HorizontalPodAutoscaling"`, 
#   explicitly specifies `HorizontalPodAutoscaling` will disable `HttpLoadBalancing`
#   For more detail about `--addons` flag, see https://cloud.google.com/sdk/gcloud/reference/container/clusters/create

# Clean up
# To delete the entire project
gcloud projects delete $PROJECT_ID --quiet

# To delete the cluster only
gcloud container clusters delete $CLUSTER_NAME --location=$ZONE --project $PROJECT_ID --quiet
