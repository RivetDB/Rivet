
#Requires -Version 4
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'RivetTest\Import-RivetTest.ps1' -Resolve)

function Assert-OperationIsSourcedFrom
{
    param(
        [Rivet.Operation]
        $Operation,
        [string[]]
        $ExpectedSource
    )

    It 'should have additional source member' {
        $Operation | Get-Member -Name 'Source' | Should Not BeNullOrEmpty
    }

    It 'should have expected number of sources' {
        $Operation.Source.Count | Should Be $ExpectedSource.Count
        $Operation.Source | Should BeOfType ([Rivet.Migration])
    }

    for( $idx = 0; $idx -lt $ExpectedSource.Count; ++$idx )
    {
        It ('should be sourced from {0} migration' -f $ExpectedSource[$idx]) {
            $Operation.Source[$idx].Name | Should Be $ExpectedSource[$idx]
        }
    }
}

function Assert-AllMigrationsReturned
{
    param(
        $MergedMigration,
        $ExpectedCount
    )

    It 'should return all the migrations' {
        $MergedMigration | Measure-Object | Select-Object -ExpandProperty 'Count' | Should Be $ExpectedCount
    }
}

function Assert-MigrationHasNoOperations
{
    param(
        [Rivet.Migration]
        $Migration
    )

    It 'should have no operations' {
        $Migration.PushOperations.Count | Should Be 0
    }
}

