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
        '1998-01-13', 'Pablo González','kokofrank@fakemail.com',
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
  PERFORM registra_conductor('Ana', 'Roma', 'Sevilla', 
        '1998-05-04', 'Saratoga 1023','anaRoma@fakemail.com',
             '5541459967');
END $$;

--Procedimiento A. 3:
--Ingresa un nuevo método de pago bancario para un cliente.

--Procedimiento A. 4:
--Registra el viaje de un usuario con un conductor. 
--Además actualiza la tarjeta de puntos dependiendo de los
--km recorridos y el número de viajes totales.

--Procedimiento A. 5:
--Registra un conductor junto con el auto que va a manejar.
--Si se usa este procedimiento le asigna 15 días para manejarlo
--desde la fecha de inicio.

--Procedimiento A. 6:
--Paga un viaje usando la tarjeta de puntos de un cliente.
--En caso de no contar con suficiente crédito se avisa.

--Procedimiento A. 7:
--Paga un viaje usando una tarjeta bancaria.
