CREATE FUNCTION OBTENER_DOMICILIO
(
    @legajo_docente INT,
    @fecha_inicio DATE,
    @fecha_fin DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT D.legajo_docente, D.cuil, D.nombre, D.apellido, D.sexo, D.telefono_fijo, DO.CALLE,DO.NUMERO,DO.CODIGO_POSTAL
    FROM DOCENTE AS D
    JOIN DOMICILIO FOR SYSTEM_TIME ALL AS DO ON DO.CODIGO_DOMICILIO = D.nro_domicilio
    WHERE D.legajo_docente = @legajo_docente
    AND DO.INICIO_DOMICILIO <= @fecha_fin
    AND (DO.FIN_DOMICILIO >= @fecha_inicio OR DO.FIN_DOMICILIO IS NULL)
)


select * FROM OBTENER_DOMICILIO(3,'0001-01-01','9999-12-31')