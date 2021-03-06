#
# Module manifest for module 'Rivet'
#
# Generated by: Aaron Jensen
#
# Generated on: 1/25/2013
#

@{
    # Script module or binary module file associated with this manifest
    RootModule = 'Rivet.psm1'

    # Version number of this module.
    ModuleVersion = '0.11.0'

    # ID used to uniquely identify this module
    GUID = '8af34b47-259b-4630-a945-75d38c33b94d'

    # Author of this module
    Author = 'WebMD Health Services'

    # Company or vendor of this module
    CompanyName = 'WebMD Health Services'

    CompatiblePSEditions = @( 'Desktop', 'Core' )

    # Copyright statement for this module
    Copyright = 'Copyright 2013 - 2019 WebMD Health Services.'

    # Description of the functionality provided by this module
    Description = @'
Rivet is a database migration/change management/versioning tool inspired by Ruby on Rails' Migrations. It creates and applies migration scripts for SQL Server databases. Migration scripts describe changes to make to your database, e.g. add a table, add a column, remove an index, etc. Migrations scripts should get added to your version control system so they can be packaged and deployed with your application's code.
'@

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

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
    RequiredAssemblies = @( 'bin\Rivet.dll' )

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    #TypesToProcess = ''

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @( 
                            'Formats\RivetMigrationResult-GroupingFormat.format.ps1xml',
                            'Formats\RivetOperationResult-GroupingFormat.format.ps1xml',
                            'Formats\Rivet.Migration.format.ps1xml',
                            'Formats\Rivet.OperationResult.format.ps1xml'
                        )

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = @( 'bin\Rivet.dll' )

    # Functions to export from this module
    FunctionsToExport = @(
        'Add-CheckConstraint',
        'Add-DataType',
        'Add-DefaultConstraint',
        'Add-Description',
        'Add-ExtendedProperty',
        'Add-ForeignKey',
        'Add-PrimaryKey',
        'Add-Row',
        'Add-RowGuidCol',
        'Add-Schema',
        'Add-StoredProcedure',
        'Add-Synonym',
        'Add-Table',
        'Add-Trigger',
        'Add-UniqueKey',
        'Add-UserDefinedFunction',
        'Add-View',
        'Disable-Constraint',
        'Enable-Constraint',
        'Export-Migration',
        'Get-Migration',
        'Get-Migration',
        'Get-RivetConfig',
        'Get-RivetConfig',
        'Import-RivetPlugin',
        'Invoke-Ddl',
        'Invoke-Rivet',
        'Invoke-Rivet',
        'Invoke-RivetPlugin',
        'Invoke-SqlScript',
        'Merge-Migration',
        'New-BigIntColumn',
        'New-BinaryColumn',
        'New-BitColumn',
        'New-CharColumn',
        'New-Column',
        'New-DateColumn',
        'New-DateTime2Column',
        'New-DateTimeColumn',
        'New-DateTimeOffsetColumn',
        'New-DecimalColumn',
        'New-FloatColumn',
        'New-HierarchyIDColumn',
        'New-IntColumn',
        'New-Migration',
        'New-MoneyColumn',
        'New-NCharColumn',
        'New-NVarCharColumn',
        'New-RealColumn',
        'New-RowVersionColumn',
        'New-SmallDateTimeColumn',
        'New-SmallIntColumn',
        'New-SmallMoneyColumn',
        'New-SqlVariantColumn',
        'New-TimeColumn',
        'New-TinyIntColumn',
        'New-UniqueIdentifierColumn',
        'New-VarBinaryColumn',
        'New-VarCharColumn',
        'New-XmlColumn',
        'Remove-CheckConstraint',
        'Remove-DataType',
        'Remove-DefaultConstraint',
        'Remove-Description',
        'Remove-ExtendedProperty',
        'Remove-ForeignKey',
        'Remove-Index',
        'Remove-PrimaryKey',
        'Remove-Row',
        'Remove-RowGuidCol',
        'Remove-Schema',
        'Remove-StoredProcedure',
        'Remove-Synonym',
        'Remove-Table',
        'Remove-Trigger',
        'Remove-UniqueKey',
        'Remove-UserDefinedFunction',
        'Remove-View',
        'Rename-Column',
        'Rename-DataType',
        'Rename-Index',
        'Rename-Object',
        'Stop-Migration',
        'Update-CodeObjectMetadata',
        'Update-Description',
        'Update-ExtendedProperty',
        'Update-Row',
        'Update-StoredProcedure',
        'Update-Table',
        'Update-Trigger',
        'Update-UserDefinedFunction',
        'Update-View'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @(
        'Add-Index'
    )

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport = @(
        'BigInt',
        'Binary',
        'Bit',
        'Char',
        'Date',
        'DateTime',
        'DateTime2',
        'DateTimeOffset',
        'Decimal',
        'Disable-CheckConstraint',
        'Enable-CheckConstraint',
        'Float',
        'HierarchyID',
        'Int',
        'Money',
        'NChar',
        'New-NumericColumn',
        'Numeric',
        'NVarChar',
        'Real',
        'rivet',
        'RowVersion',
        'SmallDateTime',
        'SmallInt',
        'SmallMoney',
        'SqlVariant',
        'Time',
        'TinyInt',
        'UniqueIdentifier',
        'VarBinary',
        'VarChar',
        'Xml'
    )

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @()

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('sql-server','evolutionary-database','database','migrations')

            # A URL to the license for this module.
            LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

            # A URL to the main website for this project.
            ProjectUri = 'http://get-rivet.org'

            # A URL to an icon representing this module.
            # IconUri = ''

            Prerelease = ''

            # ReleaseNotes of this module
            ReleaseNotes = @'
## Upgrade Instructions

This version of Rivet is backwards-incompatible. It changes the way plug-ins work. In order to upgrade to this version, you'll need to update your plugins and your rivet.json file.

1. Package your plugins into a PowerShell module. Make sure your plug-in functions are exported by your module.
2. Add the attribute `[Rivet.Plugin([Rivet.Event]::BeforeOperationLoad)]` to any existing `Start-MigrationOperation` functions.
3. Add the attribute `[Rivet.Plugin([Rivet.Event]::AfterOperationLoad)]` to any existing `Complete-MigrationOperation` functions.
4. Change the `PluginsRoot` setting in your rivet.json file to `PluginPaths`. Change its value to the path to the module you created in step 1.

See `about_Rivet_Plugins` for more information.

## Changes

* Created `Export-Migration` function for exporting database objects as Rivet migrations.
* Rivet can now add XML columns that don't have schema associated with them.
* `New-Column` can now be used to create columns on tables that have custom size specifications, are rowguidcol, are identities, custom collations, and are file stream.
* Fixed: `Merge-Migration` doesn't merge `Add-RowGuidCol` and `Remove-RowGuidCol` operations into `Add-Table`/`Update-Table` operations.
* ***Breaking Change***: Rivet plug-ins must now be packaged as/in PowerShell modules. The `PluginsRoot` configuration option has been renamed to `PluginPaths` and should be a list of paths were Rivet can find the PowerShell modules containing your plug-ins. These paths are imported using the `Import-Module` command. See `about_Rivet_Plugins` for more information.
* The `PluginsPath` (fka `PluginsRoot`) configuration setting is now allowed to have wildcards.
* Completely re-architected how `Merge-Migration` merges migrations together. This fixed a lot of bugs where many operations were not merging correctly. 
* The Convert-Migration.ps1 sample script no longer include a header for all migrations that affected an operation, since Rivet no longer exposes this information. Instead, it only adds an author header for the migration an operation ends up in.
* The `Remove-DefaultConstraint` operation's `ColumnName` parameter is now required. When merging operations, Rivet needs to know what column a default expression operates on. You'll get a warning if it isn't provided. In a future version of Rivet, this parameter will be made mandatory.
* Default constraint names are now required. You must pass a constraint name to the Add-DefaultConstraint operator's Name parameter and to the DefaultConstraintName parameter on any column definition that has a default value.
* Performance improvement: Rivet now only queries once for the state of all applied migrations instead of querying for every migration.
* Performance improvement: Rivet only reads migration files that haven't been applied to a database. This should help with backwards-compatability. If Rivet's API changes only migrations you want to push/pop will need to get updated to match the new API.
* Unique key constraint names are now required. You must pass a constraint name to the Add-UniqueKey operation's Name parameter.
* Primary key constraint names are now required. You must pass a constraint name to the Add-PrimaryKey operation's Name parameter.
* Foreign key constraint names are now required. You must pass a constraint name to the Add-ForeignKey operation's Name parameter.
* Index names are now required. You must pass an index name to the Add-Index operation's Name parameter.
'@
        } # End of PSData hashtable

    } # End of PrivateData hashtable
}
