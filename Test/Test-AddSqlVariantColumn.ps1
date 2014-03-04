function Start-Test
{
    & (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve) -DatabaseName 'AddSqlVariantColumn' 
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
}

function Test-ShouldCreateSqlVariantColumn
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        SqlVariant 'id'
    } -Option 'data_compression = none'
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateSqlVariantColumn'

    Invoke-Rivet -Push 'CreateSqlVariantColumn'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'sql_variant' -TableName 'Foobar'
}

function Test-ShouldCreateSqlVariantColumnWithSparse
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        SqlVariant 'id' -Sparse
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateSqlVariantColumnWithSparse'

    Invoke-Rivet -Push 'CreateSqlVariantColumnWithSparse'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'sql_variant' -TableName 'Foobar' -Sparse
}

function Test-ShouldCreateSqlVariantColumnWithNotNull
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        SqlVariant 'id' -NotNull
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateSqlVariantColumnWithNotNull'

    Invoke-Rivet -Push 'CreateSqlVariantColumnWithNotNull'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'sql_variant' -TableName 'Foobar' -NotNull
}