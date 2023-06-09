USE jirho_bda GO
/****** Object:  Table [dbo].[ESCUELA]    Script Date: 30/5/2023 11:09:39 ******/
SET
	ANSI_NULLS ON GO
SET
	QUOTED_IDENTIFIER ON GO
CREATE TABLE
	ESCUELA (
		numero int NOT NULL,
		nombre varchar(30) NULL,
		direccion varchar(30) NULL,
		CONSTRAINT PK_ESCUELA PRIMARY KEY CLUSTERED (numero ASC)
		WITH
			(
				PAD_INDEX = OFF,
				STATISTICS_NORECOMPUTE = OFF,
				IGNORE_DUP_KEY = OFF,
				ALLOW_ROW_LOCKS = ON,
				ALLOW_PAGE_LOCKS = ON,
				OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON PRIMARY
	) ON PRIMARY GO