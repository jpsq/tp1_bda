CREATE DATABASE ejemplo;

USE ejemplo;

--ejemplo de microsoft
CREATE TABLE Department
(
    DepartmentNumber CHAR(10) NOT NULL PRIMARY KEY CLUSTERED,
    DepartmentName VARCHAR(50) NOT NULL,
    ManagerID INT NULL,
    ParentDepartmentNumber CHAR(10) NULL,
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (SYSTEM_VERSIONING = ON);

--select de la tabla vacia
SELECT * FROM Department;

--insertamos un departamento
INSERT INTO Department VALUES (
    'ABC-CBA',
    'prueba',
    100,
    NULL
)

--select de la tabla con 1 dpto
SELECT * FROM Department;

--actualizamos la info
UPDATE Department SET ManagerID = 200 WHERE DepartmentNumber = 'ABC-CBA';

--select de la tabla con 1 dpto actualizado
SELECT * FROM Department;

--hasta acá nada fuera de lo normal
--pero con esta implementación podemos obtener el resultado anterior

SELECT DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
        SysStartTime, SysEndTime
  FROM Department
    FOR SYSTEM_TIME ALL;

--borramos el registro 
DELETE FROM Department WHERE DepartmentNumber = 'ABC-CBA';

--vemos la tabla vacía
SELECT * FROM Department;
--y la histórica
SELECT DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
        SysStartTime, SysEndTime
  FROM Department
    FOR SYSTEM_TIME ALL;

--FOR SYSTEM_TIME ALL nos da el histórico completo
--Cómo obtener el valor en un momento específico?
SELECT DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
        SysStartTime, SysEndTime
  FROM Department
    FOR SYSTEM_TIME AS OF '2020-06-01 02:10:10';

--Todos los posibles escenarios en:
--https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-table-usage-scenarios?redirectedfrom=MSDN&view=sql-server-ver15


--la implementación de SQL SERVER guarda los datos en UTC y por el momento no puede ser cambiada al uso de una zona horaria.
--la alternativa que nos queda es intentar utilizar alguna de las herramientas que ya conocemos para hacer manejo más sencillo o natural.

--distintos resultados para "ahora"
SELECT SYSDATETIME() AS [SYSDATETIME()]  
    ,SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET()]  
    ,SYSUTCDATETIME() AS [SYSUTCDATETIME()]  
    ,CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP]  
    ,GETDATE() AS [GETDATE()]  
    ,GETUTCDATE() AS [GETUTCDATE()];  

--probemos usar una función para transformar una fecha UTF en una de nuestra zona horaria
CREATE FUNCTION fn_UtfALocal (
    @fechaHoraUTF datetime
)
RETURNS datetime
AS
BEGIN
    DECLARE @fechaHoraLocal datetime;

    SET @fechaHoraLocal = (
        --restamos a la fecha y hora pasada por parametro
        --la diferencia entre la hora local y la hora UTC
        dateadd(
            hour,(
                cast(
                    datepart(
                        hour,
                        SYSDATETIME()
                    ) as int
                ) 
                - cast(
                    datepart(
                        hour,
                        SYSUTCDATETIME()
                    ) as int
                )
            ),
            @fechaHoraUTF
        )
    );
    
    RETURN @fechaHoraLocal;
END;

--veamos ahora el histórico pero con hora local
SELECT DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
        dbo.fn_UtfALocal(SysStartTime), dbo.fn_UtfALocal(SysEndTime)
  FROM Department
    FOR SYSTEM_TIME ALL;
--NOTA: Ojo al tratar con esos datos ya que están truncados

--ahora deberíamos hacer la función pero inversa
CREATE FUNCTION fn_LocalAUtf (
    @fechaHoraLocal datetime
)
RETURNS datetime
AS
BEGIN
    DECLARE @fechaHoraUTF datetime;

    SET @fechaHoraUTF = (
        --sumamos a la fecha y hora pasada por parametro
        --la diferencia entre la hora UTC y la hora local
        dateadd(
            hour,(
                cast(
                    datepart(
                        hour,
                        SYSUTCDATETIME()
                    ) as int
                ) 
                - cast(
                    datepart(
                        hour,
                        SYSDATETIME()
                    ) as int
                )
            ),
            @fechaHoraLocal
        )
    );
    
    RETURN @fechaHoraUTF;
