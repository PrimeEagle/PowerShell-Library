using module Varan.PowerShell.Base
using module Varan.PowerShell.Validation
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
[CmdletBinding(SupportsShouldProcess)]
param ()
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Remove-Substring
{
	[CmdletBinding()]
    param(	[Parameter(Mandatory = $true)]	[AllowEmptyString()]						[string]$Name,
			[Parameter(Mandatory = $true)]	[AllowEmptyString()]						[string]$Substring,
			[Parameter()]					[ValidateRange(0, [int]::MaxValue)]			[int]	$Index = -1,
			[Parameter()]																[switch]$CaseInsensitive,
			[Parameter()]																[switch]$WholeWord)

	if(	($Name.Length -eq 0) -Or
		($Substring.Length -eq 0) -Or
		($Substring.Length -gt $Name.Length))
	{
		return $Name
	}
	
	$pattern  = ''
	
	if($CaseInsensitive) { $pattern += '(?i-)' }
	
	$pattern += [RegEx]::Escape($Substring)
	
	if($WholeWord) { $pattern = "\b$pattern(?:\b|(?=\s))" }
	
	
	
	$matches = [RegEx]::Matches($Name, $pattern)

	if(-Not $matches) { return $Name }

	$result = $Name
	
	if($Index -ge 0)
	{
		foreach($m in $matches)
		{
			if($m.Index -eq $Index)
			{
				$result = ($Name.Substring(0, $Index) + $Name.Substring($Index + $m.Value.Length))
			}
		}
	}
	elseif($CaseInsensitive)
	{	
		$result = $Name -IReplace $pattern, ''
	}
	else
	{
		$result = $Name -Replace $pattern, ''
	}
	
	return $result
}

function Get-RootInvocationInfo
{
	[CmdletBinding()]
    param()
	
	$stack = Get-PSCallStack
	$result = $stack.InvocationInfo[-2]

	$result
}

function Get-RootScriptPath
{
	[CmdletBinding()]
    param()
	
	[string](Get-RootInvocationInfo).MyCommand.Path
}

function Get-RootScriptName
{
	[CmdletBinding()]
    param()
	
	$name = Get-PathPart -Path (Get-RootScriptPath) -FilenameNoExtension
}

function Get-RootBoundParameter
{
	[CmdletBinding()]
    param(	[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline = $true)]
						[ValidateVariable()]
						[string]$Parameter
		 ) 
		
	$rootInvocation = Get-RootInvocationInfo
	
	return $rootInvocation.BoundParameters[$Parameter]
}

function Get-RootSwitchParameter
{
	[CmdletBinding()]
    param(	[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline = $true)]
			[ValidateVariable()]
													[string]$Parameter
		 ) 
	
	$result = Get-RootBoundParameter $Parameter
	
	if($result)
	{
		return $true
	}
	else
	{
		return $false
	}
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Assert-Debug
{
	[CmdletBinding()]
    param()
	
	return ((Get-RootSwitchParameter Debug) -Or ($DebugPreference -ne 'SilentlyContinue'))
}

function Assert-Verbose
{
	[CmdletBinding()]
    param()
	
	return (Get-RootSwitchParameter Verbose)
}

function Assert-WhatIf
{
	[CmdletBinding()]
    param()
	
	return ((Get-RootSwitchParameter WhatIf) -Or ($WhatIfPreference))
}

function Assert-Trace
{
	[CmdletBinding()]
    param()
	
	return (Get-RootSwitchParameter Trace)
}

function Assert-Silent
{
	[CmdletBinding()]
    param()
	
	return (Get-RootSwitchParameter Silent)
}

function Assert-Testing
{
	[CmdletBinding()]
    param()
	
	return (Get-RootSwitchParameter Testing)
}

function Assert-PathQueueParameter
{
	[CmdletBinding()]
	param()
	
	return (((Get-BaseParamDrivePreset) -ne $null) -Or ((Get-BaseParamDriveLetter) -ne $null) -Or ((Get-BaseParamDriveLabel) -ne $null) -Or ((Get-BaseParamPath) -ne $null))
}

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Exit-Script
{
	[CmdletBinding()]
    param( [Parameter()] [switch]$Errored
		 ) 

	if($Errored) { exit 1 }
	else { exit 0 }
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Confirm-ValueExists
{
	[CmdletBinding()]
    param(	[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline = $true)]
			[AllowEmptyString()]
			[ValidateVariable()]						[string]$VariableName
		 ) 
	
	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		if(-Not (Get-Variable $VariableName -ErrorAction SilentlyContinue))
		{
			Write-DisplayTrace "Exit with error from $funcName"
			Write-DisplayError "Could not find required value $VariableName." -Exit
		}
	}
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get-BaseParamTrace
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter Trace
}

function Get-BaseParamHelpFull
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter HelpFull
}

function Get-BaseParamHelpDetail
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter HelpDetail
}

function Get-BaseParamHelpSynopsis
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter HelpSynopsis
}

function Get-BaseParamSilent
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter Silent
}

function Get-BaseParamSummary
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter Summary
}

function Get-BaseParamSummarySource
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter SummarySource
}

function Get-BaseParamSummaryOutput
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter SummaryOutput
}

function Get-BaseParamSummaryFilename
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter SummaryFilename
}

function Get-BaseParamTesting
{
	[CmdletBinding()]
    param()
	
	return Get-RootSwitchParameter Testing
}

function Get-BaseParamDrivePreset
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter DrivePreset
}

function Get-BaseParamDriveLetter
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter DriveLetter
}

function Get-BaseParamDriveLabel
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter DriveLabel
}

function Get-BaseParamPath
{
	[CmdletBinding()]
    param()
	Write-Host "Get-BaseParamPath"
	return Get-RootBoundParameter Path
}

function Get-BaseParamDebugItem
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter DebugItem
}

function Get-BaseParamDebugItemAction
{
	[CmdletBinding()]
    param()
	
	return Get-RootBoundParameter DebugItemAction
}

Export-ModuleMember -Function *