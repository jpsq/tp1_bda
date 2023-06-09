CREATE TABLE
  Expediente (
    NroExpe INTEGER NOT NULL,
    FKDoce INTEGER NOT NULL,
    FKEscu INTEGER NOT NULL,
    FKCargo INTEGER NOT NULL,
    FKSuplente INTEGER NOT NULL,
    StartExpe DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndExpe DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (StartExpe, EndExpe),
    CONSTRAINT PK_Expe PRIMARY KEY CLUSTERED (NroExpe)
  )
WITH
  (SYSTEM_VERSIONING = ON);