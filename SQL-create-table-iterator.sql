-- Creating a table that has  @Counter amount of columns
DROP TABLE NewTable
DECLARE @CreateTable nvarchar(MAX)
Set @CreateTable = 'CREATE TABLE NewTable ('

DECLARE @Counter INT = 1
WHILE @Counter <= 15
BEGIN
    SET @CreateTable = @CreateTable + 'Column' + CAST(@Counter AS nvarchar) + ' VARCHAR(255), '
    SET @Counter = @Counter + 1
END

SET @CreateTable = LEFT(@CreateTable, LEN(@CreateTable) - 1) -- Removed the last comma
SET @CreateTable = @CreateTable + ')' -- Added closing parenthesis

--EXEC sp_executesql @CreateTable -- Uncomment to execute the SQL