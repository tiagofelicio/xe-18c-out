#!/bin/bash

git clone https://github.com/oracle/docker-images.git

cd docker-images/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -v 18.4.0 -x

rm -rf docker-images

mkdir -p ~/.oracle/oradata
mkdir -p ~/.oracle/scripts/setup
mkdir -p ~/.oracle/scripts/startup

docker run --name oracle-18.4.0-xe \
    -p 1521:1521 \
    -p 5500:5500 \
    -e ORACLE_PWD=oracle \
    -e ORACLE_CHARACTERSET=AL32UTF8 \
    -v ~/.oracle/oradata:/opt/oracle/oradata \
    -v ~/.oracle/scripts/setup:/opt/oracle/scripts/setup \
    -v ~/.oracle/scripts/startup:/opt/oracle/scripts/startup \
oracle/database:18.4.0-xe
