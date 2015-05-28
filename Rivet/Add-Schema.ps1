
function Add-Schema
{
    <#
    .SYNOPSIS
    Creates a new schema.

    .DESCRIPTION
    The `Add-Schema` operation creates a new schema in a database. It does so in an idempotent way, i.e. it only creates the schema if it doesn't exist. 

    .EXAMPLE
    Add-Schema -Name 'rivetexample'

    Creates the `rivetexample` schema.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [Alias('SchemaName')]
        [string]
        # The name of the schema.
        $Name,

        [Alias('Authorization')]
        [string]
        # The owner of the schema.
        $Owner,

        [Switch]
        # Don't show any host output.
        $Quiet
    )

    Set-StrictMode -Version 'Latest'

    if( -not $Quiet )
    {
        Write-Host (" +{0} {1}" -f $Name, $Owner)
    }
    $op = New-Object 'Rivet.Operations.AddSchemaOperation' $Name, $Owner
    Invoke-MigrationOperation -Operation $op
}