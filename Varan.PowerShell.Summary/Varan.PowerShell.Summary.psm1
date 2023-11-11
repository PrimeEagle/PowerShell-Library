enum FetchType
{
	First
	Last
	Next
	Previous
}

class SummaryItem
{
	[string] 	$Name = ''
	[string] 	$Description = ''
	[string] 	$Action = ''
	[string] 	$Reason = ''
	[string] 	$Category = ''
	[string] 	$Type = ''
	[string]	$Source = ''
	[string]	$Destination = ''
}

class SummaryDefinition
{
	[string] 		$Name
	[string] 		$Header
	[int]	 		$Width
}

class SummaryPageSetting
{
	[int]			$CurrentPage
	[int]			$TotalPages
	[int]			$RowStartIdx
	[int]			$RowEndIdx
	[int]			$Gap
	[bool]			$Paging
	[int]			$PageSize
}

class Summary
{
			[SummaryItem[]] 		$WorkList
			[SummaryItem[]] 		$ErrorList
			[SummaryItem[]] 		$WarningList
			[SummaryDefinition[]]	$DefinitionsWork
			[SummaryDefinition[]]	$DefinitionsError
			[SummaryDefinition[]]	$DefinitionsWarning
	hidden 	[int[]] 				$columnWidthsWork
	hidden 	[int[]] 				$columnWidthsError
	hidden 	[int[]] 				$columnWidthsWarning
	hidden	[bool]					$Silent
			[SummarySource[]]		$Sources
			[SummaryOutput[]]		$Outputs
			[SummaryPageSetting]	$PageSettingWork
			[SummaryPageSetting]	$PageSettingError
			[SummaryPageSetting]	$PageSettingWarning
			[string]				$ExportDelimiter = "`t"
			[DisplayStyle]			$HeaderStyle = [DisplayStyle]::SummaryHeader
			[DisplayStyle]			$NormalStyle = [DisplayStyle]::SummaryNormal
			[DisplayStyle]			$FooterStyle = [DisplayStyle]::SummaryFooter
			[DisplayStyle]			$PromptStyle = [DisplayStyle]::SummaryPrompt
			[DisplayStyle]			$StatusStyle = [DisplayStyle]::SummaryStatus
			[string]				$DefaultExportFile = 'summaryexport.txt'
			[string]				$ExportFile


	Summary([SummarySource[]] $summarySources, [SummaryOutput[]] $summaryOutputs, [bool] $silentFlag)
	{
		$this.Summary($summarySources, $summaryOutputs, $silentFlag, $null)
	}
	
	Summary([SummarySource[]] $summarySources, [SummaryOutput[]] $summaryOutputs, [bool] $silentFlag, [string] $exportFilename)
	{
		$this.PageSettingWork = [SummaryPageSetting]::new()
		$this.PageSettingError = [SummaryPageSetting]::new()
		$this.PageSettingWarning = [SummaryPageSetting]::new()
		
		$this.PageSettingWork.Gap = 2
		$this.PageSettingWork.Paging = $false
		$this.PageSettingWork.PageSize = 28
		
		$this.PageSettingError.Gap = 2
		$this.PageSettingError.Paging = $false
		$this.PageSettingError.PageSize = 28
		
		$this.PageSettingWarning.Gap = 2
		$this.PageSettingWarning.Paging = $false
		$this.PageSettingWarning.PageSize = 28
		
		$this.Sources = $summarySources
		$this.Outputs = $summaryOutputs
		$this.ExportFile = $exportFilename
		$this.Silent = $silentFlag
		
		$this.Clear([SummarySource]::Work)
		$this.InitPaging([SummarySource]::Work)
		
		$this.Clear([SummarySource]::Error)
		$this.InitPaging([SummarySource]::Error)
		
		$this.Clear([SummarySource]::Warning)
		$this.InitPaging([SummarySource]::Warning)
	}
	
	[void] Clear([SummarySource] $source)
	{
		$sourceList = $this.GetList($source)
		$sourceList = @()
		
		switch($source)
		{
			"Work"
				{
					$this.columnWidthsWork = @()
					break
				}
			"Error"
				{
					$this.columnWidthsError = @()
					break
				}
			"Warning"
				{
					$this.columnWidthsWarning = @()
					break
				}
		}
	}
	
