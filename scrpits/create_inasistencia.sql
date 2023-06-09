CREATE TABLE
	INASISTENCIA (
		CODIGO_INASISTENCIA INT PRIMARY KEY,
		DIA_DE_FALTA DATE,
		DESCRIPCION VARCHAR(100),
		INICIO_INASISTENCIA DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
		FIN_INASISTENCIA DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
		PERIOD FOR SYSTEM_TIME (INICIO_INASISTENCIA, FIN_INASISTENCIA)
	)
WITH
	(SYSTEM_VERSIONING = ON);