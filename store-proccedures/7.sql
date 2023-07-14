CREATE OR ALTER PROCEDURE Ejercicio7
AS
BEGIN

	DECLARE @answer INT;
	DECLARE @AUX_TABLE TABLE (
		AÑO INT,
		Total_Faltas INT
	);

	INSERT INTO @AUX_TABLE (AÑO, Total_Faltas)
	SELECT Año, sum(Faltas) FROM 
	(
		SELECT year(Fecha_Falta) as Año, count(Nro_Inasistencia) as Faltas
		FROM INASISTENCIA FOR SYSTEM_TIME ALL
		GROUP BY year(Fecha_Falta)
		UNION
		SELECT year(Fecha_Emision) as Año, sum(datediff(day, Start_Licencia, End_Licencia)) as Faltas
		FROM LICENCIA FOR SYSTEM_TIME ALL
		INNER JOIN CONSTANCIA ON FK_Constancia = Nro_Constancia
		WHERE Tipo != 'Enfermedad' AND Tipo != 'Cuidado'
		GROUP BY year(Fecha_Emision)
	) as T1 GROUP BY Año;

	SELECT @answer = (SELECT sum(Total_Faltas) FROM @AUX_TABLE) / (SELECT count(AÑO) FROM @AUX_TABLE);

	RETURN @answer

END;

EXEC Ejercicio7