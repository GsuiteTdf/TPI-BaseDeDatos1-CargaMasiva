SELECT p.id, p.nombre, p.categoria, p.precio, cb.tipo, cb.fecha_asignacion
FROM producto p
JOIN codigo_barras cb ON cb.id = p.codigo_barras_id
WHERE cb.tipo = 'EAN13'
  AND cb.fecha_asignacion BETWEEN '2023-01-01' AND '2023-12-31'
  AND p.precio BETWEEN 100 AND 500
ORDER BY cb.fecha_asignacion DESC;