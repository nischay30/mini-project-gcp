#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../projectSettings.sh

# Create the network for services
gcloud compute networks create $SERVICES_NETWORK \
--project=$PROJECT_NAME \
--description="Custom network for services and ads" \
--subnet-mode=custom

# Create Product subnet
gcloud compute networks subnets create $PRODUCT_SUBNET \
--project=$PROJECT_NAME \
--network=$SERVICES_NETWORK \
--range=10.29.0.0/24 \
--description="Subnet for Product APIs" \
--region=$PROJECT_REGION \
--enable-flow-logs \
--enable-private-ip-google-access

# Create subnet for Ads
gcloud compute networks subnets create $ADS_SUBNET \
--project=$PROJECT_NAME \
--network=$SERVICES_NETWORK \
--range=10.28.0.0/24 \
--description="Subnet for ADS APIs" \
--region=$PROJECT_REGION \
--enable-flow-logs \
--enable-private-ip-google-access

# Create Firewall rule to allow instances to talk to each other
gcloud compute firewall-rules create "$SERVICES_NETWORK-internal-access" \
--allow tcp,udp,icmp \
--network=$SERVICES_NETWORK \
--source-ranges 10.28.0.0/15 \
--description="Firewall rule to allow instances to talk to each other"

# Create Firewall rule to allow SSH Connections
gcloud compute firewall-rules create "$SERVICES_NETWORK-ssh" \
--allow tcp:22 \
--network=$SERVICES_NETWORK \
--description="Firewall rule to allow anybody to do ssh into machines"


