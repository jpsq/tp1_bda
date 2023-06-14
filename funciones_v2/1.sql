CREATE FUNCTION ObtenerSalarioEmpleado(
    @legajo_docente int,
    @fecha_inicio datetime,
    @fecha_fin datetime
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.Descripcion AS Cargo,
        e.SalarioBrutoTotal AS Salario,
        v.StartCargo AS FechaInicio,
        v.EndCargo AS FechaFin
    FROM Expediente v
    INNER JOIN Cargo c ON v.FKCargo = c.NroCargo
    WHERE
        v.FKDoce = @legajo_docente
        AND v.StartCargo <= @fecha_fin
        AND v.EndCargo >= @fecha_inicio
);
