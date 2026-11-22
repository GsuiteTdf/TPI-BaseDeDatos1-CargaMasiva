SELECT p.*
FROM producto p
WHERE p.precio > (
  SELECT AVG(p2.precio)
  FROM producto p2
  WHERE p2.categoria = p.categoria
);