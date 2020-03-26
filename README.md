# Oracle 18c Express Edition on Docker + Unified Toolkit for Oracle

<!-- TOC depthFrom:2 -->

- [Requirements](#requirements)
- [Install](#install)
    - [Linux](#linux)
    - [Windows](#windows)
- [Reference](#reference)
- [Uninstall](#uninstall)
    - [Linux](#linux-1)
    - [Windows](#windows-1)

<!-- /TOC -->

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/downloads)

## Install

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

## Reference

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

## Uninstall

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
