function Update-StoredProcedure
{
    <#
    .SYNOPSIS
    Updates an existing stored procedure.

    .DESCRIPTION
    Updates an existing stored procedure.

    .EXAMPLE
    Update-StoredProcedure -SchemaName 'rivet' 'ReadMigrations' 'AS select * from rivet.Migrations'

    Updates a stored procedure to read the migrations from Rivet's Migrations table.  Note that in real life, you probably should leave my table alone.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        # The name of the stored procedure.
        $Name,
            
        [Parameter()]
        [string]
        # The schema name of the stored procedure.  Defaults to `dbo`.
        $SchemaName = 'dbo',
            
        [Parameter(Mandatory=$true,Position=1)]
        [string]
        # The store procedure's definition.
        $Definition
    )
        
    $op = New-Object 'Rivet.Operations.UpdateStoredProcedureOperation' $SchemaName, $Name, $Definition
    Write-Host(' ={0}.{1}' -f $SchemaName,$Name)
    Invoke-MigrationOperation -operation $op
}