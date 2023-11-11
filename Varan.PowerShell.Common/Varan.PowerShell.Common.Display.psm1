using module Varan.PowerShell.Validation

function Test-ShowFunction
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true)] [string]$FunctionName,
			[Parameter(Mandatory = $true, ParameterSetName = 'setA')] [switch]$DisplayHost,
			[Parameter(Mandatory = $true, ParameterSetName = 'setB')] [switch]$DisplayInfo,
			[Parameter(Mandatory = $true, ParameterSetName = 'setC')] [switch]$DisplayTrace,
			[Parameter(Mandatory = $true, ParameterSetName = 'setD')] [switch]$DisplayDebug,
			[Parameter(Mandatory = $true, ParameterSetName = 'setE')] [switch]$DisplayStatus,
			[Parameter(Mandatory = $true, ParameterSetName = 'setF')] [switch]$DisplayError,
			[Parameter(Mandatory = $true, ParameterSetName = 'setG')] [switch]$DisplayWarning,
			[Parameter(Mandatory = $true, ParameterSetName = 'setH')] [switch]$LogHost,
			[Parameter(Mandatory = $true, ParameterSetName = 'setI')] [switch]$LogInfo,
			[Parameter(Mandatory = $true, ParameterSetName = 'setJ')] [switch]$LogTrace,
			[Parameter(Mandatory = $true, ParameterSetName = 'setK')] [switch]$LogDebug,
			[Parameter(Mandatory = $true, ParameterSetName = 'setL')] [switch]$LogStatus,
			[Parameter(Mandatory = $true, ParameterSetName = 'setM')] [switch]$LogError,
			[Parameter(Mandatory = $true, ParameterSetName = 'setN')] [switch]$LogWarning
		 )

	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
	$result = $false
	$includeAlways = $false
	$excludeAlways = $false
	[string[]]$filterInclude
	[string[]]$filterExclude
	
	if($DisplayHost)
	{
		$filterInclude = $displayHostFilterInclude
		$filterExclude = $displayHostFilterExclude
	}
	elseif($DisplayInfo)
	{
		$filterInclude = $displayInfoFilterInclude
		$filterExclude = $displayInfoFilterExclude
	}
	elseif($DisplayTrace)
	{
		$filterInclude = $displayTraceFilterInclude
		$filterExclude = $displayTraceFilterExclude
	}
	elseif($DisplayDebug)
	{
		$filterInclude = $displayDebugFilterInclude
		$filterExclude = $displayDebugFilterExclude
	}
	elseif($DisplayStatus)
	{
		$filterInclude = $displayStatusFilterInclude
		$filterExclude = $displayStatusFilterExclude
	}
	elseif($DisplayError)
	{
		$filterInclude = $displayErrorFilterInclude
		$filterExclude = $displayErrorFilterExclude
	}
	elseif($DisplayWarning)
	{
		$filterInclude = $displayWarningFilterInclude
		$filterExclude = $displayWarningFilterExclude
	}
	elseif($LogHost)
	{
		$filterInclude = $logHostFilterInclude
		$filterExclude = $logHostFilterExclude
	}
	elseif($LogInfo)
	{
		$filterInclude = $logInfoFilterInclude
		$filterExclude = $logInfoFilterExclude
	}
	elseif($LogTrace)
	{
		$filterInclude = $logTraceFilterInclude
		$filterExclude = $logTraceFilterExclude
	}
	elseif($LogDebug)
	{
		$filterInclude = $logDebugFilterInclude
		$filterExclude = $logDebugFilterExclude
	}
	elseif($LogStatus)
	{
		$filterInclude = $logStatusFilterInclude
		$filterExclude = $logStatusFilterExclude
	}
	elseif($LogError)
	{
		$filterInclude = $logErrorFilterInclude
		$filterExclude = $logErrorFilterExclude
	}
	elseif($LogWarning)
	{
		$filterInclude = $logWarningFilterInclude
		$filterExclude = $logWarningFilterExclude
	}
	
	if($filterInclude -eq $null -Or $filterExclude -eq $null -Or
	   $filterInclude -eq $null -Or $filterExclude -eq $null)
	{
		return $true
	}
	
	if($filterInclude.Contains("*") -And $filterInclude.Length -gt 1)
	{
		Write-DisplayError "`$filterInclude can not include anything else if a wildcard is used." -Exit
	}
	if($filterExclude.Contains("*") -And $filterExclude.Length -gt 1)
	{
		Write-DisplayError "`$filterExclude can not include anything else if a wildcard is used." -Exit
	}
	if($filterInclude.Contains("*") -And $filterExclude.Contains("*"))
	{
		Write-DisplayError "`$filterInclude and `$filterExclude can not both contain a wildcard." -Exit
	}
	if($filterInclude.Contains($FunctionName) -And $filterExclude.Contains($FunctionName))
	{
		Write-DisplayError "$FunctionName can not be in both `$filterInclude and `$filterExclude." -Exit
	}
	
	if($filterInclude.Contains("*")) 	{ $includeAlways = $true }
	elseif($filterExclude.Contains("*")) { $excludeAlways = $true }
	
	if(($filterInclude.Length -eq 0) -And ($filterExclude.Length -eq 0)) { $result = $true }
	elseif(($filterInclude.Contains($FunctionName)) -And (-Not $filterExclude.Contains($FunctionName)))  { $result = $true  }
	elseif($includeAlways -And (-Not $filterExclude.Contains($FunctionName)))  { $result = $true  }
	elseif($filterInclude.Contains($FunctionName) -And $excludeAlways)  { $result = $true  }
	
	return $result
	
	Write-DisplayTrace "Exit $funcName"
}

