#!/bin/bash

git clone https://github.com/oracle/docker-images.git

cd docker-images/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -v 18.4.0 -x

rm -rf docker-images

mkdir -p ~/.oracle/oradata
mkdir -p ~/.oracle/scripts/setup
mkdir -p ~/.oracle/scripts/startup
