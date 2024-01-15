using module Varan.PowerShell.Validation

class HelpParameterResult
{
	[string]$Name
	[string]$Description
}
	
class HelpResult
{
	[string]$Synopsis
	[string]$Description
	[HelpParameterResult[]]$Parameters = [HelpParameterResult[]]::@()
	[string]$Inputs
	[string]$Outputs
	[string[]]$Examples = [string[]]::@()
	[bool]$Excluded
	[string[]]$Syntax = [string[]]::@()
	[string[]]$SupportedBaseParameters = [string[]]::@()
	[string[]]$SupportedCommonParameters = [string[]]::@()
	[string[]]$ToDo = [string[]]::@()
}

function Read-HelpComments
{
	param(  [Parameter(Mandatory = $true)]
			[ValidatePath(FileOnly, MustExist)]	[string] $Path
		 )
		 
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	$result = [HelpResult]::new()
	
	$lines = Get-Content $Path
	
	$inBlock = $false
	$inSection = ''
	$sectionHeader = $false
	$paramName = ''
	$exclude = $false
	
	foreach($line in $lines)
	{
		$tl = $line.Trim()
		$tll = $tl.ToLower()
		if($tl.Contains('<#')) { $inBlock = $true }
		if($tl.Contains('#>')) 
		{ 
			$inBlock = $false
			$inSection = '' 
		}
	
		if($inBlock)
		{
			if($tl.StartsWith('.'))
			{
				$inSection = $tl.Split(' ')[0].Replace('.', '').Trim().ToLower()
				$sectionHeader = $true
				
				if($inSection -eq 'parameter') { $paramName = $tl.Split(' ')[1].Trim() }
				if($inSection -eq 'excludefromsummary') { $exclude = $true }
				if($inSection -eq 'baseparameters')
				{
					$idx = $tl.IndexOf(' ')
					$paramList = $tl.Substring($idx + 1)

					$pArray = $paramList.Split(',')
					$temp = @()
					foreach($pa in $pArray)
					{
						$temp += $pa.Trim().ToLower()
					}

					$result.SupportedBaseParameters = $temp
				}
				if($inSection -eq 'commonparameters')
				{
					$idx = $tl.IndexOf(' ')
					$paramList = $tl.Substring($idx + 1)

					$pArray = $paramList.Split(',')
					$temp = @()
					foreach($pa in $pArray)
					{
						$temp += $pa.Trim().ToLower()
					}

					$result.SupportedCommonParameters = $temp
				}
			}
			elseif($tl.Length -eq 0)
			{
				$inSection = ''
				$sectionHeader = $false
			}
			else
			{
				$sectionHeader = $false
			}
			
			if($tl.Length -gt 0 -And $inSection.Length -gt 0 -And (-Not $sectionHeader))
			{
				switch($inSection)
				{
					"synopsis"
					{
						$result.Synopsis = $tl
						break
					}
					"description"
					{
						$result.Description += $tl
						break
					}
					"parameter"
					{
						[HelpParameterResult] $p = [HelpParameterResult]::new()
						$p.Name = $paramName
						$p.Description = $tl					
						$result.Parameters += $p
						break
					}
					"inputs"
					{
						$result.Inputs = $tl
						break
					}
					"outputs"
					{
						$result.Outputs = $tl
						break
					}
					"example"
					{
						$result.Examples += $tl
						break
					}
					"todo"
					{
						$result.ToDo += $tl
						break
					}
				}
			}
		}
	}
	
	$validData = $result.Synopsis.Length -gt 0 -Or $result.Description.Length -gt 0 -Or
				 $result.Parameters.Count -gt 0 -Or $result.Inputs.Length -gt 0 -Or
				 $result.Outputs.Length -gt 0 -Or $result.Examples.Count -gt 0
				 
	if($exclude -Or -Not $validData)
	{
		$result.Excluded = $true
	}
	else
	{
		$result.Excluded = $false
	}
	
	$helpStr = Get-Help "$([System.IO.Path]::GetFileNameWithoutExtension($Path))" -Full | Out-String -Stream
	$helpLines = $helpStr.Split('`n`r')

	$inSyntax = $false
	$lastThl = ''

	foreach($hl in $helpLines)
	{
		$thl = $hl.Replace($global:codeScriptsDir, '').Replace('.ps1', '').Trim()
		
		if($inSyntax -And $thl.Length -gt 0)
		{
			$first, $rest = $thl.Split(' ')
		
			$syntaxRow = [System.IO.Path]::GetFileNameWithoutExtension($Path)
			$syntaxRow += ' '
			$syntaxRow += $rest
			
			$paramDefs = Get-BaseParameterDefinitions
			$baseParameters = ''
			foreach($key in $paramDefs.Keys)
			{
				$dontShow = $paramDefs.Item($key).DontShow
				
				if(-Not $dontShow)
				{
					$mandatory = $paramDefs.Item($key).Mandatory
					$paramStr = ''
					
					if(-Not $mandatory) { $paramStr += '[' }
					$paramStr += '-'
					$paramStr += $key
					if(-Not $mandatory) { $paramStr += ']' }
					$paramStr += ' '
					$baseParameters += $paramStr
				}
			}
			$syntaxRow += ' '
			$syntaxRow += $baseParameters
			
			$result.Syntax += $syntaxRow
		}
		
		if($inSyntax -And $thl.Length -eq 0 -And $lastThl.Length -eq 0)
		{
			Break
		}
		
		if($thl.ToLower() -eq "syntax") { $inSyntax = $true }
		$lastThl = $thl
	}
	
	return $result
	
	Write-DisplayTrace "Exit $funcName"
}

