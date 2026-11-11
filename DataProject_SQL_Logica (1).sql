/* =====================================================================
   DataProject: Lógica Consultas SQL
   Motor: PostgreSQL  |  Herramienta: DBeaver
   Base de datos: Sakila / Pagila (alquiler de películas)
   ===================================================================== */

/* ---------------------------------------------------------------------
   1. Crea el esquema de la BBDD.
   El esquema (diagrama entidad-relación) se genera en DBeaver:
   clic derecho sobre el esquema "public" > "View Diagram" > exportar
   como imagen (PNG) y guardarla en el repositorio (esquema_bbdd.png).
   Tablas principales: actor, film, film_actor, category, film_category,
   language, inventory, rental, payment, customer, staff, store,
   address, city, country.
   --------------------------------------------------------------------- */

-- 2. Películas con clasificación por edades 'R'.
SELECT f.title
FROM film AS f
WHERE f.rating = 'R';

-- 3. Actores con actor_id entre 30 y 40.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4. Películas cuyo idioma coincide con el idioma original.
-- Nota: en esta BBDD original_language_id suele ser NULL, por lo que el resultado puede estar vacío.
SELECT f.title
FROM film AS f
WHERE f.language_id = f.original_language_id;

-- 5. Películas ordenadas por duración ascendente.
SELECT f.title, f.length
FROM film AS f
ORDER BY f.length ASC;

-- 6. Actores con 'Allen' en su apellido.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.last_name ILIKE '%allen%';

-- 7. Total de películas por clasificación.
SELECT f.rating, COUNT(*) AS total_peliculas
FROM film AS f
GROUP BY f.rating
ORDER BY total_peliculas DESC;

-- 8. Películas 'PG-13' o con duración mayor a 3 horas (180 min).
SELECT f.title, f.rating, f.length
FROM film AS f
WHERE f.rating = 'PG-13' OR f.length > 180;

-- 9. Variabilidad del coste de reemplazo (varianza y desviación estándar).
SELECT ROUND(VARIANCE(f.replacement_cost), 2) AS varianza,
       ROUND(STDDEV(f.replacement_cost), 2)   AS desviacion_estandar
FROM film AS f;

-- 10. Mayor y menor duración de una película.
SELECT MAX(f.length) AS duracion_maxima,
       MIN(f.length) AS duracion_minima
FROM film AS f;

-- 11. Lo que costó el antepenúltimo alquiler ordenado por día.
SELECT r.rental_id, r.rental_date, p.amount
FROM rental AS r
JOIN payment AS p ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC
OFFSET 2 LIMIT 1;

-- 12. Películas que no son ni 'NC-17' ni 'G'.
SELECT f.title, f.rating
FROM film AS f
WHERE f.rating NOT IN ('NC-17', 'G');

-- 13. Duración media por clasificación.
SELECT f.rating, ROUND(AVG(f.length), 2) AS duracion_media
FROM film AS f
GROUP BY f.rating
ORDER BY duracion_media DESC;

-- 14. Películas con duración mayor a 180 minutos.
SELECT f.title, f.length
FROM film AS f
WHERE f.length > 180;

-- 15. Dinero total generado por la empresa.
SELECT SUM(p.amount) AS total_ingresos
FROM payment AS p;

-- 16. Los 10 clientes con mayor id.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
ORDER BY c.customer_id DESC
LIMIT 10;

-- 17. Actores de la película 'Egg Igby'.
SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN film AS f        ON f.film_id  = fa.film_id
WHERE f.title = 'EGG IGBY';

-- 18. Nombres de películas únicos.
SELECT DISTINCT f.title
FROM film AS f
ORDER BY f.title;

-- 19. Comedias con duración mayor a 180 minutos.
SELECT f.title, f.length
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;

-- 20. Categorías con duración media superior a 110 minutos.
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f           ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110
ORDER BY duracion_media DESC;

-- 21. Media de duración del alquiler.
-- a) Duración de alquiler pactada en el catálogo (días):
SELECT ROUND(AVG(f.rental_duration), 2) AS media_dias_pactados
FROM film AS f;
-- b) Duración real de los alquileres devueltos:
SELECT AVG(r.return_date - r.rental_date) AS media_duracion_real
FROM rental AS r
WHERE r.return_date IS NOT NULL;

