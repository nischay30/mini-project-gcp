#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../projectSettings.sh

gsutil mb -c regional -l $PROJECT_REGION  -p $PROJECT_NAME gs://$PRIVATE_ASSETS/
