-- Ejercicio 1
-- Conocer los datos de los clientes que tengan más de 21 años.
SELECT * FROM Persona, date_part('year',age(fechaNac)) as edad
WHERE edad > 21;

-- Ejercicio 2
-- Conocer el puesto, nombre, edad y la fecha en la que inicio a trabajar de todos los choferes.
-- (Falta la fecha de inicio)                                        
SELECT Persona.Nombre, date_part('year',age(fechaNac)) as edad FROM Persona
JOIN Conductor ON Conductor.idPersona = Persona.idPersona;                                          

-- Ejercicio 3
-- Conocer el nombre y edad de todos los choferes que hayan hecho mas de siete viajes.

-- Ejercicio 4
-- Conocer los automóviles que se tienen asignado un chofer disponibles.

-- Ejercicio 5)
-- Conocer cuales son TODOS los automóviles que ha manejado cada chofer.
SELECT DISTINCT placas
FROM conductor INNER JOIN manejar
ON conductor.idconductor = manejar.idconductor;

-- Ejercicio 6)
-- Conocer la duración de cada uno de los viajes realizados por la empresa.
SELECT tiempo, idviaje
FROM viaje;

-- Ejercicio 7)
-- Conocer a los clientes que tengan mas saldo en sus tarjetas de puntos.

-- Ejercicio 8)
-- Conocer cual es la forma de pago mas recurrente.
SELECT formapago, count(*)
FROM formadepago
GROUP BY formapago
ORDER BY count(*) DESC
LIMIT 1;

-- Ejercicio 9)
-- Conocer al cliente que ha hecho mas viajes en la empresa.
SELECT cliente.idcliente, count(*)
FROM cliente INNER JOIN viaje
ON cliente.idcliente = viaje.idcliente
GROUP BY cliente.idcliente
ORDER BY count(*) DESC
LIMIT 1;