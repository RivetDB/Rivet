 function New-IntColumn
    {
        <#
        .SYNOPSIS
        Creates a column object representing an Int datatype.
        #>
        [CmdletBinding(DefaultParameterSetName='Nullable')]
        param(
            [Parameter(Mandatory=$true,Position=0)]
            [string]
            # The column's name.
            $Name,

            [Parameter(Mandatory=$true,ParameterSetName='Identity')]
            [Parameter(Mandatory=$true,ParameterSetName='IdentityWithSeed')]
            [Switch]
            # The column should be an identity.
            $Identity,

            [Parameter(Mandatory=$true,ParameterSetName='IdentityWithSeed',Position=1)]
            [int]
            # The starting value for the identity.
            $Seed,

            [Parameter(Mandatory=$true,ParameterSetName='IdentityWithSeed',Position=2)]
            [int]
            # The increment between auto-generated identity values.
            $Increment,

            [Parameter(ParameterSetName='Identity')]
            [Parameter(ParameterSetName='IdentityWithSeed')]
            [Switch]
            # Stops the identity from being replicated.
            $NotForReplication,

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

        switch ($PSCmdlet.ParameterSetName)
        {
            'Nullable'
            {
                $nullable = 'Null'
                if( $Sparse )
                {
                    $nullable = 'Sparse'
                }
                [Rivet.Column]::Int($Name, $nullable, $Default, $Description)
            }
            
            'NotNull'
            {
                [Rivet.Column]::Int($Name,'NotNull', $Default, $Description)
            }

            'Identity'
            {
                $i = New-Object 'Rivet.Identity' $NotForReplication
                [Rivet.Column]::Int( $Name, $i, $Description )
            }

            'IdentityWithSeed'
            {
                $i = New-Object 'Rivet.Identity' $Seed, $Increment, $NotForReplication
                [Rivet.Column]::Int( $Name, $i, $Description )
            }

            
        }
    }
    
    Set-Alias -Name 'Int' -Value 'New-IntColumn'