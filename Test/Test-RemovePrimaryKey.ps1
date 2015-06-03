
function Start-Test
{
    & (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve) -DatabaseName 'RivetTest' 
    Start-RivetTest
    @'
function Push-Migration()
{
    Add-Table -Name 'PrimaryKey' {
        Int 'id' -NotNull
    }
}

function Pop-Migration()
{
    Remove-Table -Name 'PrimaryKey'
}
'@ | New-Migration -Name 'CreateTable'
}

function Stop-Test
{
    Stop-RivetTest
}

function Test-ShouldRemovePrimaryKey
{
@'
function Push-Migration()
{
    Add-PrimaryKey -TableName 'PrimaryKey' -ColumnName 'id'
}

function Pop-Migration()
{
    Remove-PrimaryKey -TableName 'PrimaryKey'
}
'@ | New-Migration -Name 'SetandRemovePrimaryKey'
    Invoke-Rivet -Push
    Assert-True (Test-Table 'PrimaryKey')
    Assert-PrimaryKey -TableName 'PrimaryKey' -ColumnName 'id'

    Invoke-Rivet -Pop
    Assert-False (Test-PrimaryKey -TableName 'PrimaryKey')
}

function Test-ShouldQuotePrimaryKeyName
{
    @'
function Push-Migration()
{
    Add-PrimaryKey -TableName 'PrimaryKey' -ColumnName 'id' -Name 'Primary Key'
}

function Pop-Migration()
{
    Remove-PrimaryKey -TableName 'PrimaryKey' -Name 'Primary Key'
}
'@ | New-Migration -Name 'SetandRemovePrimaryKey'
    Invoke-Rivet -Push
    Invoke-Rivet -Pop
    Assert-False (Test-PrimaryKey -TableName 'Remove-PrimaryKey')
}

function Test-ShouldRemovePrimaryKeyWithCustomName
{
    @'
function Push-Migration()
{
    Add-PrimaryKey -TableName 'PrimaryKey' -ColumnName 'id' -Name 'Custom'
}

function Pop-Migration()
{
    Remove-PrimaryKey -TableName 'PrimaryKey' -Name 'Custom'
}

'@ | New-Migration -Name 'RemovePrimaryKeyWithCustomName'
    Invoke-Rivet -Push
    Assert-PrimaryKey -Name 'Custom' -ColumnName 'id'

    Invoke-Rivet -Pop
    Assert-False (Test-PrimaryKey -Name 'Custom')
}
