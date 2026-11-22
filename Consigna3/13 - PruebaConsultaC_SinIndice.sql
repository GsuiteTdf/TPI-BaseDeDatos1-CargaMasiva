-- C sin índice en la FK
SET @t0 = NOW(6);
SELECT SQL_NO_CACHE COUNT(*) AS total
FROM producto p IGNORE INDEX (idx_prod_fk_codbar)
JOIN codigo_barras cb ON cb.id = p.codigo_barras_id;
SELECT ROUND(TIMESTAMPDIFF(MICROSECOND,@t0,NOW(6))/1000,3) AS ms;