
param(
    [Parameter(Mandatory=$true)]
    [string]
    # The name of the database.
    $Name
)

$moduleVars = @(
                    'DatabasesSourcePath',
                    'DatabaseSourcePath',
                    'DatabaseSourceName',
                    'DatabaseName',
                    'DatabaseName',
                    'DatabasesRoot',
                    'DatabaseRoot',
                    'Server',
                    'PstepPath',
                    'DatabaseConnection',
                    'MasterConnection'
               ) 
               
$moduleVars | ForEach-Object { Set-Variable -Name $_ -Value $null -Option AllScope }

$DatabasesSourcePath = Join-Path $PSScriptRoot ..\Databases -Resolve
$DatabaseSourcePath = Join-Path $DatabasesSourcePath $Name -Resolve
$DatabaseSourceName = $Name

$Server = Get-Content (Join-Path $PSScriptRoot ..\Server.txt) -TotalCount 1

$PstepPath = Join-Path $PSScriptRoot ..\..\Pstep\pstep.ps1 -Resolve

$MasterConnection = New-Object Data.SqlClient.SqlConnection ('Server={0};Database=master;Integrated Security=True;' -f $Server)
$MasterConnection.Open()

dir $PSScriptRoot *-*.ps1 |
    Where-Object { $_.BaseName -ne 'Import-PstepTest' } |
    ForEach-Object { . $_.FullName }

. (Join-Path $PSScriptRoot '..\..\Pstep\New-DefaultConstraintName.ps1')
    
Export-ModuleMember -Function * -Alias * -Variable *