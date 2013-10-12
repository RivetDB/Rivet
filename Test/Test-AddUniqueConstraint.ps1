function Setup
{
    Import-Module -Name (Join-Path $TestDir 'RivetTest') -ArgumentList 'RivetTest' 
    Start-RivetTest

    # yes, on PowerShell 2 these tests need a breather.  Not sure why.
    if( $PSVersionTable.PsVersion -eq '2.0' )
    {
        Start-Sleep -Milliseconds 200
    }
}

function TearDown
{
    Stop-RivetTest
    Remove-Module RivetTest
}

function Test-ShouldAddUniqueConstraintToOneColumn
{
    @'
function Push-Migration()
{
    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe'
}

function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintToOneColumn'
    Invoke-Rivet -Push 'AddUniqueConstraintToOneColumn'
    Assert-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe'
}

function Test-ShouldAddUniqueConstraintToMultipleColumns
{
    @'
function Push-Migration()
{
    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
        Int 'UniqueConstraintMe2' -NotNull
        Int 'DoNotUniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2'
}

function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintToMultipleColumns'
    Invoke-Rivet -Push 'AddUniqueConstraintToMultipleColumns'
    Assert-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2'
}

function Test-ShouldAddUniqueConstraintWithClustered
{
    @'
function Push-Migration()
{
    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
        Int 'UniqueConstraintMe2' -NotNull
        Int 'DoNotUniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -Clustered
}

function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintWithClustered'
    Invoke-Rivet -Push 'AddUniqueConstraintWithClustered'
    Assert-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -TestClustered
}

function Test-ShouldAddUniqueConstraintWithFillFactor
{
    @'
function Push-Migration()
{
    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
        Int 'UniqueConstraintMe2' -NotNull
        Int 'DoNotUniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -Option @('IGNORE_DUP_KEY = ON','ALLOW_ROW_LOCKS = OFF') -FillFactor 80
}

function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintWithFillFactor'
    Invoke-Rivet -Push 'AddUniqueConstraintWithFillFactor'
    Assert-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -TestFillFactor 80 -TestOption
}

function Test-ShouldAddUniqueConstraintWithOptions
{
    @'
function Push-Migration()
{
    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
        Int 'UniqueConstraintMe2' -NotNull
        Int 'DoNotUniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -Option @('IGNORE_DUP_KEY = ON','ALLOW_ROW_LOCKS = OFF')
}

function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintWithOptions'
    Invoke-Rivet -Push 'AddUniqueConstraintWithOptions'
    Assert-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe','UniqueConstraintMe2' -TestOption
}

function Test-ShouldAddUniqueConstraintWithCustomFileGroup
{
    @'
function Push-Migration()
{

    Add-Table -Name 'AddUniqueConstraint' {
        Int 'UniqueConstraintMe' -NotNull
    }

    Add-UniqueConstraint -TableName 'AddUniqueConstraint' -ColumnName 'UniqueConstraintMe' -On 'ThisShouldFail'
}
function Pop-Migration()
{
}
'@ | New-Migration -Name 'AddUniqueConstraintWithCustomFileGroup'
    $Error.Clear()
    Invoke-Rivet -Push 'AddUniqueConstraintWithCustomFileGroup' -ErrorAction SilentlyContinue
    Assert-True (0 -lt $Error.Count)
    Assert-Like $Error[1].Exception.Message '*Invalid filegroup*'
}