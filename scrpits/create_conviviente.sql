CREATE TABLE
    CONVIVIENTE (
        dni_conviviente int NOT NULL,
        nombre varchar(15) NOT NULL,
        sexo char(1) NOT NULL,
        fecha_de_nacimiento date NOT NULL,
        CONSTRAINT PK_CONVIVIENTE PRIMARY KEY CLUSTERED (dni_conviviente ASC)
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