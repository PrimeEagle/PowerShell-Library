<#
	.SYNOPSIS
	Short description.
	
	.DESCRIPTION
	Long description.

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
using module Varan.PowerShell.SelfElevate
using module Varan.PowerShell.Summary
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Base
#Requires -Modules Varan.PowerShell.Common
#Requires -Modules Varan.PowerShell.Music
#Requires -Modules Varan.PowerShell.PerformanceTimer
#Requires -Modules Varan.PowerShell.SelfElevate
#Requires -Modules Varan.PowerShell.Summary
#Requires -Modules Varan.PowerShell.Validation
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (	
	  )
DynamicParam { Build-BaseParameters -IncludeMusicPathQueues }

Begin
{	
	Write-LogTrace "Execute: $(Get-RootScriptName)"
	$cmd = @{}

	if(Get-BaseParamHelpFull) { $cmd.HelpFull = $true }
	if((Get-BaseParamHelpDetail) -Or ($PSBoundParameters.Count -eq 0)) { $cmd.HelpDetail = $true }
	if(Get-BaseParamHelpSynopsis) { $cmd.HelpSynopsis = $true }
	if($cmd.Count -gt 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" -HelpDetail }
	if($cmd.Count -eq 1) { Write-DisplayHelp -Name "$(Get-RootScriptPath)" @cmd }
}
Process
{
	try
	{
		$isDebug = Assert-Debug
		
		if(-Not (Assert-PathQueueParameter))
		{
			Write-DisplayHelp -Name "$(Get-RootScriptPath)" -HelpDetail
		}
	
		$queue = Get-PathQueue -DrivePreset (Get-BaseParamDrivePreset) -DriveLetter (Get-BaseParamDriveLetter) -DriveLabel (Get-BaseParamDriveLabel) -Path (Get-BaseParamPath)

		foreach($q in $queue)
		{	
			if($q.BackupPath.Length -eq 0) { continue }
		}
	}
	catch [System.Exception]
	{
		Write-DisplayError $PSItem.ToString() -Exit
	}
}
End
{
	Write-DisplayHost "Done." -Style Done
}
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------