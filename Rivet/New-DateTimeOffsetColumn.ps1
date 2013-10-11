function New-DateTimeOffsetColumn
{
    <#
    .SYNOPSIS
    Creates a column object representing an DateTimeOffset datatype.

    .DESCRIPTION
    Use this function in the `Column` script block for `Add-Table`:

        Add-Table 'Orders' {
            DateTimeOffset 'OrderedAt'
        }

    ## ALIASES

     * DateTimeOffset

    .EXAMPLE
    Add-Table 'Orers' { DateTimeOffset 'OrderedAt' }

    Demonstrates how to create an optional `datetimeoffset` column.

    .EXAMPLE
    Add-Table 'Orders' { DateTimeOffset 'OrderedAt' 5 -NotNull }

    Demonstrates how to create a required `datetimeoffset` column with a digits of fractional seconds precision.

    .EXAMPLE
    Add-Table 'Orders' { DateTimeOffset 'OrderedAt' -Sparse }

    Demonstrate show to create a nullable, sparse `datetimeoffset` column when adding a new table.

    .EXAMPLE
    Add-Table 'Orders' { DateTimeOffset 'OrderedAt' -NotNull -Default 'getutcdate()' }

    Demonstrates how to create a `datetimeoffset` column with a default value.  You only use UTC dates, right?

    .EXAMPLE
    Add-Table 'Orders' { DateTimeOffset 'OrderedAt' -NotNull -Description 'The time the record was created.' }

    Demonstrates how to create a `datetimeoffset` column with a description.
    #>
    [CmdletBinding(DefaultParameterSetName='Nullable')]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        # The column's name.
        $Name,

        [Parameter(Position=1)]
        [Int]
        # The number of decimal digits that will be stored to the right of the decimal point
        $Scale = 5,

        [Parameter(Mandatory=$true,ParameterSetName='NotNull')]
        [Switch]
        # Don't allow `NULL` values in this column.
        $NotNull,

        [Parameter(ParameterSetName='Nullable')]
        [Switch]
        # Store nulls as Sparse.
        $Sparse,

        [Parameter()]
        [string]
        # A SQL Server expression for the column's default value 
        $Default,
            
        [Parameter()]
        [string]
        # A description of the column.
        $Description
    )

    if ($NotNull -and $Sparse)
    {
        throw ('Column {0}: A column cannot be NOT NULL and SPARSE.  Please choose one, but not both' -f $Name)
        return
    }

    $dataSize = $null

    $dataSize = New-Object Rivet.PrecisionScale $Scale
        
    switch ($PSCmdlet.ParameterSetName)
    {
        'Nullable'
        {
            $nullable = 'Null'
            if( $Sparse )
            {
                $nullable = 'Sparse'
            }
            [Rivet.Column]::DateTimeOffset($Name, $dataSize, $nullable, $Default, $Description)
        }
            
        'NotNull'
        {
            [Rivet.Column]::DateTimeOffset($Name, $dataSize, 'NotNull', $Default, $Description)
        }
    }
}
    
Set-Alias -Name 'DateTimeOffset' -Value 'New-DateTimeOffsetColumn'