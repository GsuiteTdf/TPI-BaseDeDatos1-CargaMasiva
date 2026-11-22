SELECT '========================================' AS separador;
SELECT 'LOGS DE TRANSACCIONES (Ultimas 15)' AS titulo;
SELECT * FROM log_transacciones ORDER BY id DESC LIMIT 15;

SELECT '========================================' AS separador;
SELECT 'LOGS DE ERRORES' AS titulo;
SELECT * FROM log_errores ORDER BY id DESC LIMIT 10;

SELECT '========================================' AS separador;
SELECT 'HISTORIAL DE CAMBIOS' AS titulo;
SELECT * FROM historial_cambios ORDER BY id DESC LIMIT 10;

SELECT '========================================' AS separador;
SELECT 'ESTADISTICAS' AS titulo;
SELECT 
    estado,
    COUNT(*) AS cantidad,
    ROUND(AVG(intento), 2) AS intentos_promedio
FROM log_transacciones
GROUP BY estado
ORDER BY cantidad DESC;

SELECT 'Consultas completadas' AS status;