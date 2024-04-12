-- Query creates a new table and populates it with data from csv file. 
-- File has been formatted with a python script. In addition to original data TapahtumaID is added
-- Empty cells contain 'NULL'. Lempilelut should be separated to another table. 

-- Check if table exists in database, if not, create a new schema.
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'NewTable')
BEGIN
	CREATE TABLE NewTable (
		[TapahtumaID] INT,
		[KeskuksenNimi] VARCHAR(255),
		[KeskuksenPerustamisvuosi] INT,
		[HoitajanNimi] NVARCHAR(255),
		[El‰in] VARCHAR(255),
		[El‰imenLempilelut1] VARCHAR(255),
		[El‰imenLempilelut2] VARCHAR(255),
		[El‰imenLempilelut3] VARCHAR(255),
		[El‰imenIk‰] INT,
		[Toimenpide] VARCHAR(255),
		[ToimenpiteenPvm] VARCHAR(255),
		[HoitajanPalkka] INT,
		[El‰imenKiinniottopaikka] VARCHAR(255),
		[KiinniottoPvm] VARCHAR(255),
		[El‰imenLaji] VARCHAR(255),
		[KeskuksenOsoite] VARCHAR(255)
	);
END

-- Truncate data in table
TRUNCATE TABLE NewTable;
SELECT * FROM NewTable; PRINT 'NewTable after creating or Truncating';

-- Bulk all data into the table
BULK INSERT dbo.NewTable
FROM 'C:\Users\Arde\DTEK-projektit\tietokanta-normalisointi\Modified_Labrat_tietokanta.csv'
WITH (
	ROWTERMINATOR = '\n',
    FIELDTERMINATOR = ',', 
	DATAFILETYPE = 'char',
    FIRSTROW = 2,-- '2' If the first row contains column headers
	TABLOCK -- Pit‰‰ koodin kasassa ilman LASTROWta.
);
SELECT * FROM NewTable; PRINT 'NewTable after populating';

----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERT INTO -BLOCK HERE


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StagingTable')
BEGIN
	CREATE TABLE StagingTable (
		TapahtumaID varchar(255),
		ToimenpiteenPvm varchar(255),
		KiinniottoPvm varchar(255)-- Assuming your date strings are stored in this column
		-- Other columns from the CSV file
	);
	PRINT 'Table created';
END
ELSE
BEGIN
    TRUNCATE TABLE dbo.StagingTable
	PRINT 'Else executed';
END

-- INSERT INTO TABLE Query to test TABLE named StagingTable
-- TapahtumaID need to be varchar before insertin. 
INSERT INTO StagingTable (TapahtumaID, ToimenpiteenPvm, KiinniottoPvm)
	Select NewTable.TapahtumaID , CONVERT(DATE, NewTable.ToimenpiteenPvm, 103), CONVERT(DATE, NewTable.Kiinniottopvm, 103)
	FROM NewTable;

-- INSERTING into original table
UPDATE NewTable
SET NewTable.TapahtumaID = StagingTable.TapahtumaID,
    NewTable.ToimenpiteenPvm = StagingTable.ToimenpiteenPvm,
	NewTable.KiinniottoPvm = StagingTable.KiinniottoPvm
FROM NewTable
INNER JOIN StagingTable ON NewTable.TapahtumaID = StagingTable.TapahtumaID;

------------------------------------------------
------------------------------------------------
-- Select querys here to check modifications
SELECT * FROM NewTable;
SELECT TapahtumaID, ToimenpiteenPvm FROM dbo.StagingTable;

------------------------------------------------
------------------------------------------------
-- Drop tables 
DROP TABLE StagingTable; -- execute to delete temporary stagingtable
DROP TABLE NewTable;
	



