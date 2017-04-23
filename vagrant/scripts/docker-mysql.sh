#!/bin/bash

# use a frontend that expects no interactive input at all.
export DEBIAN_FRONTEND=noninteractive

# Check if mysql container is already installed.
IMAGE="$(docker ps -a | grep mysql)"
if [[ ! -z $IMAGE ]]; then :
  echo "MySQL container already exists."
  exit 0
fi

# Stop the execution of a script if a command or pipeline has an error.
set -e

# Print all executed commands to the terminal
set -x

# Mysql server parameters.
MYSQL_CONTAINER=$1
MYSQL_ROOT_PASSWORD=$2
MYSQL_DATABASE=$3
MYSQL_USER=$4
MYSQL_PASSWORD=$5
MYSQL_VERSION=$6

# Download 'mysql' docker image.
docker pull mysql:$MYSQL_VERSION

# Run the 'mysql' docker image.
docker run --name $MYSQL_CONTAINER \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$MYSQL_DATABASE \
  -e MYSQL_USER=$MYSQL_USER \
  -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
  -d mysql:$MYSQL_VERSION

echo "MySQL server ip address: $(docker inspect \
  --format '{{.NetworkSettings.IPAddress}}' ${MYSQL_CONTAINER})"
