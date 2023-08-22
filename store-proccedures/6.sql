/*
	Promedio anual de días de vacaciones tomados por cargo y por escuela. Considerar para el promedio 160 días trabajo.

	Agarrar todos los dias de vacaciones tomados por ese cargo y esa escuela, luego sumarlos y dividirlos por la cantidad de años,
	para esto tendremos que sacar la diferencia de años restando el primer año desde ese cargo por el año actual.
*/
CREATE OR ALTER PROCEDURE Ejercicio6 (
	@charge INT,
	@school INT,
	@Prom INT OUTPUT
) AS
BEGIN
	DECLARE @minyear INT;
	DECLARE @maxyear INT;
	DECLARE @totaldays INT;
	DECLARE @AUXTABLE TABLE (
		Inicio DATETIME2,
		Final DATETIME2
	);

	/* 
	Paso 1: conseguir todas las licencias por vacaciones 
		SELECT FK_Docente as Docente, Start_Licencia, End_Licencia 
		FROM LICENCIA FOR SYSTEM_TIME ALL WHERE Tipo LIKE 'Vacaciones';
	*/

	/* 
	Paso 2: Ver si los docentes que tomaron esas licencias ocupan el cargo y escuela elegidos 
		SELECT Start_Licencia, End_Licencia, Start_Expediente, End_Expediente 
		FROM EXPEDIENTE FOR SYSTEM_TIME ALL INNER JOIN (
			SELECT FK_Docente as Docente, Start_Licencia, End_Licencia 
			FROM LICENCIA FOR SYSTEM_TIME ALL WHERE Tipo LIKE 'Vacaciones'
		) AS T1 ON FK_Docente = Docente
		WHERE FK_Cargo = @charge AND FK_Escuela = @school;
	*/

	/* Paso 3: asegurarnos que las fechas de las licencias concuerdan con las de los expedientes */
	INSERT INTO @AUXTABLE (Inicio, Final)
	SELECT Start_Licencia, End_Expediente FROM (
		SELECT Start_Licencia, End_Licencia, Start_Expediente, End_Expediente 
		FROM EXPEDIENTE FOR SYSTEM_TIME ALL INNER JOIN (
			SELECT FK_Docente as Docente, Start_Licencia, End_Licencia 
			FROM LICENCIA FOR SYSTEM_TIME ALL WHERE Tipo LIKE 'Vacaciones'
		) AS T1 ON FK_Docente = Docente
		WHERE FK_Cargo = @charge AND FK_Escuela = @school
	) as T2
	WHERE Start_Licencia >= Start_Expediente AND End_Licencia <= End_Expediente;

	/* Paso 4: extraer los dias de vacaciones totales y el año de las primeras y ultimas vacaciones */
	SELECT @minyear = MIN(YEAR(Inicio)), @maxyear = CASE
		WHEN (MAX(YEAR(Final)) < YEAR(GETDATE()))
			THEN MAX(YEAR(Final))
		ELSE YEAR(GETDATE())
	END,
	@totaldays = SUM(DATEDIFF(day, Inicio, Final)) 
	FROM @AUXTABLE;

	/* Paso 5: promediar */
	SELECT @Prom = (@totaldays / (@maxyear - @minyear + 1));
	RETURN @Prom;
END;