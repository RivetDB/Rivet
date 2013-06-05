
function Push-Migration()
{

    Invoke-Query -Query @'
    create table WithSparseColumns (
        name varchar(max) not null,
    ) 
'@
    $commonArgs = @{
                        TableName = 'WithSparseColumns'
                   }

    Add-Column -Name varchar -Varchar -Size 20 -Sparse -Description 'varchar(20) sparse' @commonArgs
    Add-Column -Name varcharmax -Varchar -Sparse -Description 'varchar(max) sparse' @commonArgs
    Add-Column char -Char 10 -Sparse -Description 'char(10) sparse' @commonArgs
    Add-Column nchar -Char 35 -Unicode -Sparse -Description 'nchar(35) sparse' @commonArgs
    Add-Column nvarchar -VarChar 30 -Unicode -Sparse -Description 'nvarchar(30) sparse' @commonArgs
    Add-Column nvarcharmax -VarChar -Unicode -Sparse -Description 'nvarchar(max) sparse' @commonArgs
    Add-Column binary -Binary 40 -Sparse -Description 'binary(40) sparse' @commonArgs
    Add-Column varbinary -VarBinary 45 -Sparse -Description 'varbinary(45) sparse' @commonArgs
    Add-Column varbinarymax -VarBinary -Sparse -Description 'varbinary(max) sparse' @commonArgs
    Add-Column bigint -BigInt -Sparse -Description 'bigint sparse' @commonArgs
    Add-Column int -Int -Sparse -Description 'int sparse' @commonArgs
    Add-Column smallint -SmallInt -Sparse -Description 'smallint sparse' @commonArgs
    Add-Column tinyint -TinyInt -Sparse -Description 'tinyint sparse' @commonArgs
    Add-Column numeric -Numeric 1 -Sparse -Description 'numeric(1) sparse' @commonArgs
    Add-Column numericwithscale -Numeric 2 2 -Sparse -Description 'numeric(2,2) sparse' @commonArgs
    Add-Column decimal -Decimal 4 -Sparse -Description 'decimal(4) sparse' @commonArgs
    Add-Column decimalwithscale -Decimal 5 5 -Sparse -Description 'decimal(5,5) sparse' @commonArgs
    Add-Column bit -Bit -Sparse -Description 'bit sparse' @commonArgs
    Add-Column money -Money -Sparse -Description 'money sparse' @commonArgs
    Add-Column smallmoney -SmallMoney -Sparse -Description 'smallmoney sparse' @commonArgs
    Add-Column float -Float -Sparse -Description 'float sparse' @commonArgs
    Add-Column floatwithprecision -Float 53 -Sparse -Description 'float(53) sparse' @commonArgs
    Add-Column real -Real -Sparse -Description 'real sparse' @commonArgs
    Add-Column date -Date -Sparse -Description 'date sparse' @commonArgs
    Add-Column datetime 'datetime' -Sparse -Description 'datetime sparse' @commonArgs
    Add-Column datetime2 -Datetime2 -Sparse -Description 'datetime2 sparse' @commonArgs
    Add-Column datetimeoffset -DateTimeOffset -Sparse -Description 'datetimeoffset sparse' @commonArgs
    Add-Column smalldatetime 'smalldatetime' -Sparse -Description 'smalldatetime sparse' @commonArgs
    Add-Column time -Time -Sparse -Description 'time sparse' @commonArgs
    Add-Column uniqueidentifier -UniqueIdentifier -Sparse -Description 'uniqueidentifier sparse' @commonArgs
    Add-Column xml -Xml -Sparse -Description 'xml sparse' @commonArgs
    Add-Column sql_variant -SqlVariant -Sparse -Description 'sql_variant sparse' @commonArgs
    Add-Column hierarchyid -HierarchyID -Sparse -Description 'hierarchyid sparse' @commonArgs
}

function Pop-Migration()
{
    Invoke-Query -Query @'
        drop table WithSparseColumns
'@}