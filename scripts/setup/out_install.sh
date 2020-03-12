#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    su - oracle
fi

ORACLE_SID=XE
ORAENV_ASK=NO
. oraenv

cd /opt/oracle/scripts/setup

sqlplus / as sysdba <<EOF
@out_install.pls
EOF
