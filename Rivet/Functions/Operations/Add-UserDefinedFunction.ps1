 function Add-UserDefinedFunction
{
    <#
    .SYNOPSIS
    Creates a new user-defined function.

    .DESCRIPTION
    Creates a new user-defined function.

    .EXAMPLE
    Add-UserDefinedFunction -SchemaName 'rivet' 'One' 'returns tinyint begin return 1 end'

    Creates a user-defined function that returns the number 1.
    #>    [CmdletBinding()]
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
        # The store procedure's definition. Everything after the `create function [schema].[name]` clause.
        $Definition
    )
    
    Set-StrictMode -Version 'Latest'

    New-Object Rivet.Operations.AddUserDefinedFunctionOperation $SchemaName,$Name,$Definition
}