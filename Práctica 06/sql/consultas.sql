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
