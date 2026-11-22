-- Igualdad (con índice)
SET @t0 = NOW(6);
SELECT SQL_NO_CACHE
       p.id, p.nombre, p.categoria, p.precio, cb.valor, cb.tipo
FROM codigo_barras cb FORCE INDEX (idx_cb_valor)
JOIN producto p ON p.codigo_barras_id = cb.id
WHERE cb.valor = @valor;
SELECT ROUND(TIMESTAMPDIFF(MICROSECOND,@t0,NOW(6))/1000,3) AS ms;