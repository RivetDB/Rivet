
function Start-Test
{
    & (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve) -DatabaseName 'RivetTest' 
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
}

function Test-ShouldAddTableAndColumnDescription
{
    @'
function Push-Migration()
{
    Add-Table 'MS_Description' -Column {
        varchar 'add_description' -Max
    }

    Add-Description -Description 'new description' -TableName 'MS_Description'
    Add-Description -Description 'new description' -TableName 'MS_Description' -ColumnName 'add_description'
}

function Pop-Migration()
{
    Remove-Table 'MS_Description'
}
'@ | New-Migration -Name 'AddDescription'
    Invoke-Rivet -Push 'AddDescription'

    Assert-Table -Name 'MS_Description' -Description 'new description' 
    Assert-Column -Name 'add_description' 'varchar' -Description 'new description' -TableName 'MS_Description'
}
