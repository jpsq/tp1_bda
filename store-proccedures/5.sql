CREATE OR ALTER PROCEDURE Ejercicio5
AS
BEGIN
	
	/*
	Información de costo asociado por inasistencias en general por año. 
	Considerar 30 días por mes para calcular el sueldo diario de cada docente.
	*/
	DECLARE @AUX_TABLE TABLE (
		Fecha DATE,
		Ausencia INT,
		Salario FLOAT
	);

	INSERT INTO @AUX_TABLE (Fecha, Ausencia, Salario)
	SELECT Fecha_Falta as Fecha, Ausencia, Salario_Bruto_Total/30 as Salario FROM 
		(SELECT DISTINCT FK_Docente as Docente, 
		FK_Cargo as Cargo, Salario_Bruto_Total, Start_Cargo, End_Cargo
		FROM EXPEDIENTE FOR SYSTEM_TIME ALL INNER JOIN CARGO FOR SYSTEM_TIME ALL
		ON FK_Cargo = Nro_Cargo
		WHERE End_Cargo >= Start_Expediente AND Start_Cargo <= End_Expediente
		) AS T1
	INNER JOIN
		(SELECT DISTINCT FK_Docente, FK_Inasistencia as Ausencia, Fecha_Falta
		FROM INASISTENCIA FOR SYSTEM_TIME ALL INNER JOIN INASISTENCIA_X_DOCENTE
		ON Nro_Inasistencia = FK_Inasistencia
		) AS T2
	ON Docente = FK_Docente
	WHERE Fecha_Falta BETWEEN Start_Cargo AND  End_Cargo;

	RETURN
	SELECT year(Fecha) as Año_Fecha, sum(Salario)/count(Ausencia) as Promedio_Costo
	FROM @AUX_TABLE GROUP BY year(Fecha);

END;