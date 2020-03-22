#!/bin/bash

# The name of the project to deploy services into.
PROJECT_NAME="certification-project-271215"

# Which default region should regional services use?
PROJECT_REGION="europe-west2"

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