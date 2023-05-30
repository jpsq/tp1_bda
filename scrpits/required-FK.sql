ALTER TABLE Expediente
ADD CONSTRAINT Doce_Expe /* Docente tiene una FK en Expediente */
FOREIGN KEY (FKDoce) REFERENCES Docente(DNI);

ALTER TABLE Expediente
ADD CONSTRAINT Escu_Expe /* Escuela tiene una FK en Expediente */
FOREIGN KEY (FKEscu) REFERENCES Escuela(NroEscu);

ALTER TABLE Expediente
ADD CONSTRAINT Cargo_Expe /* Cargo tiene una FK en Expediente */
FOREIGN KEY (FKCargo) REFERENCES Cargo(NroCargo);

ALTER TABLE Expediente
ADD CONSTRAINT Suple_Expe /* Docente tiene una segunda FK en Expediente */
FOREIGN KEY (FKSuplente) REFERENCES Docente(DNI);
