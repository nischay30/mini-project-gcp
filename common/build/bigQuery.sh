#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../projectSettings.sh

# Create the dataset
# https://cloud.google.com/bigquery/docs/dataset-locations
bq --location=US mk --dataset $PROJECT_NAME:"app_dataset_$ENV_TYPE"

bq mk --external_table_definition=bigquery_table_def.json "app_dataset_$ENV_TYPE.items"
