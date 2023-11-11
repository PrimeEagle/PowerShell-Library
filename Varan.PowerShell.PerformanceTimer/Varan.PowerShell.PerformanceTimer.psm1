using module Varan.PowerShell.Validation

enum PTStatusIntervalMode
{
	Iteration
	Time
}

enum PTCountMode
{
	Simple
	Increment
	Match
}

enum PTMessageType
{
	Start
	Increment
	Match
	Stop
}

enum PTMessagePosition
{
	Prefix
	Message
	Suffix
}

class MessageTemplate
{
	[string] $Condition
	[string] $Message

	MessageTemplate([string] $msg, [string] $cond)
	{
		$this.Message = $msg
		$this.Condition = $cond
	}
	
	MessageTemplate([string] $msg)
	{
		$this.Message = $msg
		$this.Condition = $null
	}
}

class PerformanceTimer
{
	hidden	[Diagnostics.Stopwatch]	$Timer
	hidden	[Diagnostics.Stopwatch]	$IntervalTimer
	hidden	[long]					$IncrementCount
	hidden	[long]					$MatchCount
	hidden	[long]					$TotalIncrementCount
	hidden	[bool]					$FirstCalled
	hidden	[bool]					$Running
	hidden	[bool]					$Done
	hidden	[bool]					$LastStatusWasStatic
	
			[PTCountMode]			$CountMode
			[PTStatusIntervalMode]	$StatusIntervalMode
			[long]					$StatusInterval
			[bool]					$TotalCountKnown
			[string[]]				$CustomValues
			[string]				$IncrementRateUnits
			[string]				$MatchRateUnits
			[int]					$IncrementRatePrecision
			[int]					$MatchRatePrecision
			[int]					$IncrementPercentPrecision
			
			[bool]					$DisplayStatusOnStart
			[bool]					$DisplayStatusOnIncrement
			[bool]					$DisplayStatusOnMatch
			[bool]					$DisplayStatusOnStop
			[bool]					$StartStatusIsStatic
			[bool]					$IncrementStatusIsStatic
			[bool]					$MatchStatusIsStatic
			[bool]					$StopStatusIsStatic
			[MessageTemplate[]]		$StartPrefix
			[MessageTemplate[]]		$StartMessage
			[MessageTemplate[]]		$StartSuffix
			[MessageTemplate[]]		$IncrementPrefix
			[MessageTemplate[]]		$IncrementMessage
			[MessageTemplate[]]		$IncrementSuffix
			[MessageTemplate[]]		$MatchPrefix
			[MessageTemplate[]]		$MatchMessage
			[MessageTemplate[]]		$MatchSuffix
			[MessageTemplate[]]		$StopPrefix
			[MessageTemplate[]]		$StopMessage
			[MessageTemplate[]]		$StopSuffix	

