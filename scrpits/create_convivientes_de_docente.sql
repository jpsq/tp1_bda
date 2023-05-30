USE [AGMER]
GO

/****** Object:  Table [dbo].[CONVIVIENTES_DE_DOCENTE]    Script Date: 30/5/2023 10:29:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CONVIVIENTES_DE_DOCENTE](
	[legajo_docente] [int] NOT NULL,
	[dni_conviviente] [int] NOT NULL,
	[parentesco] [varchar](15) NOT NULL,
 CONSTRAINT [PK_CONVIVIENTES_DE_DOCENTE] PRIMARY KEY CLUSTERED 
(
	[legajo_docente] ASC,
	[dni_conviviente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CONVIVIENTES_DE_DOCENTE]  WITH CHECK ADD FOREIGN KEY([dni_conviviente])
REFERENCES [dbo].[CONVIVIENTE] ([dni_conviviente])
GO

ALTER TABLE [dbo].[CONVIVIENTES_DE_DOCENTE]  WITH CHECK ADD FOREIGN KEY([legajo_docente])
REFERENCES [dbo].[DOCENTE] ([legajo_docente])
GO

ALTER TABLE [dbo].[CONVIVIENTES_DE_DOCENTE]  WITH CHECK ADD  CONSTRAINT [FK_CONVIVIENTES_DE_DOCENTE_CONVIVIENTES_DE_DOCENTE] FOREIGN KEY([legajo_docente], [dni_conviviente])
REFERENCES [dbo].[CONVIVIENTES_DE_DOCENTE] ([legajo_docente], [dni_conviviente])
GO

ALTER TABLE [dbo].[CONVIVIENTES_DE_DOCENTE] CHECK CONSTRAINT [FK_CONVIVIENTES_DE_DOCENTE_CONVIVIENTES_DE_DOCENTE]
GO

