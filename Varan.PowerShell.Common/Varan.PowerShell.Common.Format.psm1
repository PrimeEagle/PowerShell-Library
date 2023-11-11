using module Varan.PowerShell.Validation

function Get-DateTime 
{
	$currentDate = Get-Date
   
	$currentDate.ToString("o").substring(0, 23)
}
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Format-Time
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [double]$Seconds
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters

		$ts =  [timespan]::FromSeconds($Seconds)
		
		if($Seconds -gt 5)
		{
			$result = "{0:hh\:mm\:ss}" -f $ts
		}
		else
		{
			$result = "{0:hh\:mm\:ss\.fff}" -f $ts
		}
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Format-Number
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [double]$Num,
		   [Parameter(Mandatory = $false)]										   [int] $Precision = 0
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters

		$format = "N$($Precision.ToString())"	
		$Num.ToString($format)
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Format-FileSize 
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [long]$Size
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$resultNum = 0.0
		$result = ""

		$yb = [Math]::Pow(10,24)
		$zb = [Math]::Pow(10,21)
		$eb = [Math]::Pow(10,18)
		$pb = [Math]::Pow(10,15)
		$tb = [Math]::Pow(10,12)
		$gb = [Math]::Pow(10,9)
		$mb = [Math]::Pow(10,6)
		$kb = [Math]::Pow(10,3)
		
		if($Size -ge $yb) 
		{ 
			$resultNum = [Math]::Round($Size / $yb, 2)
			$result = " YB"
		}
		elseif($Size -ge $zb) 
		{ 
			$resultNum = [Math]::Round($Size / $zb, 2)
			$result = " ZB"
		}
		elseif($Size -ge $eb) 
		{ 
			$resultNum = [Math]::Round($Size / $eb, 2)
			$result = " EB"
		}
		elseif($Size -ge $pb) 
		{ 
			$resultNum = [Math]::Round($Size / $pb, 2)
			$result = " PB"
		}
		elseif($Size -ge $tb)
		{
			$resultNum = [Math]::Round($Size / $tb, 2)
			$result = " TB"
		}
		elseif($Size -ge $gb)
		{
			$resultNum = [Math]::Round($Size / $gb, 2)
			$result = " GB"
		}
		elseif($Size -ge $mb)
		{
			$resultNum = [Math]::Round($Size / $mb, 2)
			$result = " MB"
		}
		elseif($Size -ge $kb)
		{
			$resultNum = [Math]::Round($Size / $kb, 2)
			$result = " KB"
		}
		else
		{
			$result = " bytes"
		}
		
		Write-DisplayDebug $resultNum$result
		"$resultNum$result"
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Get-MeasureWord
{
	[CmdletBinding()]
    param( [Parameter(Mandatory = $true)] [long]$Count,
		   [Parameter(Mandatory = $true)] [string]$SingularWord,
		   [Parameter(Mandatory = $true)] [string]$PluralWord
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		if($Count -eq 1) 
		{
			$result = $SingularWord
		}
		else
		{
			$result = $PluralWord
		}

		Write-DisplayDebug $result
		Write-DisplayTrace "Exit $funcName"
		
		$result
	}
}

function Get-CombinedMeasureWord
{
	[CmdletBinding()]
    param( [Parameter(Mandatory = $true)] [long]$Count,
		   [Parameter(Mandatory = $true)] [string]$Words
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		$result = ''
		$splitWords = $Words.Split(';')
		
		if($splitWords.length -eq 2)
		{
			$singular = $Words.Split(';')[0]
			$plural = $Words.Split(';')[1]
			
			$result = Get-MeasureWord -Count $Count -SingularWord $singular -PluralWord $plural
		}
		else		
		{ 
			$result = $Words 
		}
		
		Write-DisplayDebug $result
		
		$result
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Get-FileLabel
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [long]$Count
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		Get-MeasureWord -Count $Count -SingularWord "file" -PluralWord "files"
		
		Write-DisplayTrace "Exit $funcName"
	}
}

function Get-DirectoryLabel
{
	[CmdletBinding()]
    param( [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)] [long]$Count
		 ) 

	Process
	{
		$funcName = $MyInvocation.MyCommand
		Write-DisplayTraceCallerInfo -Parameters $PSBoundParameters
		
		Get-MeasureWord -Count $Count -SingularWord "directory" -PluralWord "directories"
		
		Write-DisplayTrace "Exit $funcName"
	}
}

Export-ModuleMember -Function *