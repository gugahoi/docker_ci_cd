#!/bin/bash

set -e

[[ -f ci/vars.sh ]] && source ci/vars.sh || source vars.sh

# $TAG must be defined in jenkins

echo "Generating task-definition.json from template file"

TEMPLATE=$([[ -f ci/task-definition.json.template ]] && cat ci/task-definition.json.template || cat task-definition.json.template)

GENERATED=${TEMPLATE//HOST_PORT/$HOST_PORT}
GENERATED=${GENERATED//CONTAINER_PORT/$CONTAINER_PORT}
GENERATED=${GENERATED//CONTAINER_NAME/$CONTAINER_NAME}
GENERATED=${GENERATED//IMAGE_URL/$IMAGE_URL}
GENERATED=${GENERATED//IMAGE_TAG/$IMAGE_TAG}
GENERATED=${GENERATED//MEMORY/$MEMORY}
echo "$GENERATED" > /tmp/task-definition.json

echo "Creating task-definition for tag: ${TAG}"

DATA_CONTAINER_NAME="data-${TAG}"
docker create --name $DATA_CONTAINER_NAME -v /root alpine:3.3 /bin/sh
docker cp /tmp/task-definition.json $DATA_CONTAINER_NAME:/root/task-definition.json
docker run --volumes-from $DATA_CONTAINER_NAME --rm "$@" anigeo/awscli \
   ecs register-task-definition    \
   --family $FAMILY                \
   --region $REGION                \
   --cli-input-json file:///root/task-definition.json | grep "revision" | cut -d ':' -f 2 | cut -c2- > revision.txt
   
docker rm $DATA_CONTAINER_NAME

echo "Updating service with task-definition: $(cat revision.txt)"
docker run --rm "$@" anigeo/awscli \
   ecs update-service --cluster $CLUSTER --service $SERVICE --region $REGION --task-definition "${FAMILY}:$(cat revision.txt)"

rm /tmp/task-definition.json
rm revision.txt