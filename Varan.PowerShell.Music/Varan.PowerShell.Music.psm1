using module Varan.PowerShell.Validation
using module Varan.PowerShell.Common
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Requires -Version 5.0
#Requires -Modules Varan.PowerShell.Common
[CmdletBinding(SupportsShouldProcess)]
param ()

. ($PSScriptRoot + "\Varan.PowerShell.Music.Config.ps1")
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class MatchResult
{
	[bool]		$Success = $false
	[string]	$Value = ''
	[string]	$MatchTerm = ''
	[int]		$Index = -1
	[string]	$MatchTermPrefix = ''
	[int]		$IndexPrefix = -1
	[string]	$MatchTermSuffix = ''
	[int]		$IndexSuffix = -1
	[string]	$NewName = ''
}

class ExpansionResult
{
	[bool]		$IsExpansion = $false
	[bool]		$IsSpecialExpansion = $false
	[string]	$ExpansionName = ''
	[string]	$ExpansionDeveloper = ''
	[string]	$ExpansionDeveloperDisplay = ''
	[string]	$ExpansionHost = ''
	[string]	$RemainingName = ''
}

class DeveloperResult
{
	[bool]		$HasDeveloper = $false
	[string]	$DeveloperName = ''
	[string]	$RemainingName = ''
}

function Confirm-USBDrives
{
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	if(-Not (Assert-Testing))
	{
		$drives = Get-CimInstance -ClassName Win32_DiskDrive | where{$_.InterfaceType -eq 'USB' -Or $_.InterfaceType -eq 'SCSI'}
		
		if($drives.Length -ne $numUSBDrives)
		{
			Write-DisplayTrace "Exit with error from $funcName"
			Write-DisplayError "All USB drives not present ($($drives.Length) of $numUSBDrives found)." -Exit
		}
	}
	
	Write-DisplayTrace "Exit $funcName"
}

function Confirm-USBDrivesIterative
{
	param ( 
			[Parameter(Position = 0, Mandatory = $true)] [int]$Count
	)
	
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters

	if(-Not (Assert-Testing))
	{
		if($Count % $usbDriveCheckInterval -eq 0) { Confirm-USBDrives }	
	}
	
	Write-DisplayTrace "Exit $funcName"
}
	
function Get-Developer
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )
			
	$result = [DeveloperResult]::new()
	
	foreach($devName in $DeveloperList)
	{
		$devEsc = [RegEx]::Escape($devName)
		
		$devPattern = "(?i)^$devEsc(?:(?:'|`)s){0,1}(?:\b|(?=\s))"
		$devM = [RegEx]::Match($Name, $devPattern)
		if($devM.Success) 
		{ 
			$result.HasDeveloper = $true
			$result.DeveloperName = $devName
			$result.RemainingName = (Remove-Substring -Name $Name -Substring "$devName's" -Index 0 -WholeWord -CaseInsensitive).Trim()
			$result.RemainingName = (Remove-Substring -Name $result.RemainingName -Substring "$devName``s" -Index 0 -WholeWord -CaseInsensitive).Trim()
			$result.RemainingName = (Remove-Substring -Name $result.RemainingName -Substring $devName -Index 0 -WholeWord -CaseInsensitive).Trim()
		}
		else
		{
			$result.RemainingName = $Name
		}
		
		if($result.HasDeveloper) { break }
	}
		
	return $result
}

function Remove-Developer
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )
	
	$result = $Name
	
	$dev = Get-Developer -Name $Name -DeveloperList $DeveloperList
	
	if($dev.HasDeveloper -gt 0)
	{
		$result = (Remove-Substring -Name $Name -Substring $dev.DeveloperName -Index 0 -CaseInsensitive).Trim()
	}
	
	return $result
}

