--Práctica 06: Fundamentos de Bases de Datos.

-- 1: Conocer los datos de los automóviles que tengan más de 15 años en servicio.
SELECT DISTINCT a.placas, marca, preciofactura, submarca, año, (date_part('year',age(m.fechaInic))) AS añosDeServicio
FROM automovil AS a, manejar AS m
WHERE (date_part('year',age(m.fechaInic))) > 15;

--2: Conocer el nombre, edad y la fecha en la que inicio a trabajar de todos los choferes.
SELECT p.nombre, p.apaterno, p.amaterno, date_part('year',age(p.fechaNac)) AS edad, MIN(m.fechaInic) as fechaInicio
FROM conductor AS c, persona AS p, manejar AS m
WHERE c.idPersona = p.idPersona and c.idConductor = m.idConductor
GROUP BY p.nombre, p.apaterno, p.amaterno, edad;                            

--3: Conocer el nombre y edad de todos los choferes que han conducido en mas de un automóvil.
SELECT nombre, date_part('year',age(p.fechaNac)) AS edad, COUNT(m) AS manejado
FROM conductor AS c, persona AS p, manejar AS m
WHERE c.idPersona = p.idPersona and c.idConductor = m.idConductor
GROUP BY p.nombre, edad
HAVING COUNT(m) > 1;
                                    
--4: Conocer el nombre del chofer y el nombre de los clientes que han tomado un viaje con el chofer.
SELECT DISTINCT cdt.conductor, clt.cliente, cdt.idViaje
FROM (
	SELECT p.nombre AS conductor, idViaje
	FROM viaje AS v, conductor AS c, persona AS p
	WHERE v.idConductor = c.idConductor and c.idPersona = p.idPersona
) cdt
INNER JOIN
(
	SELECT p.nombre AS cliente, idViaje
	FROM viaje AS v, cliente AS c, persona AS p
	WHERE v.idCliente = c.idCliente and c.idPersona = p.idPersona
) clt
ON cdt.idViaje = clt.idViaje
ORDER BY conductor;                                
