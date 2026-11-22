--  Actualizacion exitosa
SELECT '--- Test 1: Actualizacion exitosa ---' AS test;
CALL actualizar_precio_producto(1000, 150.00, 'Ajuste de precio', @resultado1, @error1);
SELECT @resultado1 AS resultado, @error1 AS codigo_error;

-- Error - Producto no existe
SELECT '--- Test 2: Producto inexistente ---' AS test;
CALL actualizar_precio_producto(999999, 100.00, 'Test', @resultado2, @error2);
SELECT @resultado2 AS resultado, @error2 AS codigo_error;

-- Error - Precio negativo
SELECT '--- Test 3: Precio invalido ---' AS test;
CALL actualizar_precio_producto(1000, -50.00, 'Test negativo', @resultado3, @error3);
SELECT @resultado3 AS resultado, @error3 AS codigo_error;

--  Con retry
SELECT '--- Test 4: Actualizacion con retry ---' AS test;
CALL actualizar_precio_con_retry(2000, 25.50, @resultado4, @intentos4);
SELECT @resultado4 AS resultado, @intentos4 AS intentos_realizados;

-- Transferencia
SELECT '--- Test 5: Transferencia de stock ---' AS test;
CALL transferir_stock_productos(1000, 2000, 5.5, @resultado5, @error5);
SELECT @resultado5 AS resultado, @error5 AS codigo_error;

SELECT 'Pruebas echas' AS status;