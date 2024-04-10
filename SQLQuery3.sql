-- Creating a table that has  @Counter amount of columns
DROP TABLE NewTable
DECLARE @CreateTable nvarchar(MAX)
Set @CreateTable = 'CREATE TABLE NewTable ('

DECLARE @Counter INT = 1
WHILE @Counter <= 13
BEGIN
    SET @CreateTable = @CreateTable + 'Column' + CAST(@Counter AS nvarchar) + ' VARCHAR(255), '
    SET @Counter = @Counter + 1
END

SET @CreateTable = LEFT(@CreateTable, LEN(@CreateTable) - 1) -- Removed the last comma
SET @CreateTable = @CreateTable + ')' -- Added closing parenthesis

EXEC sp_executesql @CreateTable -- Uncomment to execute the SQL

USE lab_db;


-- Populating the DB table
TRUNCATE TABLE dbo.NewTable
BULK INSERT dbo.NewTable
FROM 'C:\Users\Arde\DTEK-projektit\tietokanta-normalisointi\Labrat_tietokanta.csv'
WITH (
	--ROWTERMINATOR = '\n',
    --FIELDTERMINATOR = ',', 
    DATAFILETYPE = 'char',
    FIRSTROW = 1,-- If the first row contains column headers
	--LASTROW = 600, Tätä riviä ei tarvitse 
	FIELDTERMINATOR=',',
	ROWTERMINATOR = '0x0a',
	TABLOCK -- Pitää koodin kasassa ilman LASTROWta.
);

SELECT * FROM NewTable; -- Has now 15 columns

close