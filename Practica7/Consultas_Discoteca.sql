-- Sirve para buscar primero en el esquema industria_musical.
SET search_path TO industria_musical;
-- Ejercicio 1
-- Seleccionar el nombre de los intérpretes 1 que no sean de México.

-- Ejercicio 2
-- Obtener el título de las canciones con más de 5 minutos de duración.
SELECT titulo, duracion
FROM industria_musical.cancion
WHERE duracion >= '05:00';

-- Ejercicio 3
-- Obtener la lista de las distintas funciones que pueden realizar los artistas.

-- Ejercicio 4
-- Seleccionar el nombre y el lugar de origen de los clubes con más de 500 fans.

-- Ejercicio 5
-- Obtener el nombre y el lugar de origen de cada club de fans de intérpretes de
-- México así como el nombre del intérprete al que admiran.

-- Ejercicio 6
-- Obtener el nombre de los discos que contienen alguna canción que dure más de
-- 5 minutos y decir cuantas canciones del disco cumplen esto.

-- Ejercicio 7
-- Obtener los nombres de las canciones que dan nombre al disco en el que apare-
-- cen.

-- Ejercicio 8
-- Obtener los nombres de las disqueras y direcciones de aquellas compañías dis-
--queras que han grabado algún disco que empiece con ’T’.

-- Ejercicio 9
-- Obtener el nombre de los discos de los intérpretes registrados en el año 1996.

-- Ejercicio 10
-- El dúo dinámico por fin se jubila; para sustituirlos se pretende hacer una selec-
-- ción sobre todos los pares de artistas españoles distintos tales que el primero sea
-- voz y el segundo guitarra. Obtener dicha selección.

-- Ejercicio 11
-- Obtener el título de las canciones de todos los discos del grupo U2

-- Ejercicio 12
-- Obtener el nombre del club con mayor número de fans indicando ese número.

-- Ejercicio 13
-- Obtener el género de los discos con mayor número de fans.

-- Ejercicio 14
-- Obtener el número de discos de cada intérprete.

-- Ejercicio 15
-- Obtener el número de canciones que ha grabado cada compañía discográfica y
-- su dirección.

-- Ejercicio 16
-- Obtener los nombre de los artistas de grupos con clubes de fans de más de 500
-- personas y que el grupo sea de Inglaterra.

-- Ejercicio 17
-- Obtener el nombre de los artistas que pertenezcan a un grupo de México.

-- Ejercicio 18
-- Obtener el décimo (Debe haber sólo 9 por encima de el) club con mayor número
-- de fans indicando este número).

-- Ejercicio 19
-- Obtener el nombre de los artistas que tengan la función de bajo en un único grupo
-- y que además este tenga más de dos miembros.

-- Ejercicio 20
-- Indica el nombre del compositor que más canciones ha creado y el título de estas.

-- Ejercicio 21
-- Obtener el año en el que hubo mayor lanzamientos de discos.

-- Ejercicio 22
-- Obtener para cada grupo con más de dos integrantes, el nombre y el número de
-- componentes del grupo.

-- Ejercicio 23
-- Obtener para cada artista el nombre de sus álbumes y las canciones de cada
-- álbum.

-- Ejercicio 24
-- Obtener para cada compositor la canción que aparece más veces en distintos
-- álbumes.

-- Ejercicio 25
-- Obtener los Clubs que sean fanáticos de grupos que tengan al menos un integran-
-- te que tenga la función de bajo.

-- Ejercicio 26
-- Se desea saber cuales son las funciones que desempeñan los artistas y cuantos
-- hay por cada funciones dentro de la base de datos
SELECT funcion, COUNT(funcion)
FROM pertenec   e
GROUP BY funcion;

-- Ejercicio 27
-- Para cada intérprete se desea saber cuántos años han pasado desde que se conso-
-- lidaron estos.

-- Ejercicio 28
-- Para cada disco obtener el total de canciones que tiene este y además, agregar la
-- duración de la canción más larga de cada disco.
