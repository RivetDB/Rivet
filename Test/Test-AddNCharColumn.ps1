function Start-Test
{
    Import-Module -Name (Join-Path $TestDir 'RivetTest') -ArgumentList 'AddNCharColumn' 
    Start-RivetTest
}

function Stop-Test
{
    Stop-RivetTest
    Remove-Module RivetTest
}

function Test-ShouldCreateNCharColumn
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        NChar 'id'
    } -Option 'data_compression = none'
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateNCharColumn'

    Invoke-Rivet -Push 'CreateNCharColumn'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'NChar' -TableName 'Foobar'
}

function Test-ShouldCreateNCharColumnWithSparse
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        NChar 'id' -Sparse
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateNCharColumnWithSparse'

    Invoke-Rivet -Push 'CreateNCharColumnWithSparse'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'NChar' -TableName 'Foobar' -Sparse
}

function Test-ShouldCreateNCharColumnWithNotNull
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        NChar 'id' -NotNull
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'CreateNCharColumnWithNotNull'

    Invoke-Rivet -Push 'CreateNCharColumnWithNotNull'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'NChar' -TableName 'Foobar' -NotNull
}

function Test-ShouldCreateNCharColumnWithCustomSizeCollation
{
    @'
function Push-Migration
{
    Add-Table -Name 'Foobar' -Column {
        NChar 'id' -NotNull -Size 50 -Collation "Chinese_Taiwan_Stroke_CI_AS"
    }
}

function Pop-Migration
{
    
}

'@ | New-Migration -Name 'ShouldCreateNCharColumnWithCustomSizeCollation'

    Invoke-Rivet -Push 'ShouldCreateNCharColumnWithCustomSizeCollation'
    
    Assert-Table 'Foobar'
    Assert-Column -Name 'id' -DataType 'NChar' -TableName 'Foobar' -NotNull -Size 50 -Collation "Chinese_Taiwan_Stroke_CI_AS"
}