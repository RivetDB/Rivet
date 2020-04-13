#
# Module manifest for module 'RivetTest'
#
# Generated by: Aaron Jensen
#
# Generated on: 5/23/2013
#

@{

    # Script module or binary module file associated with this manifest
    RootModule = 'RivetTest.psm1'

    # Version number of this module.
    ModuleVersion = '0.1.0.0'

    # ID used to uniquely identify this module
    GUID = '815217c6-29c6-4398-8310-28acd1cf345e'

    # Author of this module
    Author = 'Aaron Jensen'

    # Company or vendor of this module
    CompanyName = ''

    # Copyright statement for this module
    Copyright = '(c) 2013 Aaron Jensen. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Rivet Test Module'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = ''

    # Name of the Windows PowerShell host required by this module
    PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    #TypesToProcess = ''

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @()

    # Functions to export from this module
    FunctionsToExport = @(
        'Assert-CheckConstraint',
        'Assert-Column',
        'Assert-DataType',
        'Assert-DefaultConstraint',
        'Assert-ForeignKey',
        'Assert-Index',
        'Assert-PrimaryKey',
        'Assert-Row',
        'Assert-Schema',
        'Assert-StoredProcedure',
        'Assert-Synonym',
        'Assert-Table',
        'Assert-Trigger',
        'Assert-UniqueKey',
        'Assert-UserDefinedFunction',
        'Assert-View',
        'Clear-TestDatabase',
        'Get-ActivityInfo',
        'Get-CheckConstraint',
        'Get-Column',
        'Get-DataType',
        'Get-DefaultConstraint',
        'Get-ExtendedProperties',
        'Get-ExtendedProperty',
        'Get-ForeignKey',
        'Get-Index',
        'Get-IndexColumn',
        'Get-MigrationInfo',
        'Get-MigrationScript',
        'Get-PrimaryKey',
        'Get-Row',
        'Get-Schema',
        'Get-StoredProcedure',
        'Get-Synonym',
        'Get-SysObject',
        'Get-Table',
        'Get-Trigger',
        'Get-UniqueKey',
        'Get-UserDefinedFunction',
        'Get-View',
        'Invoke-RTRivet',
        'Invoke-RivetTestQuery',
        'Measure-Migration',
        'Measure-MigrationScript',
        'New-ConstraintName',
        'New-Database',
        'New-File',
        'New-ForeignKeyConstraintName',
        'New-TestMigration',
        'New-SqlConnection',
        'Remove-RivetTestDatabase',
        'Set-PluginPath',
        'Start-RivetTest',
        'Stop-RivetTest',
        'Test-CheckConstraint',
        'Test-Column',
        'Test-Database',
        'Test-DatabaseObject',
        'Test-DataType',
        'Test-DefaultConstraint',
        'Test-ExtendedProperty',
        'Test-ForeignKey',
        'Test-Index',
        'Test-Pester',
        'Test-PrimaryKey',
        'Test-Row',
        'Test-Schema',
        'Test-StoredProcedure',
        'Test-Synonym',
        'Test-Table',
        'Test-Trigger',
        'Test-UniqueKey',
        'Test-UserDefinedFunction',
        'Test-View',
        'Write-RTTiming'
    )

    # Cmdlets to export from this module
    #CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = @(
        'RTDatabaseName',
        'RTConfigFilePath',
        'RTDatabaseName',
        'RTDatabase2Name',
        'RTDatabasesRoot',
        'RTDatabaseRoot',
        'RTDatabaseMigrationRoot',
        'RTRivetPath',
        'RTRivetRoot',
        'RTRivetSchemaName',
        'RTServer',
        'RTTestRoot',
        'RTTimestamp'
    )

    # Aliases to export from this module
    AliasesToExport = 'GivenFile'

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @()

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = ''

}

