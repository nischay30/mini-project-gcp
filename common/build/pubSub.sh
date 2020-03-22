#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../projectSettings.sh

gcloud pubsub topics create $PUB_SUB_TOPIC_NAME \
--project=$PROJECT_NAME