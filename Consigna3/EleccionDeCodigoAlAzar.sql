-- Elege un valor existente de código de barras (para la consulta A)
SELECT @valor := cb.valor
FROM codigo_barras cb
JOIN producto p ON p.codigo_barras_id = cb.id
ORDER BY cb.id
LIMIT 1;

-- Elege una ventana temporal consistente (últimos 365 días respecto al máximo cargado)
SELECT
  @d2 := MAX(fecha_asignacion),
  @d1 := DATE_SUB(MAX(fecha_asignacion), INTERVAL 365 DAY)
FROM codigo_barras;

-- Confirmar
SELECT @valor AS sample_valor, @d1 AS desde, @d2 AS hasta;