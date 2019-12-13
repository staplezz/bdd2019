--Para el tipo de dato CITEXT
CREATE EXTENSION citext;

--Tabla Persona.
CREATE TABLE Persona (
	idPersona serial PRIMARY KEY,
	Nombre varchar(20) NOT NULL,
	APaterno varchar(20) NOT NULL,
	AMaterno varchar(20) NOT NULL,
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
	Telefono varchar(16) PRIMARY KEY,
	idPersona integer references Persona(idPersona),
  CONSTRAINT idpersonaT_del ON DELETE CASCADE
);

--Comentarios de la tabla PersonaTelefono.
COMMENT ON TABLE PersonaTelefono IS 'Para el/los teléfonos de las personas.';
COMMENT ON COLUMN PersonaTelefono.Telefono IS 'Un número telefónico de una persona, se considerqa la llave primaria.';
COMMENT ON COLUMN PersonaTelefono.idPersona IS 'llave foránea asociada a un teléfono de una persona';

--Tabla el o los correos electrónicos de una persona.
CREATE TABLE PersonaCorreo(
	Correo citext PRIMARY KEY,
	idPersona integer references Persona(idPersona),
  CONSTRAINT idpersonaC_del ON DELETE CASCADE
);

--Comentarios de la tabla PersonaCorreo.
COMMENT ON TABLE PersonaCorreo IS 'Para el/los correo electrónicos de las personas';
COMMENT ON COLUMN PersonaCorreo.Correo IS 'Un correo electrónico de una persona, es la llave primaria';
COMMENT ON COLUMN PersonaCorreo.idPersona IS 'llave foranea asociada a un correo de una persona';

--Tabla para el cliente.
CREATE TABLE Cliente (
	idCliente serial PRIMARY KEY,
	idPersona integer references Persona(idPersona),
  CONSTRAINT idpersonaClien_del ON DELETE NO ACTION
);

--Comentarios de la tabla Cliente.
COMMENT ON TABLE Cliente IS 'Para representar un cliente';
COMMENT ON COLUMN Cliente.idCliente IS 'llave de un cliente';
COMMENT ON COLUMN Cliente.idPersona IS 'llave foranea de el cliente que es una persona';

--Tabla de la tarjeta de puntos.
CREATE TABLE Tarjeta (
	idTarjeta serial PRIMARY KEY,
	idCliente integer references Cliente(idCliente),
  tipo varchar(20) NOT NULL,
  CONSTRAINT idclienteT_del ON DELETE CASCADE
);

--Comentarios de la tabla Tarjeta.
COMMENT ON TABLE Tarjeta IS 'Para tarjetas';
COMMENT ON COLUMN Tarjeta.idTarjeta IS 'la llave primaria asociada a la tarjeta';
COMMENT ON COLUMN Tarjeta.idCliente IS 'llave foranea asociada a la tarjeta de la persona';
COMMENT ON COLUMN Tarjeta.tipo IS 'el tipo de la tarjeta';

--Tabla para el conductor           .
CREATE TABLE Conductor (
	idConductor serial PRIMARY KEY,
	idPersona integer references Persona(idPersona),
  fechaInicio date DEFAULT current_date,
  CONSTRAINT idpersonaCond_del ON DELETE NO ACTION
);

--Comentarios de la tabla Conductor.
COMMENT ON TABLE Conductor IS 'Para representar un conductor';
COMMENT ON COLUMN Conductor.idConductor IS 'llave de un conductor';
COMMENT ON COLUMN Conductor.idPersona IS 'llave foranea de el conductor que es una persona';
COMMENT ON COLUMN Conductor.fechaInicio IS 'la fecha en la que inició el conductor';

--Tabla para un automóvil.
CREATE TABLE Automovil (
	Placas char(6) PRIMARY KEY,
	Marca varchar(20) NOT NULL,
	PrecioFactura numeric NOT NULL,
	Submarca varchar(20) NOT NULL,
	Año char(4) NOT NULL,
  Color varchar(20) NOT NULL,
  NumPuertas smallint NOT NULL
);

--Comentarios de la tabla Automovil.
COMMENT ON TABLE Automovil IS 'Para representar un automóvil';
COMMENT ON COLUMN Automovil.Placas IS 'llave de un automóvil';
COMMENT ON COLUMN Automovil.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil.PrecioFactura IS 'El precio de factura del automóvil';
COMMENT ON COLUMN Automovil.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil.Año IS 'El año del automóvil';
COMMENT ON COLUMN Automovil.Color IS 'El color del automóvil';
COMMENT ON COLUMN Automovil.NumPuertas IS 'El número de puertas del automóvil';

--Tabla para la relación manejar.
CREATE TABLE Manejar (
  idManejar serial PRIMARY KEY,
	idConductor integer references Conductor(idConductor) NOT NULL,
	Placas char(6) references Automovil(Placas) NOT NULL,
	FechaInic date DEFAULT current_date,
	FechaFin date,
  CONSTRAINT idcondplacasManej_del ON DELETE NO ACTION
);

