-- -----------------------------------------------------------------------------------
-- File Name     : 01_out_install.sql
-- Author        : tiago felicio
-- Description   :
-- Call Syntax   : 01_out_install.sql
-- Last Modified : 2020/01/14
-- -----------------------------------------------------------------------------------

alter session set container = xepdb1;

create tablespace meta
datafile '/opt/oracle/oradata/XE/XEPDB1/meta01.dbf' size 1g
autoextend on next 1g maxsize 5g
nologging online permanent
extent management local autoallocate default
compress segment space management auto;

@@out/install.sql $ORACLE_PWD meta temp
