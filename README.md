# Base de Datos I — Carga masiva de datos: Producto ↔ Código de barras

Trabajo Final Integrador · Bases de Datos I · Tecnicatura Universitaria en Programación a Distancia (UTN).

Modelado e implementación en **MySQL** de la relación 1:1 entre `producto` y `codigo_barras`, con restricciones de integridad, carga masiva reproducible (≈ 200.000 filas por tabla) usando solo SQL, vistas, mediciones de rendimiento con y sin índices, seguridad por roles y usuarios, y procedimientos almacenados con manejo de transacciones y reintento ante *deadlocks*.

- **Video de demostración:** https://www.youtube.com/watch?v=8xNp3CX9sew
- **Comisión 01 · Grupo 117**
- **Integrantes:** Gastón Cejas · Hernán Coceres · Claudio Rodríguez · Hernán Bula

## Tecnologías y conceptos

| Área          | Contenido                                                                                                   |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| SGBD          | MySQL 8.x (o MariaDB con características equivalentes)                                                      |
| Modelado      | Relación 1:1, PK / FK / UNIQUE / CHECK, `ENUM`, baja lógica (`eliminado`)                                    |
| Carga masiva  | `WITH RECURSIVE`, `ROW_NUMBER() OVER()`, tablas semilla, distribución por categoría                         |
| Rendimiento   | Índices, vistas, comparación de tiempos con y sin índice                                                    |
| Seguridad     | Roles, usuarios con privilegios mínimos, pruebas de permisos, intento de inyección SQL, tablas de auditoría |
| Transacciones | Procedimientos almacenados, `SIGNAL`, `GET DIAGNOSTICS`, reintento ante *deadlock*, tablas de log           |

## Volumen de datos

| Tabla             | Registros |
| ----------------- | --------- |
| `codigo_barras`   | 200.000   |
| `producto`        | 200.000   |

Distribución de productos por categoría: Alimentos 40 % · Ferretería 25 % · Bebidas 15 % · Electrodomésticos 10 % · Limpieza 10 %.

## Estructura y orden de ejecución

Los scripts se ejecutan en orden numérico dentro de cada carpeta, y las carpetas en orden (1 → 5). Son idempotentes: incluyen `DROP ... IF EXISTS` y otras defensas, por lo que pueden volver a ejecutarse.

```
.
├── Consigna1/   Base de datos, tablas e índices, validaciones (inserciones válidas e inválidas)
├── Consigna2/   Tablas semilla y carga masiva de códigos de barras y productos
├── Consigna3/   Vista para CRUD, consultas representativas y pruebas de rendimiento con/sin índice
│                (DatosObtenidos.txt: tiempos medidos)
├── Consigna4/   Roles, usuarios, permisos mínimos, inyección SQL, limpieza idempotente y auditoría
└── Consigna5/   Tablas de log y procedimientos con transacciones y retry ante deadlocks
```

## Requisitos

- MySQL 8.x (o MariaDB equivalente).
- Ejecutar con un usuario con privilegios para crear bases, roles y usuarios (por ejemplo `root`), al menos durante la Consigna 4.
- Los scripts de carga masiva ajustan `max_recursive_iterations` cuando hace falta.

## Usuarios de base de datos (Consigna 4)

| Usuario       | Uso                         | Permisos              |
| ------------- | --------------------------- | --------------------- |
| `app_user`    | Aplicación principal        | Privilegios mínimos   |
| `etl_user`    | Cargas masivas              | Permisos extendidos   |
| `report_user` | Reportes                    | Solo lectura          |
| `admin_user`  | Administración              | Completos             |

> Las contraseñas de estos usuarios están en `Consigna4/01 - CreacionDeUsuarios.sql` y son solo de ejemplo para un entorno local.

## Resultados de rendimiento

Mediciones de la Consigna 3 (promedio de tres ejecuciones, ver `Consigna3/DatosObtenidos.txt`):

| Consulta | Con índice | Sin índice |
| -------- | ---------- | ---------- |
| A        | ≈ 20 ms    | ≈ 25 ms    |
| B        | ≈ 22 ms    | ≈ 302 ms   |
| C        | ≈ 219 ms   | ≈ 185 ms   |

Los índices aceleran notablemente las consultas con filtros selectivos (consulta B, más de 13 veces). En conteos o recorridos globales (consulta C) el escaneo secuencial puede resultar igual o más eficiente.