function Get-ExpansionInfo
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[AllowEmptyString()]
			[string] $PrimaryDeveloper,
			
			[Parameter(Mandatory = $true)]
			#[ValidatePath(MustExist)]
			[string] $Path,
			
			[Parameter(Mandatory = $true)]
			[string[]] $Keys,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )
	
	$result = [ExpansionResult]::new()
	$result.RemainingName = $Name
	$nameLower = $Name.ToLower()
	$indicatorUsed = ''
	

	# check for special expansions
	foreach($se in $specialExpansionFunctions.GetEnumerator())
	{
		Write-DisplayDebug "Get-ExpansionInfo: checking special expansion '$($se.Name)' against '$PrimaryDeveloper'"
		if($PrimaryDeveloper -eq $se.Name)
		{
			$result = Invoke-Expression  "$($se.Value) -Name ""$Name"" -Path ""$Path"" -Keys ""$($Keys -Join ',')"" -DeveloperList ""$($DeveloperList -Join ',')"""
			return $result
		}
	}
	
	# check for exceptions
	foreach($ee in $expansionExceptions)
	{
		Write-DisplayDebug "Get-ExpansionInfo: checking exception '$($ee.ToLower())' against '$($Name.ToLower())'"
		if($Name.ToLower().Contains($ee.ToLower()))
		{
			return $result
		}
	}
	
	$prefixTag = 'for'

	$nameToUse = $Name
	$fm = [RegEx]::Match($Name, "(?i)\bfor\b")
	if($fm.Success -And ($fm.Index + $prefixTag.Length + 1 -lt $Name.Length))
	{
		Write-DisplayDebug "Get-ExpansionInfo: found '$prefixTag'"
		$idx = $fm.Index
		$nameToUse = $Name.Substring($idx + $prefixTag.Length + 1)
		Write-DisplayDebug "Get-ExpansionInfo: nameToUse=$nameToUse"
		$result.IsExpansion = $true
	}
	
	if(-Not $result.IsExpansion)
	{
		foreach($t in $expansionIndicators)
		{	
			$tEsc = [RegEx]::Escape($t)
			$pattern = "\b(?i)$tEsc\b"
			$sm = [RegEx]::Match($nameToUse, $pattern)
			
			if($sm.Success)
			{
				Write-DisplayDebug "Get-ExpansionInfo: found based on '$t'"
				$result.IsExpansion = $true
				$nameToUse = $Name.Substring(0, $sm.Index)
				Write-DisplayDebug "Get-ExpansionInfo: nameToUse=$nameToUse"
				$indicatorUsed = $t
				break
			}
		}
	}
	
	if($result.IsExpansion)
	{	
		$matched = $false
		$matchIdx = -1
		
		foreach($k in $Keys)
		{
			$substring = ''
			$e = $expansionHosts[$k]
			
			$eName = [RegEx]::Escape($k)
			$eVal = [RegEx]::Escape($e)
		
			if(-Not $matched)
			{
				$patVal= "\b(?i)$eVal\b"
				$mVal = [RegEx]::Match($nameToUse, $patVal)
				Write-DisplayDebug "Get-ExpansionInfo:    checking $e"
				
				if($mVal.Success)
				{
					Write-DisplayDebug "Get-ExpansionInfo: found based on value '$e'"
					$matched = $true
					$result.ExpansionName = $e
				
					if($indicatorUsed.Length -eq 0)
					{
						$substring = "$prefixTag $e"
					}
					else
					{
						$substring = $result.ExpansionName
					}
				}
			}
			
			if(-Not $matched)
			{
				$patName= "\b(?i)$eName\b"
				$mName = [RegEx]::Match($nameToUse, $patName)
				Write-DisplayDebug "Get-ExpansionInfo:    checking $k"
			
				if($mName.Success)
				{
					Write-DisplayDebug "Get-ExpansionInfo: found based on name '$k'"
					$matched = $true
					$result.ExpansionName = $e
					
					if($indicatorUsed.Length -eq 0)
					{
						$substring = "$prefixTag $k"
					}
					else
					{
						$substring = $result.ExpansionName
					}
				}
			}
			
			if($substring.Length -gt 0)
			{
				$repToken = '#####'
				$foundEE = ''
				
				foreach($ee in $expansionReplacementExceptions)
				{
					$eeEsc = [RegEx]::Escape($ee)
					$pattern = "(?i)\b$eeEsc\b"
					
					if($Name -Match $pattern)
					{
						[RegEx]::Replace($Name, $pattern, $repToken, @('IgnoreCase'))
						$foundEE = $ee
						break
					}
				}
				
				$remainingName = (Remove-Substring -Name $Name -Substring $substring -WholeWord -CaseInsensitive).Trim()
				$remainingName = [RegEx]::Replace($remainingName, "(?i)\b$indicatorUsed\b", '', @('IgnoreCase'))
				$remainingName = [RegEx]::Replace($remainingName, "(?i)\b$eVal\b", '', @('IgnoreCase'))
				$remainingName = [RegEx]::Replace($remainingName, "(?i)\b$eName\b", '', @('IgnoreCase'))
				$remainingName = $remainingName.Replace($repToken, $foundEE)
			
				$result.RemainingName = $remainingName
			}
			
			if($matched) { break }
		}
	}
		
	
	# check .nfo files
	if(-Not $result.IsExpansion)
	{
		$result = Get-ExpansionInfoFromFiles -Name $Name -Path $Path -Keys $Keys
	}
	
	if($result.ExpansionName.Length -gt 0)
	{
		$result.ExpansionDeveloper = (Get-Developer -Name $result.ExpansionName -DeveloperList $DeveloperList).DeveloperName
		$result.ExpansionHost = (Remove-Substring -Name ($result.ExpansionName) -Substring ($result.ExpansionDeveloper) -WholeWord -CaseInsensitive).Trim()
	}
	
	if($result.ExpansionDeveloper -eq $PrimaryDeveloper)
	{
		foreach($ad in $altDevelopers.GetEnumerator())
		{
			$adName = $ad.Name
			$adVal = $ad.Value
			
			if($Name.StartsWith($adVal) -Or $result.ExpansionName -eq $adVal)
			{
				$result.ExpansionDeveloperDisplay = $adName
				break
			}
		}
	}
	else
	{
		$result.ExpansionDeveloperDisplay = $result.ExpansionDeveloper
	}

	Write-DisplayDebug "result = $($result | Out-String)"
	return $result
}