function Invoke-MergeMigration
{
    [OutputType([Rivet.Migration])]`
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $ScriptBlock
    )

    Invoke-Command -ScriptBlock $ScriptBlock | Merge-Migration
}

function New-MigrationObject
{
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $Name,

        [Parameter(Mandatory=$true,Position=1)]
        [scriptblock]
        $ScriptBlock
    )

    $id = Get-Date -UFormat '%Y%m%d%H%M%S'
    $path = '{0}_{1}' -f $id,$Name
    $migration = New-Object 'Rivet.Migration' $id,$Name,$path,'Verification'
    Invoke-Command -ScriptBlock $ScriptBlock | ForEach-Object { $migration.PushOperations.Add( $_ ) } | Out-Null
    return $migration
}

Describe 'Merge-Migration when adding a table then adding a column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int index -NotNull
            }
        }

        New-MigrationObject 'AddColumn' {
            Update-Table 'snafu' -AddColumn { 
                int 'newcol' -NotNull
            }
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    [Rivet.Operations.AddTableOperation]$op = $result[0].PushOperations[0]
    It 'should consolidate columns' {
        $op.Columns.Count | Should Be 2
        $op.Columns[1].Name | Should Be 'newcol'
    }

    Assert-OperationIsSourcedFrom $op 'AddTable','AddColumn'
    Assert-MigrationHasNoOperations $result[1]
}

Describe 'Merge-Migration when adding a table then updating a column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int index -NotNull
            }
        }

        New-MigrationObject 'UpdateColumn' {
            Update-Table 'snafu' -UpdateColumn { 
                int 'index'
            }
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    [Rivet.Operations.AddTableOperation]$op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddTable','UpdateColumn'

    It 'should consolidate columns' {
        $op.Columns.Count | Should Be 1
        $op.Columns[0].Name | Should Be 'index'
        $op.Columns[0].NotNull | Should Be $false
    }

    Assert-MigrationHasNoOperations $result[1]
}

Describe 'Merge-Migration when adding a table then updating a column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int index -NotNull
            }
        }

        New-MigrationObject 'RemoveColumn' {
            Update-Table 'snafu' -RemoveColumn 'index'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    [Rivet.Operations.AddTableOperation]$op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddTable','RemoveColumn'

    It 'should consolidate columns' {
        $op.Columns.Count | Should Be 0
    }

    Assert-MigrationHasNoOperations $result[1]
}

Describe 'Merge-Migration when renaming a column' {
    $result = Invoke-MergeMigration { 
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int 'index' -NotNull
            }
        }

        New-MigrationObject 'RenameColumn' {
            Rename-Column 'snafu' 'index' 'newindex' 
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddTable','RenameColumn'

    It 'should rename the column' {
        $op.Columns[0].Name | Should Be 'newindex'
    }

    Assert-MigrationHasNoOperations $result[1]
}


Describe 'Merge-Migration when renaming a table' {
    $result = Invoke-MergeMigration { 
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int 'index' -NotNull
            }
        }

        New-MigrationObject 'RenameTable' {
            Rename-Object 'snafu' 'fubar'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddTable','RenameTable'

    It 'should rename the table' {
        $op.Name | Should Be 'fubar'
    }

    Assert-MigrationHasNoOperations $result[1]
}

Describe 'Merge-Migration when removing an object' {
    $result = Invoke-MergeMigration { 
        New-MigrationObject 'AddTable' {
            Add-Table 'snafu' {
                int 'index' -NotNull
            }
        }

        New-MigrationObject 'RemoveTable' {
            Remove-Table 'snafu'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    Assert-MigrationHasNoOperations -Migration $result[0]
    Assert-MigrationHasNoOperations -Migration $result[1]
}


Describe 'Merge-Migration when removing an object in the same migration it was created' {
    $Global:Error.Clear()

    $result = Invoke-MergeMigration { 
        New-MigrationObject 'AddAndRemoveTable' {
            Add-Table 'snafu' {
                int 'index' -NotNull
            }

            Remove-Table 'snafu'
        }
    }

    $Global:Error.Count | Should Be 0

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 1

    Assert-MigrationHasNoOperations -Migration $result[0]
}

Describe 'Merge-Migration when updating a table' {

    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddColumn' {
            Update-Table 'fubar' -AddColumn {
                int 'col1'
            }
        }

        New-MigrationObject 'AddColumn2' {
            Update-Table 'fubar' -AddColumn {
                int 'col2'
            }
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddColumn','AddColumn2'

    It 'should consolidate second added column into first migration' {
        $op.AddColumns.Count | Should Be 2
        $op.AddColumns[1].Name | Should Be 'col2'
    }

    Assert-MigrationHasNoOperations -Migration $result[1]
}

Describe 'Merge-Migration when adding a column that was removed' {

    $result = Invoke-MergeMigration {
        New-MigrationObject 'RemoveColumns' {
            Update-Table 'fubar' -RemoveColumn 'removemeforreal','removemebymistake'
        }

        New-MigrationObject 'AddColumn' {
            Update-Table 'fubar' -AddColumn {
                int 'removemebymistake'
            }
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'RemoveColumns','AddColumn'

    It 'should consolidate re-add into first migration' {
        $op.RemoveColumns.Count | Should Be 1
        $op.RemoveColumns[0] | Should Be 'removemeforreal'
        $op.AddColumns.Count | Should Be 1
        $op.AddColumns[0].Name | Should Be 'removemebymistake'
    }

    Assert-MigrationHasNoOperations -Migration $result[1]
}

Describe 'Merge-Migation when removing an updated column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'UpdateColumn' {
            Update-Table 'fubar' -UpdateColumn {
                int 'toberemoved'
            }
        }

        New-MigrationObject 'RemoveColumn' {
            Update-Table 'fubar' -RemoveColumn 'toberemoved'
        }

    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2
    Assert-MigrationHasNoOperations -Migration $result[0]
    Assert-MigrationHasNoOperations -Migration $result[1]
}

Describe 'Merge-Migation when removing an added column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddColumn' {
            Update-Table 'fubar' -AddColumn {
                int 'toberemoved'
            }
        }

        New-MigrationObject 'RemoveColumn' {
            Update-Table 'fubar' -RemoveColumn 'toberemoved'
        }

    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2
    Assert-MigrationHasNoOperations -Migration $result[0]
    Assert-MigrationHasNoOperations -Migration $result[1]
}


Describe 'Merge-Migation when updating an added column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddColumn' {
            Update-Table 'fubar' -AddColumn {
                int 'tobeupdated'
            }
        }

        New-MigrationObject 'UpdateColumn' {
            Update-Table 'fubar' -UpdateColumn { int 'tobeupdated' -NotNull }
        }

    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddColumn','UpdateColumn'

    It 'should replace original add column definition with updated definition' {
        $op.UpdateColumns.Count | Should Be 0
        $op.AddColumns.Count | Should Be 1
        $op.AddColumns[0].Name | Should Be 'tobeupdated'
        $op.AddColumns[0].NotNull | Should Be $true
    }

    Assert-MigrationHasNoOperations -Migration $result[1]
}


Describe 'Merge-Migation when updating an updated' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'UpdateColumn' {
            Update-Table 'fubar' -UpdateColumn {
                int 'tobeupdated'
            }
        }

        New-MigrationObject 'UpdateColumn2' {
            Update-Table 'fubar' -UpdateColumn { int 'tobeupdated' -NotNull }
        }

    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2
    
    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'UpdateColumn','UpdateColumn2'

    It 'should move second update to first migration' {
        $op.UpdateColumns.Count | Should Be 1
        $op.UpdateColumns[0].Name | Should Be 'tobeupdated'
        $op.UpdateColumns[0].NotNull | Should Be $true
    }

    Assert-MigrationHasNoOperations -Migration $result[1]
}

Describe 'Merge-Migration when merging multiple update table operations' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddAndUpdateTable' {
            Add-Table -SchemaName 'skma' 'Farmers' {
                int 'ID' -NotNull
                varchar 'Name' -NotNull -Size 500
            }

            Update-Table -SchemaName 'skma' 'Farmers' -UpdateColumn {
                varchar 'Name' -NotNull -Size 50
            } 

            Update-Table -SchemaName 'skma' 'Farmers' -AddColumn {
                varchar 'Zip' -Size 10
            }
            Rename-Column -SchemaName 'skma' 'Farmers' -Name 'Zip' -NewName 'ZipCode'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 1
    
    $op = $result[0].PushOperations[0]

    Assert-OperationIsSourcedFrom $op 'AddAndUpdateTable'

    It 'should consolidate into one operation' {
        $result[0].PushOperations.Count | Should Be 1
    }

    It 'should move all updates to add table operation' {
        $op | Should BeOfType ([Rivet.Operations.AddTableOperation])
        $op.Columns.Count | Should Be 3
        $op.Columns[0].Name | Should Be 'ID'
        $op.Columns[1].Name | Should Be 'Name'
        $op.Columns[2].Name | Should Be 'ZipCode'
    }
}

Describe 'Merge-Migation when adding removing and adding an object' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddTable' {
            Add-Schema 'aggregate'

            Add-Table -SchemaName 'aggregate' 'Beta' {
                int 'ID' -NotNull
                nvarchar 'Name' -Size 50
                nvarchar 'RemoveMe' -Size 10
            }

            Add-PrimaryKey -SchemaName 'aggregate' -TableName 'Beta' -ColumnName 'ID'
        }

        New-MigrationObject 'UpdateTable' {
            Remove-PrimaryKey -SchemaName 'aggregate' -TableName 'Beta' -Name (New-ConstraintName -PrimaryKey -SchemaName 'aggregate' -TableName 'Beta')
            Add-PrimaryKey -SchemaName 'aggregate' -TableName 'Beta' -ColumnName 'Name'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 2

    It 'should merge operations' {
        $ops = $result[0].PushOperations
        $ops.Count | Should Be 2
        $ops[0] | Should BeOfType ([Rivet.Operations.AddSchemaOperation])
        $ops[1] | Should BeOfType ([Rivet.Operations.AddTableOperation])

        $ops = $result[1].PushOperations
        $ops.Count | Should Be 1
        $ops[0] | Should BeOfType ([Rivet.Operations.AddPrimaryKeyOperation])
    }
}

Describe 'Merge-Migration when adding a column to a table then removing it' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'UpdateWithRemove' {
            Update-Table -Name 'FeedbackLog' -AddColumn {
                varchar 'ToBeIncreased' -Size 50 -NotNull
                varchar 'ToBeRemoved' -Size 100 -NotNull
            }

            # Yes.  Keep these separate.  That's what we're testing.
            Update-Table -Name 'FeedbackLog' -UpdateColumn { 
                VarChar 'Feedback' -Size 3000 
                varchar 'ToBeIncreased' -Size 200
            }

            Update-Table -Name 'FeedbackLog' -RemoveColumn 'ToBeRemoved'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 1

    It 'should merge down to one update table operation' {
        $ops = $result[0].PushOperations
        $ops.Count | Should Be 1

        $op = $ops[0]

        $op | Should BeOfType ([Rivet.Operations.UpdateTableOperation])

        $op.AddColumns.Count | Should Be 1
        $op.AddColumns[0].Name | Should Be 'ToBeIncreased'
        $op.AddColumns[0].Size.ToString() | Should Be '(200)'

        $op.UpdateColumns.Count | Should Be 1
        $op.UpdateColumns[0].Name | Should Be 'Feedback'

        $op.RemoveColumns.Count | Should Be 0
    }
}

Describe 'Merge-Migration when adding a removed column' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'RemoveThenAddColumns' {
            Update-Table -Name EligibilityMaps -RemoveColumn 'UsePgpEncryption'
            Update-Table -Name EligibilityMaps -RemoveColumn 'Delimiter'
            Update-Table -Name EligibilityMaps -AddColumn { Bit 'UsePgpEncryption' -Description 'is the file expected to be encrypted?' }
            Update-Table -Name EligibilityMaps -AddColumn { char 'Delimiter' -Size 1 -Description 'what is the delimiter to use when processing the file. valid values are: [,|\t]' }
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 1

    $ops = $result[0].PushOperations

    It 'should merge all updates into one operation' {
        $ops.Count | Should Be 3
    }

    $op = $ops[0]
    It 'should have only update operations' {
        $op | Should BeOfType ([Rivet.Operations.UpdateTableOperation])
        $op.RemoveColumns.Count | Should Be 0
        $op.UpdateColumns.Count | Should Be 0
        $op.AddColumns.Count | Should Be 2
    }

    It 'should have add extended property operations' {
        $ops[1] | Should BeOfType ([Rivet.Operations.AddExtendedPropertyOperation])
        $ops[2] | Should BeOfType ([Rivet.Operations.AddExtendedPropertyOperation])
    }
}

Describe 'Merge-Migration when adding/removing different objects multiple times' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'AddPrimaryKeyAndSynonym' {
            Add-PrimaryKey -TableName 'CoachMessagingPractice_RefOnly' -ColumnName AgentId,PracticeId
            Add-Synonym -Name 'CoachMessagingPractice' -TargetDatabaseName 'hcUser' -TargetObjectName 'CoachMessagingPractice_RefOnly'
        }

        New-MigrationObject 'RemoveAndAddPrimaryKey' {
            Remove-PrimaryKey -TableName 'CoachMessagingPractice_RefOnly' -Name 'PK_CoachMessagingPractice_RefOnly'
            Add-PrimaryKey -TableName 'CoachMessagingPractice_RefOnly' -ColumnName Id
        }

        New-MigrationObject 'RemoveAndAddSynonym' {
            Remove-Synonym 'CoachMessagingPractice'
            Add-Synonym -Name 'CoachMessagingPractice' -TargetDatabaseName 'hcUser' -TargetObjectName 'CoachMessagingPractice_RefOnly'
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 3

    It 'should merge operations correctly' {
        $result[0].PushOperations.Count | Should Be 0
        $result[1].PushOperations.Count | Should Be 1
        $result[2].PushOperations.Count | Should Be 1
    }
}

Describe 'Merge-Migration when add and removal are in the same migration and there are operations after the removal' {
    $result = Invoke-MergeMigration {
        New-MigrationObject 'fubar' {
            # AccountIdentityStatusHistory_RefOnly_V2
            Add-Trigger -Name 'trAccountIdentityStatusHistory_RefOnly_V2_Activity' -Definition 'fubar'
            Remove-Trigger -Name trAccountIdentityStatusHistory_RefOnly_V2_Activity
            Remove-DefaultConstraint -TableName AccountIdentityStatusHistory_RefOnly_V2 -Name DF_AccountIdentityStatusHistory_RefOnly_V2_CreateDate
        }
    }

    Assert-AllMigrationsReturned -MergedMigration $result -ExpectedCount 1

    It 'should remove the add and removal' {
        $ops = $result[0].PushOperations
        $ops.Count | Should Be 1
        $ops[0] | Should BeOfType ([Rivet.Operations.RemoveDefaultConstraintOperation])
    }
}