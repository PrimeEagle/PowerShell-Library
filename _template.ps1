<#
	.SYNOPSIS
	Cleans undesired files and directories from USB drives.
	
	.DESCRIPTION
	Cleans undesired files and directories from USB drives, based on an array of drive letters or pre-defined drive names.

	.PARAMETER Drive
	Pre-defined drive name to use.
	
	.INPUTS
	Drive letter or drive label. You can pipe drive letters or drive labels as System.String.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> .\mucl -Drive Music1,Music4
#>
using module Varan.PowerShell.Music
using module Varan.PowerShell.PerformanceTimer
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Base, Varan.PowerShell.Common, Varan.PowerShell.Music, Varan.PowerShell.PerformanceTimer
[CmdletBinding(SupportsShouldProcess)]
param (	
	  )
DynamicParam { Build-BaseParameters }

Begin
{
	Write-LogTrace "Execute: $(Get-RootScriptName)"
	if($PSCmdlet.ParameterSetName -eq 'setDefault' -Or (Get-BaseParamHelp)) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" -Full }
}

Process
{

}

End
{
	Write-DisplayHost "Done." -Style Done
}
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------