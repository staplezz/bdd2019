--Primeros dos puntos de la práctica:

SET search_path TO geografico;

--Obtener el nombre y la abreviatura de cada uno de los estados que existan
--en la tabla de geografico_completo, no deben aparecer estados repetidos.
SELECT DISTINCT nombre_estado, abreviatura
FROM geografico_completo
ORDER BY 1;

--Obtener el nombre del estado y cabecera distrital federal, que exista en
--la tabla de geografico_completo , no deben aparecer cabeceras distritales
--repetidas.
SELECT DISTINCT nombre_estado, cabecera_distrital_federal
FROM geografico_completo
ORDER BY 1;

-- Insertar un estado llamado ’mi estado’.
INSERT INTO geografico_completo (nombre_estado) VALUES
('mi estado');

 --Insertar 5 distritos federales, distritos locales y municipios diferentes.
INSERT INTO geografico_completo (cabecera_distrital_federal) VALUES
('Mordor'),
('Ciudad Gótica'),
('Tepito'),
('Chiconcuac'),
('Twin Peaks');

INSERT INTO geografico_completo (cabecera_distrital_local) VALUES
('Grove Street'),
('Wall Street'),
('Negra Arroyo Lane'),
('Evergreen Terrace'),
('Fargo');

INSERT INTO geografico_completo (nombre_municipio) VALUES
('Cuetzalan'),
('Tepoztlán'),
('Batopilas'),
('Arteaga'),
('Viesca');

--Insertar 3 secciones para cada uno de los distritos federales:
INSERT INTO geografico_completo
SELECT
	nombre_estado,
	abreviatura,
	cabecera_distrital_federal,
	cabecera_distrital_local,
	nombre_municipio,
	849,
	tipo
FROM geografico_completo;

INSERT INTO geografico_completo
SELECT
	nombre_estado,
	abreviatura,
	cabecera_distrital_federal,
	cabecera_distrital_local,
	nombre_municipio,
	654,
	tipo
FROM geografico_completo;

INSERT INTO geografico_completo
SELECT
	nombre_estado,
	abreviatura,
	cabecera_distrital_federal,
	cabecera_distrital_local,
	nombre_municipio,
	666,
	tipo
FROM geografico_completo;

--Actualizar el nombre del estado de ’AGUASCALIENTES’ para que ahora
--se llame ’AGUASCALIENTES NUEVO’.
UPDATE geografico_completo
SET nombre_estado = 'AGUASCALIENTES NUEVO'
WHERE nombre_estado = 'AGUASCALIENTES';
