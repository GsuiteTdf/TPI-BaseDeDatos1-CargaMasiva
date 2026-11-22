SET SESSION cte_max_recursion_depth = 300000;

INSERT INTO producto (
    eliminado,
    nombre,
    marca,
    categoria,
    precio,
    peso,
    codigo_barras_id
)
WITH RECURSIVE seq(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 200000
),
codes AS (
    SELECT
        cb.id,
        ROW_NUMBER() OVER (ORDER BY cb.id) AS rn
    FROM codigo_barras cb
    LEFT JOIN producto p ON p.codigo_barras_id = cb.id
    WHERE p.id IS NULL
    LIMIT 200000
),
cat_biased AS (
    SELECT
        n,
        CASE
            WHEN (n % 100) < 40 THEN 'Alimentos'         -- 40%
            WHEN (n % 100) < 65 THEN 'Ferretería'        -- 25%
            WHEN (n % 100) < 80 THEN 'Bebidas'           -- 15%
            WHEN (n % 100) < 90 THEN 'Electrodomésticos' -- 10%
            ELSE 'Limpieza'                              -- 10%
        END AS categoria
    FROM seq
)
SELECT
    0 AS eliminado,
    
    -- Nombre del producto
    CONCAT(
        cb.categoria, ' ',
        CASE cb.categoria
            WHEN 'Alimentos' THEN
                CASE (s.n % 4)
                    WHEN 0 THEN 'San Antonio'
                    WHEN 1 THEN 'Molinos'
                    WHEN 2 THEN 'Don Satur'
                    ELSE 'Pepsico'
                END
            WHEN 'Ferretería' THEN
                CASE (s.n % 2)
                    WHEN 0 THEN 'FixTools'
                    ELSE 'Molinos'
                END
            WHEN 'Bebidas' THEN
                CASE (s.n % 2)
                    WHEN 0 THEN 'Pepsico'
                    ELSE 'San Antonio'
                END
            WHEN 'Electrodomésticos' THEN 'Ecolife'
            WHEN 'Limpieza' THEN
                CASE (s.n % 2)
                    WHEN 0 THEN 'Ecolife'
                    ELSE 'San Antonio'
                END
        END,
        ' ',
        LPAD(s.n, 6, '0')
    ) AS nombre,

    -- Marca
    CASE cb.categoria
        WHEN 'Alimentos' THEN
            CASE (s.n % 4)
                WHEN 0 THEN 'San Antonio'
                WHEN 1 THEN 'Molinos'
                WHEN 2 THEN 'Don Satur'
                ELSE 'Pepsico'
            END
        WHEN 'Ferretería' THEN
            CASE (s.n % 2)
                WHEN 0 THEN 'FixTools'
                ELSE 'Molinos'
            END
        WHEN 'Bebidas' THEN
            CASE (s.n % 2)
                WHEN 0 THEN 'Pepsico'
                ELSE 'San Antonio'
            END
        WHEN 'Electrodomésticos' THEN 'Ecolife'
        WHEN 'Limpieza' THEN
            CASE (s.n % 2)
                WHEN 0 THEN 'Ecolife'
                ELSE 'San Antonio'
            END
    END AS marca,

    cb.categoria,

    -- Precio
    CASE cb.categoria
        WHEN 'Alimentos'         THEN 5.00  + ((s.n % 500)  * 0.02)
        WHEN 'Ferretería'        THEN 25.00 + ((s.n % 800)  * 0.05)
        WHEN 'Bebidas'           THEN 2.00  + ((s.n % 300)  * 0.02)
        WHEN 'Electrodomésticos' THEN 99.00 + ((s.n % 5000) * 0.20)
        WHEN 'Limpieza'          THEN 10.00 + ((s.n % 600)  * 0.03)
    END AS precio,

    -- Peso
    CASE
        WHEN (s.n % 5) = 0 THEN NULL
        WHEN cb.categoria = 'Alimentos'         THEN 0.500
        WHEN cb.categoria = 'Ferretería'        THEN 1.200
        WHEN cb.categoria = 'Bebidas'           THEN 1.000
        WHEN cb.categoria = 'Electrodomésticos' THEN 8.000
        WHEN cb.categoria = 'Limpieza'          THEN 0.800
    END AS peso,

    c.id AS codigo_barras_id

FROM cat_biased cb
JOIN seq s ON s.n = cb.n
JOIN codes c ON c.rn = s.n;
