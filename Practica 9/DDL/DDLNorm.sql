--Nuevas tablas normalizadas.
--Tabla para marcas y submarcas de un automovil
CREATE TABLE Automovil2 (
Marca varchar(20) NOT NULL,
Submarca varchar(20) NOT NULL,
CONSTRAINT submarca PRIMARY KEY(Submarca)
);

--Comentarios de la tabla Automovil2.
COMMENT ON TABLE Automovil2 IS 'Para representar las marcas y submarcas de un automóvil';
COMMENT ON COLUMN Automovil2.Marca IS 'La marca del automóvil';
COMMENT ON COLUMN Automovil2.Submarca IS 'La submarca del automóvil';
COMMENT ON CONSTRAINT submarca ON Automovil2 IS 'La llave primaria representada por la submarca del automóvil';

--Tabla para un automóvil1.
CREATE TABLE Automovil1 (
	Placas char(6),
	Submarca varchar(20) NOT NULL,
	Año smallint NOT NULL,
	Color varchar(20) NOT NULL,
	numPuertas smallint NOT NULL,
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
PrecioFactura numeric NOT NULL,
Submarca varchar(20) NOT NULL,
Año smallint NOT NULL,
Color varchar(20) NOT NULL,
numPuertas smallint,
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

--Para pasar toda la información a la nueva tabla normalizada.

--Marcas y Submarcas: Automovil2
INSERT INTO Automovil2
SELECT DISTINCT Marca, Submarca
FROM Automovil;

--Automoviles con placas: Automovil1
INSERT INTO Automovil1
SELECT DISTINCT Placas, Submarca, Año, Color, numPuertas
FROM Automovil;

--Precios de los automóviles: Automovil3
INSERT INTO Automovil3
SELECT DISTINCT PrecioFactura, Submarca, Año, Color, numPuertas
FROM Automovil;

--Modificamos las referencias de las tablas Viaje y Manejar.
ALTER TABLE Viaje
DROP CONSTRAINT Placas;

ALTER TABLE Manejar
DROP CONSTRAINT Placas;

--Volvemos a agregar las restricciones.
ALTER TABLE Viaje
ADD CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil1(Placas);

ALTER TABLE Manejar
ADD CONSTRAINT Placas FOREIGN KEY(Placas) REFERENCES Automovil1(Placas);

--Borra la tabla original.
DROP TABLE automovil;
