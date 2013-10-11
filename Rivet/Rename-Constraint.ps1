function Rename-Constraint
{
    <#
    .SYNOPSIS
    Renames constraints: primary keys, foreign keys, check constraints, or unique constraints.
    
    .DESCRIPTION
    SQL Server ships with a stored procedure which is used to rename certain objects.  This operation wraps that stored procedure for renaming table constraints.
    
    .EXAMPLE
    Rename-Constraint -TableName 'FooBar' -Name 'Fizz' -NewName 'PK_Fizz'
    
    Changes the name of the `Fizz` constraint on the `FooBar` table to `PK_Fizz`.
    
    .EXAMPLE
    Rename-Constraint -SchemaName 'fizz' -TableName 'FooBar' -Name 'Fizz' -NewName 'PK_Fizz'
    
    Demonstrates how to rename a constraint on a table that is in a schema other than `dbo`.
    
    .EXAMPLE
    Rename-Constraint 'FooBar' 'Fizz' 'PK_Fizz'
    
    Demonstrates how to use the short form to rename the `Fizz` constraint on the `FooBar` table to `PK_Fizz`: table name is first, then existing constraint name, then new constraint name.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=1)]
        [string]
        # The name of the table of the constraint to rename.
        $TableName,
        
        [Parameter(Mandatory=$true,Position=2)]
        [string]
        # The current name of the constraint.
        $Name,
        
        [Parameter(Mandatory=$true,Position=3)]
        [string]
        # The new name of the constraint.
        $NewName,
        
        [Parameter()]
        [string]
        # The schema of the table.  Default is `dbo`.
        $SchemaName = 'dbo'
    )

    $op = New-Object 'Rivet.Operations.RenameOperation' $SchemaName, $TableName, $Name, $NewName, Default
    $return = Invoke-MigrationOperation -Operation $op -AsScalar
    Write-Host (' ={0}.{1}.{2}' -f $SchemaName,$TableName,$NewName)
    
    if ($return -ne 0)
    {
        throw "sp_rename operation has failed with error code: {0}" -f $return
        return
    }
}