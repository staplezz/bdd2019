--Ejercicio 1. Registrar a un chofer en las tablas correspondientes.
CREATE OR REPLACE 
FUNCTION registra_chofer(nombre varchar(15), apaterno varchar(15), 
			 amaterno varchar(15), rfc char(13), fNac date, 
			 dir varchar(200), correo citext, tel varchar(16))
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
DO $$ BEGIN
	PERFORM registra_chofer('Ana Luisa', 'Camacho', 'Avila','RF45YSHRJ45U6', 
				'1996-01-23', 'Mar de las lluvias 19','ALCamacho@fakemail.com',
			       '5564652467');
END $$;
								      
--Ejercicio 2
--Elimina un chofer y elimina los valores de las tablas hijas a excepción de la tabla Viajes.
--TODO.

--Ejercicio 3
--Registra el viaje de un usuario con un conductor. Además actualiza la tarjeta de puntos dependiendo de los
--km recorridos y el número de viajes totales.
CREATE OR REPLACE 
FUNCTION registra_viaje(orig varchar(200), dest varchar(200), tiempo interval, km integer, 
			costo numeric, mPago varchar(16), idClient integer, idChof integer)
RETURNS void AS $$
DECLARE
	-- Las placas que maneja el chofer actualmente.
	placasAct varchar(6);
	-- El id del viaje recién insertado
	idV integer;
	-- Total de viajes para calcular el nuevo saldo
	numViajes integer;
BEGIN
	SELECT placas INTO placasAct
	FROM manejar WHERE fechainic IN 
	(SELECT MAX(fechainic) 
	 FROM manejar 
	 WHERE idconductor = idChof) AND idconductor = idChof;
	
	INSERT INTO viaje(idcliente, idconductor, origen, destino, placas,
			  tiempo, costo, fechaPago, kilometros)
	VALUES(idCLient, idChof, orig, dest, placasAct, 
	       tiempo, costo, current_date, km) RETURNING idviaje INTO idV;
	
	IF mPago = 'efectivo' THEN
		INSERT INTO pagos(idviaje, montoefectivo) VALUES (idV, costo);
	ELSIF mPago = 'puntos' THEN
		INSERT INTO pagos(idviaje, montopuntos) VALUES (idV, costo);
	ELSIF mPago = 'debito' THEN
		INSERT INTO pagos(idviaje, montodebito) VALUES (idV, costo);
	ELSIF mPago = 'credito' THEN
		INSERT INTO pagos(idviaje, montocredito) VALUES (idV, costo);
	END IF;
	
	SELECT COUNT(*) INTO numViajes FROM viaje WHERE idClient = idcliente; 
	UPDATE tarjeta
	SET puntos = puntos + costo + (costo * (numViajes * 0.005))
	WHERE idcliente = idClient;
END;
$$ language PLPGSQL;

--Ejemplo:
DO $$ BEGIN
	PERFORM registra_viaje('Tepito', 'Portales', interval '01:00:00', 11, 70, 'debito', 1, 1);
END $$;
