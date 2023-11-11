using module Varan.PowerShell.Validation

class ZipItem
{
	[bool] $TopLevel = $false
	[DateTime] $Timestamp = [DateTime]::MinValue
	[DiskItemType] $ItemType = [DiskItemType]::Directory
	[string] $Name = ''
	[long] $Size = 0
	[long] $CompressedSize = 0
}

function Start-ZipProcess
{
	[CmdletBinding()]
    param(
		[Parameter()]
		[string]$Arguments
	)	
	
	$process = New-Object System.Diagnostics.Process
	$process.StartInfo.UseShellExecute = $false
	$process.StartInfo.RedirectStandardOutput = $true
	$process.StartInfo.RedirectStandardError = $true
	$process.StartInfo.FileName = $sevenZipExe
	$process.StartInfo.Arguments = $Arguments
	Write-DisplayDebug "Running 7-zip with arguments: $Arguments"
	
	$out = $process.Start()

	$stdOutput = $process.StandardOutput.ReadToEnd()
	$stdError = $process.StandardError.ReadToEnd()
	
	$result = [PSCustomObject]@{
				StandardOutput = $stdOutput
				StandardError =  $stdError
				}

	return $result
}

function Get-ZipList
{
	[CmdletBinding()]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidatePath(FileOnly, MustExist)]
		[string]$File,
		[Parameter()]
		[string]$Password
	)	
	
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
		$pw = ''
		if($Password.Length -gt 0)
		{
			$pw = "-p""$Password"""
		}
		
		$args = "l ""$File"" $pw"
		$proc = Start-ZipProcess -Arguments $args	
		
		$out = $proc.StandardOutput.Split("`r`n")
		
		$result = @()
		foreach($o in $out)
		{	
			$reservedPhrase = $false
			
			Write-DisplayDebug "line = $o"
			foreach($rp in $sevenZipReservedPhrases)
			{
				Write-DisplayDebug "   checking reserved word: $rp"
				if($o.StartsWith($rp))
				{
					$reservedPhrase = $true
					break
				}
			}
			
			
			Write-DisplayDebug "reserved phrase present: $reservedPhrase"
			
			if(	$reservedPhrase -Or $o.StartsWith(' ') -Or $o.StartsWith('-') -Or
				(($o.Contains(' file, ')) -And ($o.Contains(' bytes ('))) -Or
				($o.Length -le 52) -Or
				($o.Substring(20, 5).Trim().Length -eq 0))
			{
				continue
			}
					
			$zipInfo = [ZipItem]::new()
			
			$idx = 0
			$len = 19
			$zipInfo.Timestamp = $o.Substring($idx, $len)
			
			$idx = 20
			$len = 5
			$type = $o.Substring($idx, $len)

			if($type.Contains('A')) { $zipInfo.ItemType = [DiskItemType]::File }
			elseif($type.Contains('D')) { $zipInfo.ItemType = [DiskItemType]::Directory }
			
			$idx = 26
			$len = 12
			$zipInfo.Size = $o.Substring($idx, $len)
			
			$idx = 39
			$len = 12
			$zipInfo.CompressedSize = $o.Substring($idx, $len)
			
			$idx = 52
			$zipInfo.Name = $o.Substring($idx)

			if($zipInfo.Name.IndexOf('\') -lt 0) { $zipInfo.TopLevel = $true }
			$result += $zipInfo
		}

	$result
	
	Write-DisplayTrace "Exit $funcName"
}

function Test-ZipItemDirectory
{
	[CmdletBinding()]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ZipItem]$Item
	)	
	
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	($Item.ItemType -eq [DiskItemType]::Directory)
	
	Write-DisplayTrace "Exit $funcName"
}

function Test-ZipItemFile
{
	[CmdletBinding()]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ZipItem]$Item
	)	
	
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	($Item.ItemType -eq [DiskItemType]::File)
	
	Write-DisplayTrace "Exit $funcName"
}

function Test-ZipHasSingleTopLevelDirectory
{
	[CmdletBinding()]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidatePath(FileOnly, MustExist)]
		[string]$File,
		[Parameter()]
		[string]$Password
	)
	
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	$topDir = 0
	$topFile  = 0
	
	$zipItems = Get-ZipList -File $File -Password $Password
	$topLevelDir = ''
	
	foreach($z in $zipItems)
	{
		if(($z.TopLevel) -And (Test-ZipItemDirectory $z)) 
		{ 
			$topDir++ 
			$topLevelDir = $z.Name
		}
		
		if(($z.TopLevel) -And (Test-ZipItemFile $z)) { $topFile++ }
	}
	
	if($topDir -eq 1)
	{
		foreach($z in $zipItems)
		{
			if(-Not $z.Name.StartsWith($topLevelDir)) { $topDir++ }
		}
	}
	
	(($topDir -eq 1) -And ($topFile -eq 0))
	
	Write-DisplayTrace "Exit $funcName"
}