END;

--probemos el ejemplo completo
--debemos almacenar el resultado de la función en una variable, no podemos pasarla directamente
DECLARE @asOf datetime2 = dbo.fn_LocalAUtf(cast('2020-05-31 23:10:10' as DATETIME2));
SELECT DepartmentNumber, DepartmentName, ManagerID, ParentDepartmentNumber,
        dbo.fn_UtfALocal(SysStartTime), dbo.fn_UtfALocal(SysEndTime)
  FROM Department
    FOR SYSTEM_TIME AS OF @asOf;


--Donde se almacenan los valores históricos?
--veamos todas las tablas
SELECT * FROM INFORMATION_SCHEMA.TABLES;

--hay una tabla que no está en el explorador.. vemos el contenido:
SELECT * FROM MSSQL_TemporalHistoryFor_885578193; --puede cambiar ese número
--et voilà.... lindo nombre para una tabla no?

--empecemos de nuevo
DROP TABLE Department;
--ERROR!

--la tabla esta bloqueada por el versionado
--además como vimos son dos tablas las que debemos borrar

--1ro, desactivamos el versionado
ALTER TABLE Department SET ( SYSTEM_VERSIONING = OFF);
--2do drop de la tabla actual
DROP TABLE Department;
--3ro drop de la histórica
DROP TABLE MSSQL_TemporalHistoryFor_885578193;

--por las dudas chequeamos
SELECT * FROM INFORMATION_SCHEMA.TABLES;

--volvemos a ejecutar el ejemplo 
--pero esta vez le indicamos el nombre de la tabla donde se almacenarán los datos históricos
CREATE TABLE Department
(
    DepartmentNumber CHAR(10) NOT NULL PRIMARY KEY CLUSTERED,
    DepartmentName VARCHAR(50) NOT NULL,
    ManagerID INT NULL,
    ParentDepartmentNumber CHAR(10) NULL,
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory));


--por las dudas chequeamos
SELECT * FROM INFORMATION_SCHEMA.TABLES;
--mejor no?

--volvemos a insertar nuestra prueba
INSERT INTO Department VALUES (
    'ABC-CBA',
    'prueba',
    100,
    NULL
)

--volvemos a actualizar
UPDATE Department SET ManagerID = 200 WHERE DepartmentNumber = 'ABC-CBA';

--que sucede al agregar una columna
ALTER TABLE Department ADD Phone VARCHAR(20);
--???
select * from Department;
select * from DepartmentHistory;
--excelente no hay drama para agregar

--y para eliminar?
ALTER TABLE Department DROP COLUMN ManagerID;
--lo mismo
select * from Department;
select * from DepartmentHistory;

--no hay restricciones desde el motor para agregar y/o eliminar columnas.
--lo que si al eliminar la columna ManagerID, perdimos el único dato que había cambiado

--dependiendo el caso, si querríamos mantener esta información luego del DROP COLUMN,
--podríamos dejar la tabla histórica como está y crear una nueva para seguir el histórico
--de cambios en otra tabla con la nueva estructura.
--esto lo podemos hacer:
--1ro, desactivamos el versionado
ALTER TABLE Department SET ( SYSTEM_VERSIONING = OFF);
--2do, hacemos los cambios necesarios sobre la tabla
--alter + add, drop, etc.
--3ro, activamos el versionado pero con una nueva tabla historica:
ALTER TABLE Department SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory2));

--que nos queda?
select * from Department;
select * from DepartmentHistory;
select * from DepartmentHistory2;

SELECT *,
        dbo.fn_UtfALocal(SysStartTime), dbo.fn_UtfALocal(SysEndTime)
  FROM Department
    FOR SYSTEM_TIME ALL;
--NOTA: el versionado ahora está solamente sobre DepartmentHistory2,
--      por lo que si queremos acceder a los datos anteriores al cambio
--      se deberá hacer de manera manual.. o bien podríamos crear una
--      vista con todas las columnas, viejas + nuevas donde unimos las 
--      3 tablas y hacemos los wheres en vez de FOR SYSTEM_TIME... 

--      para este problema podemos encontrar varias alternativas, hasta
--      por que no despedirnos de nuestra vieja tabla de datos históricos
--      todo va a depender de la funcionalidad futura del sistema y el
--      objetivo de ese histórico de cambios

