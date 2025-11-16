#!/bin/bash

set -e
CURRENT_DIR=$(pwd)

## Load the environment variables from the .env file
set -o allexport
source .env
set -o allexport

## Ensure required environment variables are set
: "${USER_ID:?Need to set USER_ID}"
: "${USER_NAME:?Need to set USER_NAME}"
: "${GROUP_ID:?Need to set GROUP_ID}"
: "${GROUP_NAME:?Need to set GROUP_NAME}"
: "${WORKSPACE:?Need to set WORKSPACE}"
: "${DOCKER_IMAGE_NAME:?Need to set DOCKER_IMAGE_NAME}"


## Run the Docker container with the specified configuration
if docker run \
        --net=host \
        --shm-size=2G \
        --env DISPLAY=$DISPLAY \
        --env QT_X11_NO_MITSHM=1 \
        --volume /tmp/.X11-unix:/tmp/.X11-unix \
        --volume /dev/shm:/dev/shm \
        --volume /dev/input/:/dev/input \
        --group-add $(getent group video | cut -d: -f3) \
        --privileged \
	--name $DOCKER_IMAGE_NAME  \
        -v $CURRENT_DIR/$WORKSPACE:/home/$USER_NAME/$WORKSPACE \
        -u $USER_ID:$GROUP_ID \
        --rm \
        -it \
        $DOCKER_IMAGE_NAME \
        bash; then
    echo "Data generation successful."
else
    echo "Error: Data generation failed."
    exit 1
fi
