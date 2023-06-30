CREATE FUNCTION dbo.OBTENER_ASISTENCIA (
    @LegajoEmpleado int,
    @FechaInicio date,
    @FechaFin date
)
RETURNS INT
AS
BEGIN
    DECLARE @DiasAsistencia INT;

    -- Calcular la diferencia en días entre las fechas
    SET @DiasAsistencia = DATEDIFF(day, @FechaInicio, @FechaFin);

    -- Restar los días de inasistencia del empleado
    SET @DiasAsistencia = @DiasAsistencia - (
        SELECT COUNT(D.legajo_docente)
		FROM DOCENTE D
		INNER JOIN INASISTENCIAS_DOCENTES ID
		ON ID.DNI_DOCENTE=D.legajo_docente
		INNER JOIN INASISTENCIA I
		ON I.CODIGO_INASISTENCIA = ID.CODIGO_INASISTENCIA
		WHERE D.legajo_docente = @LegajoEmpleado
        AND I.DIA_DE_FALTA >= @FechaInicio AND I.DIA_DE_FALTA <= @FechaFin
    );

    -- Retornar el resultado
    RETURN @DiasAsistencia;
END;