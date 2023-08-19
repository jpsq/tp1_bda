/*
	Porcentaje de distribución de asistencia, inasistencia por año y escuela
	El suario le pasa el año y escuela al procedimiento

	Se tendra en conosideración 160 dias de trabajo anual y no se consideraran los meses de enero y febrero.
*/
CREATE OR ALTER PROCEDURE Ejercicio8 (
	@year INT,
	@school INT,
	@Ausencias INT OUTPUT,
	@Asistencias INT OUTPUT
) AS
BEGIN
	DECLARE @AUX_DATES TABLE (
			Fecha_A DATETIME2,
			Fecha_B DATETIME2);
	DECLARE @AUX_TABLE TABLE (
			Asistencias INT,
			Ausencias INT);
	


	/* Aca creamos dos columnas que contendran las fechas de inicio y fin de cada cargo segun el año y escuela pasados por parametro.
	Si el Docente posee ese cargo desde antes de ese año se comenzara a contar desde el primero de marzo.
	Si el Docente posee ese cargo despues de terminado el año el conteo finaliza el ultima dia del año.
	Deliberadamente sacamos de la ecuación los meses de enero y febrero.*/
	INSERT INTO @AUX_DATES (Fecha_A, Fecha_B)
	SELECT  
		CASE
			WHEN (YEAR(Start_Expediente) < @year OR MONTH(Start_Expediente) < 3)
				THEN DATEADD(year, @year - 2000, 2000/03/01)
			ELSE Start_Expediente
		END AS 'Inicio',
		CASE
			WHEN (YEAR(End_Expediente) > @year)
				THEN DATEADD(YEAR, @year - 2000, 2000/12/31)
			ELSE End_Expediente
		END AS 'Final'
	FROM EXPEDIENTE FOR SYSTEM_TIME ALL
	WHERE YEAR(Start_Expediente) <= @year AND YEAR(End_Expediente) >= @year AND FK_Escuela = @school;



	/* Aca obtendremos el total de ausencias dadas en la escuela y año elegidos*/
	INSERT INTO @AUX_TABLE (Ausencias)
	SELECT count(Falta) as Inasistencias FROM EXPEDIENTE FOR SYSTEM_TIME ALL INNER JOIN (
		SELECT FK_Docente as Docente, Fecha_Falta as Falta FROM INASISTENCIA FOR SYSTEM_TIME ALL 
		INNER JOIN INASISTENCIA_X_DOCENTE ON Nro_Inasistencia = FK_Inasistencia
	) AS T1 ON FK_Docente = Docente
	WHERE YEAR(Falta) = @year AND FK_Escuela = @school;



	/* Aca obtendremos el total de dias de trabajo de los docentes y los acumularemos en un solo valor.
	El total de dias se dividira por 30 y se multiplicara por 16 para obtener el total "exacto" de dias laborales */
	INSERT INTO @AUX_TABLE (Asistencias)
	SELECT (COUNT(DATEDIFF(day, Fecha_A, Fecha_B)) / 30 * 16) as Dias_Totales FROM @AUX_DATES;



	/* Por ultimo en el return mostraremos los */
	SELECT @Ausencias =((Asistencias - Ausencias) * 100 / Asistencias) FROM @AUX_TABLE;
	SELECT @Ausencias = (Ausencias * 100 / Asistencias) FROM @AUX_TABLE;
	RETURN;
END;


DECLARE @Porc_Asistencias INT;
DECLARE @Porc_Ausencias INT;

EXECUTE Ejercicio8 2023, 3, @Porc_Asistencias OUTPUT, @Porc_Ausencias OUTPUT;

SELECT @Porc_Asistencias, @Porc_Ausencias;