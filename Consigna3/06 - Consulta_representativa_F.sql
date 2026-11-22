SELECT
  DATE_FORMAT(cb.fecha_asignacion, '%Y-%m') AS anio_mes,
  cb.tipo,
  COUNT(*) AS cantidad
FROM producto p
JOIN codigo_barras cb ON cb.id = p.codigo_barras_id
GROUP BY anio_mes, cb.tipo
ORDER BY anio_mes DESC, cb.tipo;