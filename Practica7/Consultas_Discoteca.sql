-- Sirve para buscar primero en el esquema industria_musical.
SET search_path TO industria_musical;

--Ejercicio 1: Seleccionar el nombre de los intérpretes que no sean de México.
SELECT nombreint
FROM interprete
WHERE pais NOT LIKE 'México';

--Ejercicio 2: Obtener el título de las canciones con más de 5 minutos de duración.
SELECT titulo
FROM cancion
WHERE duracion >= '05:00';

--Ejercicio 3: Obtener la lista de las distintas funciones que pueden realizar los artistas.
SELECT funcion
FROM pertenece
GROUP BY funcion;

--Ejercicio 4: Seleccionar el nombre y el lugar de origen de los clubes con más de 500 fans.
SELECT nombre, lugarorigen
FROM club
WHERE numfans > 500;

--Ejercicio 5: Obtener el nombre y el lugar de origen de cada club de fans de intérpretes de 
--México así como el nombre del intérprete al que admiran.
SELECT nombre, lugarorigen, nombreint
FROM club
WHERE lugarorigen = 'México';

--Ejercicio 6: Obtener el nombre de los discos que contienen alguna canción que dure más de
--5 minutos y decir cuantas canciones del disco cumplen esto.
SELECT album, COUNT(c) as numCanciones
FROM cancion as c, esta as e
WHERE c.cod = e.codcan AND duracion >= '05:00'
GROUP BY album;

--Ejercicio 7: Obtener los nombres de las canciones que dan nombre al disco en el que aparecen.
SELECT titulo
FROM cancion as c, esta as e
WHERE titulo = album;

--Ejercicio 8: Obtener los nombres de las disqueras y direcciones de aquellas compañías disqueras 
--que han grabado algún disco que empiece con ’T’.
SELECT d.disquera, direccion
FROM disco as d, disquera as disq
WHERE d.origen_disquera = disq.origen_disquera AND album LIKE 'T%';

--Ejercicio 9: Obtener el nombre de los discos de los intérpretes registrados en el año 1996.
SELECT album
FROM interprete as i, disco as d
WHERE EXTRACT(YEAR FROM fechacreacion) = 1996 and i.nombreint = d.nombreint;

-- Ejercicio 10: El dúo dinámico por fin se jubila; para sustituirlos se pretende hacer una selección
--sobre todos los pares de artistas españoles distintos tales que el primero sea
--voz y el segundo guitarra. Obtener dicha selección.
SELECT '[' || A.vozesp || ', ' || B.guitesp || ']' as duo
FROM
(SELECT nombre as vozesp
FROM interprete as i
INNER JOIN pertenece as p ON i.nombreint = p.nombreint
INNER JOIN artista as a ON p.curp = a.curp
WHERE funcion = 'Voz' AND pais = 'España') as A,
(SELECT nombre as guitesp
FROM interprete as i
INNER JOIN pertenece as p ON i.nombreint = p.nombreint
INNER JOIN artista as a ON p.curp = a.curp
WHERE funcion = 'Guitarra' AND pais = 'España') as B;

-- Ejercicio 11
-- Obtener el título de las canciones de todos los discos del grupo U2
SELECT titulo
FROM cancion INNER JOIN esta ON cancion.cod = esta.codCan
INNER JOIN disco ON esta.album = disco.album
WHERE nombreInt = 'U2';

-- Ejercicio 12
-- Obtener el nombre del club con mayor número de fans indicando ese número.
SELECT nombre
FROM club
ORDER BY numFans
LIMIT 1;

-- Ejercicio 13
-- Obtener el género de los discos con mayor número de fans.
SELECT genero, SUM(numfans) as numfans
FROM disco as d
INNER JOIN club as c ON d.nombreint = c.nombreint
GROUP BY genero
ORDER BY numfans DESC
LIMIT 1;

-- Ejercicio 14
-- Obtener el número de discos de cada intérprete.
SELECT COUNT(*)
FROM disco
GROUP BY nombreInt;

-- Ejercicio 15
-- Obtener el número de canciones que ha grabado cada compañía discográfica y
-- su dirección.
SELECT A.numCanciones, A.disquera, direccion
FROM
(SELECT COUNT(codcan) as numCanciones, disquera
FROM disco
INNER JOIN esta ON disco.album = esta.album
GROUP BY disquera) as A
INNER JOIN disquera ON A.disquera = disquera.disquera;

-- Ejercicio 16
-- Obtener los nombre de los artistas de grupos con clubes de fans de más de 500
-- personas y que el grupo sea de Inglaterra.
SELECT artista.nombre
FROM club INNER JOIN interprete ON club.nombreInt = interprete.nombreInt
INNER JOIN pertenece ON interprete.nombreInt = pertenece.nombreInt
INNER JOIN artista ON pertenece.curp = artista.curp
WHERE numfans > 500 AND pais = 'Inglaterra';

