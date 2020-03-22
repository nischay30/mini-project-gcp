#!/bin/bash

set -ve

# Import the settings from the common settings file
source ../projectSettings.sh

cat > publicbucketcors.json << EOL
[
    {
      "origin": ["*"],
      "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
      "method": ["GET", "HEAD"],
      "maxAgeSeconds": 5
    }
]
EOL

gsutil mb -c regional -l $PROJECT_REGION -p $PROJECT_NAME gs://$PUBLIC_ASSETS/

gsutil cors set publicbucketcors.json gs://$PUBLIC_ASSETS

gsutil iam ch allUsers:objectViewer gs://$PUBLIC_ASSETS
