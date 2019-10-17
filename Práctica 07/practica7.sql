SET search_path TO geografico;


--Sección 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--Ejercicio 1
--Obtener el nombre y la abreviatura de cada uno de los estados que existan
--en la tabla de geografico_completo, no deben aparecer estados repetidos.
SELECT DISTINCT nombre_estado, abreviatura
FROM geografico_completo
ORDER BY 1;

--Ejercicio 2
--Obtener el nombre del estado y cabecera distrital federal, que exista en
--la tabla de geografico_completo , no deben aparecer cabeceras distritales
--repetidas.
SELECT DISTINCT nombre_estado, cabecera_distrital_federal
FROM geografico_completo
ORDER BY 1;

--Sección 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--Ejercicio 1
-- Insertar un estado llamado ’mi estado’.
INSERT INTO geografico_completo (nombre_estado) VALUES
('mi estado');

--Ejercicio 2
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

--Ejercicio 3
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

--Ejercicio 4
--Actualizar el nombre del estado de ’AGUASCALIENTES’ para que ahora
--se llame ’AGUASCALIENTES NUEVO’.
UPDATE geografico_completo
SET nombre_estado = 'AGUASCALIENTES NUEVO'
WHERE nombre_estado = 'AGUASCALIENTES';

--Ejercicio 5
--Actualizar una sección para el estado de ’TAMAULIPAS’ con cabecera
--distrital federal ’RIO BRAVO’.
UPDATE geografico_completo
SET seccion = 455
WHERE nombre_estado = 'TAMAULIPAS' AND cabecera_distrital_federal = 'RIO BRAVO';

--Ejercicio 6
-- Actualizar los registros de las primeras dos inserciones para que no tengan
-- ningún campo en null.
UPDATE geografico_completo
SET abreviatura = 'MIEDO',
cabecera_distrital_federal = 'MI CABEZERA LOCAL',
cabecera_distrital_local = 'MI CABEZERA LOCAL',
nombre_municipio = 'MI MUNICIPIO',
seccion = 234,
tipo = 'R'
WHERE nombre_estado = 'mi estado';

--Update distritos federales
UPDATE geografico_completo
SET 
nombre_estado = 'MORDOR',
abreviatura = 'MOR',
cabecera_distrital_local = 'LOTER',
nombre_municipio = 'MINICO',
seccion = 234,
tipo = 'R'
WHERE cabecera_distrital_federal = 'Mordor' OR 
cabecera_distrital_federal = 'Ciudad Gótica' OR 
cabecera_distrital_federal = 'Tepito' OR
cabecera_distrital_federal = 'Chiconcuac' OR
cabecera_distrital_federal = 'Twin Peaks';

--Update distritos locales
UPDATE geografico_completo
SET 
nombre_estado = 'MIXTLAN',
abreviatura = 'MIX',
cabecera_distrital_federal = 'MOTER',
nombre_municipio = 'LOTEARAN',
seccion = 275,
tipo = 'R'
WHERE cabecera_distrital_local = 'Grove Street' OR 
cabecera_distrital_local = 'Wall Street' OR 
cabecera_distrital_local = 'Negra Arroyo Lane' OR
cabecera_distrital_local = 'Evergreen Terrace' OR
cabecera_distrital_local = 'Fargo';

--Update municipios
UPDATE geografico_completo
SET 
nombre_estado = 'SOVIET',
abreviatura = 'SOV',
cabecera_distrital_federal = 'PETERSBURGO',
cabecera_distrital_local = 'FIODOR',
seccion = 555,
tipo = 'U'
WHERE cabecera_distrital_local = 'Cuetzalan' OR 
nombre_municipio = 'Tepoztlán' OR 
nombre_municipio = 'Batopilas' OR
nombre_municipio = 'Arteaga' OR
nombre_municipio = 'Viesca';
