function Start-Test
{
    & (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve) -DatabaseName 'AddTimeColumn' 
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
}

function Test-ShouldCreateTimeColumn
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        Time 'id'
    } -Option 'data_compression = none'
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateTimeColumn'

    Invoke-Rivet -Push 'CreateTimeColumn'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'Time' -TableName 'Foobar' -Scale 7
}

function Test-ShouldCreateTimeColumnWithSparse
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        Time 'id' 3 -Sparse 
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateTimeColumnWithSparse'

    Invoke-Rivet -Push 'CreateTimeColumnWithSparse'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'Time' -TableName 'Foobar' -Sparse -Scale 3
}

function Test-ShouldCreateTimeColumnWithNotNull
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        Time 'id' 2 -NotNull
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateTimeColumnWithNotNull'

    Invoke-Rivet -Push 'CreateTimeColumnWithNotNull'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'Time' -TableName 'Foobar' -NotNull -Scale 2
}