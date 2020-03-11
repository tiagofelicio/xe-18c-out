# Oracle 18c Express Edition + Oracle Unified Toolkit on Docker

<!-- TOC depthFrom:3 -->

1. [Requirements](#1-requirements)
1. [Install](#2-install)
..1. [Oracle 18c Express Edition on Docker](#21-oracle-18c-express-edition-on-docker)
        - [Linux](#linux)
        - [Windows](#windows)
    1. [Oracle Unified Toolkit](#22-oracle-unified-toolkit)
1. [Run Container](#run-container)
1. [Container Commands](#container-commands)

<!-- /TOC -->

## 1. Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/downloads)

## 2. Install

### 2.1. Oracle 18c Express Edition on Docker

#### Linux
```bash
# create work directory
mkdir ~/.oracle
# go to work directory
cd ~/.oracle
# clone oracle docker images repo
git clone https://github.com/oracle/docker-images.git
# go to oracle single instance docker files directory
cd docker-images/OracleDatabase/SingleInstance/dockerfiles
# check https://github.com/oracle/docker-images/blob/master/OracleDatabase/SingleInstance/README.md for more info
./buildDockerImage.sh -v 18.4.0 -x
# go to work directory
cd ~/.oracle
# remove oracle docker images folder
rm -rf docker-images
# data files will be stored here
mkdir ~/.oracle/oradata
# create container
docker create --name oracle-18.4.0-xe \
    -p 1521:1521 \
    -p 5500:5500 \
    -e ORACLE_PWD=oracle \
    -e ORACLE_CHARACTERSET=AL32UTF8 \
    -v ~/.oracle/oradata:/opt/oracle/oradata \
oracle/database:18.4.0-xe
```

#### Windows
```bat
# go to user home directory
cd /d %USERPROFILE%
# clone oracle docker images repo
git clone https://github.com/oracle/docker-images.git
# go to oracle single instance docker files directory
cd docker-images/OracleDatabase/SingleInstance/dockerfiles
# check https://github.com/oracle/docker-images/blob/master/OracleDatabase/SingleInstance/README.md for more info
"D:\Program Files\Git\bin\bash.exe" --login -i -c "./buildDockerImage.sh -v 18.4.0 -x"
# go to user home directory
cd /d %USERPROFILE%
# remove oracle docker images folder
rmdir docker-images /s /q
```

### 2.2. Oracle Unified Toolkit

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
