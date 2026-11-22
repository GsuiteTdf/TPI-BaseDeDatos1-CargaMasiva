SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar procedimientos almacenados
DROP PROCEDURE IF EXISTS depositotpi.sp_insertar_producto_seguro;
DROP PROCEDURE IF EXISTS depositotpi.sp_actualizar_producto_seguro;
DROP PROCEDURE IF EXISTS depositotpi.sp_buscar_productos_seguro;
DROP PROCEDURE IF EXISTS depositotpi.sp_asignar_codigo_barras;

-- Eliminar vistas
DROP VIEW IF EXISTS depositotpi.vw_producto_public;
DROP VIEW IF EXISTS depositotpi.vw_producto_admin;
DROP VIEW IF EXISTS depositotpi.vw_estadisticas;
DROP VIEW IF EXISTS depositotpi.vw_inventario;

-- Eliminar triggers de auditoría
DROP TRIGGER IF EXISTS depositotpi.trg_producto_audit_ins;
DROP TRIGGER IF EXISTS depositotpi.trg_producto_audit_upd;
DROP TRIGGER IF EXISTS depositotpi.trg_producto_audit_del;
DROP TRIGGER IF EXISTS depositotpi.trg_codigo_barras_audit;

-- Eliminar tabla de auditoría
DROP TABLE IF EXISTS depositotpi.audit_producto;
DROP TABLE IF EXISTS depositotpi.audit_codigo_barras;

-- Eliminar usuarios y roles existentes
DROP USER IF EXISTS 'app_user'@'localhost';
DROP USER IF EXISTS 'etl_user'@'localhost';
DROP USER IF EXISTS 'report_user'@'localhost';
DROP USER IF EXISTS 'admin_user'@'localhost';

DROP ROLE IF EXISTS 'role_app';
DROP ROLE IF EXISTS 'role_etl';
DROP ROLE IF EXISTS 'role_report';
DROP ROLE IF EXISTS 'role_admin';