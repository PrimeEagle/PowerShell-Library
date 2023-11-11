using module Varan.PowerShell.Validation

function Get-CurrentLogFile
{
	[CmdletBinding()]
    param()
	
	$directory = Split-Path -Path $logFile
	$filename = Split-Path -Path $logFile -LeafBase
	$ext = Split-Path -Path $logFile -Extension

	$curLogFile = (Get-ChildItem -Path $directory -Filter "$fileName*" |
					Sort-Object -Property Name -Descending |
					Select-Object -First 1).Name
	
	if($curLogFile.Length -eq 0) { $curLogFile = "$fileName-000000$ext" }
	
	"$directory\$curLogFile"
}

function Step-LogFile
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true)]
			[ValidatePath(FileOnly, MustExist)]				[string]$File
		  )
		  	
	$directory = Get-PathPart -Path $File -LastDirectory
	Write-DisplayDebug "`$directory = $directory" -NoLog
	
	$filename = Get-PathPart -Path $File -FilenameNoExtension
	Write-DisplayDebug "`$filename = $filename" -NoLog
	
	$ext = Get-PathPart -Path $File -Extension
	Write-DisplayDebug "`$ext = $ext" -NoLog
	
	$fileParts = $fileName.Split('-')
	Write-DisplayDebug "`$fileParts = $fileParts" -NoLog
	
	[long]$filenum = [long]$fileParts[-1]
	$filenum++
	Write-DisplayDebug "`$filenum = $filenum" -NoLog
	
	$result = "$directory\\"
	
	$i=0
	for(;$i -lt $fileParts.Length - 1;$i++)
	{
		$result += "$($fileParts[$i])-"
	}
	Write-DisplayDebug "`$result = $result" -NoLog
	
	$result += ([string]$filenum).PadLeft(6, '0')
	Write-DisplayDebug "`$result = $result" -NoLog
	
	$result += $ext
	Write-DisplayDebug "`$result = $result" -NoLog

	$result
}

function Write-LogFile
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [AllowEmptyString()] [string]$Message
		  )
	
	Process
	{		
		if($logEnabled)
		{
			$msg = Remove-NewLines $Message
			$delay = 1
			
			$curLogFile = Get-CurrentLogFile 
			
			if(Test-Path $curLogFile)
			{
				$numLines = (Get-Content $curLogFile).Length
			}
			else
			{
				$numLines = 0
			}
					
			if($numLines -ge $maxLinesPerLog)
			{
				$curLogFile = Step-LogFile $curLogFile
			}
			
			$locked = $false
			$timer = [Diagnostics.Stopwatch]::StartNew()
			while ((Confirm-FileLock $curLogFile) -And ($timer.Elapsed.TotalSeconds -lt $logTimeout))
			{
				$locked = $true
				Write-DisplayWarning "Waiting for locked file $logFile to be available ($([Math]::Round($timer.Elapsed.TotalSeconds, 0)) seconds elapsed)" -NoLog
				Reset-HostLine 0
				Start-Sleep -Seconds $delay
			}
			$timer.Stop()
			
			if($locked)
			{
				$locked = $false
				Reset-HostLine 0
			}
			
			if(Confirm-FileLock $curLogFile) 
			{
				Write-DisplayWarning "Timeout expired." -NoLog
			}
			
			"$(Get-DateTime) | $Message" | Add-Content $curLogFile
		}
	}
}

function Write-LogHost
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [AllowEmptyString()] [string]$Message
		  )
	
	Process
	{	
		if($logHost)
		{
			Write-LogFile "$hostLogDefaultTag$Message"
		}
	}
}

function Write-LogTrace
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{		
		if($logTrace)
		{
			Write-LogFile "$traceLogDefaultTag$Message"
		}
	}
}

function Write-LogDebug
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{			
		if($logDebug)
		{
			Write-LogFile "$debugLogDefaultTag$Message"
		}
	}
}

function Write-LogStatus
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{			
		if($logStatus)
		{
			Write-LogFile "$statusLogDefaultTag$Message"
		}
	}
}

function Write-LogInfo
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{	
		if($logInfo)
		{
			Write-LogFile "$infoLogDefaultTag$Message"
		}
	}
}

function Write-LogError
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{			
		if($logError)
		{
			Write-LogFile "$errorLogDefaultTag$Message"
		}
	}
}

function Write-LogWarning
{
	[CmdletBinding()]
    param(  [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [string]$Message
		  )
	
	Process
	{			
		if($logWarning)
		{
			Write-LogFile "$warningLogDefaultTag$Message"
		}
	}
}

Export-ModuleMember -Function *