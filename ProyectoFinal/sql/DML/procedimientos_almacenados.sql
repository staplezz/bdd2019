--Proyecto Final: Procedimientos almacenados.
--Fundamentos de Bases de Datos.

--Procedimiento A. 1:
--Recibe la información de un cliente la almacena en la
--tabla de persona y en la de cliente y le asigna una
--nueva tarjeta de puntos.
CREATE OR REPLACE
FUNCTION registra_cliente(nombre varchar(15), apaterno varchar(15), 
       amaterno varchar(15), fechanac date, dir varchar(200), 
       correo citext, tel varchar(16))
RETURNS void AS 
$$
DECLARE
	--El id de la persona a insertar.
	idPers int;
	--El id del cliente a insertar.
	idClien int;
	--El id de la tarjeta de puntos que tendrá.
	idTarj int;
BEGIN
	--Revisamos que los nombres sean factibles
	IF nombre NOT LIKE '%[^a-zA-Z]%' AND apaterno NOT LIKE '%[^a-zA-Z]%' AND amaterno NOT LIKE '%[^a-zA-Z]%' THEN
		INSERT INTO persona(nombre, apaterno, amaterno, fechanac, direccion)
		VALUES(nombre, apaterno, amaterno, fechanac, dir)
		--Guardamos el id que acabamos de insertar.
		RETURNING idPersona
		INTO idPers;
		--Insertamos el correo y el número telefónico.
		INSERT INTO personacorreo VALUES(correo, idPers);
    	INSERT INTO personatelefono VALUES(tel, idPers);
    	--Creamos el cliente en la tabla cliente y guardamos su idCliente.
    	INSERT INTO cliente VALUES(DEFAULT, idPers)
    	RETURNING idCliente
    	INTO idClien;
    	--Finalmente creamos su tarjeta de puntos.
    	INSERT INTO tarjeta VALUES(DEFAULT, idClien, 'puntos')
    	RETURNING idTarjeta
    	INTO idTarj;
    	--Y asignamos los puntos iniciales que serán cero.
    	INSERT INTO TarjetaDePuntos VALUES(DEFAULT, idTarj, DEFAULT);
	END IF;
END;
$$
LANGUAGE PLPGSQL;

--Ejemplo:
DO $$ BEGIN
  PERFORM registra_cliente('Eric', 'Francisco', 'Cortés', 
        '1998-01-13', 'Pablo González','kokofrankt@fakemail.com',
             '5545012653');
END $$;

--Procedimiento A. 2:
--Recibe la información de un conductor la almacena en la
--tabla de persona y en la de conductor.
CREATE OR REPLACE
FUNCTION registra_conductor(nombre varchar(15), apaterno varchar(15), 
       amaterno varchar(15), fechanac date, dir varchar(200), 
       correo citext, tel varchar(16))
RETURNS void AS 
$$
DECLARE
	--El id de la persona a insertar.
	idPers int;
BEGIN
	--Revisamos que los nombres sean factibles
	IF nombre NOT LIKE '%[^a-zA-Z]%' AND apaterno NOT LIKE '%[^a-zA-Z]%' AND amaterno NOT LIKE '%[^a-zA-Z]%' THEN
		INSERT INTO persona(nombre, apaterno, amaterno, fechanac, direccion)
		VALUES(nombre, apaterno, amaterno, fechanac, dir)
		--Guardamos el id que acabamos de insertar.
		RETURNING idPersona
		INTO idPers;
		--Insertamos el correo y el número telefónico.
		INSERT INTO personacorreo VALUES(correo, idPers);
    	INSERT INTO personatelefono VALUES(tel, idPers);
    	--Creamos el conductor en la tabla conductor.
    	INSERT INTO conductor VALUES(DEFAULT, idPers, current_date);
	END IF;
END;
$$
LANGUAGE PLPGSQL;

--Ejemplo:
DO $$ BEGIN
  PERFORM registra_conductor('Paola', 'Gallegos', 'Salgado', 
        '1998-05-04', 'Saratoga 1023','kokofrank@fakemail.com',
             '5541109967');
END $$;

--Procedimiento A. 3:
--Ingresa un nuevo método de pago bancario para un cliente.
--El tipo puede ser de crédito o de débito.
CREATE OR REPLACE
FUNCTION registra_tarjeta(idCliente integer, tipo varchar(20),
						Numero char(16), nombreBanco varchar(20),
  						Expiracion date)
RETURNS void AS 
$$
DECLARE
	--El id de la tarjeta a insertar.
	idTarj int;
BEGIN
	--Creamos la tarjeta.
	INSERT INTO Tarjeta VALUES(DEFAULT, idCliente, tipo)
	RETURNING idTarjeta INTO idTarj;
	--Insertamos la tarjeta bancaria.
	INSERT INTO TarjetaBancaria VALUES(DEFAULT, idTarj, Numero,
		nombreBanco, Expiracion);
END;
$$
LANGUAGE PLPGSQL;

DO $$ BEGIN
    PERFORM registra_tarjeta(1, 'credito', '4766273849308783', 'BBVA', '2020-07-15');
END $$;

--Procedimiento A. 4:
--Registra el viaje de un usuario con un conductor. 
--Además actualiza la tarjeta de puntos dependiendo de los
--km recorridos y el número de viajes totales.
CREATE OR REPLACE 
FUNCTION registra_viaje(orig varchar(200), dest varchar(200), tiempo interval, km integer, 
      costo numeric, idClient integer, idChof integer)
