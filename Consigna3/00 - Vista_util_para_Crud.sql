CREATE OR REPLACE VIEW v_productos_detalle AS
SELECT
  p.id,
  p.nombre,
  p.marca,
  p.categoria,
  p.precio,
  p.peso,
  p.eliminado,
  cb.id                AS codigo_barras_id,
  cb.valor             AS codigo_barras_valor,
  cb.tipo              AS codigo_barras_tipo,
  cb.fecha_asignacion  AS codigo_barras_fecha
FROM producto p
JOIN codigo_barras cb
  ON cb.id = p.codigo_barras_id;