USE deposito;

CREATE TABLE IF NOT EXISTS log_transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operacion VARCHAR(200),
    intento INT DEFAULT 1,
    estado VARCHAR(100),
    error_code INT DEFAULT NULL,
    error_msg TEXT DEFAULT NULL,
    usuario VARCHAR(50) DEFAULT NULL,
    INDEX idx_fecha (fecha),
    INDEX idx_estado (estado),
    INDEX idx_operacion (operacion(50))
);

CREATE TABLE IF NOT EXISTS historial_cambios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    cambio_precio DECIMAL(10,2),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    motivo VARCHAR(200),
    INDEX idx_producto (producto_id),
    INDEX idx_fecha (fecha)
);

CREATE TABLE IF NOT EXISTS log_errores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    procedimiento VARCHAR(100),
    error_code INT,
    error_msg TEXT,
    sql_state VARCHAR(5),
    contexto TEXT,
    INDEX idx_fecha (fecha),
    INDEX idx_procedimiento (procedimiento)
);

SELECT '✓ BLOQUE 1: Tablas de logging creadas' AS status;