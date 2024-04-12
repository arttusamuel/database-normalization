

USE lab_db;


-- Populating the DB table
TRUNCATE TABLE NewTable

BULK INSERT dbo.NewTable
FROM 'C:\Users\Arde\DTEK-projektit\tietokanta-normalisointi\Modified_Labrat_tietokanta.csv'
WITH (
	--ROWTERMINATOR = '\n',
    --FIELDTERMINATOR = ',', 
    DATAFILETYPE = 'char',
    FIRSTROW = 2,-- '2' If the first row contains column headers
	--LASTROW = 600, T‰t‰ rivi‰ ei tarvitse 
	FIELDTERMINATOR=',',
	ROWTERMINATOR = '0x0a',
	TABLOCK -- Pit‰‰ koodin kasassa ilman LASTROWta.
);


