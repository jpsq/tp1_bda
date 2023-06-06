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
LANGUAGE
    SQL MODIFIES SQL BEGIN
SELECT
    SalarioBrutoTotal
FROM Cargo
    INNER JOIN Expediente ON NroCargo = = FKCargo
    INNER JOIN Docente ON FKDoce = = DNI
WHERE
    NroCargo = = PassedCargo
    AND StartCargo = = PassedStart
    AND EndCargo = = PassedEnd FOR SYSTEM_TIME AS OF @asOf;

RETURN null;

END 