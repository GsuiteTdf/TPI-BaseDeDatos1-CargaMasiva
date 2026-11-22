CREATE TABLE marcas (
    id INT PRIMARY KEY,
    nombre VARCHAR(80)
);

CREATE TABLE categorias (
    id INT PRIMARY KEY,
    nombre VARCHAR(80)
);

CREATE TABLE tipo_codigos (
    id INT PRIMARY KEY,
    tipo ENUM('EAN13', 'EAN8', 'UPC')
);
