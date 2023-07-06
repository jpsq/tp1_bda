CREATE OR ALTER PROCEDURE Ejercicio9
AS BEGIN
	/* Porcentaje de distribucion de inasistencias por año y titular / suplentes. */
	DECLARE @AUX_INT INT;

	SELECT @AUX_INT = count(Nro_inasistencia) FROM INASISTENCIA;
	/**/
	RETURN
	/* Porcentaje de distribucion de inasistencias por año y suplentes. */
	SELECT Suplente as Nro_Legajo, 'Suplente' as Rol, year(Fecha_Falta) as Year, (count(Fecha_Falta) * 100 / @AUX_INT) as Porcentaje FROM 
		/* Lista de Docentes con cada falta que han cometido cada uno */
		(SELECT Nro_Inasistencia, Fecha_Falta, FK_Docente 
		FROM INASISTENCIA FOR SYSTEM_TIME ALL AS I
		INNER JOIN INASISTENCIA_X_DOCENTE AS IXD
		ON Nro_Inasistencia = FK_Inasistencia) AS T1
	INNER JOIN
		/* Lista de Suplentes con sus rangos de tiempo */
		(SELECT FK_Suplente as Suplente, Start_Expediente, End_Expediente 
		FROM EXPEDIENTE FOR SYSTEM_TIME ALL) AS T2
	ON FK_Docente = Suplente
	WHERE Fecha_Falta BETWEEN Start_Expediente AND End_Expediente
	GROUP BY Suplente, year(Fecha_Falta)
	UNION
	/* Porcentaje de distribucion de inasistencias por año y Titulares. */
	SELECT Titular as Nro_Legajo, 'Titular' as Rol, year(Fecha_Falta) as Year, (count(Fecha_Falta) * 100 / @AUX_INT) as Porcentaje FROM 
		/* Lista de Docentes con cada falta que han cometido cada uno */
		(SELECT Nro_Inasistencia, Fecha_Falta, FK_Docente 
		FROM INASISTENCIA FOR SYSTEM_TIME ALL AS I
		INNER JOIN INASISTENCIA_X_DOCENTE AS IXD
		ON Nro_Inasistencia = FK_Inasistencia) AS T1
	INNER JOIN
		/* Lista de Titulares con sus rangos de tiempo */
		(SELECT FK_Docente as Titular, Start_Expediente, End_Expediente 
		FROM EXPEDIENTE FOR SYSTEM_TIME ALL) AS T2
	ON FK_Docente = Titular
	WHERE Fecha_Falta BETWEEN Start_Expediente AND End_Expediente
	GROUP BY Titular, year(Fecha_Falta)
	ORDER BY Rol, A�o;
	
END;