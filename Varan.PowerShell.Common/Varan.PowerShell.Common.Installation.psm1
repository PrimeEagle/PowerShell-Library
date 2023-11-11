using module Varan.PowerShell.Validation

function Add-SymbolicLink
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
	param ( [Parameter(Mandatory = $true)]	[string]$LinkPath,
			[Parameter(Mandatory = $true)]	[string]$TargetPath,
			[Parameter(Mandatory = $true)]	[DiskItem]$Type
		  )

	Process
	{	
		if(-Not (Test-SymbolicLink -LinkPath $LinkPath))
		{
			if($Type -eq [DiskItem]::Directory)
			{
				cmd /c mklink /d """$LinkPath""" """$TargetPath"""
			}
			
			if($Type -eq [DiskItem]::File)
			{
				cmd /c mklink """$LinkPath""" """$TargetPath"""
			}
		}
	}
}

function Remove-SymbolicLink
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
	param ( [Parameter(Mandatory = $true)]	[string]$LinkPath
		  )

	Process
	{	
		if(Test-SymbolicLink -LinkPath $LinkPath)
		{
			(Get-Item $LinkPath).Delete()
		}
	}
}

function Test-SymbolicLink
{
	[CmdletBinding(SupportsShouldProcess)]
	param ( [Parameter(Mandatory = $true)]	[string]$LinkPath
		  )

	Process
	{	
		$item = Get-Item $LinkPath -Force -ErrorAction SilentlyContinue
		
		return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
	}
}

function Add-LineToProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$Text
		  )

	Process
	{	
		$exists = Confirm-FileHasLine -Path $profile -Equals $Text -IgnoreWhitespace
		
		if(-Not $exists)
		{
			Add-IntoFileSection -Path $profile -Text $Text -Section $Text -IgnoreWhitespace -DefaultToEnd
		}		
	}
}

function Remove-LineFromProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$Text
		  )

	Process
	{	
		Remove-FromFile -Path $profile -Text $Text -IgnoreWhitespace
	}
}

function Add-AliasToProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$Script,
			[Parameter(Position = 1, Mandatory = $true)]	[string]$Alias
		  )

	Process
	{	
		$aliasStr = "if(-Not (Test-Path alias:$Alias)) { New-Alias -Name `"$Alias`" $Script }"
		$exists = Confirm-FileHasLine -Path $profile -Equals $aliasStr -IgnoreWhitespace

		if(-Not $exists)
		{
			Add-IntoFileSection -Path $profile -Text $aliasStr -Section "if(-Not (Test-Path alias" -IgnoreWhitespace -DefaultToEnd
		}
	}
}

function Remove-AliasFromProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$Script,
			[Parameter(Position = 1, Mandatory = $true)]	[string]$Alias
		  )

	Process
	{	
		$aliasStr = "if(-Not (Test-Path alias:$Alias)) { New-Alias -Name `"$Alias`" $Script }"
		Remove-FromFile -Path $profile -Text $aliasStr -IgnoreWhitespace
		if(Test-Path alias:$Alias) { Remove-Alias -Name $Alias }
	}
}

function Add-PathToProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$PathVariable,
			[Parameter(Position = 1, Mandatory = $true)]	[string]$Path
		  )

	Process
	{		
		$variableExists = Confirm-FileHasLine -Path $profile -StartsWith $PathVariable -IgnoreWhitespace
		$pathExists = Confirm-FileHasLine -Path $profile -StartsWith $PathVariable -Contains $Path -IgnoreWhitespace
		
		if(-Not $variableExists)
		{
			$pathLine = $PathVariable + " += `"`""
			
			Add-IntoFileSection -Path $profile -Text $pathLine -Section '$env:' -IgnoreWhitespace -DefaultToEnd
			$variableExists = $true
		}
		
		if($variableExists -And -Not $pathExists)
		{
			$output = @()
			$added = $false
			$lines = Get-Content $profile
			$lineNum = 0
			foreach($line in $lines)
			{
				$lineNum++
				$trimmedLine = $line.Trim().ToLower()

				if(-Not $added -And ($trimmedLine.Length -gt 0) -And ($trimmedLine.StartsWith($PathVariable.ToLower())))
				{
					$pathParts = $trimmedLine.Split('+=')
					$varName = $pathParts[0].Trim()
					$paths = $pathParts[1].Replace("'", '').Replace('"', '').Split(';')

					$newPaths = @()
					for($i = 0; $i -lt $paths.Length; $i++)
					{
						$tempPath = $paths[$i].Trim()
						if($tempPath.Length -gt 0)
						{
							if(-Not $tempPath.EndsWith("\")) { $tempPath += '\' }
							$newPaths += $tempPath
						}
					}
					
					$tPath = $Path.Trim()
					if(-Not $tPath.EndsWith("\")) { $tPath += '\' }
					
					$newPaths += $tPath
					$pathStr += $newPaths -Join ';'
					
					$newLine = "$varName += ';$pathStr;'"
					
					$added = $true
					$output += $newLine
				}
				else
				{
					$output += $line
				}
				
				if($lineNum -eq $ilnes.Length)
				{
					$output += ''
				}
			}
			
			Set-Content -Path $profile -Value $output
		}
	}
}

function Remove-PathFromProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]	[string]$PathVariable,
			[Parameter(Position = 1, Mandatory = $true)]	[string]$Path
		  )

	Process
	{
		$lines = Get-Content $profile
		$output = @()
		
		foreach($line in $lines)
		{
			if($line.Length -gt 0 -And $line.ToLower().Contains($PathVariable.ToLower()) -And ($line.ToLower().Contains($Path.ToLower()) -Or $line.ToLower().Contains($Path.ToLower() + '\')))
			{
				$tempLine = $line.Replace("$Path\;", '')
				$tempLine = $tempLine.Replace("$Path;", '')
				$tempLine = $tempLine.Replace("$Path", '')

				$output += $tempLine
			}
			else
			{
				$output += $line
			}
		}
		
		Set-Content -Path $profile -Value $output
	}
}

function Add-ModuleToProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]			[string]$Path
		  )

	Process
	{	
		$module = "using module `"$Path`""
		$exists = Confirm-FileHasLine -Path $profile -Equals $module -IgnoreWhitespace
		
		if(-Not $exists)
		{
			Add-IntoFileSection -Path $profile -Text $module -Section $module -IgnoreWhitespace -DefaultToStart
		}
	}
}

function Remove-ModuleFromProfile
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
	param ( [Parameter(Position = 0, Mandatory = $true)]			[string]$Path
		  )

	Process
	{	
		$module = "using module `"$Path`""
		Remove-FromFile -Path $profile -Text $module -IgnoreWhitespace

		$module = "using module '$Path'"
		Remove-FromFile -Path $profile -Text $module -IgnoreWhitespace
	}
}

function Remove-BlankLinesFromEndOfProfile
{
	$contents = (Get-Content -Path $profile -Raw) -Replace "(?s)`r`n\s*$"
	[System.Io.File]::WriteAllText($profile, $contents)
}


Export-ModuleMember -Function *