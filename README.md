# Oracle 18c Express Edition on Docker + Unified Toolkit for Oracle

<!-- TOC depthFrom:2 -->

1. [Requirements](#1-requirements)
2. [Install](#2-install)
    - [Linux](#linux)
    - [Windows](#windows)
3. [Uninstall](#3-uninstall)
    - [Linux](#linux-1)
    - [Windows](#windows-1)
4. [Notes](#4-notes)
5. [Run Container](#run-container)
6. [Container Commands](#container-commands)

<!-- /TOC -->

## 1. Requirements

- [Docker](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/downloads)

## 2. Install

#### Linux
```bash
mkdir -p ~/.oracle/oradata ~/.oracle/scripts/setup
git clone https://github.com/oracle/docker-images.git ~/.oracle/docker-images
cd ~/.oracle/docker-images/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -v 18.4.0 -x # https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
rm -rf ~/.oracle/docker-images
git clone https://github.com/tiagofelicio/out.git ~/.oracle/scripts/setup
cat > ~/.oracle/scripts/setup/out_install.sql << EOF
    alter session set container = xepdb1;
    create tablespace meta
    datafile '/opt/oracle/oradata/XE/XEPDB1/meta01.dbf' size 1g
    autoextend on next 1g maxsize 5g
    nologging online permanent
    extent management local autoallocate default
    compress segment space management auto;
    @@out/install.sql $ORACLE_PWD meta temp
EOF
docker create --name oracle-18.4.0-xe \
    -p 1521:1521 \
    -p 5500:5500 \
    -e ORACLE_PWD=oracle \
    -e ORACLE_CHARACTERSET=AL32UTF8 \
    -v ~/.oracle/oradata:/opt/oracle/oradata \
    -v ~/.oracle/scripts/setup:/opt/oracle/scripts/setup \
oracle/database:18.4.0-xe
```

#### Windows
```bat
REM go to user home directory
cd /d %USERPROFILE%
REM clone oracle docker images repo
git clone https://github.com/oracle/docker-images.git
REM go to oracle single instance docker files directory
cd docker-images/OracleDatabase/SingleInstance/dockerfiles
REM check https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance for more info
"D:\Program Files\Git\bin\bash.exe" --login -i -c "./buildDockerImage.sh -v 18.4.0 -x"
REM go to user home directory
cd /d %USERPROFILE%
REM remove oracle docker images folder
rmdir docker-images /s /q
```

## 3. Uninstall

#### Linux

```bash
docker rm oracle-18.4.0-xe
docker rmi $(docker images oracle/database:18.4.0-xe -q)
docker rmi $(docker images oraclelinux:7-slim -q)
rm -rf ~/.oracle
```

#### Windows

```bat
REM remove container
docker rm oracle-18.4.0-xe
```

## 4. Notes

Name | Required | Description 
--- | --- | ---
`-p 1521`| Required | TNS Listener. `32118:1521` maps `32118` on your laptop to `1521` on the container.
`-p 5500`| Optional | Enterprise Manager (EM) Express. `35518:5500` maps `35518` to your laptop to `5500` on the container. You can then access EM via https://localhost:35518/em 
`--name` | Optional | Name of container. Optional but recommended
`--volume /opt/oracle/oradata` | Optional | (recommended) If provided, data files will be stored here. If the container is destroyed can easily rebuild container using the data files.
`--network` | Optional | If other containers need to connect to this one (ex: [ORDS](https://github.com/martindsouza/docker-ords)) then they should all be on the same docker network.
`oracle-xe:18c` | Required | This is the `name:tag` of the docker image that was built in the previous step

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
