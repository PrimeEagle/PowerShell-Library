using module Varan.PowerShell.Validation

class QueueItem
{
	[string]	$Name
	[string]	$Path
	[string]	$BackupPath
	
	QueueItem([string] $name, [string]$path, [string]$backupPath)
	{
		$this.Name = $name
		$this.Path = $path
		$this.BackupPath = $backupPath
	}
}

function Rename-InvalidFilename
{
	[CmdletBinding()]
	param( [Parameter(Mandatory = $true)]
													[string]$Filename
	)

	$tempFilename = $Filename.Replace('[', '(').Replace(']', ')')
	$tempFilename = $tempFilename.Trim()
	
	if($Filename -ne $tempFilename)
	{
		Rename-Item -Path $Filename -NewName $tempFilename -Force
	}
	
	return $tempFilename
}

function Get-PathQueue
{
	[CmdletBinding()]
    param( 	[Parameter()]
																	[MusicDrive[]]		$DrivePreset = @(),
			[Parameter()]
			[ValidateDriveLetter(MustExist, AllowNull)]
																	[string[]]			$DriveLetter = @(),
			[Parameter()]
			[ValidateVariable(AllowNull)]
																	[string[]]			$DriveLabel = @(),
			[Parameter()]
			[ValidatePath(DirectoryOnly, MustExist, AllowNull)]
																	[string[]]			$Path = @()
		 )

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$queue = @()

		if($DrivePreset.Count -gt 0)
		{
			$musicTemp 			= ($DrivePreset.Contains([MusicDrive]::MusicTemp)			-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicLaptopTemp	= ($DrivePreset.Contains([MusicDrive]::MusicLaptopTemp))
			$music1 			= ($DrivePreset.Contains([MusicDrive]::Music1) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup1 		= ($DrivePreset.Contains([MusicDrive]::Music1Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music2 			= ($DrivePreset.Contains([MusicDrive]::Music2) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup2 		= ($DrivePreset.Contains([MusicDrive]::Music2Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music3 			= ($DrivePreset.Contains([MusicDrive]::Music3) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup3 		= ($DrivePreset.Contains([MusicDrive]::Music3Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music4 			= ($DrivePreset.Contains([MusicDrive]::Music4) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup4 		= ($DrivePreset.Contains([MusicDrive]::Music4Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music5 			= ($DrivePreset.Contains([MusicDrive]::Music5) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup5 		= ($DrivePreset.Contains([MusicDrive]::Music5Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music6 			= ($DrivePreset.Contains([MusicDrive]::Music6) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup6 		= ($DrivePreset.Contains([MusicDrive]::Music6Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			$music7 			= ($DrivePreset.Contains([MusicDrive]::Music7) 				-Or	$DrivePreset.Contains([MusicDrive]::All))
			$musicBackup7 		= ($DrivePreset.Contains([MusicDrive]::Music7Backup) 		-Or	$DrivePreset.Contains([MusicDrive]::All))
			
			if($musicTemp) 			{ $queue += [QueueItem]::new("Music Temp", 			$musicTempPath,			'') 				}
			if($musicLaptopTemp) 	{ $queue += [QueueItem]::new("Music Laptop Temp", 	$musicLaptopTempPath,	'') 				}
			if($music1) 			{ $queue += [QueueItem]::new("Music 1", 			$music1Path,			$musicBackup1Path) 	}
			if($music2) 			{ $queue += [QueueItem]::new("Music 2", 			$music2Path,			$musicBackup2Path) 	}
			if($music3) 			{ $queue += [QueueItem]::new("Music 3", 			$music3Path,			$musicBackup3Path) 	}
			if($music4) 			{ $queue += [QueueItem]::new("Music 4", 			$music4Path,			$musicBackup4Path) 	}
			if($music5) 			{ $queue += [QueueItem]::new("Music 5", 			$music5Path,			$musicBackup5Path) 	}
			if($music6) 			{ $queue += [QueueItem]::new("Music 6", 			$music6Path,			$musicBackup6Path) 	}	
			if($music7) 			{ $queue += [QueueItem]::new("Music 7", 			$music7Path,			$musicBackup7Path) 	}	

			Confirm-USBDrives
		}

		foreach($d in $DriveLetter)
		{
			$dl = (Get-PathPart -Path $d -DriveLetter) + ":\"
			$queue += [QueueItem]::new("'$dl'", $dl, '')
		}

		foreach($d in $DriveLabel)
		{
			$dl = (Get-Volume -FileSystemLabel $d).DriveLetter + ":\"
			
			$queue += [QueueItem]::new($DriveLabel, $dl, '')
		}

		foreach($p in $Path)
		{
			$queue += [QueueItem]::new("'$Path'", $p, '')
		}
		
		Write-DisplayTrace "Exit $funcName"
		
		$queue
	}
}

function Get-Directories
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
																					[string]$Path,
		   [Parameter()] 														   	[switch]$Recurse
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
	
		$pFixed = Update-Path $Path
		Write-DisplayDebug "`$pFixed = $pFixed"	
		$d = [System.IO.DirectoryInfo]::new($pFixed)
		
		$dirs = [System.Collections.ArrayList]::new()

		$opt = [System.IO.EnumerationOptions]::new()
		$opt.RecurseSubdirectories = $Recurse
		$opt.AttributesToSkip = "SparseFile", "ReparsePoint"
		
		$dirs += $d.GetDirectories("*", $opt)
		
		Write-DisplayTrace "Exit $funcName"
		
		$dirs
	}
}

function Get-PathPart
{
	[CmdletBinding()]
    param(	[Parameter(	Position = 0,
						Mandatory = $true,
						ValueFromPipeline = $true)]
																	[string]$Path,
			[Parameter(ParameterSetName = 'setDriveLetter')] 		[switch]$DriveLetter,
			[Parameter(ParameterSetName = 'setLastDirectory')] 		[switch]$LastDirectory,
			[Parameter(ParameterSetName = 'setFirstDirectory')]		[switch]$FirstDirectory,
			[Parameter(ParameterSetName = 'setPreviousFolder')]		[switch]$PreviousDirectory,
			[Parameter(ParameterSetName = 'setFullFilename')] 		[switch]$Filename,
			[Parameter(ParameterSetName = 'setFilenameOnly')] 		[switch]$FilenameNoExtension,
			[Parameter(ParameterSetName = 'setExtension')] 			[switch]$Extension
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
			
		[string] $result = ''

		if($DriveLetter)
		{
			$result = $Path.Substring(0, 1).ToUpper()
		}
		
		if($LastDirectory)
		{
			$lastIndex = $Path.LastIndexOf("\")
			
			$result = $Path.Substring(0, $lastIndex + 1)
		}
		
		if($FirstDirectory)
		{
			$firstIndex = $Path.FirstIndexOf("\")
			
			$result = $Path.Substring(0, $firstIndex + 1)
		}
		
		if($PreviousDirectory)
		{
			$tempPath = Get-PathPart -Path $Path -LastDirectory
			$tempPath = $tempPath.Substring(0, $tempPath.Length - 1)
			
			$result = Get-PathPart -Path $tempPath -LastDirectory
		}
		
		if($Filename)
		{
			$result = Split-Path $Path -Leaf
		}
		
		if($FilenameNoExtension)
		{
			$result = [System.IO.Path]::GetFileNameWithoutExtension($Path) 
		}
		
		if($Extension)
		{
			$ext = [System.IO.Path]::GetExtension($Path)
			if($ext.Length -gt 0)
			{
				$result = $ext.Substring(1, $ext.Length - 1)
			}
		}
		
		Write-DisplayTrace "Exit $funcName"
		
		$result
	}
}

function Get-Files
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
																					[string]$Path,
			[Parameter()] 														   	[switch]$Recurse,
			[Parameter()]															[string[]]$Exclude
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$pFixed = Update-Path $Path
		Write-DisplayDebug "`$pFixed = $pFixed"	
		$f = [System.IO.DirectoryInfo]::new($pFixed)
		
		$files = [System.Collections.ArrayList]::new()

		$opt = [System.IO.EnumerationOptions]::new()
		$opt.RecurseSubdirectories = $Recurse
		$opt.AttributesToSkip = "SparseFile", "ReparsePoint"
		
		$files += $f.GetFiles("*", $opt)
		
		if($Exclude)
		{
			$files = ($files | Where-Object { $Exclude -NotContains [System.IO.Path]::GetExtension($_) })
		}
		
		Write-DisplayTrace "Exit $funcName"
		
		$files
	}
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Update-Path
{
	[CmdletBinding()]
    param(	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath()]														[string]$Path
		 ) 
	
	Process
	{		
		[string]$result = [Management.Automation.WildcardPattern]::Escape($Path).Trim()

		$result
	}
}


function Get-FreeSpace
{
	[CmdletBinding(SupportsShouldProcess)]
	param(	[Parameter(Position = 0, Mandatory = $true)]
			[ValidateDriveLetter()]
			[string]$Drive
	)
	
	$d = $Drive
	if($d.EndsWith(':')) { $d = $d.Substring(0, $d.Length - 1) }
	
	$bytes = (Get-PSDrive $d).Free
	
	$size = Format-FileSize $bytes
	
	$rv = new-object psobject -Property @{
			   Label = (Get-Volume -DriveLetter $Drive).FileSystemLabel
			   Drive = $Drive.ToUpper()
			   FreeSpace = $size
		   }
		   
	$rv
}

function Edit-PathDrive
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath()]																					[string]$Path,
			[Parameter(Position = 1, ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'setA')]
			[ValidateDriveLetter()]
																												[string]$NewDrive,
			[Parameter(Position = 1, ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'setB')]
			[ValidatePath()]
																												[string]$DriveFromPath
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		[string]$drive = ''
		if($NewDrive.Length -gt 0) 
		{ 
			$drive = $NewDrive 
		}
		else
		{
			$drive = Get-PathPart -Path $DriveFromPath -DriveLetter
		}
		Write-DisplayDebug "Edit-PathDrive: `$drive = $drive"
		
		[string]$result = "$($drive):$(Split-Path -Path $Path -NoQualifier)"
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Confirm-DirectoryExists
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
		   [ValidatePath()]											[string]$Path
		 ) 
	
	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$pathFixed = Update-Path $path
		Write-DisplayDebug "`$pathFixed = $pathFixed"
		Write-DisplayDebug "Test-Path `$pathFixed = $(Test-Path $pathFixed)"
		
		if(-Not(Test-Path $pathFixed))
		{
			$n = New-Item $path -ItemType Directory
		}
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Get-DirectorySize 
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath(DirectoryOnly, MustExist)]								[string]$Path,
			[Parameter()]														   	[switch]$Force,
			[Parameter()]														   	[switch]$Recurse
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$timer = [Diagnostics.Stopwatch]::StartNew()
		
		$result = [PSCustomObject]@{
					PSTypename        = "FolderSizeInfo"
					Computername      = [System.Environment]::MachineName
					Path              = $Path
					Name              = $(Split-Path $Path -leaf)
					TotalDirectories  = 0
					TotalFiles        = 0
					TotalSize         = 0
					ElapsedSeconds    = 0
					ElapsedTime       = ''}
		
		$pathFixed = Update-Path $Path
		
		if (Test-Path $pathFixed) 
		{
			$d = [System.IO.DirectoryInfo]::new($Path)
		
			$files = [System.Collections.ArrayList]::new()
			$dirs = [System.Collections.ArrayList]::new()

			$opt = [System.IO.EnumerationOptions]::new()
			$opt.RecurseSubdirectories = $Recurse

			if ($Force) 
			{
				$opt.AttributesToSkip = "SparseFile", "ReparsePoint"
			}
			else 
			{
				$opt.attributestoSkip = "Hidden"
			}

			$data = $($d.GetFiles("*", $opt))
			$dirData = $d.GetDirectories("*", $opt)
			
			if ($data.count -gt 1) 
			{
				$files.AddRange($data)
			}
			elseif ($data.count -eq 1) 
			{
				[void]($files.Add($data))
			}

			if ($dirData.count -gt 1) 
			{
				$dirs.AddRange($dirData)
			}
			elseif ($dirData.count -eq 1) 
			{
				[void]($dirs.Add($dirData))
			}
			
			if ($files.count -gt 0) 
			{
				# there appears to be a bug with the array list in Windows PowerShell
				# where it doesn't always properly enumerate. Passing the list
				# items via ForEach appears to solve the problem and doesn't
				# adversely affect PowerShell 7. Addeed in v2.22.0. JH
				$stats = $files.foreach( {$_}) | Measure-Object -Property Length -Sum
				$totalFiles = $files.Count
				$totalSize = $stats.Sum
			}
			else 
			{
				$totalFiles = 0
				$totalSize = 0
			}
			
			$totalDirs = $dirs.Count
			
			$timer.Stop()
			
			$result.TotalDirectories = $totalDirs
			$result.TotalFiles = $totalFiles
			$result.TotalSize = $totalSize
			
			$seconds = $timer.Elapsed.TotalSeconds
			$result.ElapsedSeconds = $seconds
			$result.ElapsedTime = Format-Time $seconds
		}
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Confirm-FileLock {
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath(FileOnly, MustExist)]											[string]$Path
		 ) 

	Process
	{	
		$result = $false		
		$oFile = New-Object System.IO.FileInfo $Path
		
		$pathFixed = Update-Path $Path
		
		if (-Not (Test-Path -Path $pathFixed)) 
		{
			return $result
		}

		try 
		{
			$oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)

			if ($oStream) 
			{
				$oStream.Close()
			}
			
			$result = $false
		} 
		catch 
		{
			$result = $true
		}
		
		return $result
	}
}

function Confirm-Path
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath()]														[string]$Path
		 ) 
	
	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$result = $false

		if($Path)
		{
			$pathFixed = Update-Path $Path
			Write-DisplayDebug "param `$Path = $Path"
			Write-DisplayDebug "`$pathFixed = $pathFixed"
			
			Write-DisplayDebug "`$pathFixed.Length = $($pathFixed.Length)"
			Write-DisplayDebug "Test-Path `$pathFixed = $(Test-Path $pathFixed)"
			
			$result = ($pathFixed.Length -gt 0) -And (Test-Path $pathFixed)
		}
		
		if(-Not $result)
		{
			Write-DisplayTrace "Exit with error from $funcName"
			Write-DisplayError "Could not find required file or path $path." -Exit
		}
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Confirm-RegistryValue 
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Path,
		   [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)] [string]$Name
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$result = $false
		
		Write-DisplayDebug "Test-Path `$Path = $(Test-Path $Path)"
		if (Test-Path $Path) 
		{
			$key = Get-Item -LiteralPath $Path
			Write-DisplayDebug "`$key = $key"
			
			if ($key.GetValue($Name, $null) -ne $null) 
			{
				$result = $true
			}
		}

		$result
		Write-DisplayTrace "Exit $funcName"
	}
}

function Backup-Directory {
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param( 	[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath(DirectoryOnly, MustExist)]								[string]$Source,
			[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath(DirectoryOnly)]											[string]$Destination,
			[Parameter(ParameterSetName = 'setRecurse')]							[switch]$Recurse,
			[Parameter(ParameterSetName = 'setMirror')]							   	[switch]$Mirror,
			[Parameter()]														   	[switch]$ShowProgress
		 ) 
	$whatIf = Assert-WhatIf
	
    $regexBytes = '(?<=\s+)\d+(?=\s+)'
	[int]$reportGap = 1
	
	$stagingParams = '/NP /NDL /NC /BYTES /NJH /NJS /IS /NS /NP'

	if($Recurse -And -Not($Mirror)) { $stagingParams += ' /E' }
	if($Mirror) { $stagingParams += ' /MIR' }
	
	if(-Not $PSCmdlet.ShouldProcess($Source, 'Copy'))
	{
		$stagingParams += ' /L'
	}
	
	$robocopyParams = "$stagingParams /MT:$numCopyThreads"
	
    Write-DisplayInfo 'Analyzing robocopy job.'
    $stagingLogPath = "$($env:WinDir)\Temp\robocopy staging.log"
	
	if(Test-Path $stagingLogPath) { Remove-Item $stagingLogPath -WhatIf:$whatIf }
	
    $stagingArguments = """$Source"" ""$Destination"" /LOG:""$stagingLogPath"" /L $stagingParams" 
	
	Write-DisplayInfo "Staging arguments: $stagingArguments"
    Start-Process -Wait -FilePath robocopy.exe -ArgumentList $stagingArguments -NoNewWindow -RedirectStandardOutput Output-Null -WhatIf:$whatIf

	$stagingContent = @()
	if(-Not $whatIf)
	{
		$stagingContent = Get-Content -Path $stagingLogPath
    }
	
	$totalFileCount = $stagingContent.Count - 1

    [RegEx]::Matches(($stagingContent -join "`n"), $regexBytes) | % { $bytesTotal = 0 } { $bytesTotal += $_.Value }
	$bytesTotalLabel = Format-FileSize $bytesTotal
	Write-DisplayInfo "Total bytes to be copied: $bytesTotalLabel"

    $robocopyLogPath = "$($env:WinDir)\Temp\robocopy.log"
	if(Test-Path $robocopyLogPath) { Remove-Item $robocopyLogPath -WhatIf:$whatIf }
	
    $arguments = """$Source"" ""$Destination"" /LOG:""$robocopyLogPath"" $robocopyParams"
	Write-DisplayInfo "Beginning the robocopy process with arguments: $arguments"

	$timer = [Diagnostics.Stopwatch]::StartNew()
    $robocopy = Start-Process -FilePath robocopy.exe -ArgumentList $arguments -PassThru -NoNewWindow -RedirectStandardOutput Output-Null
    Start-Sleep -Milliseconds 100
	[long]$bytesCopied = 0
	$exitLoop = $false
	
    while (-Not $robocopy.HasExited -And -Not $exitLoop) 
	{
		Start-Sleep -Seconds $reportGap
		if(-Not $ShowProgress) { continue }
        
		$logContent = $null
		if(-Not $whatIf)
		{
			$logContent = Get-Content -Path $robocopyLogPath
		}
		else
		{
			$exitLoop = $true
		}
		
		if($logContent -ne $null)
		{
			$bytesCopied = [Regex]::Matches($logContent, $regexBytes) | ForEach-Object -Begin { [long]$bytesCopied = 0 } -Process { $bytesCopied += $_.Value } -End { $bytesCopied }
			$copiedFileCount = $logContent.Count - 1
			Write-DisplayInfo "Bytes copied: $bytesCopied"
			Write-DisplayInfo "Files copied: $($logContent.Count)"
			
			$percentage = 0
			if ($bytesCopied -gt 0) 
			{
			   $percentage = (($bytesCopied/$bytesTotal)*100)
			   $pctLabel = [string][Math]::Round($percentage, 2)
			}
			
			$bytesCopiedLabel = Format-FileSize $bytesCopied
			$elapsedSeconds = $timer.Elapsed.TotalSeconds
			$rate = [Math]::Round($bytesCopied/$elapsedSeconds, 2)
			$rateLabel = Format-FileSize $rate
			$timeRemainingSeconds = ($bytesTotal - $bytesCopied)/$rate
			$timeLabel = Format-Time $timeRemainingSeconds
			
			Write-DisplayStatus -Prefix "Copying" -Message "$copiedFileCount of $totalFileCount $(Get-FileLabel $totalFileCount), ${pctLabel}% [$bytesCopiedLabel of $bytesTotalLabel]" -Suffix "${rateLabel}/s ($timeLabel remaining)"
		}
    }
	$timer.Stop()
	
	if(-Not $whatIf)
	{
		Remove-Item $stagingLogPath -WhatIf:$whatIf
		Remove-Item $robocopyLogPath -WhatIf:$whatIf
	}
}

function ConvertTo-RegEx
{
	[CmdletBinding()]
	param ( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]	[string]$FileMask
		  )

	$rx = $FileMask.Replace('*', '[0-9a-zA-Z_\-. ]+')
	$rx = "^$rx`$"

	$rx
}

function Add-IntoFileSection
{
	[CmdletBinding()]
	param (	[Parameter(Position = 0, Mandatory = $true)]						
			[ValidatePath(FileOnly, MustExist)]									[string]$Path,
			[Parameter(Mandatory = $true)] [AllowEmptyString()]					[string]$Text,
			[Parameter(Mandatory = $true)]										[string]$Section,
			[Parameter()]														[switch]$IgnoreWhitespace,
			[Parameter(Mandatory = $true, ParameterSetName = 'setStart')]		[switch]$DefaultToStart,
			[Parameter(Mandatory = $true, ParameterSetName = 'setEnd')]			[switch]$DefaultToEnd
	)
	
	Process
	{
		$sectionExists = Confirm-FileHasLine -Path $Path -StartsWith $Section -IgnoreWhitespace:$IgnoreWhitespace
		
		if($sectionExists)
		{
			$inSection = $false
			$prevInSection = $false
			$added = $false
			$contents = @()
			$lines = Get-Content -Path $Path
			
			$lineNum = 0
			foreach($line in $lines)
			{
				$lineNum++
				$testLine = $line
				if($IgnoreWhitespace) { $testLine = $testLine.Trim() }
				
				if($testLine.StartsWith($Section)) { $inSection = $true }
							
				if(-Not $added -And -Not($inSection) -And $prevInSection)
				{
					$contents += $Text
					$contents += $line
					$added = $true
					$inSection = $false
				}	
				
				if(-Not $added -And ($lineNum -eq $lines.Length))
				{
					$contents += $line
					$contents += $Text
					
					$added = $true
				}
				else
				{
					$contents += $line
				}
				
				$prevInSection = $inSection
			}
			
			
			Set-Content -Path $Path -Value $contents
		}
		else
		{
			if($DefaultToStart)
			{
				$contents = @($Text) + (Get-Content $Path)
				Set-Content  -Path $Path -Value $contents
			}
			elseif($DefaultToEnd)
			{
				Add-Content -Path $Path -Value ""
				Add-Content -Path $Path -Value $Text
			}
		}
	}
}

function Remove-FromFile
{
	[CmdletBinding()]
	param (	[Parameter(Position = 0, Mandatory = $true)]
			[ValidatePath(FileOnly, MustExist)]									[string]$Path,
			[Parameter(Mandatory = $true)] [AllowEmptyString()]					[string]$Text,
			[Parameter()]														[switch]$IgnoreWhitespace
	)
	
	Process
	{
		$contents = @()
		$lines = Get-Content -Path $Path
			
		foreach($line in $lines)
		{
			$testLine = $line.ToLower()
			if($IgnoreWhitespace) { $testLine = $testLine.Trim() }
			
			if($testLine -ne $Text.ToLower())
			{
				$contents += $line
			}
		}
			
		Set-Content -Path $Path -Value $contents
	}
}

function Confirm-FileHasLine
{
	[CmdletBinding()]
	param ( [Parameter(Position = 0, Mandatory = $true)]
			[ValidatePath(FileOnly, MustExist)]		[string]$Path,
			[Parameter()]							[string]$StartsWith,
			[Parameter()]							[string]$Contains,
			[Parameter()]							[string]$EndsWith,
			[Parameter()]							[string]$Equals,
			[Parameter()]							[switch]$IgnoreWhitespace
		  )

	$lines = Get-Content $Path
	
	$result = $false
	
	if(-Not ($StartsWith) -And -Not ($Contains) -And -Not ($EndsWith) -And -Not ($Equals)) { return true }
	
	foreach($line in $lines)
	{
		if(-Not [String]::IsNullOrWhiteSpace($line))
		{
			$test = $line.ToLower()
			
			if ($IgnoreWhitespace) { $test = $test.Trim() }

			$resultStart = $true
			$resultContains = $true
			$resultEnd = $true
			$resultEquals = $true
			
			if($StartsWith)
			{
				if($test.StartsWith($StartsWith.ToLower()))
				{
					$resultStart = $true
				}
				else
				{
					$resultStart = $false
				}
			}

			if($Contains)
			{
				if(-Not $Contains) { $resultContains = $true }		
				if($test.Contains($Contains.ToLower()))
				{
					$resultContains = $true
				}
				else
				{
					$resultContains = $false
				}
			}
			
			if($EndsWith)
			{
				if(-Not $EndsWith) { $resultEnd = $true }
				if($test.EndsWith($EndsWith.ToLower()))
				{
					$resultEnd = $true
				}
				else
				{
					$resultEnd = $false
				}
			}
			
			if($Equals)
			{
				if(-Not $Equals) { $resultEquals = $true }
				if($test -eq $Equals.ToLower())
				{
					$resultEquals = $true
				}
				else
				{
					$resultEquals = $false
				}
			}
			
			$result = $resultStart -And $resultContains -And $resultEnd -And $resultEquals
			
			if($result) { break }
		}
	}
	
	$result
}

function Get-LineFromFile
{
	[CmdletBinding()]
	param ( [Parameter(Position = 0, Mandatory = $true)]
			[ValidatePath(FileOnly, MustExist)]		[string]$Path,
			[Parameter()]							[string]$StartsWith,
			[Parameter()]							[string]$Contains,
			[Parameter()]							[string]$EndsWith,
			[Parameter()]							[string]$Equals,
			[Parameter()]							[switch]$IgnoreWhitespace
		  )

	$lines = Get-Content $Path
	
	$result = ""
	
	if(-Not ($StartsWith) -And -Not ($Contains) -And -Not ($EndsWith) -And -Not ($Equals)) { return "" }
	
	foreach($line in $lines)
	{
		if(-Not [String]::IsNullOrWhiteSpace($line))
		{
			$test = $line.ToLower()
			
			if ($IgnoreWhitespace) { $test = $test.Trim() }

			$resultStart = $true
			$resultContains = $true
			$resultEnd = $true
			$resultEquals = $true
			
			if($StartsWith)
			{
				if($test.StartsWith($StartsWith.ToLower()))
				{
					$resultStart = $true
				}
				else
				{
					$resultStart = $false
				}
			}

			if($Contains)
			{
				if(-Not $Contains) { $resultContains = $true }		
				if($test.Contains($Contains.ToLower()))
				{
					$resultContains = $true
				}
				else
				{
					$resultContains = $false
				}
			}
			
			if($EndsWith)
			{
				if(-Not $EndsWith) { $resultEnd = $true }
				if($test.EndsWith($EndsWith.ToLower()))
				{
					$resultEnd = $true
				}
				else
				{
					$resultEnd = $false
				}
			}
			
			if($Equals)
			{
				if(-Not $Equals) { $resultEquals = $true }
				if($test -eq $Equals.ToLower())
				{
					$resultEquals = $true
				}
				else
				{
					$resultEquals = $false
				}
			}
			
			$match = $resultStart -And $resultContains -And $resultEnd -And $resultEquals
			
			if($match) 
			{
				$result = $line
				break 
			}
		}
	}
	
	return $result
}

function Test-PathIsDirectory
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath()]														[string]$Path
		 ) 
	
	$result = $false
	if($Path.EndsWith('\') -Or ($Path.LastIndexOf('\') -gt $Path.LastIndexOf('.'))) { $result = $true }
	
	$result
}

function Test-PathIsFile
{
	[CmdletBinding()]
    param( 	[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
			[ValidatePath()]														[string]$Path
		 ) 
	
	$result = -Not (Test-PathIsDirectory -Path $Path)
	
	$result
}

Export-ModuleMember -Function *