function Test-ZipPassword
{
	[CmdletBinding(SupportsShouldProcess)]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidatePath()]
		[string]$File,
		[Parameter()]
		[string]$Password
	)

	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
	$proc = Start-ZipProcess -Arguments "l ""$File"" * -x!* -p""$Password""" 
	
	$result = $true
	if($proc.StandardError.ToLower().Contains('error'))
	{
		Write-DisplayError "Incorrect password for $File"
		$result = $false
	}
	
	return $result
}

function Expand-Zip
{
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidatePath()]
		[string]$File,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidatePath()]
		[string]$Destination,
		[Parameter()]
		[switch]$Delete,
		[Parameter()]
		[string]$Password
	)
	$funcName = $MyInvocation.MyCommand
	Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters

	$skip = $false
	$fileToUse = $File
	$fileToUse = $fileToUse -Replace "(.+)(\.part[0-9]+\.)(rar)", '$1.part1.$3'
	if(-Not (Test-Path $fileToUse)) { $fileToUse = $fileToUse.Replace('.part1', '.part01') }
	if(-Not (Test-Path $fileToUse)) { $fileToUse = $fileToUse.Replace('.part01', '.part001') }
	
	Confirm-DirectoryExists -Path $Destination
	if($PSCmdlet.ShouldProcess($fileToUse, "7-Zip extract"))
	{
		if($Password -And $Password.Length -gt 0)
		{
			$pw = "-p""$Password"""
		}
		else
		{
			$pw = ''
		}

		if($Password.Length -gt 0 -And -Not (Test-ZipPassword -File $fileToUse -Password $Password))
		{
			Write-DisplayError "Incorrect password '$Password' for $fileToUse"
			$skip = $true
			$Delete = $false
		}

		if(-Not $skip)
		{
			if($Args) { $process.StartInfo.Arguments = $Args }
			$proc = Start-ZipProcess -Arguments "x ""$fileToUse"" -o""$Destination"" -y $pw"
					
			if($proc.StandardError.ToLower().Contains('error'))
			{
				Write-DisplayError "$($proc.StandardError | Out-String)"
				$Delete = $false
			}
		}
	}
	
	if($Delete)
	{	
		$sourceDir = Get-PathPart -Path $fileToUse -LastDirectory
		$filename = Get-PathPart -Path $fileToUse -FilenameNoExtension
		$extension = Get-PathPart -Path $fileToUse -Extension
		
		$filesToDelete = @()
		$filesToDelete += $fileToUse
		
		
		$sfvFile = "$sourceDir\$filename.sfv"
		if(Test-Path $sfvFile)
		{
			$filesToDelete += $sfvFile
		}

		if($extension.ToLower() -eq 'rar')
		{
			$rxPattern = [RegEx]::Escape("$sourceDir$filename")
			$itemsToDelete = Get-ChildItem $sourceDir | Where-Object { $_.FullName -Match "$rxPattern\.r[0-9]+" }
			foreach($d in $itemsToDelete)
			{
				if(-Not $filesToDelete.Contains($d.FullName)) { $filesToDelete += $d.FullName }
			}
			
			$rxPattern = "$sourceDir$filename" -Replace '(.*)(\.part[0-9]+)', '$1'
			$rxPattern = [RegEx]::Escape("$rxPattern")
			$itemsToDelete = Get-ChildItem $sourceDir | Where-Object { $_.FullName -Match "$rxPattern.part[0-9]+\.rar" }
			
			foreach($d in $itemsToDelete)
			{
				if(-Not $filesToDelete.Contains($d.FullName)) { $filesToDelete += $d.FullName }
			}		
		}
		
		if($extension.ToLower() -eq 'zip')
		{	
			$rxPattern = [RegEx]::Escape("$sourceDir$filename")		
			$itemsToDelete = Get-ChildItem $sourceDir | Where-Object { $_.FullName -Match "$rxPattern\.z[0-9]+" }
			
			foreach($d in $itemsToDelete)
			{
				if(-Not $filesToDelete.Contains($d.FullName)) { $filesToDelete += $d.FullName }
			}
		}

		if($extension -eq '001')
		{
			$filename = Get-PathPart "$sourceDir$filename" -FilenameNoExtension
			
			$rxPattern = [RegEx]::Escape("$sourceDir$filename")
			$itemsToDelete = Get-ChildItem $sourceDir | Where-Object { $_.FullName -Match "$rxPattern\..{1,3}\.[0-9]{3}`$" }

			foreach($d in $itemsToDelete)
			{
				if(-Not $filesToDelete.Contains($d.FullName)) { $filesToDelete += $d.FullName }
			}
		}
		
		foreach($d in $filesToDelete)
		{
			if($PSCmdlet.ShouldProcess($d, "Remove-Item"))
			{
				Remove-Item $d -Force
			}
		}
	}
	
	Write-DisplayTrace "Exit $funcName"
}

Export-ModuleMember -Function *