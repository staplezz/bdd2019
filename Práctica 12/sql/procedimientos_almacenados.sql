--Ejercicio 1. Registrar a un chofer en las tablas correspondientes.
CREATE OR REPLACE 
FUNCTION registra_chofer(nombre varchar(15), apaterno varchar(15), amaterno varchar(15), rfc char(13), fNac date, dir varchar(200), correo citext, tel varchar(16))
RETURNS void AS $$
DECLARE
  idPers int;
BEGIN
  IF nombre NOT LIKE '%[^a-zA-Z]%' AND apaterno NOT LIKE '%[^a-zA-Z]%' AND amaterno NOT LIKE '%[^a-zA-Z]%' THEN
    INSERT INTO persona(rfc, nombre, apaterno, amaterno, fechanac, direccion)
    VALUES(rfc, nombre, apaterno, amaterno, fNac, dir);
    --Seleccionamos el id que acabamos de insertar.
    SELECT Persona.idPersona INTO STRICT idPers
        FROM Persona WHERE Persona.rfc = registra_chofer.rfc;
    INSERT INTO personacorreo VALUES(correo, idPers);
    INSERT INTO personatelefono VALUES(tel, idPers);
    INSERT INTO conductor VALUES(DEFAULT, idPers, current_date);
  END IF;
END;
$$ LANGUAGE PLPGSQL;

--Ejemplo:
SELECT * FROM registra_chofer('Ana Luisa'::varchar(15), 'Camacho'::varchar(15), 'Avila'::varchar(15), 'RF45YSHRJ45U6'::char(13)
									 ,'1950-05-26'::date, 'SJSJJSJSJSJnns09'::varchar(200), 'kkodkod@jjma.com'::citext, '5576238467'::varchar(16));
