SELECT
  p.categoria,
  COUNT(*)              AS cant_productos,
  ROUND(AVG(p.precio),2) AS precio_promedio,
  MIN(p.precio)          AS min_precio,
  MAX(p.precio)          AS max_precio
FROM producto p
GROUP BY p.categoria
HAVING AVG(p.precio) > 50  -- umbral de negocio
ORDER BY precio_promedio DESC;