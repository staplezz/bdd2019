-- Proyecto Final: Consultas.
-- Fundamentos de Bases de Datos.

-- Consulta 1
-- Clientes con el número de viajes que han hecho ordenados
-- de forma descendente.
SELECT idCliente, COUNT(idViaje) Viajes
FROM Viaje
GROUP BY idCliente
ORDER BY Viajes DESC
LIMIT 1;

-- Consulta 2
-- Conductores con el número de viajes que han hecho ordenados
-- de forma ascendente.
SELECT idConductor, COUNT(idViaje) Viajes
FROM Viaje
GROUP BY idConductor
ORDER BY Viajes DESC
LIMIT 1;

-- Consulta 3
-- Carros y los kilómetros que han recorrido.
SELECT idCliente, kmRecorridos(idCliente)
FROM Cliente
GROUP BY idCliente;

-- Consulta 4
-- Clientes y el dinero que han gastado en viajes. Los
-- que más has gastado están en el tope.
SELECT idCliente, SUM(costo) DineroGastado
FROM Viaje
GROUP BY idCliente
ORDER BY DineroGastado DESC;

-- Consulta 5
-- Tarjetas junto con el saldo disponible.
SELECT idTarjeta, puntos
FROM TarjetaDePuntos
ORDER BY puntos DESC;

-- Consulta 6
-- Señala todas las rutas que se han tomado en
-- la aplicación y el precio por kilometro de cada
-- viaje.
SELECT Origen, Destino, Costo/Kilometros
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
SELECT *
FROM dbo.viajesMetPago('puntos');

-- Consulta 10
-- Conductor estelar, # de viajes y la fecha en la que inicio.
SELECT idConductor, numviajes, fechaInicio
FROM conductorEstelera() c
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

-- Consulta 13
-- Cliente con menos puntos y el # de viajes.
SELECT idCliente, saldoPuntos(idCliente) saldo, COUNT(idViaje)
FROM Cliente C
   INNER JOIN Viaje V ON C.idCliente = V.idCliente
ORDER BY saldo ASC
LIMIT 1;

-- Consulta 14
-- Todos los viajes pagados con débito.
SELECT *
FROM dbo.viajesMetPago('debito');

-- Consulta 15
-- Regresa el número de viajes realizado por el cliente
-- con más puntos
SELECT placas, SUM(costo)/kmRecorridos(placa)
FROM Viaje
GROUP BY placas;

-- Consulta 
-- Kilómetros recorridos de la empresa.

-- Consulta
-- Conductores con el cliente que más ha viajado.

-- Consulta
-- Cliente con menos puntos y el # de viajes.

-- Consulta
-- Conductores con los que más ha viajado.

-- Consulta
-- El método de pago más usado.

