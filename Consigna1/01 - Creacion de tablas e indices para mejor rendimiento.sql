
CREATE TABLE codigo_barras (

    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    tipo ENUM('EAN13', 'EAN8', 'UPC') NOT NULL,
    valor VARCHAR(20) NOT NULL,
    fecha_asignacion DATE,
    observaciones VARCHAR(255),
    
    CONSTRAINT uq_codigo_barras_valor UNIQUE (valor),

    CONSTRAINT chk_codigo_barras_valor_no_vacio 
        CHECK (LENGTH(TRIM(valor)) > 0),
    CONSTRAINT chk_codigo_barras_fecha_rango 
        CHECK (fecha_asignacion IS NULL OR fecha_asignacion >= '1900-01-01')
);


CREATE TABLE producto (

    id BIGINT PRIMARY KEY AUTO_INCREMENT,

    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    nombre VARCHAR(120) NOT NULL,
    marca VARCHAR(80),
    categoria VARCHAR(80),
    precio DECIMAL(10,2) NOT NULL,
    peso DECIMAL(10,3),

    codigo_barras_id BIGINT,
    
    CONSTRAINT fk_producto_codigo_barras 
        FOREIGN KEY (codigo_barras_id) 
        REFERENCES codigo_barras(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    

    CONSTRAINT uq_producto_codigo_barras UNIQUE (codigo_barras_id),

    CONSTRAINT chk_producto_nombre_no_vacio 
        CHECK (LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_producto_precio_positivo 
        CHECK (precio > 0),
    CONSTRAINT chk_producto_peso_positivo 
        CHECK (peso IS NULL OR peso > 0),
    CONSTRAINT chk_producto_marca_no_vacia 
        CHECK (marca IS NULL OR LENGTH(TRIM(marca)) > 0),
    CONSTRAINT chk_producto_categoria_no_vacia 
        CHECK (categoria IS NULL OR LENGTH(TRIM(categoria)) > 0)
);

CREATE INDEX idx_producto_nombre ON producto(nombre);
CREATE INDEX idx_producto_categoria ON producto(categoria);
CREATE INDEX idx_producto_eliminado ON producto(eliminado);
CREATE INDEX idx_codigo_barras_eliminado ON codigo_barras(eliminado);