# DataProject: Lógica Consultas SQL

Proyecto de consultas SQL sobre la base de datos de alquiler de películas (Sakila/Pagila) en **PostgreSQL**, ejecutado con **DBeaver**.

## Contenido del repositorio
| Archivo | Descripción |
|---|---|
| `DataProject_SQL_Logica.sql` | Las 64 consultas del enunciado, numeradas y comentadas |
| `esquema_bbdd.png` | Diagrama entidad-relación generado en DBeaver |
| `README.md` | Este documento |

## Cómo ejecutarlo
1. Restaurar la BBDD en PostgreSQL y conectarla en DBeaver.
2. Abrir `DataProject_SQL_Logica.sql` en el editor SQL.
3. Ejecutar cada consulta con `Ctrl + Enter` (o el script completo con `Alt + X`).

## Contenidos trabajados
- Consultas sobre una sola tabla: filtros, `ORDER BY`, `DISTINCT`, `LIMIT/OFFSET`, agregaciones (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `STDDEV`, `VARIANCE`), `GROUP BY` y `HAVING`.
- Relaciones entre tablas: `INNER`, `LEFT`, `FULL OUTER` y `CROSS JOIN`.
- Subconsultas escalares, `IN / NOT IN` y `NOT EXISTS`.
- Vistas: `actor_num_peliculas`.
- Tablas temporales: `cliente_rentas_temporal` y `peliculas_alquiladas`.
- Buenas prácticas: alias claros, palabras clave en mayúsculas, columnas explícitas en lugar de `SELECT *`, comentarios por ejercicio y `DROP ... IF EXISTS` antes de crear objetos.

## Notas sobre resultados
- **Ej. 4**: `original_language_id` está vacío (NULL) en esta BBDD, así que la consulta puede no devolver filas.
- **Ej. 44**: el `CROSS JOIN` film × category no aporta valor (producto cartesiano sin relación real); la explicación está en el script.
- Los títulos y nombres están en MAYÚSCULAS en la BBDD (p. ej. `'EGG IGBY'`, `'TAMMY'`).
