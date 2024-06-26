#
# Module manifest for module 'Varan.PowerShell.Common'
#
# Generated by: John Varan
#
# Generated on: 4/12/2022
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Varan.PowerShell.Common'

# Version number of this module.
ModuleVersion = '1.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '332514d6-4bbb-4636-b9d2-65c2efed8751'

# Author of this module
Author = 'John Varan'

# Company or vendor of this module
# CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2024 John Varan. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @('')

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('Varan.PowerShell.Common.Core','Varan.PowerShell.Common.Display', 'Varan.PowerShell.Common.Logging', 
'Varan.PowerShell.Common.Help', 'Varan.PowerShell.Common.Format', 'Varan.PowerShell.Common.IO', 'Varan.PowerShell.Common.Installation',
'Varan.PowerShell.Common.Zip')

#Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Get-RootScriptPath','Get-RootScriptName','Write-DisplayHost','Write-DisplayStatus','Write-DisplayDebug','Write-DisplayTrace',
'Write-DisplayInfo','Write-DisplayWarning','Write-DisplayError','Write-DisplayHelp','Write-LogHost','Write-LogStatus','Write-LogDebug','Write-LogTrace',
'Write-LogInfo','Write-LogWarning','Write-LogError','Write-DisplayTraceCallerInfo','Confirm-USBDrives','Assert-Debug','Assert-Trace','Assert-Silent',
'Assert-Verbose','Assert-WhatIf','Assert-Testing','Update-Path','Format-Number','Format-Time','Get-MeasureWord','Reset-HostLine','ConvertTo-RegEx','Test-Param','Get-Directories',
'Get-Files', 'Get-BaseParamHelpFull', 'Get-BaseParamHelpDetail', 'Get-BaseParamHelpSynopsis', 'Get-BaseParamTrace', 'Get-BaseParamSilent', 'Get-BaseParamSummary',
'Get-BaseParamSummarySource', 'Get-BaseParamSummaryOutput', 'Get-BaseParamSummaryFilename', 'Get-BaseParamDrivePreset', 'Get-BaseParamDriveLetter', 'Get-BaseParamDriveLabel',
'Get-BaseParamPath', 'Get-BaseParamTesting', 'Get-BaseParamDebugItem', 'Get-BaseParamDebugItemAction', 'Test-ShowFunction', 'Exit-Script', 'Add-AliasToProfile', 'Remove-AliasFromProfile', 'Remove-Substring',
'Add-PathToProfile', 'Remove-PathFromProfile', 'Add-UsingModuleToProfile', 'Remove-UsingModuleFromProfile', 'Add-ImportModuleToProfile', 'Remove-ImportModuleFromProfile', 'Confirm-FileHasLine', 'Add-IntoFileSection', 'Remove-FromFile',
'Get-PathPart', 'Get-ZipList', 'Test-ZipIntegrity', 'Test-ZipHasSingleTopLevelDirectory', 'Expand-Zip', 'Test-PathIsDirectory', 'Test-PathIsFile',
'Get-CommonParameterList', 'Confirm-DirectoryExists', 'Add-LineToProfile', 'Remove-LineFromProfile', 'Get-PathQueue', 'Assert-PathQueueParameter', 'Rename-InvalidFilename',
'Add-SymbolicLink', 'Remove-SymbolicLink', 'Test-SymbolicLink', 'Test-ZipPassword', 'Edit-PathDrive', 'Get-DirectorySize', 'Get-FileLabel', 'Get-DirectoryLabel', 'Backup-Directory',
'Format-FileSize', 'Update-ModuleHelp', 'Get-LineFromFile', 'Add-NuGetType',
'Test-ModuleInstalled', 'Install-Moduel', 'Uninstall-Module', 'Import-LocalModule', 'Format-Profile', 'Use-Module', 'Complete-Install')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this modulef
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}