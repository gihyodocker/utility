#!/usr/bin/env sh

if [ ! `which docker` ]; then
  echo "docker is not installed." 1>&2
  exit 1
fi

docker exec -it manager docker swarm init
if [ $? -ne 0 ]; then
  echo "docker swarm init failed." 1>&2
  exit 1
fi

JOIN_TOKEN=$(docker exec -it manager docker swarm join-token worker --quiet | tr '\r' ' ' | tr '\n' ' ')
if [ $? -ne 0 ]; then
  echo "get swarm join token failed." 1>&2
  exit 1
fi

docker exec -it worker01 docker swarm join --token $JOIN_TOKEN manager:2377
if [ $? -ne 0 ]; then
  echo "worker01: docker swarm join failed." 1>&2
  exit 1
fi

docker exec -it worker02 docker swarm join --token $JOIN_TOKEN manager:2377
if [ $? -ne 0 ]; then
  echo "worker02: docker swarm join failed." 1>&2
  exit 1
fi

docker exec -it worker03 docker swarm join --token $JOIN_TOKEN manager:2377
if [ $? -ne 0 ]; then
  echo "worker03: docker swarm join failed." 1>&2
  exit 1
fi

docker exec -it manager docker node ls
if [ $? -ne 0 ]; then
  echo "show swarm node failed." 1>&2
  exit 1
fi

