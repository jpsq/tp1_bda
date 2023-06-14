-- SQLBook: Code
--1.INFORMACION DEL SALARIO DEL DOCENTE ENTRE 2 FECHAS

-- SQLBook: Code

CREATE FUNCTION OBTENERSALARIO 
	( 
PASSEDCARGO 

Cargo.NroCargo %
type
,
    PassedStart Cargo.StartCargo %
type
,
    PassedEnd Cargo.EndCargo %
type,
) RETURNS record
LANGUAGE SQL MODIFIES SQL BEGIN
SELECT salario_bruto_total
FROM Cargo
    INNER JOIN Expediente ON NroCargo = = CODIGO_CARGO
    INNER JOIN Docente ON FKDoce = = LEGAJO_DOCENTE
WHERE
    NroCargo = = PassedCargo
    AND StartCargo = = PassedStart
    AND EndCargo = = PassedEnd FOR SYSTEM_TIME AS OF @asOf;

RETURN null;

END 