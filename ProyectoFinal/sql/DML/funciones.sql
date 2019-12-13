--Proyecto Final: Funciones.
--Fundamentos de Bases de Datos.

--Función 1:
-- Función que recibe el id del Cliente y regrese
-- la cantidad de puntos que tiene en su tarjeta virtual.
CREATE OR REPLACE FUNCTION saldoPuntos(Integer)
RETURNS Integer AS
$$
SELECT puntos
FROM tarjeta t INNER JOIN tarjetadepuntos tp
ON t.idTarjeta = tp.idTarjeta
WHERE idcliente = $1
$$
LANGUAGE 'sql';

--Función 2:
--Función que recibe el método de pago y regresa todos los
--viajes que han sido pagado total o parcialmente con ese
--método.
CREATE OR REPLACE FUNCTION viajesMetPago(varchar(20))
RETURNS table (viajesPagados Integer) AS
$$
SELECT idViaje
FROM pago p INNER JOIN tarjeta t
ON p.idTarjeta = t.idTarjeta
WHERE tipo = $1
$$
LANGUAGE 'sql';

--Función 3:
--Función que recibe el id del conductor y el id del cliente
--y regresa todos los viajes que han tenido.
CREATE OR REPLACE FUNCTION viajesMutuos(Integer, Integer)
RETURNS table (viajesMutuos Integer) AS
$$
SELECT idViaje
FROM Viaje
WHERE idcliente = $1 AND idConductor = $2
$$
LANGUAGE 'sql';

--Función 4:
--Función que recibe las placas del automóvil y regresa cuantos
--kilometros ha recorrido en total.
CREATE OR REPLACE FUNCTION kmRecorridos(char(6))
RETURNS numeric AS
$$
SELECT SUM(kilometros)
FROM Viaje
WHERE placas = $1
$$
LANGUAGE 'sql';

--Función 5:
--Función que devuelve el conductor que haya realizado más viajes
--en la empresa.
CREATE OR REPLACE FUNCTION conductorEstelar()
RETURNS table (idConductor Integer,
				numviajes bigint) AS
$$
SELECT idConductor, COUNT(idConductor) numviajes
FROM Viaje
GROUP BY idConductor
ORDER BY numviajes DESC
LIMIT 1;
$$
LANGUAGE 'sql';