function Remove-NewLines
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Text
		 ) 

	Process
	{	
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$result = $Text.Replace("`r", "").Replace("`n", "")
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Add-NewLine
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Text
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$result = ""
		$proper = $false
		
		if($Text.StartsWith("`r`n"))
		{
			Write-DisplayDebug "`$Text starts with ``r``n."
			$proper = $true
			$result = $Txt
		}
		
		if(-Not $proper -And ($Text.StartsWith("`r")))
		{
			Write-DisplayDebug "`$Text starts with ``r."
			$result = "`r`n" + $Text.Substring(1, $Text.Length - 1)
		}
		elseif(-Not $proper -And ($Txt.StartsWith("`n")))
		{
			Write-DisplayDebug "`$Text starts with ``n."
			$result = "`r`n" + $Text.Substring(1, $Text.Length - 1)
		}
		else
		{
			Write-DisplayDebug "`$Text does not start with ``r or ``n."
			$result = "`r`n" + $Text
		}
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Reset-HostLine 
{
	[CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)] [int]$LineOffset = 0,
		[Parameter()]								 [switch]$ClearLinesInBetween
    )

    $currentLine  = $Host.UI.RawUI.CursorPosition.Y
	$lineToUse = $currentLine - $LineOffset - 1
	if($lineToUse -lt 0) { $lineToUse = 0 }
	
	$blankLine = ''.PadRight($Host.UI.RawUI.BufferSize.Width, ' ')
	
	if($ClearLinesInBetween)
	{
		$i = 0
		for ($i; $i -le $lineToUse; $i++) 
		{
			[Console]::SetCursorPosition(0, $currentLine - $i)
			[Console]::Write($blankLine)
		}	
	}
	else
	{
		[Console]::SetCursorPosition(0, $lineToUse)
		[Console]::Write($blankLine)	
	}
	
    [Console]::SetCursorPosition(0, $lineToUse)
}

function Get-DisplayColor
{
	[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'setStyle')]  [DisplayStyle] $Style,
		[Parameter(Mandatory = $true, ParameterSetName = 'setColor')]  [ConsoleColor] $ForegroundColor,
		[Parameter(Mandatory = $false, ParameterSetName = 'setColor')] [ConsoleColor] $BackgroundColor = [ConsoleColor]::Black
	)
	
	$result = [PSCustomObject]@{
			PSTypename        = "ColorInfo"
			Foreground		  = [ConsoleColor]::Gray
			Background		  = [ConsoleColor]::Black}
			
	if($PSCmdlet.ParameterSetName -eq 'setStyle')
	{
		$fgName = "style$($Style)ForegroundColor"
		$bgName = "style$($Style)BackgroundColor"
		
		$result.Foreground = [ConsoleColor](Get-Variable $fgName -ValueOnly)
		$result.Background = [ConsoleColor](Get-Variable $bgName -ValueOnly)
	}
	
	if($PSCmdlet.ParameterSetName -eq 'setColor')
	{
		$result.Foreground = $ForegroundColor
		$result.Background = $BackgroundColor
	}

	$result
}

