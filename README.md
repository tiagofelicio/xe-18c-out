# Oracle 18c Express Edition on Docker + Unified Toolkit for Oracle

<!-- TOC depthFrom:2 -->

- [Requirements](#1-requirements)
- [Install](#2-install)
    - [Linux](#linux)
    - [Windows](#windows)
- [Reference](#3-reference)
- [Uninstall](#4-uninstall)
    - [Linux](#linux-1)
    - [Windows](#windows-1)
- [Notes](#5-notes)
- [Troubleshooting](6-troubleshooting)

<!-- /TOC -->

## 1. Requirements

- [Docker](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/downloads)

## 2. Install

#### Linux

```bash
git clone https://github.com/tiagofelicio/xe-18c-out.git ~/.oracle
git clone https://github.com/tiagofelicio/out.git ~/.oracle/scripts/setup/out
git clone https://github.com/oracle/docker-images.git ~/.oracle/docker-images
cd ~/.oracle/docker-images/OracleDatabase/SingleInstance/dockerfiles
./buildDockerImage.sh -v 18.4.0 -x # https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
cd ~/.oracle/
rm -rf ~/.oracle/docker-images
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

```bat
git clone https://github.com/tiagofelicio/xe-18c-out.git %USERPROFILE%\.oracle
git clone https://github.com/tiagofelicio/out.git %USERPROFILE%\.oracle\scripts\setup\out
git clone https://github.com/oracle/docker-images.git %USERPROFILE%\.oracle\docker-images
cd /d %USERPROFILE%\.oracle\docker-images\OracleDatabase\SingleInstance\dockerfiles
"%PROGRAMFILES%\Git\bin\bash.exe" --login -i -c "./buildDockerImage.sh -v 18.4.0 -x" & :: https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance
cd /d %USERPROFILE%\.oracle
rmdir %USERPROFILE%\.oracle\docker-images /s /q
docker create --name oracle-18.4.0-xe ^
    -p 1521:1521 ^
    -p 5500:5500 ^
    -e ORACLE_PWD=oracle ^
    -e ORACLE_CHARACTERSET=AL32UTF8 ^
    -v %USERPROFILE%\.oracle\oradata:/opt/oracle/oradata ^
    -v %USERPROFILE%\.oracle\scripts\setup:/opt/oracle/scripts/setup ^
    -v %USERPROFILE%\.oracle\scripts\startup:/opt/oracle/scripts/startup ^
oracle/database:18.4.0-xe
```

## 3. Reference

```bash
# start container
docker start oracle-18.4.0-xe

# stop container
docker stop oracle-18.4.0-xe

# open bash in container
docker exec -it oracle-18.4.0-xe bash

# check container status
docker ps -a -f "name=oracle-18.4.0-xe"

# check container resource usage
docker stats -a oracle-18.4.0-xe

# check container logs
docker logs oracle-18.4.0-xe
```

## 4. Uninstall

#### Linux

```bash
docker rm oracle-18.4.0-xe
docker rmi $(docker images oracle/database:18.4.0-xe -q)
docker rmi $(docker images oraclelinux:7-slim -q)
rm -rf ~/.oracle
```

#### Windows

```bat
docker rm oracle-18.4.0-xe
docker rmi $(docker images oracle/database:18.4.0-xe -q)
docker rmi $(docker images oraclelinux:7-slim -q)
rmdir %USERPROFILE%\.oracle /s /q
```

## 5. Notes

Name | Required | Description 
--- | --- | ---
`-p 1521`| Required | TNS Listener. `32118:1521` maps `32118` on your laptop to `1521` on the container.
`-p 5500`| Optional | Enterprise Manager (EM) Express. `35518:5500` maps `35518` to your laptop to `5500` on the container. You can then access EM via https://localhost:35518/em 
`--name` | Optional | Name of container. Optional but recommended
`--volume /opt/oracle/oradata` | Optional | (recommended) If provided, data files will be stored here. If the container is destroyed can easily rebuild container using the data files.
`--network` | Optional | If other containers need to connect to this one (ex: [ORDS](https://github.com/martindsouza/docker-ords)) then they should all be on the same docker network.
`oracle-xe:18c` | Required | This is the `name:tag` of the docker image that was built in the previous step

## 6. Troubleshooting
