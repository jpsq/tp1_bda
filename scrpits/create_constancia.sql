-- SQLBook: Code
CREATE TABLE
    CONSTANCIA (
        codigo_constancia int NOT NULL,
        descripcion varchar(60) NOT NULL,
        fecha_emision date NOT NULL,
        CONSTRAINT PK_CONSTANCIA PRIMARY KEY CLUSTERED (codigo_constancia ASC)
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