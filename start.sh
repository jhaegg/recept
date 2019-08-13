#!/bin/sh
set -e

docker build -t recept-webapp-builder -f Dockerfile.webapp-builder .
docker run -v $PWD/src/webapp/src:/src/webapp/src -v $PWD/build:/build recept-webapp-builder npm run-script build

docker build -t recept .
# docker run --rm -it -p 1024:1024 --name recept recept
docker-compose -f docker-compose.local.yaml up
docker-compose -f docker-compose.local.yaml down
