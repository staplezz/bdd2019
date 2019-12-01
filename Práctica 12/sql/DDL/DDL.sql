--Para el tipo de dato CITEXT
CREATE EXTENSION citext;

--Tabla Persona.
CREATE TABLE Persona (
	idPersona serial,
	RFC char(13) NOT NULL UNIQUE,
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
	Telefono varchar(16) UNIQUE,
	idPersona integer,
	CONSTRAINT idTelefono PRIMARY KEY(Telefono, idPersona),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla PersonaTelefono.
COMMENT ON TABLE PersonaTelefono IS 'Para el/los teléfonos de las personas';
COMMENT ON COLUMN PersonaTelefono.Telefono IS 'Un número telefónico de una persona';
COMMENT ON COLUMN PersonaTelefono.idPersona IS 'llave foranea asociada a un teléfono de una persona';
COMMENT ON CONSTRAINT idTelefono ON PersonaTelefono IS 'la llave primaria que es el teléfono de una persona.';
COMMENT ON CONSTRAINT idPersona ON PersonaTelefono IS 'la llave foránea que es el id de la persona asoaciada a cada teléfono';

--Tabla el o los correos electrónicos de una persona.
CREATE TABLE PersonaCorreo(
	Correo CITEXT UNIQUE,
	idPersona integer NOT NULL,
	CONSTRAINT idCorreo PRIMARY KEY(Correo, idPersona),
	CONSTRAINT idPersona FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
);

--Comentarios de la tabla PersonaCorreo.
COMMENT ON TABLE PersonaCorreo IS 'Para el/los correo electrónicos de las personas';
COMMENT ON COLUMN PersonaCorreo.Correo IS 'Un correo electrónico de una persona';
COMMENT ON COLUMN PersonaCorreo.idPersona IS 'llave foranea asociada a un correo de una persona';
COMMENT ON CONSTRAINT idCorreo ON PersonaCorreo IS 'la llave primaria compuesta que es el correo de una persona.';
COMMENT ON CONSTRAINT idPersona ON PersonaCorreo IS 'la llave foránea que es el id de la persona asoaciada a cada correo';

--Tabla para el cliente.
CREATE TABLE Cliente (
	idCliente serial,
	idPersona integer UNIQUE,
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
	idCliente integer NOT NULL UNIQUE,
	puntos integer NOT NULL DEFAULT 0 CHECK (puntos >= 0),
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
	idPersona integer NOT NULL UNIQUE,
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

--Tabla para marcas y submarcas de un automovil
CREATE TABLE Automovil2 (
Marca varchar(20),
Submarca varchar(20) UNIQUE,
CONSTRAINT idSubmarca PRIMARY KEY(Marca,Submarca)
);

--Comentarios de la tabla Automovil2.
COMMENT ON TABLE Automovil2 IS 'Para representar las marcas y submarcas de un automóvil';
COMMENT ON COLUMN Automovil2.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil2.Submarca IS 'La submarca del automóvil';
COMMENT ON CONSTRAINT idSubmarca ON Automovil2 IS 'La llave primaria compuesta representada por la submarca del automóvil';

--Tabla para un automóvil1.
CREATE TABLE Automovil1 (
	Placas char(6),
	Submarca varchar(20) NOT NULL,
	Año smallint NOT NULL,
	Color varchar(20) NOT NULL,
	numPuertas smallint NOT NULL CHECK (numPuertas >= 4 AND numPuertas <= 6),
	CONSTRAINT Placasid PRIMARY KEY(Placas),
	CONSTRAINT submarca FOREIGN KEY(Submarca) REFERENCES Automovil2(submarca)
);

--Comentarios de la tabla Automovil1.
COMMENT ON TABLE Automovil1 IS 'Para representar un automóvil';
COMMENT ON COLUMN Automovil1.Placas IS 'llave de un automóvil';
COMMENT ON COLUMN Automovil1.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil1.Año IS 'El año del automóvil';
COMMENT ON COLUMN Automovil1.Color IS 'El color del automóvil';
COMMENT ON COLUMN Automovil1.numPuertas IS 'El número de puertas del automóvil';
COMMENT ON CONSTRAINT Placasid ON Automovil1 IS 'La llave primaria representada por las placas del automóvil';
COMMENT ON CONSTRAINT submarca ON Automovil1 IS 'La llave foranea que representa la submarcas que puede tener un automóvil';

--Tabla para precios de factura de un automóvil.
CREATE TABLE Automovil3 (
PrecioFactura numeric NOT NULL CHECK (PrecioFactura > 0),
Submarca varchar(20) NOT NULL,
Año smallint NOT NULL,
Color varchar(20) NOT NULL,
numPuertas smallint CHECK (numPuertas >= 4 AND numPuertas <= 6),
CONSTRAINT autoprecioid PRIMARY KEY(Submarca, Año, Color, numPuertas),
CONSTRAINT Submarca FOREIGN KEY(Submarca) REFERENCES Automovil2(Submarca)
);

--Comentarios de la tabla Automovil3.
COMMENT ON TABLE Automovil3 IS 'Para representar el precio de factura de un automóvil';
COMMENT ON COLUMN Automovil3.PrecioFactura IS 'El precio de factura del automóvil';
COMMENT ON COLUMN Automovil3.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil3.Año IS 'El año del automóvil';
COMMENT ON COLUMN Automovil3.Color IS 'El color del automóvil';
COMMENT ON COLUMN Automovil3.numPuertas IS 'El número de puertas del automóvil';
COMMENT ON CONSTRAINT autoprecioid ON Automovil3 IS 'La llave primaria representada por la submarca, año, color y número de puertas.';
COMMENT ON CONSTRAINT Submarca ON Automovil3 IS 'La llave foránea asociada a la submarca de un automóvil.';

--Tabla para la relación manejar.
CREATE TABLE Manejar (
	idManejar serial,
	Placas varchar(6) NOT NULL,
	idConductor integer NOT NULL,
	FechaInic date NOT NULL,
	FechaFin date,
	CONSTRAINT idManejar PRIMARY KEY(idManejar),
	CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil1(Placas),
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
	idCliente integer NOT NULL,
	idConductor integer NOT NULL,
	Origen varchar(200) NOT NULL,
	Destino varchar(200) NOT NULL,
	Placas char(6) NOT NULL,
	Tiempo interval NOT NULL,
	Costo numeric NOT NULL CHECK (Costo > 0),
	fechaPago date NOT NULL,
	kilometros integer NOT NULL,
	CONSTRAINT idViaje PRIMARY KEY(idViaje),
	CONSTRAINT idCliente FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente),
	CONSTRAINT idConductor FOREIGN KEY(idConductor) REFERENCES Conductor(idConductor),
	CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil1(Placas)
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
COMMENT ON COLUMN Viaje.fechaPago IS 'La fecha en la que se pago el viaje.';
COMMENT ON COLUMN Viaje.kilometros IS 'El número de km recorridos en el viaje';
COMMENT ON CONSTRAINT idViaje ON Viaje IS 'La llave primaria que representa la relación viajar';
COMMENT ON CONSTRAINT idCliente ON Viaje IS 'La llave foránea que es del cliente que viajó';
COMMENT ON CONSTRAINT idConductor ON Viaje IS 'La llave foránea que es del conductor que realizó el viaje';
COMMENT ON CONSTRAINT Placas ON Viaje IS 'La llave foránea que es del automóvil que se tomó en el viaje';

--Tabla para almacenar los pagos de cada uno de los viajes.
CREATE TABLE Pagos (
	idViaje integer,
	montoEfectivo numeric,
	montoPuntos numeric,	
	montoDebito numeric,
	montoCredito numeric,
	CONSTRAINT idPago PRIMARY KEY(idViaje),
	CONSTRAINT idPagoFK FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
);

--Comentarios de la tabla Pagos.
COMMENT ON TABLE Pagos IS 'Para guardar los pagos de un viaje';
COMMENT ON COLUMN Pagos.idViaje IS 'el id asociado al viaje que se realizó';
COMMENT ON COLUMN Pagos.montoEfectivo IS 'El monto que se realizó en efectivo';
COMMENT ON COLUMN Pagos.montoPuntos IS 'El monto que se realizó en efectivo';
COMMENT ON COLUMN Pagos.montoDebito IS 'El monto que se realizó en efectivo';
COMMENT ON COLUMN Pagos.montoCredito IS 'El monto que se realizó en efectivo';
COMMENT ON CONSTRAINT idPago ON Pagos IS 'La llave primaria que se asocia cada pago';
COMMENT ON CONSTRAINT idPagoFK ON Pagos IS 'La llave foránea que se asocia cada viaje';
