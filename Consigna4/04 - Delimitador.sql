DELIMITER //

CREATE PROCEDURE deposito.sp_insertar_producto_seguro (
    IN p_marca VARCHAR(80),
    IN p_categoria VARCHAR(80),
    IN p_precio DECIMAL(10,2),
    IN p_peso DECIMAL(10,3),
    IN p_codigo_barras VARCHAR(45)
)
BEGIN
    INSERT INTO deposito.producto (marca, categoria, precio, peso, codigo_barras)
    VALUES (p_marca, p_categoria, p_precio, p_peso, p_codigo_barras);
END;
//

DELIMITER ;