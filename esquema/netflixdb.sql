-- ============================================================
-- NetflixDB — esquema de práctica
-- ============================================================
-- Cuatro tablas: series, sus episodios, los actores y sus
-- actuaciones. Actuaciones resuelve la relación N:N entre
-- Actores y Series con clave primaria compuesta.
-- ============================================================

CREATE TABLE Actores (
    actor_id          INT         PRIMARY KEY,
    nombre            TEXT        NOT NULL,
    fecha_nacimiento  DATE
);

CREATE TABLE Series (
    serie_id          INT         PRIMARY KEY,
    titulo            TEXT        NOT NULL,
    descripcion       TEXT,
    año_lanzamiento   INT,
    genero            TEXT
);

CREATE TABLE Episodios (
    episodio_id       INT         PRIMARY KEY,
    serie_id          INT         NOT NULL,
    titulo            TEXT        NOT NULL,
    duracion          INT,
    rating_imdb       INT,
    temporada         INT,
    descripcion       TEXT,
    fecha_estreno     DATE,
    CONSTRAINT fk_episodios_serie
        FOREIGN KEY (serie_id) REFERENCES Series (serie_id)
);

-- Tabla puente: un actor puede estar en varias series y una serie
-- tiene varios actores. El personaje es atributo de la relación,
-- no del actor ni de la serie.
CREATE TABLE Actuaciones (
    actor_id          INT         NOT NULL,
    serie_id          INT         NOT NULL,
    personaje         TEXT,
    CONSTRAINT pk_actuaciones PRIMARY KEY (actor_id, serie_id),
    CONSTRAINT fk_actuaciones_actor
        FOREIGN KEY (actor_id) REFERENCES Actores (actor_id),
    CONSTRAINT fk_actuaciones_serie
        FOREIGN KEY (serie_id) REFERENCES Series (serie_id)
);

-- Índices sobre las claves foráneas más consultadas: las dos consultas
-- del repositorio unen Series con Episodios por serie_id.
CREATE INDEX idx_episodios_serie ON Episodios (serie_id);
CREATE INDEX idx_series_genero   ON Series (genero);
