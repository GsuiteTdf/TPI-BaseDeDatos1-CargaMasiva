

SET SESSION cte_max_recursion_depth = 200000;

DROP TEMPORARY TABLE IF EXISTS tmp_codigos;

CREATE TEMPORARY TABLE tmp_codigos AS
WITH RECURSIVE secuencia(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM secuencia WHERE n < 200000
)
SELECT
    CASE
        WHEN RAND() < 0.6 THEN 'EAN13'
        WHEN RAND() < 0.9 THEN 'EAN8'
        ELSE 'UPC'
    END AS tipo,
    CONCAT('CB', LPAD(n, 12, '0')) AS valor,
    DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 1500) DAY) AS fecha_asignacion,
    CONCAT('Observación ', n) AS observaciones
FROM secuencia;

INSERT INTO codigo_barras (tipo, valor, fecha_asignacion, observaciones)
SELECT tipo, valor, fecha_asignacion, observaciones
FROM tmp_codigos;