	PerformanceTimer()
	{	
		$this.DisplayStatusOnStart = $true
		$this.DisplayStatusOnIncrement = $true
		$this.DisplayStatusOnMatch = $true
		$this.DisplayStatusOnStop = $true
		$this.StatusIntervalMode = [PTStatusIntervalMode]::Time
        $this.StatusInterval = 500
		$this.CountMode = [PTCountMode]::Simple
		$this.TotalCountKnown = $true
			
		$this.StartPrefix			= [MessageTemplate[]]@()
		$this.StartMessage			= [MessageTemplate[]]@()
		$this.StartSuffix			= [MessageTemplate[]]@()
		$this.IncrementPrefix 		= [MessageTemplate[]]@()
		$this.IncrementMessage 		= [MessageTemplate[]]@()
		$this.IncrementSuffix 		= [MessageTemplate[]]@()
		$this.MatchPrefix 			= [MessageTemplate[]]@()
		$this.MatchMessage			= [MessageTemplate[]]@()
		$this.MatchSuffix			= [MessageTemplate[]]@()
		$this.StopPrefix 			= [MessageTemplate[]]@()
		$this.StopMessage			= [MessageTemplate[]]@()
		$this.StopSuffix			= [MessageTemplate[]]@()
		
		$this.AddMessage('Processing {tic} items',												'{is-tck}',						[PTMessageType]::Start, 	[PTMessagePosition]::Message)
		$this.AddMessage('Processing',															$null, 							[PTMessageType]::Start, 	[PTMessagePosition]::Message)
		
		$this.AddMessage('Processed item {ic} of {tic} ({mc} {mw:match,matches:{mc}})',			'{is-tck} -And {is-cmm}', 		[PTMessageType]::Increment, [PTMessagePosition]::Message)
		$this.AddMessage('Processed item {ic} of {tic}',											'{is-tck}', 					[PTMessageType]::Increment, [PTMessagePosition]::Message)
		$this.AddMessage(', {ip}% [{ir} {iru}, {mr} {mru}, {tr} rem]',						'{is-tck} -And {is-cmm}', 		[PTMessageType]::Increment, [PTMessagePosition]::Suffix)
		$this.AddMessage(', {ip}% [{ir} {iru}, {tr} remaining]',									'{is-tck}', 					[PTMessageType]::Increment, [PTMessagePosition]::Suffix)
		$this.AddMessage(' [{ir} {iru}]',															'-Not {is-tck}', 				[PTMessageType]::Increment, [PTMessagePosition]::Suffix)
		
		$this.AddMessage('{mc} {mw:match,matches:{mc}} found ({c0})',								$null, 							[PTMessageType]::Match, 	[PTMessagePosition]::Message)
		$this.AddMessage(', {ip}% [{ir} {iru}, {mr} {mru}, {tr} rem]',						'{is-tck}', 					[PTMessageType]::Match, 	[PTMessagePosition]::Suffix)
		$this.AddMessage('[{ir} {iru}, {mr} {mru}]',												'-Not {is-tck}', 				[PTMessageType]::Match, 	[PTMessagePosition]::Suffix)
		
		$this.AddMessage('Done.',																	$null, 							[PTMessageType]::Stop, 		[PTMessagePosition]::Prefix)
		$this.AddMessage('{tic} {mw:item,items:{tic}} ({mc} {mw:match,matches:{mc}}) in {te}',	'{is-cmm}',						[PTMessageType]::Stop, 		[PTMessagePosition]::Message)
		$this.AddMessage('{tic} {mw:item,items:{tic}} in {te}',									$null, 							[PTMessageType]::Stop, 		[PTMessagePosition]::Message)
		$this.AddMessage('[{ir} {iru}, {mr} {mru}]',												'{is-cmm}',						[PTMessageType]::Stop, 		[PTMessagePosition]::Suffix)
		$this.AddMessage('[{ir} {iru}]',															$null,							[PTMessageType]::Stop, 		[PTMessagePosition]::Suffix)

		$this.StartStatusIsStatic = $false
		$this.IncrementStatusIsStatic = $false
		$this.MatchStatusIsStatic = $false
		$this.StopStatusIsStatic = $true
		$this.LastStatusWasStatic = $true
		$this.CustomValues = @()
		
		if($this.Timer -ne $null)
		{
			$this.Timer.Reset()
		}
		
		if($this.IntervalTimer -ne $null)
		{
			$this.IntervalTimer.Reset()
		}
		
		$this.IncrementCount = 0
		$this.MatchCount = 0
		$this.FirstCalled = $false
		$this.Running = $false
		$this.Done = $false
		$this.TotalIncrementCount = 0
		$this.IncrementRateUnits = 'items/s'
		$this.MatchRateUnits = 'm/s'
		$this.IncrementRatePrecision = 0
		$this.MatchRatePrecision = 2
		$this.IncrementPercentPrecision = 2
	}
	
	[void] Start()
	{	
		$this.Running = $true
		$this.IncrementCount = 0
		$this.MatchCount = 0
		$this.Done = $false
		
		if($this.DisplayStatusOnStart)
		{
			$this.DisplayStatusStart()
		}
		
		if($this.Timer -ne $null)
		{
			$this.Timer.Reset()
		}
		
		if($this.IntervalTimer -ne $null)
		{
			$this.IntervalTimer.Reset()
		}
		
		$this.Timer = [Diagnostics.Stopwatch]::StartNew()
		
		if($this.StatusIntervalMode -eq [PTStatusIntervalMode]::Time)
		{
			$this.IntervalTimer = [Diagnostics.Stopwatch]::StartNew()
		}
	}
	
	[void] Increment()
	{
		$this.IncrementCount++
		
		if( ($this.DisplayStatusOnIncrement) -And ($this.IsTimeForStatus()) )
		{
			$this.DisplayStatusIncrement()
		}
	}
	
