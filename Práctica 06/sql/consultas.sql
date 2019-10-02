--Práctica 06: Fundamentos de Bases de Datos.

-- 1: Conocer los datos de los automóviles que tengan más de 15 años en servicio.
SELECT DISTINCT a.placas, marca, preciofactura, submarca, año, (date_part('year',age(m.fechaInic))) AS añosDeServicio
FROM automovil AS a, manejar AS m
WHERE (date_part('year',age(m.fechaInic))) > 15;
