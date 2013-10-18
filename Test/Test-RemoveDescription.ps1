
function Start-Test
{
    Import-Module -Name (Join-Path $TestDir 'RivetTest') -ArgumentList 'RivetTest' 
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
    Remove-Module RivetTest
}

function Test-ShouldUpdateTableAndColumnDescription
{
    @'
function Push-Migration()
{
    Invoke-Query @"
    create table [MS_Description] (
        add_description varchar(max)
    )
"@

    Add-Description -Description 'new description' -TableName 'MS_Description'
    Add-Description -Description 'new description' -TableName 'MS_Description' -ColumnName 'add_description'
}

function Pop-Migration()
{
    Invoke-Query 'drop table [MS_Description]'
}
'@ | New-Migration -Name 'AddDescription'

    Invoke-Rivet -Push 'AddDescription'
    Assert-Table -Name 'MS_Description' -Description 'new description'
    Assert-Column -Name 'add_description' 'varchar' -Description 'new description' -TableName MS_Description

    @'
function Push-Migration()
{
    Update-Description -Description 'updated description' -TableName MS_Description
    Update-Description -Description 'updated description' -TableName MS_Description -ColumnName 'add_description'
}

function Pop-Migration()
{
    Update-Description -Description 'new description' -TableName MS_Description
    Update-Description -Description 'new description' -TableName MS_Description -ColumnName 'add_description'
}
'@ | New-Migration -Name 'UpdateDescription'

    Invoke-Rivet -Push 'UpdateDescription'
    Assert-Table -Name 'MS_Description' -Description 'updated description'
    Assert-Column -Name 'add_description' 'varchar' -Description 'updated description' -TableName MS_Description

    @'
function Push-Migration()
{
    Remove-Description -TableName MS_Description 
    Remove-Description -TableName MS_Description -ColumnName 'add_description'
}

function Pop-Migration()
{
    Add-Description -Description 'updated description' -TableName MS_Description
    Add-Description -Description 'updated description' -TableName MS_Description -ColumnName 'add_description'
}
'@ | New-Migration -Name 'RemoveDescription'

    Invoke-Rivet -Push 'RemoveDescription'
    Assert-Table -Name 'MS_Description' -Description $null 
    Assert-Column -Name 'add_description' 'varchar' -Description $null -TableName MS_Description
}
