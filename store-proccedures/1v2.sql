-- SQLBook: Code

CREATE FUNCTION OBTENERSALARIOSBRUTOSTOTALES(@FECHAINICIO 
DATETIME, @FECHAFIN DATETIME) RETURNS TABLE AS 
	RETURN ( SELECT SalarioBrutoTotal FROM 
CARGO 

WHERE StartCargo <= @FechaFin AND EndCargo >= @FechaInicio );
---------------
CREATE FUNCTION ObtenerSalariosBrutosTotales
(
    @FechaInicio DATETIME,
    @FechaFin DATETIME,
    @LegajoDocente INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT c.SalarioBrutoTotal
    FROM Cargo c
    INNER JOIN Expediente e ON c.NroCargo = e.CODIGO_CARGO
    WHERE c.StartCargo <= @FechaFin AND c.EndCargo >= @FechaInicio
    AND e.LEGAJO_DOCENTE = @LegajoDocente
);