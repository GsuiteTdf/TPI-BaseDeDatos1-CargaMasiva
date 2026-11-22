DROP TABLE deposito.codigo_barras;
DELETE FROM deposito.producto WHERE id = 1;
SELECT * FROM deposito.producto LIMIT 1;
INSERT INTO deposito.producto (nombre, precio) VALUES ('PruebaUser', 12.50);