function Get-AliasString
{
	param(	[Parameter(Mandatory = $true)] [ValidateVariable()] [string] $Name
	)
	
	[array]$aliases = @(Get-Alias -Definition $scriptName -ErrorAction 'SilentlyContinue' | Select-Object Name)
	
	$aliasStr = ''
	foreach($a in $aliases)
	{
		$aliasStr += $a.Name + ', '
	}
	
	if($aliasStr.Length -gt 0) 
	{ 
		$aliasStr = "[$($aliasStr.Substring(0, $aliasStr.Length - 2))]" 
	}

	$aliasStr
}

function Write-DisplayHelp
{
	param(  [Parameter(Mandatory = $true)]
			[ValidatePath(MustExist, FileOnly)] [string] $Name,
			[Parameter(Mandatory = $true, ParameterSetName = 'setFull')] [switch] $HelpFull,
			[Parameter(Mandatory = $true, ParameterSetName = 'setDetail')] [switch] $HelpDetail,
			[Parameter(Mandatory = $true, ParameterSetName = 'setSynopsis')] [switch] $HelpSynopsis,
			[Parameter()] [switch]$DontExit
		 )
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters

	$scriptName = Get-PathPart -Path $Name -FilenameNoExtension
	$helpInfo = Read-HelpComments $Name

	if($helpInfo.Excluded) { return }
	if($HelpSynopsis)
	{
		$aliasStr = Get-AliasString -Name $scriptName
		Write-DisplayHost "$($scriptName.PadRight(38, ' '))" -NoNewline -Style HelpTitle
		Write-DisplayHost "$($aliasStr.PadRight(16, ' '))" -NoNewline -Style HelpItem
		Write-DisplayHost "$($helpInfo.Synopsis)" -Style HelpDescription
	}
	
	if($HelpFull -Or $HelpDetail)
	{
		$indent = '     '
		
		if($HelpDetail -Or $HelpFull)
		{
			Write-DisplayHost "Description: " -Style HelpTitle
			Write-DisplayHost "$indent$($helpInfo.Description)" -Style HelpDescription
			Write-DisplayHost -BlankLine
		}
		
		Write-DisplayHost "Usage: " -Style HelpTitle
		
		if($helpInfo.Syntax.Length -gt 0)
		{
			foreach($syntax in $helpInfo.Syntax)
			{	
				$width = $Host.UI.RawUI.BufferSize.Width
				$indent = '     '
				$space = ' '
				
				$first, $rest = $syntax.Split(' ')
				$restStr = $rest -Join ' '
				
				if($i -gt 0) { Write-DisplayHost -BlankLine }
				
				Write-DisplayHost "$indent$first$space" -NoNewline -Style HelpItem
				
				$fakeFirst = $string = " " * $first.Length

				$i = 0
				while($restStr.Length -gt 0)
				{
					$partLen = $width - $first.Length - $indent.Length - $space.Length
					if($partLen -gt $restStr.Length) { $partLen = $restStr.Length }
				
					$part = $restStr.Substring(0, $partLen)			
						
					while($part.Length -lt $restStr.Length -And -Not $part.EndsWith(' ') -And -Not $restStr[$partLen] -ne '|')
					{
						if($part.EndsWith('|'))
						{
							$partLen = $partLen - 2
						}
						else
						{
							$partLen = $partLen - 1
						}
						
						$part = $restStr.Substring(0, $partLen)
					}		
							
					if($i -eq 0)
					{
						Write-DisplayHost "$part" -Style HelpDescription
					}
					else
					{
						Write-DisplayHost "$indent$fakeFirst$space$part" -Style HelpDescription
					}
					
					$restStr = $restStr.Substring($part.Length)
					$i++
				}		
			}
			
			Write-DisplayHost -BlankLine
		}
				
		if($helpInfo.Parameters.Length -gt 0)
		{
			$parameterWidth = 25
			$parameterLabel = Get-MeasureWord -Count $helpInfo.Parameters.Length -SingularWord "Distinct Parameter" -PluralWord "Distinct Parameters"
			Write-DisplayHost "$($parameterLabel):  " -Style HelpTitle
				
			foreach($parameter in $helpInfo.Parameters)
			{
				Write-DisplayHost "$indent$($parameter.Name.PadRight($parameterWidth, ' '))" -NoNewline -Style HelpItem
				Write-DisplayHost "$($parameter.Description)" -Style HelpDescription
			}
			Write-DisplayHost -BlankLine
		}
		
		if($HelpFull)
		{
			$baseParameters = Get-BaseParameterDefinitions -IncludeMusicPathQueues
			if(($baseParameters -ne $null) -And ($baseParameters.Count -gt 0))
			{
				$parameterLabel = Get-MeasureWord -Count ($baseParameters.Count) -SingularWord "Base Parameter" -PluralWord "Base Parameters"
				Write-DisplayHost "$($parameterLabel):  " -Style HelpTitle
				foreach($bp in ($baseParameters.GetEnumerator() | Sort-Object Key))
				{
					$parameter = $baseParameters.Item($bp.Key)
					
					if(-Not $parameter.DontShow)
					{					
						if(($helpInfo.SupportedBaseParameters -ne $null) -And ($helpInfo.SupportedBaseParameters.Contains($parameter.Name.ToLower())))
						{
							Write-DisplayHost "$indent$($parameter.Name.PadRight($parameterWidth, ' '))" -NoNewline -Style HelpItem
							Write-DisplayHost "$($parameter.HelpMessage)" -Style HelpDescription
						}
						else
						{
							$pName = "[$($parameter.Name)]".PadRight($parameterWidth, ' ')
							Write-DisplayHost "$indent$pName" -NoNewline -Style HelpEmphasis
							Write-DisplayHost "[unsupported base parameter]" -Style HelpEmphasis
						}
					}
				}
				
				Write-DisplayHost -BlankLine
			}
			
			
			$commonParameters = Get-CommonParameterList
			if(($commonParameters -ne $null) -And ($commonParameters.Count -gt 0))
			{
				$parameterLabel = Get-MeasureWord -Count ($commonParameters.Count) -SingularWord "Common Parameter" -PluralWord "Common Parameters"
				Write-DisplayHost "$($parameterLabel):  " -Style HelpTitle
				foreach($cp in ($commonParameters | Sort-Object))
				{
					$parameter = $cp.ToLower()
					
					if(($helpInfo.SupportedCommonParameters -ne $null) -And ($helpInfo.SupportedCommonParameters.Contains($parameter.ToLower())))
					{
						Write-DisplayHost "$indent$($cp.PadRight($parameterWidth, ' '))" -Style HelpItem
					}
					else
					{
						$pName = "[$($cp)]".PadRight($parameterWidth, ' ')
						Write-DisplayHost "$indent$pName" -NoNewline -Style HelpEmphasis
						Write-DisplayHost "[unsupported common parameter]" -Style HelpEmphasis
					}
				}
				
				Write-DisplayHost -BlankLine
			}
		}
		
		[array]$aliases = @(Get-Alias -Definition $scriptName -ErrorAction 'SilentlyContinue' | Select-Object Name)
		if($aliases.Length -gt 0)
		{
			$exampleLabel = Get-MeasureWord -Count $aliases.Length -SingularWord "Alias" -PluralWord "Aliases"
			Write-DisplayHost "$($exampleLabel):  " -Style HelpTitle
			
			foreach($a in $aliases)
			{
				Write-DisplayHost "$indent$($a.Name)" -Style HelpItem
			}
			Write-DisplayHost -BlankLine
		}
		
		if($helpInfo.Examples.Length -gt 0)
		{
			$exampleLabel = Get-MeasureWord -Count $helpInfo.Examples.Length -SingularWord "Example" -PluralWord "Examples"
			Write-DisplayHost "$($exampleLabel):  " -Style HelpTitle

			foreach($example in $helpInfo.Examples)
			{		
				$exList = $example.Split(' ')
				$exRemaining = $example.Substring($exList[0].Length + $exList[1].Length + 2)
				
				Write-DisplayHost "$indent$($exList[0])" -NoNewline -Style HelpPrompt
				Write-DisplayHost " $($exList[1])" -NoNewline -Style HelpDescription
				Write-DisplayHost " $exRemaining" -Style HelpDescription
			}
			Write-DisplayHost -BlankLine
		}
		
		if($HelpFull)
		{
			if($helpInfo.ToDo.Length -gt 0)
			{
				$todoLabel = Get-MeasureWord -Count $helpInfo.ToDo.Length -SingularWord "To Do Item" -PluralWord "To Do Items"
				Write-DisplayHost "$($todoLabel):  " -Style HelpTitle
				
				foreach($t in $helpInfo.ToDo)
				{
					Write-DisplayHost "$indent$($t)" -Style HelpEmphasis
				}
				Write-DisplayHost -BlankLine
			}
		}
	}
	
	if(-Not $DontExit) { Exit-Script }
}

Export-ModuleMember -Function *