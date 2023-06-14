-- SQLBook: Code
CREATE TABLE
    DOCENTE (
        legajo_docente int NOT NULL,
        cuil bigint NULL,
        nombre varchar(15) NULL,
        apellido varchar(15) NULL,
        sexo char(1) NULL,
        telefono_fijo varchar(11) NOT NULL,
        mail varchar(25) NOT NULL,
        nro_domicilio int NULL,
        CONSTRAINT PK_DOCENTE PRIMARY KEY CLUSTERED (legajo_docente ASC)
        WITH
            (
                PAD_INDEX = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                IGNORE_DUP_KEY = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON,
                OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
            ) ON PRIMARY
    );