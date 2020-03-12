-- -----------------------------------------------------------------------------------
-- File Name     : 01_out_install.sql
-- Author        : tiago felicio
-- Description   :
-- Call Syntax   : 01_out_install.sql
-- Last Modified : 2020/03/12
-- -----------------------------------------------------------------------------------

alter session set container = xepdb1;

create tablespace metadata
datafile '/opt/oracle/oradata/XE/XEPDB1/metadata01.dbf' size 1g
autoextend on next 1g maxsize 5g
nologging online permanent
extent management local autoallocate default
compress segment space management auto;

@@./out/install.sql oracle metadata temp
