DROP PROCEDURE IF EXISTS actualizar_precio_producto;

DELIMITER //

CREATE PROCEDURE actualizar_precio_producto(
    IN p_producto_id INT,
    IN p_nuevo_precio DECIMAL(10,2),
    IN p_motivo VARCHAR(200),
    OUT p_resultado VARCHAR(100),
    OUT p_codigo_error INT
)
BEGIN
    DECLARE v_precio_anterior DECIMAL(10,2);
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_error_msg TEXT;
    DECLARE v_sql_state VARCHAR(5);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_error_msg = MESSAGE_TEXT,
            p_codigo_error = MYSQL_ERRNO,
            v_sql_state = RETURNED_SQLSTATE;
        
   
        ROLLBACK;
        
        -- Registrar error
        INSERT INTO log_errores (procedimiento, error_code, error_msg, sql_state, contexto)
        VALUES ('actualizar_precio_producto', p_codigo_error, v_error_msg, v_sql_state,
                CONCAT('Producto ID: ', p_producto_id, ', Nuevo precio: ', p_nuevo_precio));
        
        INSERT INTO log_transacciones (operacion, estado, error_code, error_msg, usuario)
        VALUES (CONCAT('Actualizar precio producto ', p_producto_id), 
                'ERROR', p_codigo_error, v_error_msg, USER());
        
        SET p_resultado = CONCAT('ERROR: ', v_error_msg);
    END;
    
    -- Inicializar
    SET p_codigo_error = 0;
    
    -- Log inicio
    INSERT INTO log_transacciones (operacion, estado, usuario)
    VALUES (CONCAT('Actualizar precio producto ', p_producto_id), 'INICIANDO', USER());
    
    -- START TRANSACTION
    START TRANSACTION;
    
    -- Validación 1: Producto existe
    SELECT COUNT(*), COALESCE(MAX(precio), 0) 
    INTO v_existe, v_precio_anterior
    FROM producto 
    WHERE id = p_producto_id;
    
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no existe',
            MYSQL_ERRNO = 9001;
    END IF;
    
    -- Validación 2: Precio válido
    IF p_nuevo_precio <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio debe ser mayor a cero',
            MYSQL_ERRNO = 9002;
    END IF;
    
    -- Validación 3: Cambio no mayor al 50%
    IF ABS(p_nuevo_precio - v_precio_anterior) > (v_precio_anterior * 0.5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cambio de precio es demasiado grande (>50%)',
            MYSQL_ERRNO = 9003;
    END IF;
    
    -- Actualizar precio
    UPDATE producto 
    SET precio = p_nuevo_precio 
    WHERE id = p_producto_id;
    
    -- Registrar en historial
    INSERT INTO historial_cambios (producto_id, precio_anterior, precio_nuevo, 
                                   cambio_precio, usuario, motivo)
    VALUES (p_producto_id, v_precio_anterior, p_nuevo_precio,
            p_nuevo_precio - v_precio_anterior, USER(), p_motivo);
    
    -- COMMIT
    COMMIT;
    
    -- Log exito
    INSERT INTO log_transacciones (operacion, estado, usuario)
    VALUES (CONCAT('Actualizar precio producto ', p_producto_id), 'EXITO', USER());
    
    SET p_resultado = CONCAT('EXITO: Precio actualizado de ', v_precio_anterior, ' a ', p_nuevo_precio);
END//

DELIMITER ;

SELECT '✓ BLOQUE 2: Procedimiento actualizar_precio_producto creado' AS status;