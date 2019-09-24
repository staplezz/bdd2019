--Tabla Persona.
CREATE TABLE Persona (
	idPersona serial PRIMARY KEY,
	Nombre char(15) NOT NULL,
	APaterno char(15) NOT NULL,
	AMaterno char(15) NOT NULL,
	FechaNac date NOT NULL,
	Direccion varchar(200) NOT NULL
);

--Comentarios de la tabla Persona.
COMMENT ON TABLE Persona IS 'Para representar una persona que puede ser cliente o conductor';
COMMENT ON COLUMN Persona.idPersona IS 'ID de una persona';
COMMENT ON COLUMN Persona.Nombre IS 'Nombre/s de una persona';
COMMENT ON COLUMN Persona.APaterno IS 'Apellido paterno de una persona';
COMMENT ON COLUMN Persona.AMaterno IS 'Apellido materno de una persona';
COMMENT ON COLUMN Persona.FechaNac IS 'La fecha de nacimiento de la persona';
COMMENT ON COLUMN Persona.Direccion IS 'La dirección en donde vive la persona';

--Tabla de el/los teléfonos de una persona.
CREATE TABLE PersonaTelefono(
	Telefono char(10) NOT NULL,
	idPersona integer references Persona(idPersona)
);

--Comentarios de la tabla PersonaTelefono.
COMMENT ON TABLE PersonaTelefono IS 'Para el/los teléfonos de las personas';
COMMENT ON COLUMN PersonaTelefono.Telefono IS 'Un número telefónico de una persona';
COMMENT ON COLUMN PersonaTelefono.idPersona IS 'llave foranea asociada a un teléfono de una persona';

--Tabla el o los correos electrónicos de una persona.
CREATE TABLE PersonaCorreo(
	Correo char(30) NOT NULL,
	idPersona integer references Persona(idPersona)
);

--Comentarios de la tabla PersonaCorreo.
COMMENT ON TABLE PersonaCorreo IS 'Para el/los correo electrónicos de las personas';
COMMENT ON COLUMN PersonaCorreo.Correo IS 'Un correo electrónico de una persona';
COMMENT ON COLUMN PersonaCorreo.idPersona IS 'llave foranea asociada a un correo de una persona';

--Tabla para el cliente.
CREATE TABLE Cliente (
	idCliente serial PRIMARY KEY,
	idPersona integer references Persona(idPersona)
);

--Comentarios de la tabla Cliente.
COMMENT ON TABLE Cliente IS 'Para representar un cliente';
COMMENT ON COLUMN Cliente.idCliente IS 'llave de un cliente';
COMMENT ON COLUMN Cliente.idPersona IS 'llave foranea de el cliente que es una persona';

--Tabla de la tarjeta de puntos.
CREATE TABLE Tarjeta (
	idTarjeta char(10) PRIMARY KEY,
	puntos integer,
	idCliente integer references Cliente(idCliente)
);

--Comentarios de la tabla Tarjeta.
COMMENT ON TABLE Tarjeta IS 'Para tarjeta de puntos de cliente frecuente';
COMMENT ON COLUMN Tarjeta.idTarjeta IS 'la llave primaria asociada a la tarjeta';
COMMENT ON COLUMN Tarjeta.puntos IS 'Los puntos que tiene la tarjeta';
COMMENT ON COLUMN Tarjeta.idCliente IS 'llave foranea asociada a la tarjeta de la persona';

--Tabla para el conductor.
CREATE TABLE Conductor (
	idConductor serial PRIMARY KEY,
	idPersona integer references Persona(idPersona)
);

--Comentarios de la tabla Conductor.
COMMENT ON TABLE Conductor IS 'Para representar un conductor';
COMMENT ON COLUMN Conductor.idConductor IS 'llave de un conductor';
COMMENT ON COLUMN Conductor.idPersona IS 'llave foranea de el conductor que es una persona';

