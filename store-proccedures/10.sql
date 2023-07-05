CREATE OR ALTER PROCEDURE Ejercicio10
AS
BEGIN
	
	/* 
	T1 me da la lista de Docentes y escuelas en las que han trabajado.
	T2 me da la lista de Docentes y cada una de sus Inasistencias.
	El INNER JOIN me da la lista de Ausencias de cada docente por Escuela.
	El GROUP BY me los agrupa primero por Escuela, uego por Año y por ultimo por Docente.
	Y el ORDER BY me ordena todo segun la cantidad de Faltas.
	*/

	SELECT FK_Escuela, year(Fecha_Falta) AS Año, Docente, count(Fecha_Falta) AS Total_Ausencias
	FROM 
		(SELECT DISTINCT FK_Docente AS Docente, FK_Escuela, Start_Expediente, End_Expediente 
		FROM EXPEDIENTE) AS T1
	INNER JOIN 
		(SELECT DISTINCT FK_Docente, Fecha_Falta
		FROM INASISTENCIA INNER JOIN INASISTENCIA_X_DOCENTE 
		ON FK_Inasistencia = Nro_Inasistencia) AS T2
	ON Docente = FK_Docente
	WHERE Fecha_Falta BETWEEN Start_Expediente AND End_Expediente
	GROUP BY FK_Escuela, year(Fecha_Falta), Docente
	ORDER BY count(Fecha_Falta) DESC;

END;