-- Ejercicio 17
-- Obtener el nombre de los artistas que pertenezcan a un grupo de México.
SELECT nombre
FROM interprete INNER JOIN pertenece ON interprete.nombreInt = pertenece.nombreInt
INNER JOIN artista ON pertenece.curp = artista.curp
WHERE pais = 'México';

-- Ejercicio 18
-- Obtener el décimo (Debe haber sólo 9 por encima de el) club con mayor número
-- de fans indicando este número).
SELECT nombre, numFans
FROM club
ORDER BY numFans
OFFSET 9 LIMIT 1;

-- Ejercicio 19
-- Obtener el nombre de los artistas que tengan la función de bajo en un único grupo
-- y que además este tenga más de dos miembros.
SELECT nombre 
FROM interprete INNER JOIN pertenece ON interprete.nombreInt = pertenece.nombreInt
INNER JOIN artista ON pertenece.curp = artista.curp
WHERE funcion = 'Bajo' AND 
(SELECT COUNT(*)
FROM interprete inter INNER JOIN pertenece per ON inter.nombreInt = per.nombreInt
WHERE interprete.nombreInt = inter.nombreInt) > 2;

-- Ejercicio 20
-- Indica el nombre del compositor que más canciones ha creado y el título de estas.
SELECT A.nombreC as compositor,  '[' || string_agg(titulo, ',') || ']' as canciones
FROM
(SELECT COUNT(*) as numCanciones, nombreC, compositor.curpc as curp
FROM compositor
INNER JOIN cancion ON compositor.curpc = cancion.curpc
GROUP BY nombreC, curp
ORDER BY numCanciones DESC
LIMIT 1) as A
INNER JOIN cancion ON A.curp = cancion.curpc
GROUP BY A.nombreC;

-- Ejercicio 21
-- Obtener el año en el que hubo mayor lanzamientos de discos.
SELECT A.año
FROM
(SELECT COUNT(*) as qty, EXTRACT(YEAR FROM fechaL) as año
FROM disco
GROUP BY año
ORDER BY qty DESC
LIMIT 1) as A;

-- Ejercicio 22
-- Obtener para cada grupo con más de dos integrantes, el nombre y el número de
-- componentes del grupo.
SELECT interprete.nombreint as banda, COUNT(*) as numIntegrantes
FROM pertenece
INNER JOIN interprete ON interprete.nombreint = pertenece.nombreint
GROUP BY banda
HAVING COUNT(*) > 2
ORDER BY numintegrantes;

-- Ejercicio 23
-- Obtener para cada artista el nombre de sus álbumes y las canciones de cada
-- álbum.
SELECT art.nombre, d.album, can.titulo
FROM cancion can INNER JOIN esta ON can.cod = esta.codCan
INNER JOIN disco d ON esta.numRef = d.numRef
INNER JOIN pertenece per ON d.nombreInt = per.nombreInt
INNER JOIN artista art ON per.curp = art.curp;

-- Ejercicio 24
-- Obtener para cada compositor la canción que aparece más veces en distintos
-- álbumes.
SELECT nombreC, titulo
FROM compositor as c
INNER JOIN cancion as can ON c.curpc = can.curpc
INNER JOIN esta as e ON can.cod = e.codcan
GROUP BY nombreC, titulo
HAVING COUNT(titulo) > 1;

-- Ejercicio 25
-- Obtener los Clubs que sean fanáticos de grupos que tengan al menos un integran-
-- te que tenga la función de bajo.
SELECT nombre
FROM club INNER JOIN interprete ON club.nombreInt = interprete.nombreInt
WHERE (SELECT COUNT(*)
	  	FROM interprete inter INNER JOIN pertenece ON inter.nombreInt = pertenece.nombreInt
	  	WHERE pertenece.funcion = 'Bajo') > 0;

-- Ejercicio 26
-- Se desea saber cuales son las funciones que desempeñan los artistas y cuantos
-- hay por cada funciones dentro de la base de datos
SELECT funcion, COUNT(funcion)
FROM pertenece
GROUP BY funcion;

-- Ejercicio 27
-- Para cada intérprete se desea saber cuántos años han pasado desde que se conso-
-- lidaron estos.
SELECT nombreInt, 2019 - date_part('year', fechaCreacion) as edad
FROM interprete;

-- Ejercicio 28
-- Para cada disco obtener el total de canciones que tiene este y además, agregar la
-- duración de la canción más larga de cada disco.
SET search_path TO industria_musical;
SELECT d.album, COUNT(*), MAX(can.duracion)
FROM disco d INNER JOIN esta ON d.numRef = esta.numRef
INNER JOIN cancion can ON esta.codCan = can.cod
GROUP BY d.album;
