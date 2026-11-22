INSERT INTO deposito.codigo_barras (tipo, valor) VALUES ('EAN13', '1234567890123');
INSERT INTO deposito.producto (nombre, precio, codigo_barras_id)
VALUES ('ProductoInvalido', 100.00, 999999);