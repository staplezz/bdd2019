--Conocer los datos de los clientes que tengan más de 21 años.
SELECT * FROM Persona, date_part('year',age(fechaNac)) as edad
WHERE edad > 21;
