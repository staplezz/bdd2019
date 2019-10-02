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

--5: Conocer los automóviles que están contenidos en cada una de las categorías (Luxury SUV, Lite, Luxury).
--Luxury SUV
SELECT *
FROM automovil
WHERE preciofactura::money::numeric::float8 > 50000000.00;

--Lite
SELECT *
FROM automovil
WHERE preciofactura::money::numeric::float8 <= 44900000.00;

--Luxury
SELECT *
FROM automovil
WHERE preciofactura::money::numeric::float8 > 45000000.00;

--6: Conocer cuales son los automóviles que pertenecen a mas de una categoría.
SELECT *
FROM automovil
WHERE preciofactura::money::numeric::float8 >= 44900000.00;

--7: Conocer la capacidad de pasajeros, el costo, categoría y modelo de cada uno de los automóviles.
SELECT submarca,preciofactura,
(CASE WHEN automovil.preciofactura::money::numeric::float8 <= 44900000.00 THEN 'Lite' 
 WHEN automovil.preciofactura::money::numeric::float8 > 50000000.00 THEN 'Luxury SUV'
 WHEN automovil.preciofactura::money::numeric::float8 > 45000000.00 THEN 'Luxury' ELSE 'n/a' END) AS categoria,
 (CASE WHEN automovil.preciofactura::money::numeric::float8 <= 44900000.00 THEN 4 
 WHEN automovil.preciofactura::money::numeric::float8 > 50000000.00 THEN 5
 WHEN automovil.preciofactura::money::numeric::float8 > 45000000.00 THEN 4 ELSE 4 END) AS capacidad
FROM automovil;

--8: Conocer la forma de pago mas recurrente.
SELECT formapago, count(*)
FROM formadepago
GROUP BY formapago
ORDER BY count(*) DESC
LIMIT 1;

--9: Conocer el viaje mas caro.
SELECT *
FROM viaje
ORDER BY costo DESC
LIMIT 1;

--10: Conocer el viaje mas corto.
SELECT *
FROM viaje
ORDER BY tiempo ASC
LIMIT 1;
