WITH ranked AS (
  SELECT
    p.*,
    ROW_NUMBER() OVER (PARTITION BY p.categoria ORDER BY p.precio DESC) AS rn
  FROM producto p
)
SELECT *
FROM ranked
WHERE rn <= 5
ORDER BY categoria, precio DESC;