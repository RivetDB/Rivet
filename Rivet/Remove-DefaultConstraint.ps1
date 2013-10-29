
function Remove-DefaultConstraint
{
    <#
    .SYNOPSIS
    Removes the Default Constraint from the database

    .DESCRIPTION
    Removes the Default Constraint from the database.

    .LINK
    Remove-DefaultConstraint

    .EXAMPLE
    Remove-DefaultConstraint -TableName Cars -Column Year

    Drops a Default Constraint of column 'Year' in the table 'Cars'

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        # The name of the target table.
        $TableName,

        [Parameter()]
        [string]
        # The schema name of the target table.  Defaults to `dbo`.
        $SchemaName = 'dbo',

        [Parameter(Mandatory=$true,Position=1)]
        [string]
        # The column(s) on which the DefaultConstraint is based
        $ColumnName,

        [Parameter()]
        [string]
        # The name for the <object type>. If not given, a sensible name will be created.
        $Name

    )

    Set-StrictMode -Version Latest

    if ($PSBoundParameters.containskey("Name"))
    {
        $op = New-Object 'Rivet.Operations.RemoveDefaultConstraintOperation' $SchemaName, $TableName, $ColumnName, $Name
        Write-Host (' {0}.{1} -{2}' -f $SchemaName,$TableName,$Name)
    }
    else 
    {
        $op = New-Object 'Rivet.Operations.RemoveDefaultConstraintOperation' $SchemaName, $TableName, $ColumnName
        Write-Host (' {0}.{1} -{2}' -f $SchemaName,$TableName,$op.ConstraintName.Name)
    }

    Invoke-MigrationOperation -Operation $op
}