-- 22. Columna con nombre y apellidos de todos los actores.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
FROM actor AS a;

-- 23. Número de alquileres por día, de mayor a menor.
SELECT DATE(r.rental_date) AS dia, COUNT(*) AS total_alquileres
FROM rental AS r
GROUP BY DATE(r.rental_date)
ORDER BY total_alquileres DESC;

-- 24. Películas con duración superior al promedio (subconsulta).
SELECT f.title, f.length
FROM film AS f
WHERE f.length > (SELECT AVG(length) FROM film)
ORDER BY f.length DESC;

-- 25. Número de alquileres por mes.
SELECT TO_CHAR(r.rental_date, 'YYYY-MM') AS mes, COUNT(*) AS total_alquileres
FROM rental AS r
GROUP BY TO_CHAR(r.rental_date, 'YYYY-MM')
ORDER BY mes;

-- 26. Promedio, desviación estándar y varianza del total pagado.
SELECT ROUND(AVG(p.amount), 2)      AS promedio,
       ROUND(STDDEV(p.amount), 2)   AS desviacion_estandar,
       ROUND(VARIANCE(p.amount), 2) AS varianza
FROM payment AS p;

-- 27. Películas que se alquilan por encima del precio medio.
SELECT f.title, f.rental_rate
FROM film AS f
WHERE f.rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY f.rental_rate DESC;

-- 28. Id de actores que han participado en más de 40 películas.
SELECT fa.actor_id, COUNT(*) AS total_peliculas
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(*) > 40;

-- 29. Todas las películas y, si están en inventario, la cantidad disponible.
SELECT f.title, COUNT(i.inventory_id) AS cantidad_disponible
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

-- 30. Actores y número de películas en las que han actuado.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;

-- 31. Todas las películas con sus actores, incluso si no tienen actores.
SELECT f.title, a.first_name, a.last_name
FROM film AS f
LEFT JOIN film_actor AS fa ON fa.film_id = f.film_id
LEFT JOIN actor AS a       ON a.actor_id = fa.actor_id
ORDER BY f.title;

-- 32. Todos los actores con sus películas, incluso si no han actuado en ninguna.
SELECT a.first_name, a.last_name, f.title
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
LEFT JOIN film AS f        ON f.film_id = fa.film_id
ORDER BY a.last_name, a.first_name;

-- 33. Todas las películas y todos los registros de alquiler.
SELECT f.title, r.rental_id, r.rental_date
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id
FULL OUTER JOIN rental AS r ON r.inventory_id = i.inventory_id
ORDER BY f.title;

-- 34. Los 5 clientes que más dinero han gastado.
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer AS c
JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

-- 35. Actores cuyo primer nombre es 'Johnny'.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.first_name = 'JOHNNY';

-- 36. Renombrar first_name como Nombre y last_name como Apellido.
SELECT a.first_name AS "Nombre", a.last_name AS "Apellido"
FROM actor AS a;

-- 37. ID de actor más bajo y más alto.
SELECT MIN(a.actor_id) AS id_minimo, MAX(a.actor_id) AS id_maximo
FROM actor AS a;

-- 38. Número de actores.
SELECT COUNT(*) AS total_actores
FROM actor AS a;

-- 39. Actores ordenados por apellido ascendente.
SELECT a.first_name, a.last_name
FROM actor AS a
ORDER BY a.last_name ASC, a.first_name ASC;

-- 40. Primeras 5 películas.
SELECT f.film_id, f.title
FROM film AS f
ORDER BY f.film_id
LIMIT 5;

-- 41. Actores agrupados por nombre y nombre más repetido.
SELECT a.first_name, COUNT(*) AS total
FROM actor AS a
GROUP BY a.first_name
ORDER BY total DESC, a.first_name;
-- Nombre más repetido:
SELECT a.first_name, COUNT(*) AS total
FROM actor AS a
GROUP BY a.first_name
ORDER BY total DESC
LIMIT 1;

-- 42. Alquileres y nombres de los clientes que los realizaron.
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
ORDER BY r.rental_date;

-- 43. Todos los clientes y sus alquileres, incluidos los que no tienen.
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
ORDER BY c.customer_id;