--Comentarios de la tabla Manejar.
COMMENT ON TABLE Manejar IS 'Para representar la relación de un conductor y el automóvil que maneja';
COMMENT ON COLUMN Manejar.Placas IS 'Las placas de un automóvil que maneja el conductor';
COMMENT ON COLUMN Manejar.idConductor IS 'La llave del conductor que maneja el automóvil';
COMMENT ON COLUMN Manejar.FechaInic IS 'La fecha de inicio que el conductor empieza a manejar el automóvil';
COMMENT ON COLUMN Manejar.FechaFin IS 'La fecha en la que terminó de conducir el coche, puede ser vacía';
COMMENT ON CONSTRAINT idManejar ON Manejar IS 'La llave candidata compuesta de las placas del automóvil, la llave del conductor y fecha de inicio';

--Tabla para la entidad Viaje.
CREATE TABLE Viaje (
	idViaje serial PRIMARY KEY,
	idCliente integer references Cliente(idCliente),
	idConductor integer references Conductor(idConductor)
	Origen varchar(200) NOT NULL,
	Destino varchar(200) NOT NULL,
  Placas char(6) references Automovil(Placas) NOT NULL,
	Tiempo interval NOT NULL,
	Costo numeric NOT NULL,
	Kilometros numeric NOT NULL,
	fechaPago date DEFAULT current_date,
  CONSTRAINT idcondclienViaje_del ON DELETE NO ACTION
);


COMMENT ON TABLE Viaje IS 'Para representar un viaje de la empresa';
COMMENT ON COLUMN Viaje.idViaje IS 'La llave primaria que está asociada a un viaje';
COMMENT ON COLUMN Viaje.idCliente IS 'La llave del cliente que tomo el viaje';
COMMENT ON COLUMN Viaje.idConductor IS 'La llave del conductor que tomo el viaje';
COMMENT ON COLUMN Viaje.Origen IS 'El origen del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.Destino IS 'El destino del viaje que eligió el cliente';
COMMENT ON COLUMN Viaje.Placas IS 'Las placas del coche usado en el viaje';
COMMENT ON COLUMN Viaje.Tiempo IS 'El tiempo que duró el viaje';
COMMENT ON COLUMN Viaje.Costo IS 'El costo total del viaje';
COMMENT ON COLUMN Viaje.Kilometros IS 'Los kilómetros recorridos';
COMMENT ON COLUMN Viaje.fechaPago IS 'La fecha de pago (misma que la del viaje)';


--Tabla para los pagos.
CREATE TABLE Pago (
	idPago serial PRIMARY KEY,
	idViaje integer references Viaje(idViaje),
	idTarjeta integer references Tarjeta(idTarjeta),
	monto numeric NOT NULL,
  CONSTRAINT idviajetarjPago_del ON DELETE NO ACTION
);

--Comentarios de la tabla forma de pago.
COMMENT ON TABLE Pago IS 'Para guardar la forma de pago de cada viaje';
COMMENT ON COLUMN Pago.idPago IS 'La llave primaria de la tabla';
COMMENT ON COLUMN Pago.idViaje IS 'La llave asociada al viaje que se pagó';
COMMENT ON COLUMN Pago.idTarjeta IS 'La llave asociada a la tarjeta con la que se pagó';
COMMENT ON COLUMN Pago.monto IS 'El monto que se pago del viaje con la forma de pago';

--Tabla de la tarjeta bancaria.
CREATE TABLE TarjetaBancaria (
  idTarjetaBancaria serial PRIMARY KEY,
  idTarjeta integer references Tarjeta(idTarjeta),
  Numero char(16) NOT NULL,
  nombreBanco varchar(20) NOT NULL,
  Expiracion date NOT NULL,
  CONSTRAINT idtarjetBanca_del ON DELETE CASCADE
);

--Comentarios de la tabla Tarjeta Bancaria.
COMMENT ON TABLE TarjetaBancaria IS 'Para tarjetas';
COMMENT ON COLUMN TarjetaBancaria.idTarjetaBancaria IS 'la llave primaria asociada a la tarjeta bancaria';
COMMENT ON COLUMN TarjetaBancaria.idTarjeta IS 'referencia al id de tarjeta que se le asocia';
COMMENT ON COLUMN TarjetaBancaria.Numero IS 'el número de la tarjeta';
COMMENT ON COLUMN TarjetaBancaria.nombreBanco IS 'el nombre del banco al que pertenece la tarjeta';
COMMENT ON COLUMN TarjetaBancaria.Expiracion IS 'la fecha de expiración';

--Tabla de la tarjeta de puntos.
CREATE TABLE TarjetaDePuntos (
idTarjetaPuntos serial PRIMARY KEY,
idTarjeta integer references Tarjeta(idTarjeta),
Puntos integer DEFAULT 0
CONSTRAINT idtarjetPunt_del ON DELETE CASCADE

);

--Comentarios de la tabla Tarjeta Bancaria.
COMMENT ON TABLE TarjetaDePuntos IS 'Para tarjetas';
COMMENT ON COLUMN TarjetaDePuntos.idTarjetaPuntos IS 'la llave primaria asociada a la tarjeta de puntos';
COMMENT ON COLUMN TarjetaDePuntos.idTarjeta IS 'referencia al id de tarjeta que se le asocia';
COMMENT ON COLUMN TarjetaDePuntos.Puntos IS 'el número de puntos que gastó';

