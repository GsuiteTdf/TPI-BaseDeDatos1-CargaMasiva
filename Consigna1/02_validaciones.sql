-- =====================================================
-- SCRIPT DE VALIDACIONES Y PRUEBAS
-- Archivo: 02_validaciones.sql
-- =====================================================
USE depositotpi;
-- #### 1) INSERCIONES CORRECTAS (DEBERÍAN FUNCIONAR)
-- Inserción correcta 1: Producto completo con código de barras EAN13
INSERT INTO codigo_barras (tipo, valor, fecha_asignacion, observaciones)
VALUES ('EAN13', '7791234567890', '2024-01-15', 'Código principal - producto lácteo');
INSERT INTO producto (nombre, marca, categoria, precio, peso, codigo_barras_id)
VALUES ('Yogurt Vainilla', 'Serenisima', 'Lacteos', 100.50, 0.900, LAST_INSERT_ID());
-- Inserción correcta 2: Producto sin código de barras
INSERT INTO producto (nombre, marca, categoria, precio, peso)
VALUES ('Yogurt Natural', 'La Serenisima', 'Lacteos', 69.99, 0.900);
-- #### 2) INSERCIONES ERRÓNEAS (DEBERÍAN FALLAR)
-- Error 1: Violación de UNIQUE (código de barras duplicado)
-- ERROR: Duplicate entry '7791234567890' for key 'uq_codigo_barras_valor'
INSERT INTO codigo_barras (tipo, valor, fecha_asignacion)
VALUES ('EAN13', '7791234567890', '2024-02-01');
-- Error 2: Precio negativo (bloqueado por UNSIGNED + trigger)
-- ERROR: El precio debe ser mayor o igual a 0.01
INSERT INTO producto (nombre, marca, categoria, precio, peso)
VALUES ('Producto Invalido', 'Test 1', 'Test', -50.00, 0.500);