function Get-ExpansionInfoFromFiles
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			#[ValidatePath(MustExist)]
			[string] $Path,
			
			[Parameter(Mandatory = $true)]
			[string[]] $Keys
		  )
	
	$nfoFiles = Get-ChildItem -Path "$Path\*" -File -Include @('*.nfo')
	$result = [ExpansionResult]::new()
	$result.RemainingName = $Name
	
	foreach($nf in $nfoFiles)
	{	
		$nfoFilename = Rename-InvalidFilename -Filename $nf.FullName
		$result.IsExpansion = $false
		Write-DisplayDebug "Get-ExpansionInfo: checking file '$nfoFilename'"
		
		$lines = Get-Content $nfoFilename
		
		foreach($line in $lines)
		{
			foreach($t in $expansionIndicators)
			{		
				$tEsc = [RegEx]::Escape($t)
				$pattern = "\b(?i)$tEsc\b"
				$sm = [RegEx]::Match($line, $pattern)
				
				if($sm.Success)
				{
					$idx = $sm.Index
					$after = $line.Substring($idx + $t.Length)
					Write-DisplayDebug "Get-ExpansionInfo: after '$after'"
					if($after.Length -ge 2 -And $after.Substring(0, 1) -ne ':' -And $after.Substring(1, 1) -ne ':')
					{
						Write-DisplayDebug "Get-ExpansionInfo: isExpansion based on '$t' on line '$line'"
						$result.IsExpansion = $true
						break
					}
				}
			}
			
			if($result.IsExpansion) { break }
		}
		
		if($result.IsExpansion)
		{	
			$matched = $false
			
			foreach($line in $lines)
			{
				if($line.Trim().Length -eq 0) { continue }
					
				foreach($k in $Keys)
				{
					$e = $expansionHosts[$k]
					
					$eName = [RegEx]::Escape($k)
					$eVal = [RegEx]::Escape($e)
					
					if(-Not $matched)
					{
						$patVal= "\b(?i)$eVal\b"
						$mVal = [RegEx]::Match($Name, $patVal)
						
						if($mVal.Success)
						{
							Write-DisplayDebug "Get-ExpansionInfo: found '$e' (value) on line '$line'"
							$matched = $true
							$result.ExpansionName = $e.Value
						}
					}
					
					
					if(-Not $matched)
					{
						$patName= "\b(?i)$eName\b"
						$mName = [RegEx]::Match($Name, $patName)

						if($mName.Success)
						{
							Write-DisplayDebug "Get-ExpansionInfo: found '$k' (name) on line '$line'"
							$matched = $true
							$result.ExpansionName = $e.Value
						}
					}
					
					if($matched) { break }
				}
				
				if($matced) { break }
			}
		}
		
		if($matched) { break }
	}
	
	return $result
}

function Get-ExpansionNativeInstruments
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[ValidatePath(MustExist)]
			[string] $Path,
			
			[Parameter(Mandatory = $true)]
			[string[]] $Keys,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )

	Write-DisplayDebug "Get-ExpansionInfo: special expansion Native Instruments"
	$result = [ExpansionResult]::new()
	$result.IsExpansion = $false
	$result.IsSpecialExpansion = $true
	$result.RemainingName = $Name
	
	return $result
}

function Get-ExpansionReasonStudios
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[ValidatePath(MustExist)]
			[string] $Path,
			
			[Parameter(Mandatory = $true)]
			[string[]] $Keys,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )
	
	Write-DisplayDebug "Get-ExpansionInfo: special expansion Reason Studios"	
	$result = [ExpansionResult]::new()
	$result.IsExpansion = $false
	$result.IsSpecialExpansion = $true
	$result.RemainingName = $Name
	
	
	return $result
}

function Get-ExpansionUvi
{
	[CmdletBinding(SupportsShouldProcess)]
	param (	[Parameter(Mandatory = $true)]
			[string] $Name,
			
			[Parameter(Mandatory = $true)]
			[ValidatePath(MustExist)]
			[string] $Path,
			
			[Parameter(Mandatory = $true)]
			[string[]] $Keys,
			
			[Parameter(Mandatory = $true)]
			[string[]] $DeveloperList
		  )
	
	Write-DisplayDebug "Get-ExpansionInfo: special expansion UVI"
	$result = [ExpansionResult]::new()
	$result.IsExpansion = $false
	$result.IsSpecialExpansion = $true
	$result.RemainingName = $Name
	
	
	return $result
}

