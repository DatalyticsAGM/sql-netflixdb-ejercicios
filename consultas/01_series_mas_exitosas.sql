-- Ejercicio 1 · Las series más exitosas
-- Éxito = cantidad de episodios + rating promedio de IMDb.
-- Conceptos: JOIN · COUNT · AVG · GROUP BY

SELECT
    s.titulo                       AS titulo_serie,
    COUNT(e.episodio_id)           AS cantidad_episodios,
    ROUND(AVG(e.rating_imdb), 2)   AS rating_promedio_imdb
FROM Series s
JOIN Episodios e ON e.serie_id = s.serie_id
GROUP BY s.serie_id, s.titulo
ORDER BY cantidad_episodios DESC, rating_promedio_imdb DESC;

-- Agrupo por serie_id además del título: dos series podrían llamarse
-- igual y la clave primaria garantiza que no se fusionen en una fila.
