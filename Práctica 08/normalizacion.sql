SET search_path TO geografico;

--Tabla Abreviatura.
CREATE TABLE Abreviatura (
	nombre_estado varchar(50) NOT NULL,
	abreviatura varchar(10) NOT NULL,
	CONSTRAINT nombre_estado PRIMARY KEY(nombre_estado)
);

--Comentarios de la tabla Persona.
COMMENT ON TABLE Abreviatura IS 'Para representar la abreviatura de un estado';
COMMENT ON COLUMN Abreviatura.nombre_estado IS 'Nombre del estado';
COMMENT ON COLUMN Abreviatura.abreviatura IS 'La abreviatura del estado';
COMMENT ON CONSTRAINT nombre_estado ON Abreviatura IS 'La llave primaria que es el estado asociado a cada abreviatura';

--Tabla Municipio
CREATE TABLE Municipio (
	nombre_municipio varchar(50) NOT NULL,
	nombre_estado varchar(50) NOT NULL,
	CONSTRAINT nombre_municipio PRIMARY KEY(nombre_municipio),
	CONSTRAINT nombre_estado FOREIGN KEY(nombre_estado) REFERENCES Abreviatura(nombre_estado)
);

--Comentarios de la tabla Municipio.
COMMENT ON TABLE Municipio IS 'Para representar los municipios de un estado';
COMMENT ON COLUMN Municipio.nombre_municipio IS 'Nombre del municipio';
COMMENT ON COLUMN Municipio.nombre_estado IS 'El nombre del estado al que pertenece el municipio';
COMMENT ON CONSTRAINT nombre_municipio ON Municipio IS 'La llave primaria que es el municipio asociado a cada estado';
COMMENT ON CONSTRAINT nombre_estado ON Municipio IS 'La llave foranea que es el estado asociado a cada municipio';

--Tabla Cabecera Distrital Local
CREATE TABLE CabeceraDL (
	cabecera_distrital_local varchar(50) NOT NULL,
	nombre_estado varchar(50) NOT NULL,
	CONSTRAINT cabecera_distrital_local PRIMARY KEY(cabecera_distrital_local),
	CONSTRAINT nombre_estado FOREIGN KEY(nombre_estado) REFERENCES Abreviatura(nombre_estado)
);

--Comentarios de la tabla Cabecera Distrital Local.
COMMENT ON TABLE geografico.CabeceraDL IS 'Para representar las Cabecera Distrital Local de un estado';
COMMENT ON COLUMN CabeceraDL.cabecera_distrital_local IS 'Cabecera Distrital Local de un estado';
COMMENT ON COLUMN CabeceraDL.nombre_estado IS 'El nombre del estado al que pertenece el Cabecera Distrital Local';
COMMENT ON CONSTRAINT cabecera_distrital_local ON CabeceraDL IS 'La llave primaria que es la Cabecera Distrital Local asociado a cada estado';
COMMENT ON CONSTRAINT nombre_estado ON CabeceraDL IS 'La llave foranea que es el estado asociado a cada Cabecera Distrital Local';

--Tabla Cabecera Distrital Federal
CREATE TABLE CabeceraDF (
	cabecera_distrital_federal varchar(50) NOT NULL,
	nombre_estado varchar(50) NOT NULL,
	CONSTRAINT cabecera_distrital_federal PRIMARY KEY(cabecera_distrital_federal),
	CONSTRAINT nombre_estado FOREIGN KEY(nombre_estado) REFERENCES Abreviatura(nombre_estado)
);

--Comentarios de la tabla Cabecera Distrital Federal.
COMMENT ON TABLE CabeceraDF IS 'Para representar las Cabecera Distrital Federal de un estado';
COMMENT ON COLUMN CabeceraDF.cabecera_distrital_federal IS 'Cabecera Distrital Federal de un estado';
COMMENT ON COLUMN CabeceraDL.nombre_estado IS 'El nombre del estado al que pertenece el Cabecera Distrital Federal';
COMMENT ON CONSTRAINT cabecera_distrital_federal ON CabeceraDF IS 'La llave primaria que es la Cabecera Distrital Federal asociado a cada estado';
COMMENT ON CONSTRAINT nombre_estado ON CabeceraDF IS 'La llave foranea que es el estado asociado a cada Cabecera Distrital Federal';

--Tabla Secciones
CREATE TABLE Seccion (
	nombre_estado varchar(50) NOT NULL,
	seccion numeric(5) NOT NULL,
	tipo varchar(1) NOT NULL,
	cabecera_distrital_federal varchar(50) NOT NULL,
	cabecera_distrital_local varchar(50) NOT NULL,
	nombre_municipio varchar(50) NOT NULL,
	CONSTRAINT idSeccion PRIMARY KEY(nombre_estado, seccion, tipo),
	CONSTRAINT cabecera_distrital_federal FOREIGN KEY(cabecera_distrital_federal) REFERENCES CabeceraDF(cabecera_distrital_federal),
	CONSTRAINT cabecera_distrital_local FOREIGN KEY(cabecera_distrital_local) REFERENCES CabeceraDL(cabecera_distrital_local),
	CONSTRAINT nombre_municipio FOREIGN KEY(nombre_municipio) REFERENCES Municipio(nombre_municipio)
	
);

--Comentarios de la tabla Seccion.
COMMENT ON TABLE Seccion IS 'Para representar las secciones de un país';
COMMENT ON COLUMN Seccion.nombre_estado IS 'Nombre del estado';
COMMENT ON COLUMN Seccion.seccion IS 'Seccion de un estado';
COMMENT ON COLUMN Seccion.tipo IS 'Tipo de un estado';
COMMENT ON COLUMN Seccion.cabecera_distrital_federal IS 'Cabecera Distrital Federal de un estado';
COMMENT ON COLUMN Seccion.cabecera_distrital_local IS 'Cabecera Distrital Local de un estado';
COMMENT ON COLUMN Seccion.nombre_municipio IS 'Nombre del municipio';
COMMENT ON CONSTRAINT idSeccion ON Seccion IS 'La llave primaria compuesta de las secciones';
COMMENT ON CONSTRAINT cabecera_distrital_federal ON Seccion IS 'La llave foranea que es la Cabecera Distrital Federal asociado a cada seccion';
COMMENT ON CONSTRAINT cabecera_distrital_local ON Seccion IS 'La llave foranea que es la Cabecera Distrital Local asociado a cada seccion';
COMMENT ON CONSTRAINT nombre_municipio ON Seccion IS 'La llave foranea que es el municipio asociado a cada seccion';