	[void] IncrementMatch()
	{		
		$this.MatchCount++
		
		if($this.DisplayStatusOnMatch)
		{
			$this.DisplayStatusMatch()
		}
	}
	
	[void] Stop()
	{
		if($this.IntervalTimer -ne $null)
		{
			$this.IntervalTimer.Stop()
		}

		if($this.Timer -ne $null)
		{
			$this.Timer.Stop()
		}

		$this.Running = $false
		$this.Done = $true

		if($this.DisplayStatusOnStop)
		{
			$this.DisplayStatusStop()
		}
	}
	
	[void] Stop([long] $TotalIncrementCount)
	{
		$this.IncrementCount = $TotalIncrementCount
		$this.TotalIncrementCount = $TotalIncrementCount
		
		$this.Stop()
	}
	
	[void] ClearMessages([PTMessageType] $msgType, [PTMessagePosition] $pos)
	{	
		if($msgType -eq [PTMessageType]::Start)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.StartPrefix = @()
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.StartMessage = @()
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.StartSuffix = @()
			}
		}
		
		if($msgType -eq [PTMessageType]::Increment)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.IncrementPrefix = @()
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.IncrementMessage = @()
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.IncrementSuffix = @()
			}
		}
		
		if($msgType -eq [PTMessageType]::Match)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.MatchPrefix = @()
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.MatchMessage = @()
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.MatchSuffix = @()
			}
		}
		
		if($msgType -eq [PTMessageType]::Stop)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.StopPrefix = @()
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.StopMessage = @()
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.StopSuffix = @()
			}
		}
	}
	
	[void] AddMessage([string] $msg, [string] $condition, [PTMessageType] $msgType, [PTMessagePosition] $pos)
	{
		$mt = [MessageTemplate]::new($msg, $condition)
		
		if($msgType -eq [PTMessageType]::Start)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.StartPrefix += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.StartMessage += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.StartSuffix += $mt
			}
		}
		
		if($msgType -eq [PTMessageType]::Increment)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.IncrementPrefix += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.IncrementMessage += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.IncrementSuffix += $mt
			}
		}
		
		if($msgType -eq [PTMessageType]::Match)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.MatchPrefix += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.MatchMessage += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.MatchSuffix += $mt
			}
		}
		
		if($msgType -eq [PTMessageType]::Stop)
		{
			if($pos -eq [PTMessagePosition]::Prefix)
			{
				$this.StopPrefix += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Message)
			{
				$this.StopMessage += $mt
			}
			
			if($pos -eq [PTMessagePosition]::Suffix)
			{
				$this.StopSuffix += $mt
			}
		}
	}
	
	[double] MetricIncrementPercent()
	{
		if(-Not ($this.Running) -Or 
			-Not ($this.TotalCountKnown) -Or 
			($this.TotalIncrementCount -le 0))
		{
			$percent = 0
		}
		elseif(($this.Done) -Or ($this.IncrementCount -eq $this.TotalIncrementCount))
		{
			$percent = 100
		}
		else
		{
			$percent = ($this.IncrementCount/$this.TotalIncrementCount)*100
		}
		
		return $percent
	}
	
	[double] MetricIncrementRate()
	{	
		if($this.MetricTimeElapsed() -eq 0)
		{
			$rate = 0
		}
		else
		{
			$rate = ($this.IncrementCount)/($this.MetricTimeElapsed())
		}
		
		return $rate
	}
	
	[double] MetricMatchRate()
	{	
		$rate = ($this.MatchCount)/($this.MetricTimeElapsed())
		
		return $rate
	}

	[double] MetricTimeElapsed()
	{
		$time = $this.timer.Elapsed.TotalMilliseconds/1000
		
		return $time
	}	
	
	[long] MetricTimeRemaining()
	{	
		if($this.Done)
		{
			$timeRemaining = 0
		}
		elseif($this.TotalCountKnown)
		{
			$rate = $this.MetricIncrementRate()		
			$itemsRemaining = $this.TotalIncrementCount - $this.IncrementCount
			
			if($rate -eq 0) 
			{
				$timeRemaining = 0
			}
			else
			{
				$timeRemaining = $itemsRemaining/$rate
			}
		}
		else
		{
			$timeRemaining = 0			
		}
			
		return $timeRemaining
	}	

	hidden [string] LabelIncrementCount()
	{	
		$count = Format-Number ($this.IncrementCount)
		
		return $count
	}

	hidden [string] LabelMatchCount()
	{	
		$count = Format-Number ($this.MatchCount)
		
		return $count
	}

	hidden [string] LabelTotalIncrementCount()
	{	
		$count = Format-Number ($this.TotalIncrementCount)
		
		return $count
	}
	
	hidden [string] LabelIncrementPercent()
	{	
		$percentStr = Format-Number ([Math]::Round($this.MetricIncrementPercent(), ($this.IncrementPercentPrecision))) -Precision ($this.IncrementPercentPrecision)
		
		return $percentStr
	}

	hidden [string] LabelIncrementRate()
	{
		$rateStr = Format-Number ([Math]::Round($this.MetricIncrementRate(), ($this.IncrementRatePrecision))) -Precision ($this.IncrementRatePrecision)
		
		return $rateStr
	}

	hidden [string] LabelMatchRate()
	{
		$rateStr = Format-Number ([Math]::Round($this.MetricMatchRate(), ($this.MatchRatePrecision))) -Precision ($this.MatchRatePrecision)
		
		return $rateStr
	}
	
	hidden [string] LabelTimeElapsed()
	{
		$time = Format-Time ($this.MetricTimeElapsed())
		
		return $time
	}
	
	hidden [string] LabelTimeRemaining()
	{
		if($this.TotalIncrementCount -lt 0)
		{
			$time = "--"
		}
		else
		{
			$time = Format-Time ($this.MetricTimeRemaining())
		}
		
		return $time
	}
	
	hidden [bool] EvaluateCondition([string] $condition)
	{
		Write-DisplayDebug "EvaluateCondition"
		
		if($condition -eq $null -Or $condition.length -eq 0) { return $true }
		
		$t = $condition
		$t = $this.ReplaceConditions($t)
		$t = $t.Replace('True', '$true').Replace('False', '$false')
		$t = "if($t) { `$true } else { `$false }"
			
		$scriptBlock = [Scriptblock]::Create($t)
		$result = Invoke-Command -ScriptBlock $scriptBlock
		
		return $result
	}
	
	<#
		Conditions
		----------
		{is-d}			- Is Done
		{is-r}			- Is Running
		{is-tck}		- Is Total Count Known
		{is-fc}			- Is First Called
		{is-cms}		- Is Count Mode = Simple
		{is-cmi}		- Is Count Mode = Increment
		{is-cmm}		- Is Count Mode = Match
		{is-sii}		- Is Status Interval = Iteration
		{is-sit}		- Is Status Interval = Time

		Simple Tags
		-----------
		{ic} 			- Increment Count
		{tic}			- Total Increment Count
		{mc}			- Match Count 
		{iru}			- Increment Rate Units 
		{mru}			- Match Rate Units 
		{ip}			- Increment Percent 
		{te}			- Time Elapsed 
		{tr}			- Time Remaining
		{ir}			- Increment Rate
		{mr}			- Match Rate
		{c#}			- Custom Value (# is index of array)
		
		Complex Tags
		------------
		{mw:"s,p":{x}}	- Measure Word (s=singular, p=plural, {x} tag of count)
	#>
	
	hidden [string] ReplaceConditions([string] $source)
	{
		Write-DisplayDebug "ReplaceConditions"
		
		$src = $source
		
		$src = $src.Replace('{is-d}',   $this.Done)
		$src = $src.Replace('{is-r}',   $this.Running)
		$src = $src.Replace('{is-tck}', $this.TotalCountKnown)
		$src = $src.Replace('{is-fc}',  $this.FirstCalled)
		$src = $src.Replace('{is-cms}', $this.CountMode -eq [PTCountMode]::Simple)
		$src = $src.Replace('{is-cmi}', $this.CountMode -eq [PTCountMode]::Increment)
		$src = $src.Replace('{is-cmm}', $this.CountMode -eq [PTCountMode]::Match)
		$src = $src.Replace('{is-sii}', $this.StatusInterval -eq [PTStatusIntervalMode]::Iteration)
		$src = $src.Replace('{is-sit}', $this.StatusInterval -eq [PTStatusIntervalMode]::Time)
		
		return $src
	}
	
	hidden [string] ReplaceCustomTagValues([string] $source)
	{
		$src = $source
		
		$rx = '{c(.*?)}'
		([regex]$rx).Matches($src) | foreach-object {
			$idx = $_.Groups[1].Value
			$pattern = "`{c$idx`}"
			
			if($this.CustomValues.length -gt $idx)
			{
				$src = $src.Replace($pattern, $this.CustomValues[$idx])
			}
		}

		return $src
	}
	
	hidden [string] ReplaceBasicTagValues([string] $source)
	{
		$src = $source
		
		$src = $src.Replace('{ic}',  $this.IncrementCount)
		$src = $src.Replace('{tic}', $this.TotalIncrementCount)
		$src = $src.Replace('{mc}',  $this.MatchCount)
		$src = $src.Replace('{iru}', $this.IncrementRateUnits)
		$src = $src.Replace('{mru}', $this.MatchRateUnits)
		$src = $src.Replace('{ip}',  $this.MetricIncrementPercent())
		$src = $src.Replace('{te}',  $this.MetricTimeElapsed())
		$src = $src.Replace('{tr}',  $this.MetricTimeRemaining())
		$src = $src.Replace('{ir}',  $this.MetricIncrementRate())
		$src = $src.Replace('{mr}',  $this.MetricMatchRate())
		
		$src = $this.ReplaceCustomTagValues($src)

		return $src
	}

	hidden [string] ReplaceBasicTagLabels([string] $source)
	{
		$src = $source.Replace('{ic}',  $this.LabelIncrementCount())
		$src = 	  $src.Replace('{tic}', $this.LabelTotalIncrementCount())
		$src = 	  $src.Replace('{mc}',  $this.LabelMatchCount())
		$src = 	  $src.Replace('{iru}', $this.IncrementRateUnits)
		$src = 	  $src.Replace('{mru}', $this.MatchRateUnits)
		$src = 	  $src.Replace('{ip}',  $this.LabelIncrementPercent())
		$src = 	  $src.Replace('{te}',  $this.LabelTimeElapsed())
		$src = 	  $src.Replace('{tr}',  $this.LabelTimeRemaining())
		$src = 	  $src.Replace('{ir}',  $this.LabelIncrementRate())
		$src = 	  $src.Replace('{mr}',  $this.LabelMatchRate())

		$src = $this.ReplaceCustomTagValues($src)
		
		return $src
	}
	
	hidden [string] ReplaceTags([string] $source)
	{	
		Write-DisplayDebug "ReplaceTags"
		
		if($source -eq $null -Or $source.length -eq 0) { return '' }
		
		
		$src = $source
		
		$rx = '{mw:(.*?),(.*?):({.*?})}'
		([regex]$rx).Matches($src) | foreach-object {
			$singular = $_.Groups[1].Value
			$plural = $_.Groups[2].Value
			$tag = $_.Groups[3].Value
			
			$tagReplaced = $this.ReplaceBasicTagValues($tag)	
			$word = Get-MeasureWord -SingularWord $singular -PluralWord $plural -Count $tagReplaced
			$pattern = "{mw`:$singular,$plural`:$tag}"
			
			$src = $src.Replace($pattern, $word)
		}
		
		$src = $this.ReplaceBasicTagLabels($src)
		
		return $src
	}
	
	hidden [bool] IsTimeForStatus()
	{
		$result = $false
		
		$ic = $this.IncrementCount
		$tic = $this.TotalIncrementCount
		$si = $this.StatusInterval
			
		if($this.StatusIntervalMode -eq [PTStatusIntervalMode]::Iteration)
		{					
			$result = ($si -gt 0) -And ( ($ic -eq 1) -Or ($ic -eq $tic) -Or ($ic % $si -eq 0) )
		}
		
		if($this.StatusIntervalMode -eq [PTStatusIntervalMode]::Time)
		{		
			if ($this.IntervalTimer.ElapsedMilliseconds -ge $this.StatusInterval -Or ($ic -eq 1) -Or ($ic -eq $tic))
			{			
				$result = $true
				$this.IntervalTimer.Reset()
				$this.IntervalTimer.Start()
			}
		}
		
		return $result
	}
	
	hidden [string] FindMessage([MessageTemplate[]] $list)
	{
		Write-DisplayDebug "FindMessage"
		
		$result = ''
		
		foreach($mt in $list)
		{
			$cond = $mt.Condition
			
			if($cond -eq $null -Or $this.EvaluateCondition($cond))
			{
				$result = $this.ReplaceTags($mt.Message)
				break;
			}
		}
		
		return $result
	}
	
	hidden [void] DisplayStatusStart()
	{	
		Write-DisplayDebug "DisplayStatusStart"
		
		if($this.StartStatusIsStatic)
		{
			$m = $this.FindMessage($this.StartPrefix)
			$m += ' '
			$m += $this.FindMessage($this.StartMessage)
			$m += ' '
			$m += $this.FindMessage($this.StartSuffix)
			$m = $m.Trim().Replace('  ', ' ')
			
			if(-Not $this.LastStatusWasStatic) { Reset-HostLine 0 }
			Write-DisplayHost $m
			$this.LastStatusWasStatic = $true
		}
		else
		{
			$initial = -Not ($this.FirstCalled) -Or ($this.LastStatusWasStatic)
			$this.FirstCalled = $true
			
			$p = $this.FindMessage($this.StartPrefix)
			$m = $this.FindMessage($this.StartMessage)
			$s = $this.FindMessage($this.StartSuffix)
			
			Write-DisplayStatus -Prefix $p -Message $m -Suffix $s -Initial:$initial
			$this.LastStatusWasStatic = $false
		}	
	}
	
	hidden [void] DisplayStatusIncrement()
	{
		if($this.IncrementStatusIsStatic)
		{
			$m = $this.FindMessage($this.IncrementPrefix)
			$m += ' '
			$m += $this.FindMessage($this.IncrementMessage)
			$m += ' '
			$m += $this.FindMessage($this.IncrementSuffix)
			$m = $m.Trim().Replace('  ', ' ')
			
			if(-Not $this.LastStatusWasStatic) { Reset-HostLine 0 }
			Write-DisplayHost $m
			$this.LastStatusWasStatic = $true
		}
		else
		{
			$initial = -Not ($this.FirstCalled) -Or ($this.LastStatusWasStatic)
			$this.FirstCalled = $true
			
			$p = $this.FindMessage($this.IncrementPrefix)
			$m = $this.FindMessage($this.IncrementMessage)
			$s = $this.FindMessage($this.IncrementSuffix)

			Write-DisplayStatus -Prefix $p -Message $m -Suffix $s -Initial:$initial
			$this.LastStatusWasStatic = $false
		}	
	}

	hidden [void] DisplayStatusMatch()
	{
		if($this.MatchStatusIsStatic)
		{
			$m = $this.FindMessage($this.MatchPrefix)
			$m += ' '
			$m += $this.FindMessage($this.MatchMessage)
			$m += ' '
			$m += $this.FindMessage($this.MatchSuffix)
			$m = $m.Trim().Replace('  ', ' ')
			
			if(-Not $this.LastStatusWasStatic) { Reset-HostLine 0 }
			Write-DisplayHost $m
			$this.LastStatusWasStatic = $true
		}
		else
		{
			$initial = -Not ($this.FirstCalled) -Or ($this.LastStatusWasStatic)
			$this.FirstCalled = $true
			
			$p = $this.FindMessage($this.MatchPrefix)
			$m = $this.FindMessage($this.MatchMessage)
			$s = $this.FindMessage($this.MatchSuffix)
			
			Write-DisplayStatus -Prefix $p -Message $m -Suffix $s -Initial:$initial
			$this.LastStatusWasStatic = $false
		}	
	}
	
	hidden [void] DisplayStatusStop()
	{	
		if($this.StopStatusIsStatic)
		{
			$m = $this.FindMessage($this.StopPrefix)
			$m += ' '
			$m += $this.FindMessage($this.StopMessage)
			$m += ' '
			$m += $this.FindMessage($this.StopSuffix)
			$m = $m.Trim().Replace('  ', ' ')
			
			if(-Not $this.LastStatusWasStatic) { Reset-HostLine 0 }
			Write-DisplayHost $m
			$this.LastStatusWasStatic = $true
		}
		else
		{
			$initial = -Not ($this.FirstCalled) -Or ($this.LastStatusWasStatic)
			$this.FirstCalled = $true
			
			$p = $this.FindMessage($this.StopPrefix)
			$m = $this.FindMessage($this.StopMessage)
			$s = $this.FindMessage($this.StopSuffix)
			
			Write-DisplayStatus -Prefix $p -Message $m -Suffix $s -Initial:$initial
			$this.LastStatusWasStatic = $false
		}	
	}
}