--Tabla para un automóvil.
CREATE TABLE Automovil (
	Placas char(6) PRIMARY KEY NOT NULL,
	Marca char(20) NOT NULL,
	PrecioFactura money NOT NULL,
	Submarca char(20) NOT NULL,
	Año char(4) NOT NULL
);

--Comentarios de la tabla Automovil.
COMMENT ON TABLE Automovil IS 'Para representar un automóvil';
COMMENT ON COLUMN Automovil.Placas IS 'llave de un automóvil';
COMMENT ON COLUMN Automovil.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil.PrecioFactura IS 'El precio de factura del automóvil';
COMMENT ON COLUMN Automovil.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil.Año IS 'El año del automóvil';

--Tabla para la relación manejar.
CREATE TABLE Manejar (
	Placas char(6) references Automovil(Placas) NOT NULL,
	idConductor integer references Conductor(idConductor) NOT NULL,
	FechaInic date NOT NULL,
	FechaFin date,
	CONSTRAINT idManejar PRIMARY KEY (Placas, idConductor, FechaInic)
);

--Comentarios de la tabla Manejar.
COMMENT ON TABLE Manejar IS 'Para representar la relación de un conductor y el automóvil que maneja';
COMMENT ON COLUMN Manejar.Placas IS 'Las placas de un automóvil que maneja el conductor';
COMMENT ON COLUMN Manejar.idConductor IS 'La llave del conductor que maneja el automóvil';
COMMENT ON COLUMN Manejar.FechaInic IS 'La fecha de inicio que el conductor empieza a manejar el automóvil';
COMMENT ON COLUMN Manejar.FechaFin IS 'La fecha en la que terminó de conducir el coche, puede ser vacía';
COMMENT ON CONSTRAINT idManejar ON Manejar IS 'La llave candidata compuesta de las placas del automóvil, la llave del conductor y fecha de inicio'

--Tabla para la entidad Viaje.
CREATE TABLE Viaje (
	idViaje serial PRIMARY KEY NOT NULL,
	Costo money NOT NULL,
	Tiempo time NOT NULL,
	Destino varchar(200) NOT NULL,
	Origen varchar(200) NOT NULL,
	TipoViaje char(200) NOT NULL,
	idCliente integer references Cliente(idCliente),
	Ubicacion varchar(200) NOT NULL,
	idConductor integer references Conductor(idConductor)
);

--Comentarios sobre la tabla Viaje.
COMMENT ON TABLE Viaje IS 'Para representar un viaje de la empresa';
COMMENT ON COLUMN Viaje.idViaje IS 'La llave primaria que está asociada a un viaje';
COMMENT ON COLUMN Viaje.Costo IS 'El costo total del viaje';
COMMENT ON COLUMN Viaje.Tiempo IS 'El tiempo que duró el viaje';
COMMENT ON COLUMN Viaje.Destino IS 'El destino del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.Origen IS 'El origen del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.TipoViaje IS 'El tipo de viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.idCliente IS 'La llave del cliente que tomo el viaje';
COMMENT ON COLUMN Viaje.Ubicacion IS 'La ubicación actual del cliente que pide el viaje';
COMMENT ON COLUMN Viaje.idConductor IS 'La llave del conductor que tomo el viaje';


--Tabla para el atributo forma de pago.
CREATE TABLE FormaDePago (
	idPago char(10),
	idViaje integer references Viaje(idViaje),
	CONSTRAINT idFormaDePago PRIMARY KEY (idPago, idViaje)
);

--Comentarios de la tabla forma de pago.
COMMENT ON TABLE FormaDePago IS 'Para guardar la forma de pago de cada viaje';
COMMENT ON COLUMN FormaDePago.idPago IS 'La llave asociada a una forma de pago';
COMMENT ON COLUMN FormaDePago.idViaje IS 'La llave asociada al viaje que se pagó';
COMMENT ON CONSTRAINT idFormaDePago ON FormaDePago IS 'La llave candidata formada por la llave del pago y del viaje';
