--Para el tipo de dato CITEXT
CREATE EXTENSION citext;

--Tabla Persona.
CREATE TABLE Persona (
	idPersona serial,
	Nombre varchar(20) NOT NULL,
	APaterno varchar(20) NOT NULL,
	AMaterno varchar(20) NOT NULL,
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
  	CONSTRAINT idTelefono PRIMARY KEY(Telefono),
  	CONSTRAINT idPersonaT FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
  	ON UPDATE CASCADE
  	ON DELETE CASCADE
);

--Comentarios de la tabla PersonaTelefono.
COMMENT ON TABLE PersonaTelefono IS 'Para el/los teléfonos de las personas.';
COMMENT ON COLUMN PersonaTelefono.Telefono IS 'Un número telefónico de una persona';
COMMENT ON COLUMN PersonaTelefono.idPersona IS 'El id asociado al teléfono';
COMMENT ON CONSTRAINT idTelefono ON PersonaTelefono IS 'la llave primaria que es el teléfono de una persona.';
COMMENT ON CONSTRAINT idPersonaT ON PersonaTelefono IS 'la llave foránea que es el id de la persona asoaciada a cada teléfono';

--Tabla el o los correos electrónicos de una persona.
CREATE TABLE PersonaCorreo(
	Correo citext,
	idPersona integer,
	CONSTRAINT idCorreo PRIMARY KEY(Correo),
  	CONSTRAINT idPersonaC FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
  	ON UPDATE CASCADE
  	ON DELETE CASCADE
);

--Comentarios de la tabla PersonaCorreo.
COMMENT ON TABLE PersonaCorreo IS 'Para el/los correo electrónicos de las personas';
COMMENT ON COLUMN PersonaCorreo.Correo IS 'Un correo electrónico de una persona';
COMMENT ON COLUMN PersonaCorreo.idPersona IS 'llave foranea asociada a un correo de una persona';
COMMENT ON CONSTRAINT idCorreo ON PersonaCorreo IS 'la llave primaria que es el correo de una persona.';
COMMENT ON CONSTRAINT idPersonaC ON PersonaCorreo IS 'la llave foránea que es el id de la persona asoaciada a cada correo';

