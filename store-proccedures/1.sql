CREATE FUNCTION OBTENER_SALARIO
(
    @legajo_docente INT,
    @fecha_inicio DATE,
    @fecha_fin DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT D.legajo_docente, D.cuil, D.nombre, D.apellido, D.sexo, D.telefono_fijo, D.mail, C.salario_bruto_total
    FROM DOCENTE AS D
    JOIN Expediente E
    ON D.legajo_docente=E.FKDoce
    JOIN CARGO FOR SYSTEM_TIME ALL AS C ON E.FKCargo = C.codigo_cargo
    WHERE D.legajo_docente = @legajo_docente
    AND C.FECHA_ASIGNACION_CARGO <= @fecha_fin
    AND (C.FECHA_QUITA_CARGO >= @fecha_inicio OR C.FECHA_QUITA_CARGO IS NULL)
)


select * FROM OBTENER_SALARIO(3,'0001-01-01','9999-12-31')