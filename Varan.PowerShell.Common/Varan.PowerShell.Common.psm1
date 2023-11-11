<#
scripts to do
-------------
chkdsk - redirect output to log? run as admin?
build - increment version number
versioning for script to show up in Get-Command

add options to muhelp for module help

audioz automate download
#>
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
[CmdletBinding(SupportsShouldProcess)]
param ()

. ($PSScriptRoot + "\Varan.PowerShell.Common.Config.ps1")
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Export-ModuleMember -Function *