function Write-DisplayHost
{ 
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Normal,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,			
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
		
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And $displayHost -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) { $msg = "$hostDefaultTag$msg" }

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogHost))) { Write-LogHost $Message }
	}
}

function Write-DisplayTrace
{ 
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Normal,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string[]]		$Tags,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
		
		$tagStr = $Tags -Join ","
		if($tagStr.Length -gt 0) { $tagStr = "[$tagStr] " }
					
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And (Assert-Trace) -And $displayTrace -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) 
				{
					$msg = "$traceDefaultTag$tagStr$msg" 
				}

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogTrace))) { Write-LogHost "$tagStr$Message" }
	}
}

function Write-DisplayInfo
{ 
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Normal,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,			
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
			
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And (Assert-Verbose) -And $displayInfo -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) { $msg = "$infoDefaultTag$msg" }

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogInfo))) { Write-LogHost $Message }
	}
}

function Get-CallingFunction
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true)] $Stack
		 )
	
	$functionName = "Unknown"
	
	for($i=0; $i -lt @($Stack).Length - 1; $i++)
	{
		$functionName = @($Stack)[$i].ToString().Split(',')[0].Replace('at ', '').Replace('<Process>', '')
		
		if($functionName -ne "<ScriptBlock>") { break }
	}
	
	$functionName
}

function Write-DisplayTraceCallerInfo
{
	[CmdletBinding()]
    param(  [Parameter()] $Parameters
		 )

	$functionName = Get-CallingFunction (Get-PSCallStack)
	
	if(Assert-Trace)
	{
		$info = "Enter function $functionName"
		Write-DisplayTrace -Message $info -FunctionName $functionName
		
		$info = ""
		foreach ($p in $Parameters.Keys) 
		{
			$info = "param $($passedArgument) = $($Parameters[$p])"
			Write-DisplayTrace -Message $info -FunctionName $functionName
		}
		
		$info = ""
		foreach($cs in Get-PSCallStack)
		{
			$info = "call stack $($cs.Command)"
			Write-DisplayTrace -Message $info -FunctionName $functionName
		}
	}
}

function Write-DisplayDebug
{ 
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Normal,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,			
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[DebugCategory]	$Category,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
			
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And  (Assert-Debug) -And $displayDebug -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if($Category -ne $null)
			{
				$catStr = "[$Category] "
			}
			else
			{
				$catStr = ''
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) { $msg = "$debugDefaultTag$catStr$msg" }

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogDebug))) { Write-LogHost "$catStr$Message" }
	}
}