--Tabla para el cliente.
CREATE TABLE Cliente (
	idCliente serial,
	idPersona integer UNIQUE,
	CONSTRAINT idCliente PRIMARY KEY(idCliente),
	CONSTRAINT idPersonaCl FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--Comentarios de la tabla Cliente.
COMMENT ON TABLE Cliente IS 'Para representar un cliente';
COMMENT ON COLUMN Cliente.idCliente IS 'llave de un cliente';
COMMENT ON COLUMN Cliente.idPersona IS 'llave foranea de el cliente que es una persona';
COMMENT ON CONSTRAINT idCliente ON Cliente IS 'la llave primaria que es el id de un cliente.';
COMMENT ON CONSTRAINT idPersonaCl ON Cliente IS 'la llave foránea asociada al id de un cliente.';

--Tabla para representar una tarjeta, ya sea de puntos o bancaria.
CREATE TABLE Tarjeta (
	idTarjeta serial,
	idCliente integer,
  	tipo varchar(20) NOT NULL,
  	CONSTRAINT idTarjeta PRIMARY KEY(idTarjeta),
  	CONSTRAINT idClienteT FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
  	ON UPDATE CASCADE
  	ON DELETE CASCADE,
  	CONSTRAINT revisaTipo CHECK(tipo in ('puntos', 'credito', 'debito'))
);

--Comentarios de la tabla Tarjeta.
COMMENT ON TABLE Tarjeta IS 'Para representar una tarjeta';
COMMENT ON COLUMN Tarjeta.idTarjeta IS 'la llave primaria asociada a la tarjeta';
COMMENT ON COLUMN Tarjeta.idCliente IS 'El cliente a quien corresponde la tarjeta';
COMMENT ON COLUMN Tarjeta.tipo IS 'el tipo de la tarjeta';
COMMENT ON CONSTRAINT idTarjeta ON Tarjeta IS 'la llave primaria que es el id de una tarjeta.';
COMMENT ON CONSTRAINT idClienteT ON Tarjeta IS 'La llave foránea que es el id de un cliente';

--Tabla para el conductor.
CREATE TABLE Conductor (
	idConductor serial,
	idPersona integer UNIQUE,
  	fechaInicio date DEFAULT current_date,
  	CONSTRAINT idConductor PRIMARY KEY(idConductor),
	CONSTRAINT idPersonaCo FOREIGN KEY(idPersona) REFERENCES Persona(idPersona)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--Comentarios de la tabla Conductor.
COMMENT ON TABLE Conductor IS 'Para representar un conductor';
COMMENT ON COLUMN Conductor.idConductor IS 'llave de un conductor';
COMMENT ON COLUMN Conductor.idPersona IS 'llave foranea de el conductor que es una persona';
COMMENT ON COLUMN Conductor.fechaInicio IS 'la fecha en la que inicio el conductor';
COMMENT ON CONSTRAINT idConductor ON Conductor IS 'la llave primaria que es el id de un conductor.';
COMMENT ON CONSTRAINT idPersonaCo ON Conductor IS 'la llave foránea asociada al id de un conductor.';

--Tabla para un automóvil.
CREATE TABLE Automovil (
	Placas char(6),
	Marca varchar(20) NOT NULL,
	Submarca varchar(20) NOT NULL,
	PrecioFactura numeric NOT NULL,
	Año smallint NOT NULL,
  	Color varchar(20) NOT NULL,
  	NumPuertas smallint NOT NULL,
  	CONSTRAINT idAutomovil PRIMARY KEY(Placas)
);

--Comentarios de la tabla Automovil.
COMMENT ON TABLE Automovil IS 'Para representar un automóvil';
COMMENT ON COLUMN Automovil.Placas IS 'Placas de un automóvil';
COMMENT ON COLUMN Automovil.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil.PrecioFactura IS 'El precio de factura del automóvil';
COMMENT ON COLUMN Automovil.Submarca IS 'La submarca del automóvil';
COMMENT ON COLUMN Automovil.Año IS 'El año del automóvil';
COMMENT ON COLUMN Automovil.Color IS 'El color del automóvil';
COMMENT ON COLUMN Automovil.NumPuertas IS 'El número de puertas del automóvil';
COMMENT ON CONSTRAINT idAutomovil ON Automovil IS 'La llave primaria representada por las placas del automóvil';

--Tabla para la relación manejar.
CREATE TABLE Manejar (
	idManejar serial,
	idConductor integer NOT NULL,
	Placas char(6) NOT NULL,
	FechaInic date DEFAULT current_date,
	FechaFin date,
  	CONSTRAINT idManejar PRIMARY KEY(idManejar),
  	CONSTRAINT manejarConductor FOREIGN KEY(idConductor) REFERENCES Conductor(idConductor)
  	ON UPDATE CASCADE
  	ON DELETE CASCADE,
  	CONSTRAINT manejarAutomovil FOREIGN KEY(Placas) REFERENCES Automovil(Placas)
  	ON UPDATE CASCADE
  	ON DELETE CASCADE
);

--Comentarios de la tabla Manejar.
COMMENT ON TABLE Manejar IS 'Para representar la relación de un conductor y el automóvil que maneja';
COMMENT ON COLUMN Manejar.Placas IS 'Las placas de un automóvil que maneja el conductor';
COMMENT ON COLUMN Manejar.idConductor IS 'La llave del conductor que maneja el automóvil';
COMMENT ON COLUMN Manejar.FechaInic IS 'La fecha de inicio que el conductor empieza a manejar el automóvil';
COMMENT ON COLUMN Manejar.FechaFin IS 'La fecha en la que terminó de conducir el coche, puede ser vacía';
COMMENT ON CONSTRAINT idManejar ON Manejar IS 'La llave primaria de la relación';
COMMENT ON CONSTRAINT manejarConductor ON Manejar IS 'La llave foránea del conductor que maneja el auto.';
COMMENT ON CONSTRAINT manejarAutomovil ON Manejar IS 'La llave foránea del automóvil que maneja el conductor.';

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
	Kilometros numeric NOT NULL,
	fechaPago date DEFAULT current_date,
  	CONSTRAINT idViaje PRIMARY KEY(idViaje),
  	CONSTRAINT clienteVFK FOREIGN KEY(idCliente) REFERENCES Cliente(idCliente)
  	ON UPDATE CASCADE
  	ON DELETE SET NULL,
  	CONSTRAINT conductorVFK FOREIGN KEY(idConductor) REFERENCES Conductor(idConductor)
  	ON UPDATE CASCADE
  	ON DELETE SET NULL,
  	CONSTRAINT placasVFK FOREIGN KEY(Placas) REFERENCES Automovil(Placas)
  	ON UPDATE CASCADE
  	ON DELETE SET NULL,
  	CONSTRAINT minimoPago CHECK(costo >= 30)
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
COMMENT ON CONSTRAINT idViaje ON Viaje IS 'La llave primaria de la relación';
COMMENT ON CONSTRAINT clienteVFK ON Viaje IS 'La llave foránea del cliente que toma el viaje.';
COMMENT ON CONSTRAINT conductorVFK ON Viaje IS 'La llave foránea del conductor que toma el viaje';
COMMENT ON CONSTRAINT placasVFK ON Viaje IS 'El automóvil en el que se realiza el viaje';

--Tabla para los pagos.
CREATE TABLE Pago (
	idPago serial,
	idViaje integer,
	idTarjeta integer,
	monto numeric NOT NULL,
  	CONSTRAINT idPago PRIMARY KEY(idPago),
  	CONSTRAINT idViajePago FOREIGN KEY(idViaje) REFERENCES Viaje(idViaje)
  	ON UPDATE CASCADE
  	ON DELETE SET NULL,
  	CONSTRAINT idTarjetaPago FOREIGN KEY(idTarjeta) REFERENCES Tarjeta(idTarjeta)
  	ON UPDATE CASCADE
  	ON DELETE SET NULL
);

--Comentarios de la tabla forma de pago.
COMMENT ON TABLE Pago IS 'Para guardar la forma de pago de cada viaje';
COMMENT ON COLUMN Pago.idPago IS 'La llave primaria de la tabla';
COMMENT ON COLUMN Pago.idViaje IS 'La llave asociada al viaje que se pagó';
COMMENT ON COLUMN Pago.idTarjeta IS 'La llave asociada a la tarjeta con la que se pagó';
COMMENT ON COLUMN Pago.monto IS 'El monto que se pago del viaje con la forma de pago';
COMMENT ON CONSTRAINT idPago ON Pago IS 'La llave primaria de un pago.';
COMMENT ON CONSTRAINT idViajePago ON Pago IS 'La llave foránea del viaje a que pertenece';
COMMENT ON CONSTRAINT idTarjetaPago ON Pago IS 'La llave foránea de la tarjeta a que pertenece';

--Tabla de la tarjeta bancaria.
CREATE TABLE TarjetaBancaria (
  idTarjetaBancaria serial,
  idTarjeta integer NOT NULL,
  Numero char(16) NOT NULL UNIQUE,
  nombreBanco varchar(20) NOT NULL,
  Expiracion date NOT NULL,
  CONSTRAINT idTarjetaBancaria PRIMARY KEY(idTarjetaBancaria),
  CONSTRAINT idTBFK FOREIGN KEY(idTarjeta) REFERENCES Tarjeta(idTarjeta)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  CONSTRAINT expirada CHECK(Expiracion >= current_date)
);

--Comentarios de la tabla Tarjeta Bancaria.
COMMENT ON TABLE TarjetaBancaria IS 'Para tarjetas';
COMMENT ON COLUMN TarjetaBancaria.idTarjetaBancaria IS 'la llave primaria asociada a la tarjeta bancaria';
COMMENT ON COLUMN TarjetaBancaria.idTarjeta IS 'referencia al id de tarjeta que se le asocia';
COMMENT ON COLUMN TarjetaBancaria.Numero IS 'el número de la tarjeta';
COMMENT ON COLUMN TarjetaBancaria.nombreBanco IS 'el nombre del banco al que pertenece la tarjeta';
COMMENT ON COLUMN TarjetaBancaria.Expiracion IS 'la fecha de expiración';
COMMENT ON CONSTRAINT idTarjetaBancaria ON TarjetaBancaria IS 'La llave primaria de una Tarjeta Bancaria.';
COMMENT ON CONSTRAINT idTBFK ON TarjetaBancaria IS 'La llave foránea de la tarjeta a la que pertenece.';

--Tabla de la tarjeta de puntos.
CREATE TABLE TarjetaDePuntos (
	idTarjetaPuntos serial,
	idTarjeta integer,
	Puntos integer DEFAULT 0,
	CONSTRAINT idTarjetaPuntos PRIMARY KEY(idTarjetaPuntos),
	CONSTRAINT idTPFK FOREIGN KEY(idTarjeta) REFERENCES Tarjeta(idTarjeta)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

--Comentarios de la tabla Tarjeta Bancaria.
COMMENT ON TABLE TarjetaDePuntos IS 'Para tarjetas';
COMMENT ON COLUMN TarjetaDePuntos.idTarjetaPuntos IS 'la llave primaria asociada a la tarjeta de puntos';
COMMENT ON COLUMN TarjetaDePuntos.idTarjeta IS 'referencia al id de tarjeta que se le asocia';
COMMENT ON COLUMN TarjetaDePuntos.Puntos IS 'el número de puntos que tiene un cliente';
COMMENT ON CONSTRAINT idTarjetaPuntos ON TarjetaDePuntos IS 'La llave primaria de una tarjeta de puntos.';
COMMENT ON CONSTRAINT idTPFK ON TarjetaDePuntos IS 'La llave foránea de la tarjeta a la que pertenece.';
