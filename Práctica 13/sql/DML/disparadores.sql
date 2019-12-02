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
	WHERE idConductor = NEW.idConductor AND Viaje.fechaPago = NEW.fechaPago
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

/*
Ejercicio 3:
Un disparador el cual se encargue de validar que un chofer no puede realizar mas
de 35 viajes al día.
*/

/*
Ejercicio 4:
Un disparador el cual se encarge de validar que al realizar un pago con la tarjeta
de puntos, revise que haya saldo disponible y si no, rechazar el pago.
*/

/*
Ejercicio 5:
Un disparador el cual se encargue de que ningún coche en la tabla manejar tenga
más de una fecha de término indeterminada.
*/
