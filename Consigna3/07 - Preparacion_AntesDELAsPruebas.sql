
-- 1) Igualdad por valor de código (A)
CREATE INDEX idx_cb_valor         ON codigo_barras(valor);

-- 2) Rango temporal + tipo (B)
CREATE INDEX idx_cb_tipo_fecha    ON codigo_barras(tipo, fecha_asignacion);

-- 3) JOIN por FK (C): en MariaDB no siempre se indexa la FK automáticamente
CREATE INDEX idx_prod_fk_codbar   ON producto(codigo_barras_id);

-- 4) Filtros por categoría/precio (apoya algunas variantes y ordenamientos)
CREATE INDEX idx_prod_cat_precio  ON producto(categoria, precio);