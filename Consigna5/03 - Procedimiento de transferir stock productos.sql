DROP PROCEDURE IF EXISTS transferir_stock_productos;

DELIMITER //

CREATE PROCEDURE transferir_stock_productos(
    IN p_producto_origen INT,
    IN p_producto_destino INT,
    IN p_cantidad DECIMAL(10,3),
    OUT p_resultado VARCHAR(100),
    OUT p_codigo_error INT
)
BEGIN
    DECLARE v_stock_origen DECIMAL(10,3);
    DECLARE v_stock_destino DECIMAL(10,3);
    DECLARE v_error_msg TEXT;
    DECLARE v_sql_state VARCHAR(5);
    DECLARE v_mensaje_error VARCHAR(200);
    
    -- Handler para errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_error_msg = MESSAGE_TEXT,
            p_codigo_error = MYSQL_ERRNO,
            v_sql_state = RETURNED_SQLSTATE;
        
        -- ROLLBACK
        ROLLBACK;
        
        INSERT INTO log_errores (procedimiento, error_code, error_msg, sql_state, contexto)
        VALUES ('transferir_stock_productos', p_codigo_error, v_error_msg, v_sql_state,
                CONCAT('Origen: ', p_producto_origen, ' → Destino: ', p_producto_destino,
                       ', Cantidad: ', p_cantidad));
        
        INSERT INTO log_transacciones (operacion, estado, error_code, error_msg)
        VALUES (CONCAT('Transferir stock ', p_producto_origen, '→', p_producto_destino),
                'ERROR', p_codigo_error, v_error_msg);
        
        SET p_resultado = CONCAT('ERROR: ', v_error_msg);
    END;
    
    -- Inicializar
    SET p_codigo_error = 0;
    
    -- Log inicio
    INSERT INTO log_transacciones (operacion, estado, usuario)
    VALUES (CONCAT('Transferir stock ', p_producto_origen, '→', p_producto_destino),
            'INICIANDO', USER());
    
    -- START TRANSACTION
    START TRANSACTION;
    
    -- Validación 1: Productos diferentes
    IF p_producto_origen = p_producto_destino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Origen y destino no pueden ser iguales';
    END IF;
    
    -- Validación 2: Cantidad positiva
    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La cantidad debe ser mayor a cero';
    END IF;
    
    -- Bloquear en orden (evitar deadlocks)
    IF p_producto_origen < p_producto_destino THEN
        SELECT peso INTO v_stock_origen FROM producto WHERE id = p_producto_origen FOR UPDATE;
        SELECT peso INTO v_stock_destino FROM producto WHERE id = p_producto_destino FOR UPDATE;
    ELSE
        SELECT peso INTO v_stock_destino FROM producto WHERE id = p_producto_destino FOR UPDATE;
        SELECT peso INTO v_stock_origen FROM producto WHERE id = p_producto_origen FOR UPDATE;
    END IF;
    
    -- Validación 3: Stock suficiente
    IF v_stock_origen < p_cantidad THEN
        SET v_mensaje_error = CONCAT('Stock insuficiente. Disponible: ', v_stock_origen);
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_mensaje_error;
    END IF;
    
    -- Operación 1: Reducir stock origen
    UPDATE producto
    SET peso = peso - p_cantidad
    WHERE id = p_producto_origen;
    
    -- Operación 2: Aumentar stock destino
    UPDATE producto
    SET peso = peso + p_cantidad
    WHERE id = p_producto_destino;
    
    -- Log operación
    INSERT INTO log_transacciones (operacion, estado, usuario)
    VALUES (CONCAT('Transferencia ejecutada: ', p_producto_origen, ' → ', p_producto_destino, ' (', p_cantidad, 'kg)'),
            'EJECUTADO', USER());
    
    -- COMMIT
    COMMIT;
    
    -- Log exito
    INSERT INTO log_transacciones (operacion, estado, usuario)
    VALUES (CONCAT('Transferir stock ', p_producto_origen, '→', p_producto_destino),
            'EXITO', USER());
    
    SET p_resultado = CONCAT('EXITO: Transferidos ', p_cantidad, 'kg de producto ',
                             p_producto_origen, ' a producto ', p_producto_destino);
END//

DELIMITER ;

SELECT '✓ BLOQUE 4: Procedimiento transferir_stock_productos creado' AS status;