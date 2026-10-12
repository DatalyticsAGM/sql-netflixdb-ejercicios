# SQL sobre NetflixDB — ejercicios resueltos

Consultas resueltas sobre una base de datos relacional de práctica, con el
enunciado, la consulta y la explicación de por qué está escrita así.

Formación de referencia: **SQL TOTAL — Domina Bases de Datos de 0 a Avanzado**
(Udemy).

---

## El modelo de datos

Cuatro tablas: series, sus episodios, los actores y sus actuaciones.

```
   Actores                    Series
   ─────────                  ─────────
   actor_id  PK               serie_id  PK
   nombre                     titulo
   fecha_nacimiento           descripcion
        │                     año_lanzamiento
        │                     genero
        │                          │
        │                          ├────────────┐
        │                          │            │
        │     Actuaciones          │        Episodios
        │     ─────────────        │        ──────────
        └────►actor_id  PK·FK      │        episodio_id  PK
              serie_id  PK·FK ◄────┤        serie_id     FK ──► Series
              personaje            │        titulo
                                   │        duracion
                                   └────    rating_imdb
                                            temporada
                                            descripcion
                                            fecha_estreno
```

- `Episodios.serie_id` referencia a `Series`
- `Actuaciones` resuelve la relación N:N entre `Actores` y `Series`, con clave
  primaria compuesta `(actor_id, serie_id)`

El DDL está en [`esquema/netflixdb.sql`](esquema/netflixdb.sql).

---

## Ejercicio 1 · Las series más exitosas

**Enunciado.** Identificar las series más exitosas, definiendo el éxito por la
cantidad de episodios y el rating promedio de IMDb. El resultado es una tabla
con tres columnas: título de la serie, cantidad de episodios y rating promedio.

`JOIN` · `COUNT` · `AVG` · `GROUP BY`

```sql
SELECT
    s.titulo                       AS titulo_serie,
    COUNT(e.episodio_id)           AS cantidad_episodios,
    ROUND(AVG(e.rating_imdb), 2)   AS rating_promedio_imdb
FROM Series s
JOIN Episodios e ON e.serie_id = s.serie_id
GROUP BY s.serie_id, s.titulo
ORDER BY cantidad_episodios DESC, rating_promedio_imdb DESC;
```

**Cómo funciona.** Uno la tabla `Series` con `Episodios` por `serie_id`, agrupo
por serie, cuento sus episodios y calculo la media de rating. Ordeno por número
de episodios y rating para que las series más exitosas aparezcan primero.

> Agrupo por `s.serie_id, s.titulo` y no solo por el título: dos series podrían
> llamarse igual, y la clave primaria garantiza que no se fusionen.

---

## Ejercicio 2 · Los tres géneros más populares

**Enunciado.** Usar una subconsulta para identificar los tres géneros más
populares según la cantidad de series. Para cada género, mostrar el título de
la serie, el año de lanzamiento y el rating de IMDb promedio.

`Subconsulta` · `IN` · `JOIN` · `GROUP BY` · `LIMIT`

```sql
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
```

**Cómo funciona.** La subconsulta del `WHERE` devuelve los tres géneros con más
series. La consulta principal se queda solo con las series de esos géneros y,
uniéndolas con `Episodios`, calcula el rating medio de cada una mostrando
género, título y año.

---

## En curso

Este repositorio crece con la práctica. Lo siguiente:

- [ ] Window functions: `ROW_NUMBER`, `RANK`, `LAG`/`LEAD`, acumulados
- [ ] CTEs y CTEs recursivas
- [ ] Self-joins y anti-joins
- [ ] Agregación en varios niveles con `HAVING`
- [ ] Plan de ejecución e índices

---

## Estructura

```
├── esquema/
│   └── netflixdb.sql                     DDL de las cuatro tablas
└── consultas/
    ├── 01_series_mas_exitosas.sql
    └── 02_generos_mas_populares.sql
```

Las consultas están también en
[mi portfolio](https://portafolioadrianv2.netlify.app/certificacion-sql),
con el diploma y el resaltado de sintaxis.
