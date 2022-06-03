#!/bin/bash

set -e

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Provide container name"
fi

SECONDS=0
container=$1

healthy=$(docker inspect --format='{{json .State.Health.Status}}' $container 2>/dev/null | jq -r)
until [ "$healthy" = "healthy" ]
do
	if (( SECONDS > 60 ))
  then
     echo "Giving up..."
     exit 1
  fi

  sleep 5
	healthy=$(docker inspect --format='{{json .State.Health.Status}}' $container 2>/dev/null | jq -r)
done
