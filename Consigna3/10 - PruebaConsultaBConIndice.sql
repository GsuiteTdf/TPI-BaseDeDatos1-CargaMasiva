-- B con índice
SET @t0 = NOW(6);
SELECT SQL_NO_CACHE
       p.id, p.nombre, p.categoria, p.precio,
       cb.tipo, cb.fecha_asignacion
FROM producto p
JOIN codigo_barras cb FORCE INDEX (idx_cb_tipo_fecha)
  ON cb.id = p.codigo_barras_id
WHERE cb.tipo = 'EAN13'
  AND cb.fecha_asignacion BETWEEN @d1 AND @d2
ORDER BY cb.fecha_asignacion DESC
LIMIT 200;
SELECT ROUND(TIMESTAMPDIFF(MICROSECOND,@t0,NOW(6))/1000,3) AS ms;