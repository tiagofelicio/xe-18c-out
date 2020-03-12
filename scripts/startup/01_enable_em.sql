-- ----------------------------------------------------------------------------------------------------------------------------
-- File Name     : 01_enable_em.sql
-- Author        : tiago felicio
-- Description   :
-- Call Syntax   : 01_enable_em.sql
-- Last Modified : 2020/03/12
-- ----------------------------------------------------------------------------------------------------------------------------

exec dbms_xdb_config.setlistenerlocalaccess(false);
exec dbms_xdb_config.setglobalportenabled(true);
