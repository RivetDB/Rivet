 function Rename-Index
{
    <#
    .SYNOPSIS
    Renames an index.
    
    .DESCRIPTION
    SQL Server ships with a stored procedure which is used to rename certain objects.  This operation wraps that stored procedure.
    
    .EXAMPLE
    Rename-Index -TableName 'FooBar' -Name 'IX_Fizz' -NewName 'Buzz'
    
    Changes the name of the `Fizz` index on the `FooBar` table to `Buzz`.
    
    .EXAMPLE
    Rename-Index -SchemaName 'fizz' -TableName 'FooBar' -Name 'IX_Buzz' -NewName 'Fizz'
    
    Demonstrates how to rename an index on a table that is in a schema other than `dbo`.
    
    .EXAMPLE
    Rename-Index 'FooBar' 'IX_Fizz' 'Buzz'
    
    Demonstrates how to use the short form to rename the `Fizz` index on the `FooBar` table to `Buzz`: table name is first, then existing index name, then new index name.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        # The name of the table of the index to rename.
        $TableName,
        
        [Parameter(Mandatory=$true,Position=1)]
        [string]
        # The current name of the index.
        $Name,
        
        [Parameter(Mandatory=$true,Position=2)]
        [string]
        # The new name of the index.
        $NewName,
        
        [Parameter()]
        [string]
        # The schema of the table.  Default is `dbo`.
        $SchemaName = 'dbo'
    )
    
    $op = New-Object 'Rivet.Operations.RenameIndexOperation' $SchemaName, $TableName, $Name, $NewName
    Write-Host (' {0}.{1}.{2} -> {0}.{1}.{3}' -f $SchemaName,$TableName,$Name,$NewName)
    $result = Invoke-MigrationOperation -Operation $op -AsScalar
    
    if ($result -ne 0)
    {
        throw ("Failed to rename index {0}.{1}.{2} to {0}.{1}.{3}: error code {4}" -f $SchemaName,$TableName,$Name,$NewName,$result)
    }
}