#!/bin/bash

# The name of the project to deploy services into.
PROJECT_NAME="certification-project-271215"

# Which default region should regional services use?
PROJECT_REGION="europe-west2"

# Which default zone should zonal services use
PROJECT_ZONE="europe-west2-b"

# Used as a suffix for select service names.
ENV_TYPE="dev"

# Used as a prefix for select service names.
ORGANIZATION="find-seller"

# The name of the custom network for the product and ads services
SERVICES_NETWORK="certification-network"

# The name of the product service subnet
PRODUCT_SUBNET="certification-product-subnet"

# The name of the product service subnet
ADS_SUBNET="certification-ads-subnet"

# This is the Storage bucket used for private assets.
# The entire bucket is private by default
PRIVATE_ASSETS="certification-private-bucket"

# This is the Storage bucket used for public assets.
# The entire bucket is public by default
PUBLIC_ASSETS="certification-public-bucket"

# The name of the Pubsub topic to create / use
PUB_SUB_TOPIC_NAME="certification-front-end"

# Bigtable settings...
## BigTable clusters not in EU as not available for BigQuery
BIGTABLE_PROJECT_ZONE="us-central1-a"

# The name of our Bigtable instance. An instance is basically a container for our cluster.
BIGTABLE_INSTANCE_ID="$ORGANIZATION-bt-instance-$ENV_TYPE"
BIGTABLE_CLUSTER_ID="$ORGANIZATION-bt-cluster-$ENV_TYPE"
BIGTABLE_DISPLAY_NAME="$ORGANIZATION-bt-name-$ENV_TYPE"
BIGTABLE_TABLE_ID=items