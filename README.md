# Oracle 18c Express Edition + Oracle Unified Toolkit on Docker

<!-- TOC depthFrom:2 -->

- [Prerequisites](#prerequisites)
- [Build Image](#build-image)
- [Run Container](#run-container)
- [Container Commands](#container-commands)

<!-- /TOC -->

## Prerequisites

1. [Download](https://www.docker.com/products/docker-desktop) and install Docker Desktop.
1. [Download](https://git-scm.com/downloads) and install Git.

## Build Image

#### Linux
```bash
cd ~

git clone https://github.com/tiagofelicio/xe-18c-out.git
cd xe-18c-out

git clone https://github.com/oracle/docker-images.git
cd docker-images/OracleDatabase/SingleInstance/dockerfiles

./buildDockerImage.sh -v 18.4.0 -x

rm -rf docker-images

mkdir -p ~/.oracle/oradata
mkdir -p ~/.oracle/scripts/setup
mkdir -p ~/.oracle/scripts/startup

docker create --name oracle-18.4.0-xe \
    -p 1521:1521 \
    -p 5500:5500 \
    -e ORACLE_PWD=oracle \
    -e ORACLE_CHARACTERSET=AL32UTF8 \
    -v ~/.oracle/oradata:/opt/oracle/oradata \
    -v ~/.oracle/scripts/setup:/opt/oracle/scripts/setup \
    -v ~/.oracle/scripts/startup:/opt/oracle/scripts/startup \
oracle/database:18.4.0-xe
```

#### Windows
```cmd
git clone https://github.com/tiagofelicio/xe-18c-out.git
cd xe-18c-out
TODO
```

## Run Container

_Note first time will take a a while to run for as the `oracle-xe configure` script needs to complete_

```bash
docker run -d \
  -p 32118:1521 \
  -p 35518:5500 \
  --name=oracle-xe \
  --volume ~/docker/oracle-xe:/opt/oracle/oradata \
  --network=oracle_network \
  oracle-xe:18c
  
# As this takes a long time to run you can keep track of the initial installation by running:
docker logs oracle-xe
```

Run parameters:

Name | Required | Description 
--- | --- | ---
`-p 1521`| Required | TNS Listener. `32118:1521` maps `32118` on your laptop to `1521` on the container.
`-p 5500`| Optional | Enterprise Manager (EM) Express. `35518:5500` maps `35518` to your laptop to `5500` on the container. You can then access EM via https://localhost:35518/em 
`--name` | Optional | Name of container. Optional but recommended
`--volume /opt/oracle/oradata` | Optional | (recommended) If provided, data files will be stored here. If the container is destroyed can easily rebuild container using the data files.
`--network` | Optional | If other containers need to connect to this one (ex: [ORDS](https://github.com/martindsouza/docker-ords)) then they should all be on the same docker network.
`oracle-xe:18c` | Required | This is the `name:tag` of the docker image that was built in the previous step

## Container Commands

```bash
# Status:
# Look under the STATUS column for "(health: ...".
docker ps

# Start container
docker start oracle-xe

# Stop container
docker stop -t 200 oracle-xe
```
