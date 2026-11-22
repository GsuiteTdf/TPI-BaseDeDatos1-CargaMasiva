-- ============================================================
-- LIMPIEZA PREVIA (en orden para evitar errores de dependencia)
-- ============================================================
DROP TRIGGER IF EXISTS trg_producto_audit_ins;
DROP TRIGGER IF EXISTS trg_producto_audit_upd;
DROP TRIGGER IF EXISTS trg_producto_audit_del;
DROP TRIGGER IF EXISTS trg_codigo_barras_audit;

DROP VIEW IF EXISTS vw_producto_public;
DROP VIEW IF EXISTS vw_producto_admin;
DROP VIEW IF EXISTS vw_estadisticas;
DROP VIEW IF EXISTS vw_inventario;

DROP PROCEDURE IF EXISTS sp_insertar_producto_seguro;
DROP PROCEDURE IF EXISTS sp_actualizar_producto_seguro;
DROP PROCEDURE IF EXISTS sp_buscar_productos_seguro;
DROP PROCEDURE IF EXISTS sp_asignar_codigo_barras;

DROP TABLE IF EXISTS audit_producto;
DROP TABLE IF EXISTS audit_codigo_barras;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS codigo_barras;

DROP USER IF EXISTS 'app_user'@'localhost';
DROP USER IF EXISTS 'etl_user'@'localhost';
DROP USER IF EXISTS 'report_user'@'localhost';
DROP USER IF EXISTS 'admin_user'@'localhost';

DROP ROLE IF EXISTS 'role_app';
DROP ROLE IF EXISTS 'role_etl';
DROP ROLE IF EXISTS 'role_report';
DROP ROLE IF EXISTS 'role_admin';


-- ============================================================
-- CREACIÓN DE TABLAS BASE
-- ============================================================

CREATE TABLE IF NOT EXISTS codigo_barras (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    eliminado TINYINT(1) DEFAULT 0 NOT NULL,
    tipo ENUM('EAN13', 'EAN8', 'UPC') NOT NULL,
    valor VARCHAR(20) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    fecha_asignacion DATE NULL,
    observaciones VARCHAR(255) NULL,
    CONSTRAINT uq_codigo_barras_valor UNIQUE (valor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS producto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    eliminado TINYINT(1) DEFAULT 0 NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    marca VARCHAR(80) NULL,
    categoria VARCHAR(80) NULL,
    precio DECIMAL(10,2) UNSIGNED NOT NULL,
    peso DECIMAL(10,3) UNSIGNED NULL,
    codigo_barras_id BIGINT NULL,
    CONSTRAINT uq_producto_codigo_barras UNIQUE (codigo_barras_id),
    CONSTRAINT fk_producto_codigo_barras
        FOREIGN KEY (codigo_barras_id) REFERENCES codigo_barras(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ============================================================
-- CREACIÓN DE TABLAS DE AUDITORÍA
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_producto (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    producto_id BIGINT NULL,
    accion ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    usuario_aplicacion VARCHAR(255) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_conexion VARCHAR(45),
    datos_anteriores JSON NULL,
    datos_nuevos JSON NULL,
    CONSTRAINT fk_audit_producto FOREIGN KEY (producto_id) REFERENCES producto(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS audit_codigo_barras (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo_barras_id BIGINT NULL,
    accion ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    usuario_aplicacion VARCHAR(255) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_conexion VARCHAR(45),
    datos_anteriores JSON NULL,
    datos_nuevos JSON NULL,
    CONSTRAINT fk_audit_codigo_barras FOREIGN KEY (codigo_barras_id) REFERENCES codigo_barras(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE ROLE IF NOT EXISTS 'role_app';
CREATE ROLE IF NOT EXISTS 'role_etl'; 
CREATE ROLE IF NOT EXISTS 'role_report';
CREATE ROLE IF NOT EXISTS 'role_admin';