	[void] Clear()
	{
		$this.Clear([SummarySource]::Work)
	}
	
	hidden [SummaryItem[]] GetList([SummarySource] $source)
	{	
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.WorkList
					break
				}
			"Error"
				{
					$result = $this.ErrorList
					break
				}
			"Warning"
				{
					$result = $this.WarningList
					break
				}
		}
		
		return $result
	}
	
	hidden [SummaryDefinition[]] GetDefinitions([SummarySource] $source)
	{		
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.DefinitionsWork
					break
				}
			"Error"
				{
					$result = $this.DefinitionsError
					break
				}
			"Warning"
				{
					$result = $this.DefinitionsWarning
					break
				}
		}
		
		return $result
	}
	
	hidden [int[]] GetColumnWidths([SummarySource] $source)
	{	
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.columnWidthsWork
					break
				}
			"Error"
				{
					$result = $this.columnWidthsError
					break
				}
			"Warning"
				{
					$result = $this.columnWidthsWarning
					break
				}
		}
		
		return $result
	}
	
	hidden [string] GetExportFile([SummarySource] $source)
	{		
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.ExportFile.Replace('.', '-work.')
					break
				}
			"Error"
				{
					$result = $this.ExportFile.Replace('.', '-error.')
					break
				}
			"Warning"
				{
					$result = $this.ExportFile.Replace('.', '-warning.')
					break
				}
		}
		
		return $result
	}
	
	hidden [string] GetDefaultExportFile([SummarySource] $source)
	{		
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.DefaultExportFile.Replace('.', '-work.')
					break
				}
			"Error"
				{
					$result = $this.DefaultExportFile.Replace('.', '-error.')
					break
				}
			"Warning"
				{
					$result = $this.DefaultExportFile.Replace('.', '-warning.')
					break
				}
		}
		
		return $result
	}
	
	hidden [SummaryPageSetting] GetPageSetting([SummarySource] $source)
	{		
        $result = $null
		switch($source)
		{
			"Work"
				{
					$result = $this.PageSettingWork
					break
				}
			"Error"
				{
					$result = $this.PageSettingError
					break
				}
			"Warning"
				{
					$result = $this.PageSettingWarning
					break
				}
		}
		
		return $result
	}
	
	[void] Add([SummarySource] $source, [SummaryItem] $item)
	{
		switch($source)
		{
			"Work"
				{
					$this.WorkList += $item
					break
				}
			"Error"
				{
					$this.ErrorList += $item
					break
				}
			"Warning"
				{
					$this.WarningList += $item
					break
				}
		}
	}
	
	[void] Add([SummaryItem] $item)
	{
		$this.Add([SummarySource]::Work, $item)
	}
	
	hidden [void] CalculateWidths([SummarySource] $source)
	{
		$auto = $false

        $sourceList = $this.GetList($source)
		$properties = $this.GetDefinitions($source)
		$columnWidths = $this.GetColumnWidths($source)
		$pageSetting = $this.GetPageSetting($source)
		
		foreach($p in $properties)						# if any widths are zero, then auto calculate all widths
		{
			if($p.Width -eq 0)
			{
				$auto = $true
				break
			}
		}
		
		if($auto)										#auto calculate widths
		{
			[int] $gaps = ($properties.Count + 1)*$pageSetting.Gap
			
			$maxWidth = 115	- $gaps
			[int]$w = $maxWidth/($properties.Count)
			$slack = 0
			
			foreach($p in $properties)
			{
				$names = $sourceList."$($p.Name)"
				if($p.Name.Length -gt $p.Header.Length)
				{
					$names += $p.Name
				}
				else
				{
					$names += $p.Header
				}
				$maxLen = ($names | Measure-Object -Property Length -Maximum).Maximum

				if($maxLen -lt $w)						# if the longest value for this column is less than the calculated width,
				{										# use the longest value length instead
					$len = $maxLen
					$slack += ($w - $maxLen)
				}
				else									# if the longest value for this column is greater than or equal to calculated width,
				{										# check if any slack is available
					if($slack -gt 0)					# if slack is available, check if we can use all of the slack or not
					{
						if($w + $slack -le $maxLen)		# if we can use all of the slack, use the calculated width plus the slack
						{
							$len = $w + $slack
							$slack = 0
						}
						else							# if we don't need all of the slack, use enough of it to get use to the longest
						{								# value for this column
							$len = $maxLen
							$slack = $maxLen - $w
						}
					}
					else								# if no slack is available, use the calculated width
					{
						$len = $w
					}
				}
				
				$columnWidths += $len
			}
		}
		else
		{
			foreach($p in $properties)
			{
				$columnWidths += $p.Width
			}
		}
	}
	
	hidden [void] WriteHeader([SummarySource] $source)
	{
		$properties = $this.GetDefinitions($source)
		$columnWidths = $this.GetColumnWidths($source)
		$pageSetting = $this.GetPageSetting($source)
		
		$i = 0
		foreach($p in $properties)
		{
       		$cmd = @{}

			$width = $columnWidths[$i]
			if($p.Header.Length -gt 0)
			{
				$name = $p.Header
			}
			else
			{
				$name = $p.Name
			}

			if($p -eq $properties[-1])
			{
				$cmd.NoNewLine = $false
			}
			else
			{
				$cmd.NoNewLine = $true
			}
			$cmd.Style = $this.HeaderStyle
			
			Write-DisplayHost (' '*$pageSetting.Gap) -NoNewLine
			Write-DisplayHost $name.PadRight($width, ' ') @cmd
			
			$i++
		}
		
		$i = 0
		foreach($p in $properties)
		{
		    $cmd = @{}
		
        	$width = $columnWidths[$i]
		
			if($p -eq $properties[-1])
			{
				$cmd.NoNewLine = $false
			}
			else
			{
				$cmd.NoNewLine = $true
			}
			$cmd.Style = $this.HeaderStyle
        	
			Write-DisplayHost (' '*$pageSetting.Gap) -NoNewLine
			Write-DisplayHost ('_' * $width) @cmd
			
			$i++
		}
	}
	
	hidden [void] InitPaging([SummarySource] $source)
	{
		$sourceList = $this.GetList($source)
		$page = $this.GetPageSetting($source)
		
		$page.CurrentPage = 1
		$page.TotalPages = [Math]::Ceiling($sourceList.Count / $page.PageSize)

		if($page.Paging)
		{
			$page.RowEndIdx = $page.PageSize - 1
		}
		else
		{
			$page.RowEndIdx = $sourceList.Count - 1
		}
	}
	
	hidden [SummaryItem[]] FetchRows([FetchType] $type, [SummarySource] $source)
	{
		$result = @()
		$pageSetting = $this.GetPageSetting($source)
		
        switch($type)
		{
			First
                {
				    $result = $this.FetchRows(1, $source)
				    break
                }
			Last
				{
                    $result = $this.FetchRows($pageSetting.TotalPages, $source)
				    break
                }
			Next
				{
                    if($pageSetting.CurrentPage -lt $pageSetting.TotalPages)
				    {	
				    	$page = $pageSetting.CurrentPage + 1
				    }
				    else
				    {
				    	$page = $pageSetting.TotalPages
				    }
				    
				    $result = $this.FetchRows($page, $source)
				    break
                }
			Previous
				{
                    if($pageSetting.CurrentPage -gt 1)
				    {	
				    	$page = $pageSetting.CurrentPage - 1
				    }
				    else
				    {
				    	$page = 1
				    }
				    
				    $result = $this.FetchRows($page, $source)

				    break
                }
		}
		
		return $result
	}
	
	hidden [SummaryItem[]] FetchRows([int] $page, [SummarySource] $source)
	{
		$sourceList = $this.GetList($source)
		$pageSetting = $this.GetPageSetting($source)
		
		if($this.Paging)
		{
			$startRow = $pageSetting.PageSize * ($page - 1)
			$endRow = $pageSetting.PageSize  * $page
			
			$pageSetting.CurrentPage = $page
			$pageSetting.RowStartIdx = $startRow
			$pageSetting.RowEndIdx = $endRow
			
			$result = $sourceList[$startRow..$endRow]
		}
		else
		{
			$result = $sourceList
		}
		
        return $result
	}
	
	hidden [void] ShowPrompt([SummarySource] $source)
	{
		$pageSetting = $this.GetPageSetting($source)
		
		$gapStr = ' '*$pageSetting.Gap
		Write-DisplayHost "$($gapStr)page $($this.currentPage) of $($this.totalPages) - (p)revious, (n)ext, (f)irst, (l)ast, (e)xport, (q)uit" -Style ($this.PromptStyle)
	}
	
	hidden [void] PagePrompt([SummarySource] $source)
	{
		$pageSetting = $this.GetPageSetting($source)
		
		if($pageSetting.Paging -And $pageSetting.TotalPages -gt 1)
		{
            $this.ShowPrompt()
			$key = [Console]::ReadKey('NoEcho')

			$quit = $false
			
			while(-Not $quit)
			{
				switch($key.Key.ToString().ToUpper())
				{
					'N'
						{
							$rows = $this.FetchRows([FetchType]::Next)
							$this.WriteRows($rows)
						}
					'P'
						{
							$rows = $this.FetchRows([FetchType]::Previous)
							$this.WriteRows($rows)
						}
					'F'
						{
							$rows = $this.FetchRows([FetchType]::First)
							$this.WriteRows($rows)
						}
					'L'
						{
							$rows = $this.FetchRows([FetchType]::Last)
							$this.WriteRows($rows)
						}
					'E'
						{
							$gapStr = ' '*$pageSetting.Gap
							Write-DisplayHost "$($gapStr)Enter export filename, or hit enter to use default ('$($this.DefaultExportFile)'): " -Style ($this.PromptStyle) -NoNewLine
							$fn = Read-Host
							
							if($fn.Length -eq 0)
							{
								$this.Export()
							}
							else
							{
								$this.Export($fn)
							}
							
							$quit = $true
						}
					'Q'
						{
							$quit = $true
						}
				}
				
				if(-Not $quit)
				{
					$this.ShowPrompt()
					$key = [Console]::ReadKey('NoEcho')
				}
			}
			
			$this.WriteFooter()
		}
		else
		{
			$this.WriteFooter()
		}
	}
	
	hidden [void] WriteRows([SummarySource] $source, [SummaryItem[]] $rows)
	{
		$properties = $this.GetDefinitions($source)
		$columnWidths = $this.GetColumnWidths($source)
		$pageSetting = $this.GetPageSetting($source)
		
		$r = 0
		foreach($l in $rows)
		{
			$c = 0
			foreach($def in $properties)
			{
				$val = $l."$($def.Name)"
				$w = $columnWidths[$c]

				if($val.Length -lt $w)
				{
					$val = $val.PadRight($w, ' ')
				}
				
				if($val.Length -gt $w)
				{
					$val = $val.Substring(0, $w)
				}
				
				$cmd = @{}
				
				if($def -eq $properties[-1])
				{
					$cmd.NoNewLine = $false
				}
				else
				{
					$cmd.NoNewLine = $true
				}
				$cmd.Style = $this.NormalStyle
				
				Write-DisplayHost(' '*$pageSetting.Gap) -NoNewLine
				Write-DisplayHost $val @cmd
				
				$c++
			}
						
			$r++
		}
	}
	
	hidden [void] WriteFooter()
	{
		Write-DisplayHost "End of summary" -Style ($this.FooterStyle)
	}

	[void] Show([SummarySource] $source, [string] $title)
	{
		[SummaryDefinition[]]$tempList = @()
		$def = [SummaryDefinition]::new()
		$def.Name = $title
		$tempList += $def

		$this.Show($source, $tempList)
	}
	
	[void] Show([SummarySource] $source, [string[]] $names)
	{
		[SummaryDefinition[]]$tempList = @()
		
		foreach($n in $names)
		{
			$def = [SummaryDefinition]::new()
			$def.Name = $n
			
			$tempList += $def
		}
		
		$this.Show($source, $tempList)
	}
	
	[void] Show([SummaryDefinition[]] $definitions)
	{
		$this.Show([SummarySource]::Work, $definitions)
	}
	
	[void] Show([SummarySource] $source, [SummaryDefinition[]] $definitions)
	{	
		if($source -eq [SummarySource]::Work) { $this.DefinitionsWork = $definitions }
		if($source -eq [SummarySource]::Error) { $this.DefinitionsError = $definitions }
		if($source -eq [SummarySource]::Warning) { $this.DefinitionsWarning = $definitions }
		
		if(-Not $this.Sources -Or ($this.Sources.Count -eq 0)) { $this.Sources = @([SummarySource]::Work) }
		if(-Not $this.Outputs -Or ($this.Outputs.Count -eq 0)) { $this.Outputs = @([SummaryOutput]::Console) }
			
		foreach($o in $this.Outputs)
		{
			switch($o)
			{
				([SummaryOutput]::Console)
				{
					if(-Not $this.Silent)
					{
						$this.ShowConsole($source)
					}
					break
				}
				([SummaryOutput]::Grid)
				{
					if(-Not $this.Silent)
					{
						$this.ShowGrid($source)
					}
					break
				}	
				([SummaryOutput]::File)
				{
					if(-Not($this.ExportFile) -Or ($this.ExportFile.Trim().Length -eq 0))
					{
						$this.ExportFile = $this.GetDefaultExportFile($source)
					}
					$this.Export($source)
					break
				}
				default
				{
					break
				}
			}
		}
	}
	
	
	hidden [void] ShowConsole([SummarySource] $source)
	{
		$this.InitPaging($source)

		$rows = $this.FetchRows([FetchType]::First, $source)
		
		$this.CalculateWidths($source)
		$this.WriteHeader($source)
		$this.WriteRows($rows)
		$this.PagePrompt($source)
	}

	[long] Count([SummarySource] $source)
	{
		if($source -eq [SummarySource]::Work) { return $this.WorkList.Count }
		if($source -eq [SummarySource]::Error) { return $this.ErrorList.Count }
		if($source -eq [SummarySource]::Warning) { return $this.WarningList.Count }

        return 0
	}

	
	[long] Count()
	{
		return $this.Count([SummarySource]::Work)
	}
		
	[void] Export([SummarySource] $source)
	{	
		$fileToUse = $this.GetExportFile($source)
		$sourceList = $this.GetList($source)
		$properties = $this.GetDefinitions($source)
		
		if($sourceList.Count -gt 0)
		{
			Write-DisplayHost "Exporting to '$fileToUse'" -Style ($this.StatusStyle)
					
			$i = 0
			$line = ''
			foreach($p in $properties)
			{
				if($p.Header.Length -gt 0)
				{
					$name = $p.Header
				}
				else
				{
					$name = $p.Name
				}
				
				if($p -eq $properties[-1])
				{
					$newLine = ''
				}
				else
				{
					$newLine = $this.ExportDelimiter
				}
				
				$line += "$name$newLine"
				
				$i++
			}
			$line | Add-Content -Path $fileToUse
			
			
			$rows = $sourceList
			
			$r = 0
			foreach($l in $rows)
			{
				$c = 0
				$line = ''
				foreach($def in $properties)
				{
					$val = $l."$($def.Name)"

					
					if($def -eq $properties[-1])
					{
						$newLine = ''
					}
					else
					{
						$newLine = $this.ExportDelimiter
					}
					
					$line += "$val$newLine"
					
					$c++
				}
				
				$line | Add-Content -Path $fileToUse
							
				$r++
			}
			
			Write-DisplayHost "Export done." -Style ($this.StatusStyle)
		}
	}
	
	[void] ShowGrid([SummarySource] $source)
	{		
		$sourceList = $this.GetList($source)
		$properties = $this.GetDefinitions($source)
		
		if($sourceList.Count -gt 0)
		{			
			$headerDefinitions = @()
			foreach($p in $properties)
			{			
				$hd = @{}
				
				if($p.Header.Length -gt 0)
				{
					$hd.Name = $p.Header
				}
				else
				{
					$hd.Name = $p.Name
				}
				
				$hd.Expression = $p.Name					
									
				$headerDefinitions += $hd
			}

			$sourceList | Select-Object -Property $headerDefinitions | Out-GridView
		}
	}
}

Export-ModuleMember -Function *