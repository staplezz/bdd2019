--Proyecto Final: Disparadores.
--Fundamentos de Bases de Datos.

--Disparador 1:
--Disparador que revisa que un cliente tenga una sola tarjeta de puntos.
CREATE OR REPLACE FUNCTION validaTarjetaPuntos()
RETURNS trigger AS
$$
DECLARE
	numTarjetas bigint;
BEGIN
	IF NEW.tipo = 'puntos' THEN
		--Revisamos cuantas tarjetas virtuales tiene el cliente.
		SELECT COUNT(*) INTO numTarjetas
		FROM Tarjeta
		WHERE idCliente = NEW.idCliente AND tipo = 'puntos';
		IF numTarjetas = 0 THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Un cliente no puede tener más de una tarjeta virtual.'
			USING HINT = 'Intenta verificar que el id del cliente sea correcto.';
		END IF;
	ELSE
		RETURN NEW;
	END IF;
END;	
$$
language PLPGSQL;

CREATE TRIGGER validaTP 
BEFORE INSERT OR UPDATE
ON Tarjeta
FOR EACH ROW
EXECUTE PROCEDURE validaTarjetaPuntos();

--Disparador 2:
--Un disparador el cual se encargue de que ningún coche en la tabla manejar tenga
--más de una fecha de término indeterminada.
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
BEFORE INSERT
ON Manejar
FOR EACH ROW
EXECUTE PROCEDURE revisaAuto();

--Disparador 3:
--Un disparador el cual se encargue de validar que los viajes realizados por un
--chofer siempre deben ser con el mismo automóvil durante el mismo día, estos
--quiere decir que un chofer no puede realizar viajes con diferentes automóviles
--en un mismo día.
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

--Disparador 4 y 5:
--Disparador que se encarga de validar los pagos y avisar cuanto falta por pagar
--de ese viaje.
CREATE OR REPLACE FUNCTION validaPagos()
RETURNS TRIGGER AS
$$
DECLARE
	sumaPagos bigint;
	costoViaje int;
	faltante int;
	--El tipo de la tarjeta.
	tipoT varchar;
	saldoPuntos int;
	saldoFinal int;
BEGIN
	--Pagos que se han hecho hasta el momento.
	SELECT SUM(monto) INTO sumaPagos
	FROM Pago
	WHERE idViaje = NEW.idViaje;

	--Costo total del viaje.
	SELECT costo INTO costoViaje
	FROM Viaje
	WHERE idViaje = NEW.idViaje;

	faltante := costoViaje - sumaPagos;

	--No insertamos ya que el viaje ya está pagado.
	IF faltante = 0 THEN
		RAISE EXCEPTION 'El viaje ya ha sido pagado en su totalidad.';
	END IF;

	--Calculamos cuanto falta pagar.
	faltante := faltante - NEW.monto;

	--Avisamos cuanto falta por pagar.
	IF faltante > 0 THEN
		RAISE NOTICE 'Faltan $% para completar el pago', faltante;
	--Si el pago es mayor a lo que se debe, solo paga lo necesario.
	ELSEIF faltante <= 0 THEN
		--Actualizamos el monto.
		NEW.monto := NEW.monto + faltante;
		RAISE NOTICE 'Viaje pagado en su totalidad.';
	END IF;

	--Si el pago es en efectivo.
	IF NEW.idTarjeta IS NULL THEN
		RETURN NEW;
	END IF;

	--Verificamos que tipo de pago es.
	SELECT tipo INTO tipoT
	FROM Tarjeta
	WHERE idTarjeta = NEW.idTarjeta;

	--Si el pago es con debito o crédito.
	IF tipoT = 'credito' OR tipoT = 'debito' THEN
		RETURN NEW;
	END IF;

	IF tipoT = 'puntos' THEN
		--verificamos cuánto saldo tiene el cliente.
		SELECT puntos INTO saldoPuntos
		FROM TarjetaDePuntos
		WHERE idTarjeta = NEW.idTarjeta;

		--Si el saldo no alcanza para pagar la parte de un viaje
		--rechazamos el pago.
		saldoFinal := saldoPuntos - NEW.monto;
		IF saldoFinal >= 0 THEN
			--Actualizamos tarjeta
			UPDATE TarjetaDePuntos
			SET puntos = saldoFinal
			WHERE idTarjeta = NEW.idTarjeta;
			--Insertamos en la tabla de pagos.
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'El saldo de la tarjeta de puntos no es suficiente.'
			USING HINT = 'Intenta pagar con otro método de pago.';
		END IF;
	END IF;
END;
$$
language PLPGSQL;

CREATE TRIGGER validaPagos
BEFORE INSERT
ON Pago
FOR EACH ROW
EXECUTE PROCEDURE validaPagos();
