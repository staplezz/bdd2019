-- Proyecto Final: Consultas.
-- Fundamentos de Bases de Datos.

-- Consulta 1
-- Clientes con el número de viajes que han hecho ordenados
-- de forma descendente.
SELECT idCliente, COUNT(idViaje) numViajes
FROM Viaje
GROUP BY idCliente
ORDER BY numViajes DESC;

-- Consulta 2
-- Conductores con el número de viajes que han hecho ordenados
-- de forma ascendente.
SELECT idConductor, COUNT(idViaje) numViajes
FROM Viaje
GROUP BY idConductor
ORDER BY numViajes DESC;

-- Consulta 3
-- Carros y los kilómetros que han recorrido.
SELECT placas, kmrecorridos(placas)
FROM Automovil;

-- Consulta 4
-- Clientes y el dinero que han gastado en viajes. Los
-- que más has gastado están en el tope.
SELECT idCliente, SUM(costo) DineroGastado
FROM Viaje
GROUP BY idCliente
ORDER BY DineroGastado DESC;

-- Consulta 5
-- Clientes junto con el saldo de su tarjeta disponible.
SELECT idCliente, puntos
FROM TarjetaDePuntos tp INNER JOIN Tarjeta t
ON tp.idTarjeta = t.idTarjeta
ORDER BY puntos DESC;

-- Consulta 6
-- Señala todas las rutas que se han tomado en
-- la aplicación y el precio por kilometro de cada
-- viaje.
SELECT Origen, Destino, ROUND(Costo/Kilometros, 2) as costoXKm
FROM Viaje;

-- Consulta 7
-- Regresa el viaje más caro hecho en la aplicación.
SELECT Origen, Destino, Costo
FROM Viaje
ORDER BY Costo DESC
LIMIT 1;

-- Consulta 8
-- Viaje más largo.
SELECT Origen, Destino, Kilometros
FROM Viaje
ORDER BY Kilometros DESC
LIMIT 1;

-- Consulta 9
-- Viaje pagados con tarjeta de puntos.
SELECT idViaje, idCliente, idConductor, origen, destino
FROM viajesMetPago('puntos') vm INNER JOIN
Viaje v
ON vm.viajespagados = v.idviaje;

-- Consulta 10
-- Conductor estelar (EL conductor que más ha hecho viajes)
-- No. de viajes y la fecha en la que empezó a trabajar.
SELECT c.idConductor, numviajes, fechaInicio
FROM conductorEstelar() c
INNER JOIN Conductor Cond ON c.idConductor = Cond.idConductor;

-- Consulta 11
-- Todas las placas utilizadas por el conductor estelar.
SELECT placas
FROM conductorEstelar() c
INNER JOIN Manejar Man ON c.idConductor = Man.idConductor;

-- Consulta 12
-- Cliente con el mayor número de puntos en su tarjeta.
SELECT idCliente, saldoPuntos(idCliente) saldo
FROM Cliente
ORDER BY saldo DESC
LIMIT 1;

--Consulta 13
--El número de viajes que se han hecho con cada automóvil.
SELECT placas, COUNT(idViaje) as NumViajes
FROM Viaje
GROUP BY Placas;

-- Consulta 14
-- Todos los viajes pagados con débito.
SELECT idViaje, idCliente, idConductor, origen, destino
FROM viajesMetPago('debito') vm INNER JOIN
Viaje v
ON vm.viajespagados = v.idviaje;

-- Consulta 15
-- El método de pago más usado.
(SELECT 'efectivo' tipoPago, COUNT(*) numPagos
FROM Pago
WHERE idTarjeta IS NULL)
UNION
(SELECT tipo tipoPago, COUNT(t.idTarjeta) numPagos
FROM Tarjeta t INNER JOIN Pago p
ON t.idTarjeta = p.idTarjeta
GROUP BY tipo)
ORDER BY numpagos DESC
LIMIT 1;

-- Consulta 16
-- Kilómetros recorridos de la empresa.
SELECT SUM(kilometros) kmTotales
FROM Viaje;
