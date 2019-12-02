--Práctica 13: Fundamentos de Bases de Datos.

/*
Ejercicio 1:
Un disparador el cual se encargue de validar que los viajes realizados por un
chofer siempre deben ser con el mismo automóvil durante el mismo día, estos
quiere decir que un chofer no puede realizar viajes con diferentes automóviles
en un mismo día.
*/
CREATE OR REPLACE FUNCTION validaViaje()
  RETURNS trigger AS
$$
DECLARE
  placasHoy char(6);
BEGIN
	IF TG_OP = 'UPDATE' THEN
		IF OLD.Placas NOT LIKE NEW.Placas AND OLD.fechaPago = NEW.fechaPago THEN
			RAISE EXCEPTION 'Un conductor no puede manejar dos coches diferentes en un mismo día.'
			USING HINT = 'Intenta actualizar con las mismas placas';
		ELSE
			RETURN NEW;
		END IF;
	END IF;
	--Guardamos las placas que ha manejado hoy el conductor.
	SELECT placas INTO placasHoy
	FROM Viaje
	WHERE idConductor = NEW.idConductor AND fechaPago = NEW.fechaPago
	LIMIT 1;
	IF NOT FOUND THEN
		RETURN NEW;
	END IF;
	IF TG_OP = 'INSERT' THEN
		IF NEW.Placas NOT LIKE placasHoy THEN
			RAISE EXCEPTION 'Un conductor no puede manejar dos coches diferentes en un mismo día.'
			USING HINT = 'Intenta insertar con las mismas placas';
		ELSE
			RETURN NEW;
		END IF;
	END IF;
END;
$$ language PLPGSQL;

CREATE TRIGGER validaViajes 
BEFORE INSERT OR UPDATE
ON Viaje
FOR EACH ROW
EXECUTE PROCEDURE validaViaje();

/*
Ejercicio 2:
Un disparador el cual se encargue de guardar la fecha en que se realiza el pago
de un viaje, esto quiere decir que no importa el valor que se manda en el insert
de la fecha, siempre pondrá la fecha el disparador.
*/
CREATE OR REPLACE FUNCTION fechaViaje()
RETURNS TRIGGER AS
$$
BEGIN
	NEW.fechaPago := current_date;
	RETURN NEW;
END;
$$ language PLPGSQL;

CREATE TRIGGER fechaViajes
BEFORE INSERT
ON Viaje
FOR EACH ROW
EXECUTE PROCEDURE fechaViaje();

/*
Ejercicio 3:
Un disparador el cual se encargue de validar que un chofer no puede realizar mas
de 35 viajes al día.
*/
CREATE OR REPLACE FUNCTION maximoViaje()
RETURNS TRIGGER AS
$$
DECLARE
  numViajes int;
BEGIN
	SELECT COUNT(*) INTO numViajes
	FROM Viaje
	WHERE idConductor = NEW.idConductor;
	IF (numViajes + 1) <= 35 THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Un conductor no puede hacer más de 35 viajes al día.';
	END IF;
END;
$$ language PLPGSQL;

CREATE TRIGGER maximoViajes
BEFORE INSERT
ON Viaje
FOR EACH ROW
EXECUTE PROCEDURE maximoViaje();

/*
Ejercicio 4:
Un disparador el cual se encarge de validar que al realizar un pago con la tarjeta
de puntos, revise que haya saldo disponible y si no, rechazar el pago.
*/
CREATE OR REPLACE FUNCTION pagoPuntos()
RETURNS TRIGGER AS
$$
DECLARE
	idCli int;
	saldoPuntos int;
	saldoFinal int;
BEGIN
	--Si no se quiere hacer un pago con la tarjeta de puntos.
	IF NEW.montoPuntos IS NULL OR NEW.montoPuntos = 0 THEN
		RETURN NEW;
	END IF;

	--Obtenemos el id del cliente que paga.
	SELECT idCliente INTO idCli
	FROM Viaje
	WHERE idViaje = NEW.idViaje;

	--Obtenemos el saldo de la tarjeta de puntos.
	SELECT puntos INTO saldoPuntos
	FROM Tarjeta
	WHERE Tarjeta.idCliente = idCli;

	--Si el saldo no alcanza para pagar la parte de un viaje
	--rechazamos el pago.
	saldoFinal := saldoPuntos - NEW.montoPuntos;
	IF saldoFinal >= 0 THEN
		--Actualizamos tarjeta
		UPDATE Tarjeta
		SET puntos = saldoFinal
		WHERE Tarjeta.idCliente = idCli;
		--Regresamos el valor.
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'El saldo de la tarjeta de puntos no es suficiente.'
		USING HINT = 'Intenta pagar con otro método de pago.';
	END IF;
END;
$$ language PLPGSQL;

CREATE TRIGGER pagoPuntosTRG
BEFORE INSERT
ON Pagos
FOR EACH ROW
EXECUTE PROCEDURE pagoPuntos();

/*
Ejercicio 5:
Un disparador el cual se encargue de que ningún coche en la tabla manejar tenga
más de una fecha de término indeterminada.
*/
CREATE OR REPLACE FUNCTION revisaAuto()
RETURNS TRIGGER AS
$$
DECLARE
	registrosfechaInic int;
	registrosfechaFin int;
BEGIN
	-- Si tiene fecha de fin de manejo.
	IF NEW.fechaFin IS NOT NULL THEN
		RETURN NEW;
	END IF;

	--Obtenemos los registros de inicio de manejo del auto.
	SELECT COUNT(fechaInic) INTO registrosfechaInic
	FROM Manejar
	WHERE Placas = NEW.Placas;

	--Obtenemos los registros de fin de manejo del auto.
	SELECT COUNT(fechaFin) INTO registrosfechaFin
	FROM Manejar
	WHERE Placas = NEW.Placas;
	
	IF registrosfechaInic = registrosfechaFin THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Un auto no puede ser manejado por dos personas al mismo tiempo.'
		USING HINT = 'Intenta actualizar la fecha de manejo del auto.';
	END IF;
END;
$$ language PLPGSQL;

CREATE TRIGGER revisaAutoTGR
BEFORE INSERT OR UPDATE
ON Manejar
FOR EACH ROW
EXECUTE PROCEDURE revisaAuto();