-- 44. CROSS JOIN entre film y category.
SELECT f.title, c.name AS categoria
FROM film AS f
CROSS JOIN category AS c;
/* Respuesta: No aporta valor. El CROSS JOIN genera el producto cartesiano
   (cada película combinada con TODAS las categorías: 1000 x 16 = 16.000 filas),
   sin tener en cuenta la relación real definida en film_category. El resultado
   asigna a cada película categorías que no le corresponden, por lo que la
   información es engañosa. Para relacionarlas correctamente hay que usar
   film_category con un INNER JOIN. */

-- 45. Actores que han participado en películas de la categoría 'Action'.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa    ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name;

-- 46. Actores que no han participado en películas.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE NOT EXISTS (SELECT 1 FROM film_actor AS fa WHERE fa.actor_id = a.actor_id);

-- 47. Nombre de los actores y cantidad de películas.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;

-- 48. Vista "actor_num_peliculas".
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS num_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT * FROM actor_num_peliculas ORDER BY num_peliculas DESC;

-- 49. Total de alquileres por cliente.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

-- 50. Duración total de las películas de la categoría 'Action'.
SELECT SUM(f.length) AS duracion_total_minutos
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Action';

-- 51. Tabla temporal "cliente_rentas_temporal".
DROP TABLE IF EXISTS cliente_rentas_temporal;
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC;

-- 52. Tabla temporal "peliculas_alquiladas" (alquiladas al menos 10 veces).
DROP TABLE IF EXISTS peliculas_alquiladas;
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r    ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

SELECT * FROM peliculas_alquiladas ORDER BY veces_alquilada DESC;

-- 53. Películas alquiladas por 'Tammy Sanders' aún no devueltas.
SELECT f.title
FROM rental AS r
JOIN customer AS c  ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f      ON f.film_id = i.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name  = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;

-- 54. Actores con al menos una película de 'Sci-Fi', ordenados por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa    ON fa.actor_id = a.actor_id
JOIN film_category AS fc ON fc.film_id = fa.film_id
JOIN category AS c       ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

-- 55. Actores de películas alquiladas después del primer alquiler de 'Spartacus Cheaper'.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
JOIN inventory AS i   ON i.film_id = fa.film_id
JOIN rental AS r      ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
        SELECT MIN(r2.rental_date)
        FROM rental AS r2
        JOIN inventory AS i2 ON i2.inventory_id = r2.inventory_id
        JOIN film AS f2      ON f2.film_id = i2.film_id
        WHERE f2.title = 'SPARTACUS CHEAPER')
ORDER BY a.last_name;

-- 56. Actores que no han actuado en ninguna película de 'Music'.
SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
        SELECT fa.actor_id
        FROM film_actor AS fa
        JOIN film_category AS fc ON fc.film_id = fa.film_id
        JOIN category AS c       ON c.category_id = fc.category_id
        WHERE c.name = 'Music')
ORDER BY a.last_name;

-- 57. Películas alquiladas por más de 8 días.
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id
JOIN rental AS r    ON r.inventory_id = i.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- 58. Películas de la misma categoría que 'Animation'.
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id
WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Animation')
ORDER BY f.title;

-- 59. Películas con la misma duración que 'Dancing Fever'.
SELECT f.title, f.length
FROM film AS f
WHERE f.length = (SELECT length FROM film WHERE title = 'DANCING FEVER')
ORDER BY f.title;

-- 60. Clientes que han alquilado al menos 7 películas distintas.
SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer AS c
JOIN rental AS r    ON r.customer_id = c.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name;

-- 61. Total de películas alquiladas por categoría.
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN inventory AS i      ON i.film_id = fc.film_id
JOIN rental AS r         ON r.inventory_id = i.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- 62. Número de películas por categoría estrenadas en 2006.
SELECT c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM category AS c
JOIN film_category AS fc ON fc.category_id = c.category_id
JOIN film AS f           ON f.film_id = fc.film_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY total_peliculas DESC;

-- 63. Todas las combinaciones de trabajadores con tiendas.
SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff AS s
CROSS JOIN store AS st;

-- 64. Total de películas alquiladas por cliente (id, nombre, apellido, cantidad).
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer AS c
JOIN rental AS r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY peliculas_alquiladas DESC;
