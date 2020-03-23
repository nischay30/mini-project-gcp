#!/bin/bash

# Build the app and store it in ads/build/out/app
docker run --rm -it -v $PWD:/build -v "$(dirname "$PWD")/app:/go/src/ads" -w /go/src/ads golang:1.10 bash /build/go.sh