function Get-CompleteCaseSensitiveList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
			
	$result = [PSCustomObject]@{
		Pass1 = @()
		Pass2 = @()
		Pass1Devs = @()
		Pass2Devs = @()
		Pass1Lower = @()
		Pass2Lower = @()
		Pass1DevsLower = @()
		Pass2DevsLower = @()
	}

	$caseSensitivePhrases1 = ($caseSensitivePhrases | Where { -Not $_.Contains(' ') })
	$caseSensitivePhrases1 += ($dashesToKeep | Where { -Not $_.Contains(' ') })
	$caseSensitivePhrases1 += ($periodsToKeep | Where { -Not $_.Contains(' ') })
	$caseSensitivePhrases1 += ($commasToKeep | Where { -Not $_.Contains(' ') })
	$caseSensitivePhrases1 += ($underscoresToKeep | Where { -Not $_.Contains(' ') })
	$caseSensitivePhrases1 += $expansionHosts.Values | Where { -Not $_.Contains(' ') }
	$caseSensitivePhrases1 += $expansionHosts.Keys | Where { -Not $_.Contains(' ') }
	
	$caseSensitivePhrases2 = ($caseSensitivePhrases | Where { $_.Contains(' ') })
	$caseSensitivePhrases2 += ($dashesToKeep | Where { $_.Contains(' ') })
	$caseSensitivePhrases2 += ($periodsToKeep | Where { $_.Contains(' ') })
	$caseSensitivePhrases2 += ($commasToKeep | Where { $_.Contains(' ') })
	$caseSensitivePhrases2 += ($underscoresToKeep | Where { $_.Contains(' ') })
	$caseSensitivePhrases2 += ($labeledEditions | ForEach { "(" + $_ + " version)" })
	$caseSensitivePhrases2 += $expansionHosts.Values | Where { $_.Contains(' ') }
	$caseSensitivePhrases2 += $expansionHosts.Keys | Where { $_.Contains(' ') }

	$result.Pass1 = $caseSensitivePhrases1
	$result.Pass1Devs = ($developers | Where { -Not $_.Contains(' ') })
	$result.Pass2 = $caseSensitivePhrases2
	$result.Pass2Devs = ($developers | Where { $_.Contains(' ') })
	
	$result.Pass1Lower = $result.Pass1.ToLower()
	$result.Pass2Lower = $result.Pass2.ToLower()
	$result.Pass1DevsLower = $result.Pass1Devs.ToLower()
	$result.Pass2DevsLower = $result.Pass2Devs.ToLower()
	
	return $result
}

function Get-CompleteDashesToKeepList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
	
	$dList = Get-CompleteDevelopersList
	$result = $dashesToKeep
	$result += ($developers | Where { $_.Contains('-') })
	$result += ($expansionHosts.Values | Where { $_.Contains('-') }).ForEach({Remove-Developer $_ -DeveloperList $dList})
		
	return $result
}

function Get-CompletePeriodsToKeepList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
	
	$dList = Get-CompleteDevelopersList
	$result = $periodsToKeep
	$result += ($developers | Where { $_.Contains('.') })
	$result += ($expansionHosts.Values | Where { $_.Contains('.') }).ForEach({Remove-Developer $_ -DeveloperList $dList})
		
	return $result
}

function Get-CompleteCommasToKeepList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
	
	$dList = Get-CompleteDevelopersList	
	$result = $commasToKeep
	$result += ($developers | Where { $_.Contains(',') })
	$result += ($expansionHosts.Values | Where { $_.Contains(',') }).ForEach({Remove-Developer $_ -DeveloperList $dList})
	
	return $result
}

function Get-CompleteUnderscoresToKeepList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
	
	$dList = Get-CompleteDevelopersList
	$result = $underscoresToKeep
	$result += ($developers | Where { $_.Contains('_') })
	$result += ($expansionHosts.Values | Where { $_.Contains('_') }).ForEach({Remove-Developer $_ -DeveloperList $dList})
	
	return $result
}

function Get-CompleteFirstLetterCapitalizationExceptionList
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
			
	$result = $exceptionsToFirstWordCapital
	$result += ($developers | Where { $_.ToLower().Substring(0) -ceq $_.Substring(0) })
		
	return $result
}

function Get-CompletePhrasesToRemoveKeys
{
	[CmdletBinding(SupportsShouldProcess)]
	param ()
			
	$result = $phrasesToRemove.Keys | Sort { $_.Length } -Descending
		
	return $result
}

function Get-CompleteExpansionKeys
{
	$keysToUse = $expansionHosts.Keys | Sort-Object { $_.Length } -Descending
	
	return $keysToUse
}

function Get-CompleteExpansionValues
{
	$valuesToUse = $expansionHosts.Values | Sort-Object { $_.Length } -Descending

	return $keyToUse
}

function Get-CompleteDevelopersList
{
	$devList = ($developers | Sort-Object { $_.Length } -Descending)
	
	return $devList
}

