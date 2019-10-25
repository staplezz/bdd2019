--Para el tipo de dato CITEXT
CREATE EXTENSION citext;

--Tabla Persona.
CREATE TABLE Persona (
	idPersona serial,
	Nombre varchar(15) NOT NULL,
	APaterno varchar(15) NOT NULL,
	AMaterno varchar(15) NOT NULL,
	FechaNac date NOT NULL,
	Direccion varchar(200) NOT NULL,
	CONSTRAINT idPersona PRIMARY KEY(idPersona)
);

--Comentarios de la tabla Persona.
COMMENT ON TABLE Persona IS 'Para representar una persona que puede ser cliente o conductor';
COMMENT ON COLUMN Persona.idPersona IS 'ID de una persona';
COMMENT ON COLUMN Persona.Nombre IS 'Nombre/s de una persona';
COMMENT ON COLUMN Persona.APaterno IS 'Apellido paterno de una persona';
COMMENT ON COLUMN Persona.AMaterno IS 'Apellido materno de una persona';
COMMENT ON COLUMN Persona.FechaNac IS 'La fecha de nacimiento de la persona';
COMMENT ON COLUMN Persona.Direccion IS 'La dirección en donde vive la persona';
COMMENT ON CONSTRAINT idPersona ON Persona IS 'La llave primaria que identifica a una persona.';

