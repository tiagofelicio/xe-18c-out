-- ----------------------------------------------------------------------------------------------------------------------------
-- File Name     : 02_out_samples_install.sql
-- Author        : tiago felicio
-- Description   :
-- Call Syntax   : 02_out_samples_install.sql
-- Last Modified : 2020/03/13
-- ----------------------------------------------------------------------------------------------------------------------------

alter session set container = xepdb1;

create tablespace stage
datafile '/opt/oracle/oradata/XE/XEPDB1/stage01.dbf' size 1g
autoextend on next 1g maxsize 10g
nologging online permanent
extent management local autoallocate default
compress segment space management auto;

create tablespace data
datafile '/opt/oracle/oradata/XE/XEPDB1/data01.dbf' size 1g
autoextend on next 1g maxsize 10g
nologging online permanent
extent management local autoallocate default
compress segment space management auto;

@/opt/oracle/scripts/setup/out/samples/install.sql /opt/oracle/scripts/setup/out oracle metadata stage data temp
