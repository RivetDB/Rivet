
& (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve)
Describe 'Add-DataType' {
    BeforeEach { Start-RivetTest }
    AfterEach { Stop-RivetTest }

    It 'should add data type by alias' {
        # Yes.  Spaces in the name so we check the name gets quoted.
        @'
function Push-Migration
{
    Add-DataType 'G U I D' 'uniqueidentifier'

    Add-Table 'important' {
        New-Column -DataType '[G U I D]' -Name 'ident' 
    }
}

function Pop-Migration
{
    Remove-Table 'important'
    Remove-DataType 'G U I D'
}

'@ | New-TestMigration -Name 'ByAlias'

        Invoke-RTRivet -Push 'ByAlias'

        Assert-DataType -Name 'G U I D' -BaseTypeName 'uniqueidentifier' -UserDefined
        Assert-Table 'important'
        Assert-Column 'ident' -DataType 'G U I D' -TableName 'important'
    }

    It 'should add data type by assembly' {
        $assemblyPath = Join-Path -Path $PSScriptRoot -ChildPath '..\Source\Rivet.Test.Fake\bin\*\Rivet.Test.Fake.dll' -Resolve -ErrorAction Ignore |
                        Select-Object -First 1
        $assemblyPath | Should Not BeNullOrEmpty
        # Yes.  Spaces in the name so we check the name gets quoted.
        @"
function Push-Migration
{
    Invoke-Ddl "create assembly rivettest from '$assemblyPath' "
    Add-DataType 'Point Point' -AssemblyName 'rivettest' -ClassName 'Rivet.Test.Fake.Point'

    Add-Table 'important' {
        New-Column -Name 'ident' -DataType '[Point Point]'
    }
}

function Pop-Migration
{
    Remove-Table 'important'
    Remove-DataType 'Point Point'
    Invoke-Ddl 'drop assembly rivettest'
}

"@ | New-TestMigration -Name 'ByAssembly'

        Invoke-RTRivet -Push 'ByAssembly'
        
        Assert-DataType -Name 'Point Point' -BaseTypeName $null -UserDefined -AssemblyType
        Assert-Table 'important'
        Assert-Column 'ident' -DataType 'Point Point' -TableName 'important'
    }

    It 'should add data type by table' {
        # Yes.  Spaces in the name so we check the name gets quoted.
        @'
function Push-Migration
{
    Add-DataType 'U s e r s' -AsTable { 
        varchar 'Name' 50 
        varchar 'Email' 255
   } -TableConstraint 'primary key'
}

function Pop-Migration
{
    Remove-DataType 'U s e r s'
}

'@ | New-TestMigration -Name 'ByTable'

        Invoke-RTRivet -Push 'ByTable'

        Assert-DataType -Name 'U s e r s' -UserDefined -TableType -NotNull
    }
}