--Práctica 11: Funciones.
--Fundamentos de Bases de Datos.

--Ejercicio 1: Una función que reciba el RFC y nos regrese la edad de los clientes y choferes.
CREATE OR REPLACE FUNCTION edadPersona(char(13))
RETURNS double precision AS
'SELECT extract(year from age(fnac))
FROM (
SELECT fechaNac as fnac
FROM Persona
WHERE RFC = $1) AS FN'
LANGUAGE 'sql';

--Ejemplo
SELECT edadPersona('ATRF4752175UE') as edad;

--Ejercicio 2: Una función que reciba el ID del chofer y nos regrese el número de viajes que a
--realizado.
CREATE OR REPLACE FUNCTION viajesChofer(Integer)
RETURNS bigint AS
'SELECT COUNT(idViaje)
FROM Viaje
WHERE idConductor = $1'
LANGUAGE 'sql';

--Ejemplo
SELECT viajesChofer(1) as viajesChofer;

--Ejercicio 3: Una función que reciba el RFC y te regrese el número de días faltantes para el
--cumpleaños del chofer o del cliente.
CREATE OR REPLACE FUNCTION diasParaCumpleanos(char(13))
RETURNS integer AS
'SELECT (365.25 - MOD(extract(days from now() - fnac)::integer, 365.25))::integer
FROM (
SELECT fechaNac as fnac
FROM Persona
WHERE RFC = $1) AS FN'
LANGUAGE 'sql';

--Ejemplo
SELECT diasParaCumpleanos('ATRF4752175UE') as diasParaCumpleaños;

--Ejercicio 4: Una función que reciba el nombre del chofer y su fecha de nacimiento y te regrese
--su RFC
CREATE OR REPLACE FUNCTION regresaId(varchar(15), date)
RETURNS char(13) AS
'SELECT RFC
FROM Persona
WHERE nombre = $1 AND fechaNac = $2'
LANGUAGE 'sql';

--Ejemplo
SELECT regresaId('Meghann', '1947-02-01') as RFC;

--Ejercicio 5: Una función que reciba el id del cliente y nos regrese 4 columnas; cada una
--de ellas con el total de dinero gastado en viajes. Las columnas deben ser de la
--siguiente manera: Monedero, Efectivo, Tarjeta débito y Tarjeta de crédito.
CREATE OR REPLACE FUNCTION dineroGastado(integer)
RETURNS table (montoPuntos numeric,
			  montoEfectivo numeric,
			  montoDebito numeric,
			  montoCredito numeric) AS
'SELECT SUM(montoPuntos), SUM(montoEfectivo),
SUM(montoDebito), SUM(montoCredito)
FROM Pagos P
INNER JOIN Viaje V
ON P.idViaje = V.idViaje
GROUP BY idCliente
HAVING idCliente = $1'
LANGUAGE 'sql';

--Ejemplo
SELECT *
FROM dineroGastado(12);
