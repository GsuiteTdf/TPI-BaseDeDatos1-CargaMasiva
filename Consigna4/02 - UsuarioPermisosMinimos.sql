CREATE USER IF NOT EXISTS 'user_minimos'@'localhost' IDENTIFIED BY '1234';

GRANT SELECT ON depositotpi.codigo_barras TO 'user_minimos'@'localhost';
GRANT SELECT, INSERT ON depositotpi.producto TO 'user_minimos'@'localhost';

FLUSH PRIVILEGES;