function Format-StatusText
{
	[CmdletBinding()]
    param(  [Parameter()] 							[string] $Prefix,
			[Parameter()] 							[string] $Message,
			[Parameter()] 							[string] $Suffix,
			[Parameter()] 							[switch] $ShowTag,
			[Parameter()]
			[ValidateVariable(AllowEmptyString)] 	[string] $FunctionName
		 )
		 
	$hostPrefix = $Prefix
	if($Prefix.length -gt 0 -And "$Message$Suffix".Length -gt 0 -And -Not ($Message.StartsWith(',')))
	{ 
		$hostPrefix += ' '
	}
	
	$hostMessage = $Message
	$hostSuffix = $Suffix
	if($Message.Length -gt 0 -And $Suffix.Length -gt 0 -And -Not ($hostSuffix.StartsWith(','))) 
	{ 
		$hostSuffix = " $hostSuffix"
	}
	
	if($ShowTag)
	{
		$tag = $statusDefaultTag
	}
	else
	{
		$tag = ''
	}
	
	$totalLength = $tag.Length + $FunctionName.Length + $hostPrefix.length + $hostMessage.Length + $hostSuffix.Length
	$maxMsgLength = $maxStatusLength - $tag.Length - $FunctionName.Length - $hostPrefix.Length - $hostSuffix.Length - 2	

	Write-DisplayDebug "`$totalLength = $totalLength" -NoLog
	Write-DisplayDebug "`$maxMsgLength = $maxMsgLength" -NoLog
	
	if($hostMessage.Length -gt $maxMsgLength) 
	{
		$hostMessage = $hostMessage.Substring(0, $maxMsgLength) 
	}
	
	$totalLength = $tag.Length + $FunctionName.Length + $hostPrefix.length + $hostMessage.Length + $hostSuffix.Length
	
	if($totalLength -gt $maxStatusLength)
	{
		$diff =  $totalLength - $maxStatusLength

		if($hostPrefix.Length -ge $diff)
		{
			$hostPrefix = $hostPrefix.Substring(0, $hostPrefix.Length - $diff)
		}
		else
		{
			$hostPrefix = ""
		}
	}

	$hostSuffix = $hostSuffix.PadRight($maxStatusLength - $tag.Length - $fn.Length - $hostPrefix.Length - $hostMessage.Length - 2, ' ')
	Write-DisplayDebug "`$hostPrefix = $hostPrefix" -NoLog
	Write-DisplayDebug "`$hostSuffix = $hostSuffix" -NoLog
	
	if(-Not $Initial) { Reset-HostLine 0 }

	$prefixToUse = "$tag$fn$hostPrefix"
	
	$result = [PSCustomObject]@{
		PSTypename    = "StatusInfo"
		Prefix		  = [string]$prefixToUse
		Message		  = [string]$hostMessage
		Suffix		  = [string]$hostSuffix}

	$result
}

function Write-DisplayStatus
{
		[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
			[AllowEmptyString()]
																	[string]		$Prefix,
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
			[AllowEmptyString()]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
			[AllowEmptyString()]
																	[string]		$Suffix,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$PrefixStyle = [DisplayStyle]::ProgressHighlight,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$MessageStyle = [DisplayStyle]::ProgressNormal,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$SuffixStyle = [DisplayStyle]::ProgressHighlight,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$Initial,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,			
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$PrefixForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$PrefixBackgroundColor,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$MessageForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$MessageBackgroundColor,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$SuffixForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$SuffixBackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
		  
	Process
	{	
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
		
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And $displayDebug -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			if($Initial) { $ResetLineBefore = 1 }
			
			$cmdParamsPrefix = @{
			}
			
			$cmdParamsMessage = @{
			}
			
			$cmdParamsSuffix = @{
				NoNewline = $NoNewline
			}

			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$statusInfo = Format-StatusText -Prefix $Prefix -Message $Message -Suffix $Suffix -ShowTag:$ShowTag -FunctionName $fn

				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					
					$prefixColor = Get-DisplayColor -Style $PrefixStyle
					$messageColor = Get-DisplayColor -Style $MessageStyle
					$suffixColor = Get-DisplayColor -Style $SuffixStyle
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$prefixColor = Get-DisplayColor -ForegroundColor $PrefixForegroundColor -BackgroundColor $PrefixBackgroundColor
					$messageColor = Get-DisplayColor -ForegroundColor $MessageForegroundColor -BackgroundColor $MessageBackgroundColor
					$suffixColor = Get-DisplayColor -ForegroundColor $SuffixForegroundColor -BackgroundColor $SuffixBackgroundColor
				}

				$cmdParamsPrefix.ForegroundColor = $prefixColor.Foreground
				$cmdParamsPrefix.BackgroundColor = $prefixColor.Background
				$cmdParamsMessage.ForegroundColor = $messageColor.Foreground
				$cmdParamsMessage.BackgroundColor = $messageColor.Background
				$cmdParamsSuffix.ForegroundColor = $suffixColor.Foreground
				$cmdParamsSuffix.BackgroundColor = $suffixColor.Background

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParamsPrefix.Separator = $Separator
					$cmdParamsMessage.Separator = $Separator
					$cmdParamsSuffix.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			if($statusInfo)
			{
				if($statusInfo.Prefix.Length -gt 0) { Write-Host $statusInfo.Prefix @cmdParamsPrefix -NoNewline }
				if($statusInfo.Message.Length -gt 0) { Write-Host $statusInfo.Message @cmdParamsMessage -NoNewline }
				if($statusInfo.Suffix.Length -gt 0) { Write-Host $statusInfo.Suffix @cmdParamsSuffix }
			}
			else
			{
				Write-Host $msg
			}
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogDebug))) { Write-LogHost $Message }	
	}
}

