
$Connection = New-Object Data.SqlClient.SqlConnection
$Connection | 
    Add-Member -MemberType NoteProperty -Name ScriptsPath -Value $null

$RivetSchemaName = 'rivet'
$RivetMigrationsTableName = 'Migrations'
$RivetMigrationsTableFullName = '{0}.{1}' -f $RivetSchemaName,$RivetMigrationsTableName

dir $PSScriptRoot *-*.ps1 |
    Where-Object { $_.BaseName -ne 'Import-Rivet' -and $_.BaseName -ne 'Get-Migration' } |
    ForEach-Object { . $_.FullName }

$publicFunctions = @(
                        'Add-Column',
                        'Add-DefaultConstraint',
                        'Add-Description',
                        'Add-ForeignKey',
                        'Add-Index',
                        'Add-PrimaryKey',
                        'Add-Schema',
                        'Add-Table',
                        'Add-UniqueConstraint',
                        'Get-Migration',
                        'Invoke-Rivet',
                        'Invoke-SqlScript',
                        'New-Column',
                        'Remove-Column',
                        'Remove-DefaultConstraint',
                        'Remove-Description',
                        'Remove-ForeignKey',
                        'Remove-Index',
                        'Remove-PrimaryKey',
                        'Remove-Schema',
                        'Remove-StoredProcedure',
                        'Remove-Table',
                        'Remove-UniqueConstraint',
                        'Remove-UserDefinedFunction',
                        'Remove-View',
                        'Set-StoredProcedure',
                        'Set-UserDefinedFunction',
                        'Set-View',
                        'Update-Description'
                      )

Export-ModuleMember -Function $publicFunctions
