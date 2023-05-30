CREATE TABLE CARGO
(
	CODIGO_CARGO INT NOT NULL PRIMARY KEY CLUSTERED,
	DESCRIPCION VARCHAR(50),
	SALARIO_BRUTO_TOTAL FLOAT,
	FECHA_ASIGNACION_CARGO  DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	FECHA_QUITA_CARGO DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (FECHA_ASIGNACION_CARGO,FECHA_QUITA_CARGO)
)
WITH (SYSTEM_VERSIONING=ON);