function Sync-DirectoryClear
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Mandatory = $true, ValueFromPipeline = $true)]				[string]$Source,
			[Parameter(Mandatory = $true, ValueFromPipeline = $true)]				[string]$Destination,
			[Parameter()]															[switch]$CheckUSBDrives,
			[Parameter()]															[switch]$Force
		  )

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$sFixed = Rename-InvalidFilename $Source
		$dFixed = Rename-InvalidFilename $Destination
		Write-DisplayDebug "`$sFixed = $sFixed"
		Write-DisplayDebug "`$dFixed = $dFixed"
		
		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('{tic} {mw:source file,source files:{tic}} found', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.Start()
		$srcFiles = @(Get-ChildItem -Path $sFixed -File -Force)
		$perfTimer.Stop($srcFiles.Count)
		
		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('{tic} {mw:source directory,source directories:{tic}} found', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.Start()
		$srcDirectories = @(Get-ChildItem -Path $sFixed -Force -Directory)
		$perfTimer.Stop($srcDirectories.Count)
		
		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('{tic} {mw:destination file,destination files:{tic}} found', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.Start()
		$destFiles = @(Get-ChildItem -Path $dFixed -Force -File)
		$perfTimer.Stop($destFiles.Count)

		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('{tic} {mw:destination directory,destination directories:{tic}} found', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.Start()	
		Write-DisplayDebug "`$dFixed = $dFixed"
		$destDirectories = @(Get-ChildItem -Path $dFixed -Force -Directory)
		$perfTimer.Stop($destDirectories.Count)
		
		$numRemoved = 0
		$removedNames = @()
		$fileCount = 0
		$directoryCount = 0
		
		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.CountMode = [PTCountMode]::Match
		$perfTimer.DisplayStatusOnIncrement = $true
		$perfTimer.DisplayStatusOnMatch = $true
		$perfTimer.TotalCountKnown = $true
		$perfTimer.TotalIncrementCount = $destFiles.Count
		$perfTimer.CustomValues = @()
		$perfTimer.ClearMessages([PTMessageType]::Start, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Analyzing', $null, [PTMessageType]::Start, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Increment, [PTMessagePosition]::Prefix)
		$perfTimer.AddMessage('Analyzing files {ic} of {tic}', '{is-tck}', [PTMessageType]::Increment, [PTMessagePosition]::Prefix)
		$perfTimer.ClearMessages([PTMessageType]::Increment, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Analyzed item {ic} of {tic} ({mc} {mw:file to delete,files to delete:{mc}})', '{is-tck} -And {is-cmm}', [PTMessageType]::Increment, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Found {mc} {mw:destination file,destination files:{mc}} to be removed', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Match, [PTMessagePosition]::Message)
		#$perfTimer.AddMessage('{mc} {mw:file,files:{mc}} found ({c0})', $null, [PTMessageType]::Match, [PTMessagePosition]::Message)
		$perfTimer.IncrementRateUnits = 'files/s'
		$perfTimer.Start()
		
		foreach($d in $destFiles)
		{		
			$fileCount++
			$perfTimer.CustomValues = @($f.Name)
			
			if($CheckUSBDrives) { Confirm-USBDrivesIterative $fileCount }
			
			$remove = $false
			$nameOnly = $d.FullName | Split-Path -Leaf
			$dName = $d.FullName
			$dFixed = Rename-InvalidFilename $dName
			Write-DisplayDebug "`$dFixed = $dFixed"
			
			$s = Edit-PathDrive -Path $dName -DriveFromPath $source
			$sFixed = Rename-InvalidFilename $s
			Write-DisplayDebug "`$sFixed = $sFixed"
			
			$action = ""
			$reason = ""	
			
			$perfTimer.Increment()
			
			Write-DisplayDebug "Test-Path `$sFixed = $(Test-Path $sFixed)"
			if ((Test-Path $sFixed) -eq $true)
			{			
				$action = "Analyzing"		
				$srcSize = (Get-Item $sFixed).Length
				$destSize = (Get-Item $dFixed).Length
				Write-DisplayDebug "`$srcSize = $srcSize"
				Write-DisplayDebug "`$destSize = $destSize"
				
				
				if($Force)
				{
					$action = "Deleting"
					$reason = "Forced"
					$remove = $true
					$perfTimer.IncrementMatch()
				}
				elseif($srcSize -ne $destSize) 
				{ 
					$action = "Deleting"
					$reason = "Different sizes [$(Format-FileSize $srcSize) vs. $(Format-FileSize $destSize)]"
					$remove = $true 
					$perfTimer.IncrementMatch()
				}
				else
				{
					$action = "Skipping"
				}
			}
			else
			{			
				$remove = $true
				$action = "Deleting"
				$reason = "Not in source"
				$perfTimer.IncrementMatch()
			}
			
			$actionReason = $action
			if($reason.Length -gt 0) { $actionReason += " - $reason" }
					
			Write-DisplayDebug "`$actionReason = $actionReason"
			Write-DisplayDebug "`$remove = $remove"
			if($remove)
			{
				if($PSCmdlet.ShouldProcess($dName, "Delete"))
				{
					Write-DisplayInfo "Remove-Item $dFixed"
					Remove-Item $dFixed -Recurse -Force  -WhatIf:$WhatIf
					$numRemoved++
					$removedNames += "$dName ($actionReason)"
				}
			}
		}
		$perfTimer.Stop()
		
	
		$perfTimer = [PerformanceTimer]::new()
		$perfTimer.CountMode = [PTCountMode]::Match
		$perfTimer.DisplayStatusOnIncrement = $true
		$perfTimer.DisplayStatusOnMatch = $true
		$perfTimer.TotalCountKnown = $true
		$perfTimer.TotalIncrementCount = $destDirectories.Count
		$perfTimer.CustomValues = @()
		$perfTimer.ClearMessages([PTMessageType]::Start, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Analyzing', $null, [PTMessageType]::Start, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Increment, [PTMessagePosition]::Prefix)
		$perfTimer.AddMessage('Analyzing files {ic} of {tic}', '{is-tck}', [PTMessageType]::Increment, [PTMessagePosition]::Prefix)
		$perfTimer.ClearMessages([PTMessageType]::Increment, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Analyzed item {ic} of {tic} ({mc} {mw:dir to delete,dirs to delete:{mc}})', '{is-tck} -And {is-cmm}', [PTMessageType]::Increment, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.AddMessage('Found {mc} {mw:destination directory,destination directories:{mc}} to be removed', '', [PTMessageType]::Stop, [PTMessagePosition]::Message)
		$perfTimer.ClearMessages([PTMessageType]::Match, [PTMessagePosition]::Message)
		#$perfTimer.AddMessage('{mc} {mw:directory,directories:{mc}} found ({c0})', $null, [PTMessageType]::Match, [PTMessagePosition]::Message)
		$perfTimer.IncrementRateUnits = 'dirs/s'
		$perfTimer.Start()
		
		foreach($d in $destDirectories)
		{		
			$directoryCount++
			$perfTimer.CustomValues = @($d.Name)
			
			if($CheckUSBDrives) { Confirm-USBDrivesIterative $directoryCount }
			
			$remove = $false
			$nameOnly = $d.FullName | Split-Path -Leaf
			$dName = $d.FullName
			$dFixed = Rename-InvalidFilename $dName
			Write-DisplayDebug "`$dFixed = $dFixed"
			
			$s = Edit-PathDrive -Path $dName -DriveFromPath $source
			$sFixed = Rename-InvalidFilename $s
			Write-DisplayDebug "`$sFixed = $sFixed"
			
			$action = ""
			$reason = ""
			
			$perfTimer.Increment()
			
			Write-DisplayDebug "Test-Path `$sFixed = $(Test-Path $sFixed)"
			if ((Test-Path $sFixed) -eq $true)
			{			
				$action = "Analyzing"					

				$srcResult = Get-DirectorySize $sFixed -Recurse -Force
				$destResult = Get-DirectorySize $dFixed -Recurse -Force
				
				Write-DisplayDebug "`$srcResult = $($srcResult | Out-String)"
				Write-DisplayDebug "`$destResult = $($destResult | Out-String)"
				
				if($Force)
				{
					$action = "Deleting"
					$reason = "Forced"
					$remove = $true
					$perfTimer.IncrementMatch()
				}
				elseif($srcResult.Size -ne $destResult.Size) 
				{ 
					$action = "Deleting"
					$reason = "Different sizes [$(Format-FileSize $srcResult.Size) vs. $(Format-FileSize $destResult.Size)]"
					$remove = $true 
					$perfTimer.IncrementMatch()
				}
				elseif($srcResult.Length -ne $destResult.Length) 
				{ 
					$action = "Deleting"
					$reason = "Different number of files"
					$remove = $true
					$perfTimer.IncrementMatch()
				}
				else
				{
					$action = "Skipping"
				}
			}
			else
			{			
				$remove = $true
				$action = "Deleting"
				$reason = "Not in source"
				$perfTimer.IncrementMatch()
			}
			
			$actionReason = $action
			if($reason.Length -gt 0) { $actionReason += " - $reason" }
			
			Write-DisplayDebug "`$actionReason = $actionReason"
			Write-DisplayDebug "`$remove = $remove"
			if($remove)
			{
				if($PSCmdlet.ShouldProcess($dName, "Delete"))
				{
					Write-DisplayInfo "Remove-Item $dFixed"
					Remove-Item $dFixed -Recurse -Force -WhatIf:$WhatIf
					$numRemoved++
					$removedNames += "$dName ($actionReason)"
				}
			}
		}
		$perfTimer.Stop()
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Sync-DirectoryCopy
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
	param ( [Parameter(Mandatory = $true, ValueFromPipeline = $true)] 	[string]$Source,
			[Parameter(Mandatory = $true, ValueFromPipeline = $true)] 	[string]$Destination,
			[Parameter()]			     								[switch]$CheckUSBDrives,
			[Parameter()]			     								[switch]$Force
		  )

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
			
		$sourceFixed = Rename-InvalidFilename $Source
		$destFixed = Rename-InvalidFilename $Destination
		Write-DisplayDebug "`$sourceFixed = $sourceFixed"
		Write-DisplayDebug "`$destFixed = $destFixed"
		
		Write-DisplayDebug "Test-Path `$sourceFixed = $(Test-Path $sourceFixed)"
		if ((Test-Path $sourceFixed) -eq $false)
		{
			Write-DisplayTrace "Exit with error from $funcName"
			Write-DisplayError "Source $source not found" -Exit
		}
		
		Write-DisplayInfo "Reading source files"
		$files = @(Get-ChildItem -Path $sourceFixed -Force -File)
		Write-DisplayDebug "`$files.Length = $($files.Length)"
		
		Write-DisplayInfo "Reading source directories"
		$directories = @(Get-ChildItem -Path $sourceFixed -Force -Directory)
		Write-DisplayDebug "`$directories.Length = $($directories.Length)"
		
		$fileText = Get-FileLabel $files.Length
		$directoryText = Get-DirectoryLabel $directories.Length
				
		$fileCount = 0
		$directoryCount = 0
		$numCopied = 0
		$copiedNames = @()
		
		Write-DisplayInfo "Copying files."
		foreach($file in $files)
		{
			$fileCount++
			
			if($CheckUSBDrives) { Confirm-USBDrivesIterative -Count $fileCount }
			
			$nameOnly = $file.FullName | Split-Path -Leaf
			$fileName = $file.FullName
			$fileNameFixed = Rename-InvalidFilename $fileName
			
			$destSize = 0
			$srcSize = 0
			$sourcesub = "$Source\$nameOnly"
			$destsub = "$Destination\$nameOnly"

			Write-DisplayDebug "`$sourcesub = $sourcesub"
			Write-DisplayDebug "`$destsub = $destsub"
			
			$sourcesubFixed = Rename-InvalidFilename $sourcesub
			$destsubFixed = Rename-InvalidFilename $destsub

			Write-DisplayDebug "`$sourcesubFixed = $sourcesubFixed"
			Write-DisplayDebug "`$destsubFixed = $destsubFixed"

			$copy = $false
			$action = ""
			$exists = $false
					
			$action = "Analyzing"
			$reason = ""
			if($fileCount -eq 1) { $first = $true } else { $first = $false }
			
			Write-DisplayStatus -Prefix $action -Message $nameOnly -Initial:$first
			
			if($Force)
			{
				$action = "Copying"
				$reason = "Forced"
				$copy = $true
				Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
			}
			else
			{
				Write-DisplayDebug "Test-Path `$destsubFixed = $(Test-Path $destsubFixed)"
				if(Test-Path -Path $destsubFixed)
				{
					$exists = $true
					$srcSize = (Get-Item $sourcesubFixed).Length
					$destSize = (Get-Item $destsubFixed).Length
				}
				else
				{
					$srcSize = 0
					$destSize = 0		
					$action = "Copying"
					$reason = "Does not exist"
					$copy = $true
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
				}
				
			
				if($exists -And ($srcSize -gt $destSize))
				{
					$action = "Copying"
					$reason = "Different sizes [$(Format-FileSize $srcSize) vs. $(Format-FileSize $destSize)]"
					$copy = $true
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
				}
				elseif($exists -And ($srcSize -lt $destSize))
				{
					$action = "Stopping"
					$reason = "Different sizes [$(Format-FileSize $srcSize) vs. $(Format-FileSize $destSize)]"
					$copy = $true
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					Write-DisplayWarning "Source size is less than Destination size."
				}
				elseif($exists)
				{
					$action = "Skipping"
					Write-DisplayStatus -Prefix $action -Message $nameOnly
				}
			}
			
			$actionReason = $action
			if($reason.Length -gt 0) { $actionReason += " - $reason" }
			Write-DisplayDebug "`$actionReason = $actionReason"
			Write-DisplayDebug "`$copy = $copy"
			
			if($copy)
			{
				Write-DisplayInfo "Copying $sourcesubFixed to $destsubFixed"
				Copy-Item $sourcesubFixed $destsubFixed -Recurse -Force -WhatIf:$WhatIf
				$numCopied++
				$copiedNames += "$sourcesub ($actionReason)"
			}
		}
		
		Write-DisplayInfo "Copying directories."
		foreach($directory in $directories)
		{
			$directoryCount++
			
			if($CheckUSBDrives) { Confirm-USBDrivesIterative $directoryCount }		
			
			$nameOnly = $directory.FullName | Split-Path -Leaf
			
			$directoryName = $directory.FullName
			$directoryNameFixed = Rename-InvalidFilename $directoryName
			Write-DisplayDebug "`$directoryNameFixed = $directoryNameFixed"
			
			$sourcesub = $directoryName
			$destsub = Edit-PathDrive -Path $sourcesub -DriveFromPath $Destination
			$destsubFixed = Rename-InvalidFilename $destsub
			Write-DisplayDebug "`$destsub = $destsub"
			Write-DisplayDebug "`$destsubFixed = $destsubFixed"
			
			$sourcesubFixed = Rename-InvalidFilename $sourcesub
			Write-DisplayDebug "`$sourcesubFixed = $sourcesubFixed"
			$copy = $false
			$action = ""
			$exists = $false
				
			$action = "Analyzing"
			$reason = ""

			if(-Not $first -And $directoryCount -eq 1) { $first = $true } else { $first = $false }
			Write-DisplayStatus -Prefix $action -Message $nameOnly -Initial:$first
			
			if($Force)
			{
				$action = "Copying"
				$reason = "Forced"
				$copy = $true
				Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
			}
			else
			{
				if(Test-Path -Path $destsubFixed)
				{
					$exists = $true
					$action = "Analyzing"
					
					Write-DisplayStatus -Prefix $action -Message $nameOnly
					
					Write-DisplayInfo "Getting directory size for $sourcesub"
					$srcResult = Get-DirectorySize $sourcesub -Recurse -Force
					
					Write-DisplayInfo "Getting directory size for $destsub"				
					$destResult = Get-DirectorySize $destsub -Recurse -Force
				}
				else
				{
					$srcResult = [pscustomobject]@{
						PSTypename      = "FolderSizeInfo"
						Computername    = [System.Environment]::MachineName
						Path            = $Path
						Name            = $sourcesub
						TotalFiles      = 0
						TotalSize       = 0
						ElapsedSeconds  = 0
						ElapsedTime     = ''
					}	

					$destResult = [pscustomobject]@{
						PSTypename      = "FolderSizeInfo"
						Computername    = [System.Environment]::MachineName
						Path            = $Path
						Name            = $destsub
						TotalFiles      = 0
						TotalSize       = 0
						ElapsedSeconds  = 0
						ElapsedTime     = ''
					}	

					$action = "Copying"
					$reason = "Does not exist"
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					$copy = $true
				}

				if(-Not $copy -And ($exists -And ($srcResult.TotalSize -gt $destResult.TotalSize)))
				{
					$action = "Copying"
					$reason = "Different sizes [$(Format-FileSize $srcResult.TotalSize) vs. $(Format-FileSize $destResult.TotalSize)]"
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					$copy = $true
				}
				elseif(-Not $copy -And ($exists -And ($srcResult.TotalFiles -gt $destResult.TotalFiles)))
				{
					$action = "Copying"
					$reason = "Different number of files ($($srcResult.TotalFiles) vs. $($destResult.TotalFiles))"
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					$copy = $true
				}
				elseif(-Not $copy -And ($exists -And ($srcResult.TotalSize -lt $destResult.TotalSize)))
				{
					$action = "Stopping"
					$reason = "Different sizes [$(Format-FileSize $srcResult.TotalSize) vs. $(Format-FileSize $destResult.TotalSize)]"
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					Write-DisplayWarning "Source size is less than Destination size."
					$copy = $false
				}
				elseif(-Not $copy -And ($exists -And ($srcResult.TotalFiles -lt $destResult.TotalFiles)))
				{
					$action = "Stopping"
					$reason = "Different number of files ($($srcResult.TotalFiles) vs. $($destResult.TotalFiles))"
					Write-DisplayStatus -Prefix $action -Message $nameOnly -Suffix "($reason)"
					Write-DisplayWarning "Source number of files is less than Destination number of files."
					$copy = $false
				}
				elseif($exists)
				{
					$action = "Skipping"
					Write-DisplayStatus -Prefix $action -Message $nameOnly
				}
			}

			$actionReason = $action
			if($reason.Length -gt 0) { $actionReason += " - $reason" }
			Write-DisplayDebug "`$actionReason = $actionReason"
			Write-DisplayDebug "`$copy = $copy"

			if($global:do_exit) { exit 0 }
			if($global:do_exit_error) { exit 1 }
		
			if($copy) 
			{ 	
				Confirm-DirectoryExists $destsub

				Write-DisplayInfo "Transferring directory $sourcesub."
				Backup-Directory -Source $sourcesub -Destination $destsub -Mirror -ShowProgress -WhatIf:$WhatIf
				
				$numCopied++
				$copiedNames += "$sourcesub ($actionReason)"
			}
		}         

		foreach($cn in $copiedNames)
		{
			Write-DisplayHost "   copied: $cn"
		}
		Write-DisplayHost "Copy finished."
		
		Write-DisplayTrace "Exit $funcName"
	}
}

Export-ModuleMember -Function *