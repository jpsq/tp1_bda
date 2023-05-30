USE [AGMER]
GO

/****** Object:  Table [dbo].[DOCENTE]    Script Date: 30/5/2023 10:26:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DOCENTE](
	[legajo_docente] [int] NOT NULL,
	[cuil] [bigint] NULL,
	[nombre] [varchar](15) NULL,
	[apellido] [varchar](15) NULL,
	[sexo] [char](1) NULL,
	[telefono_fijo] [varchar](11) NOT NULL,
	[mail] [varchar](25) NOT NULL,
	[nro_domicilio] [int] NULL,
 CONSTRAINT [PK_DOCENTE] PRIMARY KEY CLUSTERED 
(
	[legajo_docente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