RETURNS void AS $$
DECLARE
  -- Las placas que maneja el chofer actualmente.
  placasAct varchar(6);
  -- Total de viajes para calcular el nuevo saldo
  numViajes integer;
  -- La tarjeta a actualizar los puntos.
  idTarj integer;
BEGIN
	--Buscamos las placas que maneja actualmente el conductor.
	SELECT placas INTO placasAct
  	FROM manejar WHERE fechainic IN 
  	(SELECT MAX(fechainic) 
   	FROM manejar 
   	WHERE idconductor = idChof) AND idconductor = idChof;
  	
  	--Insertamos en la tabla de viajes
  	INSERT INTO viaje(idcliente, idconductor, origen, destino, placas,
        tiempo, costo, kilometros, fechaPago)
  	VALUES(idClient, idChof, orig, dest, placasAct, 
         tiempo, costo, km, current_date);
  	
  	--Calculamos los puntos generados.
  	SELECT COUNT(*) INTO numViajes 
  	FROM viaje WHERE idClient = idcliente; 
  	--Buscamos el id de tarjeta de puntos
  	SELECT idTarjetaPuntos INTO idTarj
  	FROM Tarjeta t INNER JOIN TarjetaDePuntos tp
  	ON t.idTarjeta = tp.idTarjeta
  	WHERE idCliente = $6;
  	--Actualizamos la tarjeta de puntos
  	UPDATE TarjetaDePuntos
  	SET puntos = puntos + costo + (costo * (numViajes * 0.005))
  	WHERE idTarjetaPuntos = idTarj;
END;
$$ language PLPGSQL;

--Ejemplo:
DO $$ BEGIN
  PERFORM registra_viaje('Tepito', 'Portales', interval '01:00:00', 11, 70, 2, 1);
END $$;

--Procedimiento A. 5:
--Registra un conductor junto con el auto que va a manejar.
--Si la fecha de fin es NULL le asigna 15 días para manejarlo
--desde la fecha de inicio.
CREATE OR REPLACE
FUNCTION asigna_auto(idconductor integer, placas char(6), fechaInic date,
					fechaFin date)
RETURNS void AS
$$
BEGIN
	IF $4 IS NULL THEN
		INSERT INTO MANEJAR VALUES(DEFAULT, idconductor, placas,
			fechaInic, fechaInic + interval '15 days');
	ELSE
		INSERT INTO MANEJAR VALUES(DEFAULT, idconductor, placas,
			fechaInic, fechaFin);
	END IF;
END;
$$
language PLPGSQL;

DO $$ BEGIN
    PERFORM asigna_auto(1, '123456', current_date, NULL);
END $$;

--Procedimiento A. 6:
--Registra el pago de un viaje usando el método de pago
--que le pasan.
CREATE OR REPLACE 
FUNCTION registra_pago(idViaje integer, metodo varchar(20), monto numeric,
						numeroTarjeta char(16))
RETURNS void AS
$$
DECLARE
	numTarjeta char(16);
	idCl integer;
	idTarjetaPuntos integer;
BEGIN
	IF metodo = 'efectivo' THEN
		INSERT INTO Pago VALUES(DEFAULT, idViaje, NULL, monto);
	--Si el pago es crédito o débito intentaremos pagar 
	--con la tarjeta que encontremos si no recibimos un número de tarjeta.
	ELSEIF metodo = 'debito' OR metodo = 'credito' AND $4 IS NULL THEN
		--Buscamos el id del cliente.
		SELECT idCliente INTO idCl
		FROM viaje v
		WHERE v.idViaje = $1;
		--Buscamos la tarjeta del cliente.
		SELECT numero INTO numTarjeta
		FROM Tarjeta t INNER JOIN TarjetaBancaria tb
		ON t.idTarjeta = tb.idTarjeta
		WHERE idCliente = idCl AND t.tipo = $2
		LIMIT 1;
		--Si no encontramos ninguna tarjeta 
		IF NOT FOUND THEN
			RAISE EXCEPTION 'Tarjeta bancaria no encontrada.'
			USING HINT = 'Intenta agregar una tarjeta o pagar en efectivo.';
		ELSE
			INSERT INTO Pago VALUES(DEFAULT, idViaje,
				(SELECT idTarjeta FROM TarjetaBancaria WHERE numero = numTarjeta),
				monto);
		END IF;
	ELSEIF metodo = 'debito' OR metodo = 'credito' THEN
		INSERT INTO Pago VALUES(DEFAULT, idViaje,
				(SELECT idTarjeta FROM TarjetaBancaria WHERE numeroTarjeta = numero), monto);
	ELSEIF metodo = 'puntos' THEN
		--Buscamos el id del cliente.
		SELECT idCliente INTO idCl
		FROM viaje v
		WHERE v.idViaje = $1;
		--Buscamos la tarjeta del cliente.
		SELECT t.idTarjeta INTO idTarjetaPuntos
		FROM Tarjeta t INNER JOIN TarjetaDePuntos tp
		ON t.idTarjeta = tp.idTarjeta
		WHERE idCliente = idCl;
		INSERT INTO Pago VALUES(DEFAULT, idViaje, idTarjetaPuntos, monto);
	END IF;
END;
$$
language PLPGSQL;

--Ejemplo:
DO $$ BEGIN
  PERFORM registra_pago(1, 'credito', 30, '4766273849308783');
END $$; 