--Tabla de el/los teléfonos de una persona.
CREATE TABLE PersonaTelefono(
	Telefono varchar(16),
	idPersona integer,
	CONSTRAINT Telefono PRIMARY KEY(Telefono),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla PersonaTelefono.
COMMENT ON TABLE PersonaTelefono IS 'Para el/los teléfonos de las personas';
COMMENT ON COLUMN PersonaTelefono.Telefono IS 'Un número telefónico de una persona';
COMMENT ON COLUMN PersonaTelefono.idPersona IS 'llave foranea asociada a un teléfono de una persona';
COMMENT ON CONSTRAINT Telefono ON PersonaTelefono IS 'la llave primaria que es el teléfono de una persona.';
COMMENT ON CONSTRAINT idPersona ON PersonaTelefono IS 'la llave foránea que es el id de la persona asoaciada a cada teléfono';

--Tabla el o los correos electrónicos de una persona.
CREATE TABLE PersonaCorreo(
	Correo CITEXT,
	idPersona integer,
	CONSTRAINT Correo PRIMARY KEY(Correo),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla PersonaCorreo.
COMMENT ON TABLE PersonaCorreo IS 'Para el/los correo electrónicos de las personas';
COMMENT ON COLUMN PersonaCorreo.Correo IS 'Un correo electrónico de una persona';
COMMENT ON COLUMN PersonaCorreo.idPersona IS 'llave foranea asociada a un correo de una persona';
COMMENT ON CONSTRAINT Correo ON PersonaCorreo IS 'la llave primaria que es el correo de una persona.';
COMMENT ON CONSTRAINT idPersona ON PersonaCorreo IS 'la llave foránea que es el id de la persona asoaciada a cada correo';

--Tabla para el cliente.
CREATE TABLE Cliente (
	idCliente serial,
	idPersona integer,
	CONSTRAINT idCliente PRIMARY KEY(idCliente),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla Cliente.
COMMENT ON TABLE Cliente IS 'Para representar un cliente';
COMMENT ON COLUMN Cliente.idCliente IS 'El id de un cliente';
COMMENT ON COLUMN Cliente.idPersona IS 'El id del cliente que asociado una persona';
COMMENT ON CONSTRAINT idCliente ON Cliente IS 'la llave primaria que es el id de un cliente.';
COMMENT ON CONSTRAINT idPersona ON Cliente IS 'la llave foránea asociada al id de un cliente.';

--Tabla de la tarjeta de puntos.
CREATE TABLE Tarjeta (
	idTarjeta serial,
	idCliente integer,
	puntos integer,
	CONSTRAINT idTarjeta PRIMARY KEY(idTarjeta),
	CONSTRAINT idCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
);

--Comentarios de la tabla Tarjeta.
COMMENT ON TABLE Tarjeta IS 'Para tarjeta de puntos de cliente frecuente';
COMMENT ON COLUMN Tarjeta.idTarjeta IS 'El id de la tarjeta';
COMMENT ON COLUMN Tarjeta.puntos IS 'Los puntos que tiene la tarjeta';
COMMENT ON COLUMN Tarjeta.idCliente IS 'llave foranea asociada a la tarjeta del cliente.';
COMMENT ON CONSTRAINT idTarjeta ON Tarjeta IS 'la llave primaria que es el id de una tarjeta.';
COMMENT ON CONSTRAINT idCliente ON Tarjeta IS 'la llave foránea el id del cliente al que pertenece la tarjeta.';

--Tabla para el conductor.
CREATE TABLE Conductor (
	idConductor serial,
	idPersona integer,
	fechaInicio date NOT NULL,
	CONSTRAINT idConductor PRIMARY KEY(idConductor),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla Conductor.
COMMENT ON TABLE Conductor IS 'Para representar un conductor';
COMMENT ON COLUMN Conductor.idConductor IS 'El id de un conductor';
COMMENT ON COLUMN Conductor.idPersona IS 'El id del conductor que asociado una persona';
COMMENT ON COLUMN Conductor.fechaInicio IS 'La fecha en la que el conductor empezó a trabajar en la empresa.';
COMMENT ON CONSTRAINT idConductor ON Conductor IS 'la llave primaria que es el id de un conductor.';
COMMENT ON CONSTRAINT idPersona ON Conductor IS 'la llave foránea asociada al id de un conductor .';


--Tabla para un automóvil.
CREATE TABLE Automovil (
	Placas char(6),
	Marca varchar(20) NOT NULL,
	PrecioFactura numeric NOT NULL,
	Submarca varchar(20) NOT NULL,
	Año smallint NOT NULL,
	Color varchar(20) NOT NULL,
	numPuertas smallint,
	CONSTRAINT Placas PRIMARY KEY(Placas)
);

--Comentarios de la tabla Automovil.
COMMENT ON TABLE Automovil IS 'Para representar un automóvil';
COMMENT ON COLUMN Automovil.Placas IS 'llave de un automóvil';
COMMENT ON COLUMN Automovil.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil.PrecioFactura IS 'El precio de factura del automóvil';
COMMENT ON COLUMN Automovil.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil.Año IS 'El año del automóvil';
COMMENT ON COLUMN Automovil.Color IS 'El color del automóvil';
COMMENT ON COLUMN Automovil.numPuertas IS 'El número de puertas del automóvil';
COMMENT ON CONSTRAINT Placas ON Automovil IS 'La llave primaria representada por las placas del automóvil';

--Tabla para la relación manejar.
CREATE TABLE Manejar (
	idManejar serial,
	Placas varchar(6),
	idConductor integer,
	FechaInic date NOT NULL,
	FechaFin date,
	CONSTRAINT idManejar PRIMARY KEY(idManejar),
	CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil(Placas),
	CONSTRAINT idConductor FOREIGN KEY(idConductor) REFERENCES Conductor(idConductor)
);

--Comentarios de la tabla Manejar.
COMMENT ON TABLE Manejar IS 'Para representar la relación de un conductor y el automóvil que maneja';
COMMENT ON COLUMN Manejar.idManejar IS 'El id que representa el conductor y el automóvil que maneja';
COMMENT ON COLUMN Manejar.Placas IS 'Las placas de un automóvil que maneja el conductor';
COMMENT ON COLUMN Manejar.idConductor IS 'La llave del conductor que maneja el automóvil';
COMMENT ON COLUMN Manejar.FechaInic IS 'La fecha de inicio que el conductor empieza a manejar el automóvil';
COMMENT ON COLUMN Manejar.FechaFin IS 'La fecha en la que terminó de conducir el coche, puede ser vacía';
COMMENT ON CONSTRAINT idManejar ON Manejar IS 'La llave primaria que representa la relación manejar';
COMMENT ON CONSTRAINT Placas ON Manejar IS 'La llave foranea que está relacionada con el automóvil';
COMMENT ON CONSTRAINT idConductor ON Manejar IS 'La llave foranea que está relacionada con el conductor';

--Tabla para la entidad Viaje.
CREATE TABLE Viaje (
	idViaje serial,
	idCliente integer,
	idConductor integer,
	Origen varchar(200) NOT NULL,
	Destino varchar(200) NOT NULL,
	Placas char(6),
	Tiempo interval NOT NULL,
	Costo numeric NOT NULL,
	CONSTRAINT idViaje PRIMARY KEY(idViaje),
	CONSTRAINT idCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente),
	CONSTRAINT idConductor FOREIGN KEY(idConductor) REFERENCES Conductor(idConductor),
	CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil(Placas)
);

--Comentarios sobre la tabla Viaje.
COMMENT ON TABLE Viaje IS 'Para representar un viaje de la empresa';
COMMENT ON COLUMN Viaje.idViaje IS 'La llave primaria que está asociada a un viaje';
COMMENT ON COLUMN Viaje.idCliente IS 'La llave del cliente que tomo el viaje';
COMMENT ON COLUMN Viaje.idConductor IS 'La llave del conductor que tomo el viaje';
COMMENT ON COLUMN Viaje.Origen IS 'El origen del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.Destino IS 'El destino del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.Placas IS 'Las placas del automóvil en el que se realizó el viaje';
COMMENT ON COLUMN Viaje.Tiempo IS 'El tiempo que duró el viaje';
COMMENT ON COLUMN Viaje.Costo IS 'El costo total del viaje';
COMMENT ON CONSTRAINT idViaje ON Viaje IS 'La llave primaria que representa la relación viajar';
COMMENT ON CONSTRAINT idCliente ON Viaje IS 'La llave foránea que es del cliente que viajó';
COMMENT ON CONSTRAINT idConductor ON Viaje IS 'La llave foránea que es del conductor que realizó el viaje';
COMMENT ON CONSTRAINT Placas ON Viaje IS 'La llave foránea que es del automóvil que se tomó en el viaje';

--Tabla para la forma de pago con Tarjeta de Crédito
CREATE TABLE TarjetaDeCredito (
	idViaje integer,
	monto numeric NOT NULL,
	--CONSTRAINT idViaje PRIMARY KEY(idViaje),
	CONSTRAINT idViaje FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
);

--Comentarios de la tabla forma de pago con Tarjeta de Crédito.
COMMENT ON TABLE TarjetaDeCredito IS 'Para guardar el pago con tarjeta de crédito de un viaje';
COMMENT ON COLUMN TarjetaDeCredito.idViaje IS 'el id asociado al viaje que se realizó';
COMMENT ON COLUMN TarjetaDeCredito.monto IS 'El monto que se realizó con esa forma de pago';
COMMENT ON CONSTRAINT idViaje ON TarjetaDeCredito IS 'La llave foránea que se asocia a cada viaje';

--Tabla para la forma de pago con Tarjeta de Débito
CREATE TABLE TarjetaDeDebito (
	idViaje integer,
	monto numeric NOT NULL,
	CONSTRAINT idViaje FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
);

--Comentarios de la tabla forma de pago con Tarjeta de Débito.
COMMENT ON TABLE TarjetaDeDebito IS 'Para guardar el pago con tarjeta de Debito de un viaje';
COMMENT ON COLUMN TarjetaDeDebito.idViaje IS 'el id asociado al viaje que se realizó';
COMMENT ON COLUMN TarjetaDeDebito.monto IS 'El monto que se realizó con esa forma de pago';
COMMENT ON CONSTRAINT idViaje ON TarjetaDeDebito IS 'La llave foránea que se asocia a cada viaje';

--Tabla para la forma de pago con Tarjeta de Puntos
CREATE TABLE TarjetaDePuntos ( 
	idViaje integer,
	monto numeric NOT NULL,
	CONSTRAINT idViaje FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
);

--Comentarios de la tabla forma de pago con Tarjeta de Puntos.
COMMENT ON TABLE TarjetaDePuntos IS 'Para guardar el pago con tarjeta de Puntos de un viaje';
COMMENT ON COLUMN TarjetaDePuntos.idViaje IS 'el id asociado al viaje que se realizó';
COMMENT ON COLUMN TarjetaDePuntos.monto IS 'El monto que se realizó con esa forma de pago';
COMMENT ON CONSTRAINT idViaje ON TarjetaDePuntos IS 'La llave foránea que se asocia a cada viaje';

--Tabla para la forma de pago con Efectivo
CREATE TABLE Efectivo ( 
	idViaje integer,
	monto numeric NOT NULL,
	CONSTRAINT idViaje FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
);

--Comentarios de la tabla forma de pago con Efectivo.
COMMENT ON TABLE Efectivo IS 'Para guardar el pago con efectivo de un viaje';
COMMENT ON COLUMN Efectivo.idViaje IS 'el id asociado al viaje que se realizó';
COMMENT ON COLUMN Efectivo.monto IS 'El monto que se realizó con esa forma de pago';
COMMENT ON CONSTRAINT idViaje ON Efectivo IS 'La llave foránea que se asocia a cada viaje';