function Write-DisplayError
{
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Error,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,		
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[ErrorCategory]	$Category,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack)),
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$Quiet,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$Exit
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
		
		if($Category -ne $null)
		{
			$catStr = "[$Category] "
		}
		else
		{
			$catStr = ''
		}
		
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And $displayError -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) { $msg = "$errorDefaultTag$catStr$msg" }

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			if(-Not $Quiet)
			{
				$frequency = 440
				$durationMS = 175
				[console]::Beep($frequency, $durationMS)
			}
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogError))) { Write-LogHost "$catStr$Message" }
		
		if($Exit)
		{
			Exit-Script
		}
	}
}
			
function Write-DisplayWarning
{
	[CmdletBinding(DefaultParameterSetName = 'setStyle')]
    param(  [Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline,
						ParameterSetName = 'setStyle')]
			[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline, 
						ParameterSetName = 'setColor')]
																	[string]		$Message,
			[Parameter(ParameterSetName = 'setStyle')]
																	[DisplayStyle]	$Style = [DisplayStyle]::Warning,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoNewline,
			[Parameter(ParameterSetName = 'setBlankLine')]
																	[switch]		$BlankLine,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowTag,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ShowCallingFunction,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$NoLog,
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceDisplay,			
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[switch]		$ForceLog,	
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[string]		$Separator,			
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineBefore,
			[ValidateRange(1, [int]::MaxValue)]
			[Parameter(ParameterSetName = 'setStyle')]
			[Parameter(ParameterSetName = 'setColor')]
																	[int]			$ResetLineAfter,
			[Parameter(	Mandatory = $true,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$ForegroundColor,
			[Parameter(	Mandatory = $false,
						ParameterSetName = 'setColor')]
																	[ConsoleColor]	$BackgroundColor,
			[Parameter(	DontShow,
						ParameterSetName = 'setStyle')]
			[Parameter(	DontShow,
						ParameterSetName = 'setColor')]
			[Parameter(	ParameterSetName = 'setBlankLine')]
			[ValidateVariable()]
																	[string]		$FunctionName = $(Get-CallingFunction (Get-PSCallStack))
		  )
	
	Process
	{
		if($ShowCallingFunction -And $FunctionName -And $FunctionName.Length -gt 0)
		{
			$fn = "${FunctionName}: "
		}
		else
		{
			$fn = ''
		}
			
		if($ForceDisplay -Or ((-Not (Assert-Silent)) -And $displayWarning -And (Test-ShowFunction $FunctionName -DisplayHost)))
		{
			$cmdParams = @{
				NoNewline = $NoNewline
			}
			
			if(($PSCmdlet.ParameterSetName -eq 'setBlankLine') -And $BlankLine)
			{
				$msg = ''
			}
			else
			{
				$msg = $Message
				
				if($AddNewLine) { $msg = Add-NewLine $msg }
			
				if($PSCmdlet.ParameterSetName -eq 'setStyle')
				{
					$color = Get-DisplayColor -Style $Style
				}
				
				if($PSCmdlet.ParameterSetName -eq 'setColor')
				{
					$color = Get-DisplayColor -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
				}
				
				$cmdParams.ForegroundColor = $color.Foreground
				$cmdParams.BackgroundColor = $color.Background

				if($ShowTag) { $msg = "$warningDefaultTag$msg" }

				if ($PSBoundParameters.ContainsKey('Separator'))
				{
					$cmdParams.Separator = $Separator
				}
			}

			if($PSBoundParameters.ContainsKey('ResetLineBefore')) { Reset-HostLine $ResetLineBefore }
			
			Write-Host $msg @cmdParams
			
			if($PSBoundParameters.ContainsKey('ResetLineAfter')) { ResetLineAfter $ResetLineAfter }
		}
		
		if($ForceLog -Or (-Not ($NoLog) -And (Test-ShowFunction $FunctionName -LogWarning))) { Write-LogHost $Message }
	}
}

Export-ModuleMember -Function *