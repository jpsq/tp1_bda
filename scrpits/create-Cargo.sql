CREATE TABLE
  Cargo (
    NroCargo INTEGER NOT NULL,
    Descripcion CHAR(150) NOT NULL,
    SalarioBrutoTotal INTEGER NOT NULL,
    StartCargo DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndCargo DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartCargo, EndCargo),
    CONSTRAINT PK_Cargo PRIMARY KEY CLUSTERED (NroCargo)
  )
WITH
  (SYSTEM_VERSIONING = ON);