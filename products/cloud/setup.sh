#!/bin/bash

set -ve

##############################################################################
#
# This only needs to be run once per project.
# This is going to create a new service account and download the
# key as a JSON file.
# The account has bigtable user and storage write permissions
#
##############################################################################

# Import the settings from the common settings file
source ../../common/projectSettings.sh

# Ensure the secrets dir exists
mkdir -p ../app/secrets

#Service account information
SERVICE_ACCOUNT_NAME="certification-product-service"
SERVICE_ACCOUNT_DEST_KEYS="../app/secrets/service_account.json"

gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
--description="Service account for product services" \
--display-name=$SERVICE_ACCOUNT_NAME

SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:$SERVICE_ACCOUNT_NAME" \
    --format='value(email)')

echo $SA_EMAIL

gcloud projects add-iam-policy-binding $PROJECT_NAME \
--member=serviceAccount:$SA_EMAIL \
--role=roles/bigtable.user


gcloud projects add-iam-policy-binding $PROJECT_NAME \
    --role roles/bigtable.user \
    --member serviceAccount:$SA_EMAIL

gcloud projects add-iam-policy-binding $PROJECT_NAME \
--member=serviceAccount:$SA_EMAIL \
--role=roles/bigquery.jobUser

gcloud projects add-iam-policy-binding $PROJECT_NAME \
--member=serviceAccount:$SA_EMAIL \
--role=roles/bigquery.dataViewer

gcloud projects add-iam-policy-binding $PROJECT_NAME \
--member=serviceAccount:$SA_EMAIL \
--role=roles/storage.objectAdmin

gcloud iam service-accounts keys create $SERVICE_ACCOUNT_DEST_KEYS --iam-account=$SA_EMAIL

# echo "##############################################################################"
# echo "Service account created and key stored in the products/app/secrets dir with the name $SERVICE_ACCOUNT_NAME"
# echo "##############################################################################"
# ##############################################################################
# #
# # Create Kubernetes Cluster.
# #
# #
# ##############################################################################

gcloud container clusters create $PRODUCT_CLUSTER_NAME \
--project $PROJECT_NAME \
--zone $PROJECT_ZONE \
--no-enable-basic-auth \
--disk-size "100" \
--disk-type "pd-standard" \
--machine-type "n1-standard-1" \
--image-type "COS" \
--cluster-version "1.14.10-gke.24" \
--num-nodes 3 \
--network $SERVICES_NETWORK \
--subnetwork $PRODUCT_SUBNET \
--service-account $SA_EMAIL \
--min-nodes 1 \
--max-nodes 4 \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard \
--enable-autorepair \
--enable-autoscaling \
--enable-autoupgrade \
--enable-stackdriver-kubernetes \
--preemptible


##############################################################################
#
# Push the container to the Google Cloud Container Registry.
# Kubernetes works with container images, not dockerfiles.
# So we need to build the image and put it someplace that it can be accessed.
#
##############################################################################
gcloud auth configure-docker -q

# This allows us to create the YAML file without needing to edit the variables for different projects.
cat > ../deploy/workload.yaml << EOL
---
apiVersion: "v1"
kind: "ConfigMap"
metadata:
  name: "products-service-config"
  namespace: "default"
  labels:
    app: "products-service"
data:
  # The path /sa comes from the volume mounted in the container.
  # It mounts the secret to that path.
  # The secret is created in the deploy.sh file for this service
  SERVICE_ACCOUNT_FILE_NAME: "/sa/service_account.json"
  PROJECT_ID: "$PROJECT_NAME"
  PRODUCT_CACHE_BUCKET: "$PUBLIC_ASSETS"
---
apiVersion: "extensions/v1beta1"
kind: "Deployment"
metadata:
  name: "products-service"
  namespace: "default"
  labels:
    app: "products-service"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: "products-service"
  template:
    metadata:
      labels:
        app: "products-service"
    spec:
      containers:
      - name: "products"
        image: "gcr.io/$PROJECT_NAME/products:latest"
        volumeMounts:
        - name: service-account
          mountPath: "/sa/"
          readOnly: true
        env:
        - name: "SERVICE_ACCOUNT_FILE_NAME"
          valueFrom:
            configMapKeyRef:
              key: "SERVICE_ACCOUNT_FILE_NAME"
              name: "products-service-config"
        - name: "PROJECT_ID"
          valueFrom:
            configMapKeyRef:
              key: "PROJECT_ID"
              name: "products-service-config"
        - name: "PRODUCT_CACHE_BUCKET"
          valueFrom:
            configMapKeyRef:
              key: "PRODUCT_CACHE_BUCKET"
              name: "products-service-config"
      volumes:
      - name: service-account
        secret:
            secretName: service-account-file
---
apiVersion: "autoscaling/v1"
kind: "HorizontalPodAutoscaler"
metadata:
  name: "products-service-hpa"
  namespace: "default"
  labels:
    app: "products-service"
spec:
  scaleTargetRef:
    kind: "Deployment"
    name: "products-service"
    apiVersion: "apps/v1beta1"
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80
EOL