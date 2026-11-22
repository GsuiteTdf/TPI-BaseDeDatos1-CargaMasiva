DROP PROCEDURE IF EXISTS actualizar_precio_con_retry;

DELIMITER //

CREATE PROCEDURE actualizar_precio_con_retry(
    IN p_producto_id INT,
    IN p_incremento DECIMAL(10,2),
    OUT p_resultado VARCHAR(100),
    OUT p_intentos INT
)
BEGIN
    DECLARE v_deadlock_detectado BOOLEAN DEFAULT FALSE;
    DECLARE v_error_code INT;
    DECLARE v_error_msg TEXT;
    DECLARE v_max_intentos INT DEFAULT 3;
    DECLARE v_intento_actual INT DEFAULT 0;
    DECLARE v_backoff_ms INT;
    DECLARE v_precio_anterior DECIMAL(10,2);
    
    -- Handler específico para DEADLOCK (código 1213)
    DECLARE CONTINUE HANDLER FOR 1213
    BEGIN
        SET v_deadlock_detectado = TRUE;
        SET v_error_code = 1213;
        ROLLBACK;
    END;
    
    -- Handler para otros errores
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            v_error_code = MYSQL_ERRNO,
            v_error_msg = MESSAGE_TEXT;
        
        ROLLBACK;
        
        INSERT INTO log_errores (procedimiento, error_code, error_msg, contexto)
        VALUES ('actualizar_precio_con_retry', v_error_code, v_error_msg,
                CONCAT('Producto: ', p_producto_id, ', Incremento: ', p_incremento));
        
        SET p_resultado = CONCAT('ERROR SQL: ', v_error_code, ' - ', v_error_msg);
        SET p_intentos = v_intento_actual;
    END;
    
    -- BUCLE DE RETRY
    retry_loop: WHILE v_intento_actual < v_max_intentos DO
        SET v_intento_actual = v_intento_actual + 1;
        SET v_deadlock_detectado = FALSE;
        
        -- Log intento
        INSERT INTO log_transacciones (operacion, intento, estado)
        VALUES (CONCAT('Actualizar precio con retry - Producto ', p_producto_id), 
                v_intento_actual, 'INICIANDO');
        
        -- START TRANSACTION
        START TRANSACTION;
        
        -- Lock pesimista
        SELECT precio INTO v_precio_anterior
        FROM producto 
        WHERE id = p_producto_id
        FOR UPDATE;
        
        -- Actualizar precio
        UPDATE producto 
        SET precio = precio + p_incremento 
        WHERE id = p_producto_id;
        
        -- Simular conflicto
        DO SLEEP(0.1);
        
        -- Registrar cambio
        INSERT INTO historial_cambios (producto_id, precio_anterior, precio_nuevo, 
                                       cambio_precio, usuario, motivo)
        VALUES (p_producto_id, v_precio_anterior, v_precio_anterior + p_incremento,
                p_incremento, USER(), 'Incremento automatico con retry');
        
        -- Si NO hubo deadlock: COMMIT y salir
        IF NOT v_deadlock_detectado THEN
            COMMIT;
            SET p_resultado = 'EXITO';
            SET p_intentos = v_intento_actual;
            
            INSERT INTO log_transacciones (operacion, intento, estado)
            VALUES (CONCAT('Actualizar precio con retry - Producto ', p_producto_id), 
                    v_intento_actual, 'EXITO');
            
            LEAVE retry_loop;
        ELSE
            -- DEADLOCK detectado: aplicar backoff y RETRY
            SET v_backoff_ms = v_intento_actual * 100 + FLOOR(RAND() * 50);
            
            INSERT INTO log_transacciones (operacion, intento, estado, error_code)
            VALUES (CONCAT('Actualizar precio con retry - Producto ', p_producto_id), 
                    v_intento_actual, 
                    CONCAT('DEADLOCK - Retry en ', v_backoff_ms, 'ms'),
                    1213);
            
            INSERT INTO log_errores (procedimiento, error_code, error_msg, contexto)
            VALUES ('actualizar_precio_con_retry', 1213, 'Deadlock detectado',
                    CONCAT('Intento ', v_intento_actual, ' de ', v_max_intentos));
            
            -- Esperar antes de reintentar
            DO SLEEP(v_backoff_ms / 1000);
            
            -- Si fue el último intento
            IF v_intento_actual >= v_max_intentos THEN
                SET p_resultado = CONCAT('FALLO: Deadlock despues de ', v_max_intentos, ' intentos');
                SET p_intentos = v_intento_actual;
                
                INSERT INTO log_transacciones (operacion, intento, estado)
                VALUES (CONCAT('Actualizar precio con retry - Producto ', p_producto_id), 
                        v_intento_actual, 'FALLO DEFINITIVO');
            END IF;
        END IF;
    END WHILE retry_loop;
END//

DELIMITER ;

SELECT '✓ BLOQUE 3: Procedimiento actualizar_precio_con_retry creado' AS status;