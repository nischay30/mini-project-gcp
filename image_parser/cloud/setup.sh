#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../../common/projectSettings.sh

SOURCE_LOCAL_FOLDER="../app"

gcloud functions deploy $FUNCTION_NAME \
--region=$PROJECT_REGION \
--runtime="nodejs10" \
--entry-point=imageParser \
--source=$SOURCE_LOCAL_FOLDER \
--stage-bucket=$PRIVATE_ASSETS \
--trigger-resource=$PUB_SUB_TOPIC_NAME \
--trigger-event="google.pubsub.topic.publish" \
--allow-unauthenticated \
--set-env-vars=BIGTABLE_INSTANCE_ID=$BIGTABLE_INSTANCE_ID,BIGTABLE_TABLE_ID=$BIGTABLE_TABLE_ID,CLOUD_STORAGE_BUCKET=$PUBLIC_ASSETS
