--Conocer los datos de los clientes que tengan más de 21 años.
SELECT * FROM Persona, date_part('year',age(fechaNac)) as edad
WHERE edad > 21;

--Conocer el puesto, nombre, edad y la fecha en la que inicio a trabajar de todos los choferes.
--(Falta la fecha de inicio)                                        
SELECT Persona.Nombre, date_part('year',age(fechaNac)) as edad FROM Persona
JOIN Conductor ON Conductor.idPersona = Persona.idPersona;                                          
