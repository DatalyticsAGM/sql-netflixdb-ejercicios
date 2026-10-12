-- Ejercicio 2 · Los tres géneros más populares
-- La subconsulta elige los géneros con más series; la principal
-- calcula el rating medio de cada serie de esos géneros.
-- Conceptos: Subconsulta · IN · JOIN · GROUP BY · LIMIT

SELECT
    s.genero,
    s.titulo,
    s.año_lanzamiento,
    ROUND(AVG(e.rating_imdb), 2)   AS rating_promedio_imdb
FROM Series s
JOIN Episodios e ON e.serie_id = s.serie_id
WHERE s.genero IN (
    SELECT genero
    FROM Series
    GROUP BY genero
    ORDER BY COUNT(serie_id) DESC
    LIMIT 3
)
GROUP BY s.serie_id, s.genero, s.titulo, s.año_lanzamiento
ORDER BY s.genero, rating_promedio_imdb DESC;
