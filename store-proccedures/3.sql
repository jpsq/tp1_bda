CREATE OR ALTER PROCEDURE Ejercicio3 (
	@F_Inicial DATETIME2(7),
	@F_Final DATETIME2(7)
) AS
BEGIN
	/* Tabla a retornar con todos los datos de los Docentes */
	DECLARE @RESULTADO TABLE (
		Nro_Legajo INT,
		CUIL BIGINT, 
		Nombre VARCHAR(15),
		Apellido VARCHAR(15),
		Genero CHAR(1),
		Tel_Fijo VARCHAR(11),
		Email VARCHAR(25),
		FK_Domicilio INT
	)
	/* Tabla auxiliar */
	DECLARE @AUX_TABLE TABLE (
		Docente INT,
		Cargo INT
	)
	/* 
		T1 es la Lista de Docente y sus cargos durante el rango de tiempo establecido.
		T2 es la Lista de Cargos y sus Salarios durante el rango de tiempo establecido.
		El INNER JOIN me une las lista.
		EL WHERE me devuelve solo los registros de salario que entran en el rango donde 
		ese Docente tenia ese Cargo.
		El GROUP BY me agrupa todo por Docente y el count() me da la suma total.
		Si el Docente tiene un Contador mayor a 1 eso significa que sufrio un cambio en 
		su salario.
	*/
	INSERT INTO @AUX_TABLE (Docente, Cargo)
		SELECT FK_Docente, count(Nro_Cargo) AS Contador FROM
			(SELECT FK_Docente, FK_Cargo, Start_Expediente, End_Expediente 
			 FROM EXPEDIENTE FOR SYSTEM_TIME BETWEEN @F_Inicial AND @F_Final) AS T1
		INNER JOIN
			(SELECT Nro_Cargo, Salario_Bruto_Total, Start_Cargo, End_Cargo FROM CARGO 
			 FOR SYSTEM_TIME BETWEEN @F_Inicial AND @F_Final) AS T2
		ON T1.FK_Cargo = T2.Nro_Cargo
		WHERE Start_Cargo <= End_Expediente OR End_Cargo >= Start_Expediente
		GROUP BY FK_Docente;

	INSERT INTO @RESULTADO
		SELECT * FROM DOCENTE WHERE Nro_Legajo IN (SELECT Docente FROM @AUX_TABLE WHERE Cargo > 1)

	RETURN SELECT * FROM @RESULTADO;
END;