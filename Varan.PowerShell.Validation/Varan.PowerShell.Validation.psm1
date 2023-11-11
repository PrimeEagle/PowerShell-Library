class ValidatePath : System.Management.Automation.ValidateArgumentsAttribute
{
	[bool]		$DirectoryOnly = $false
	[bool]		$FileOnly = $false
	[bool]		$MustExist = $false
	[string[]]	$AllowedExtensions 	= @()
	[bool]		$AllowNull = $false
	[bool]		$AllowEmptyString = $false
	[bool]		$AllowNullOrEmptyString = $false
	
	ValidatePath()
	{
	}
	
    [void] Validate([object]$path, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
		$items = @()
		if($path -Is [Array])
		{
			$items = $path
		}
		else
		{
			$items += $path
		}
		
		foreach($item in $items)
		{
			$hasValue = ($item -ne $null -And $item.Length -gt 0)
			
			if($item.Length -eq 1) { $item += ':\' }
			
			if($this.DirectoryOnly -And $this.FileOnly)
			{
				Throw [System.ArgumentException]::new("The validation parameters 'DirectoryOnly' and 'FileOnly' cannot both be specified together.")
			}
			
			if($item -eq $null -And (-Not ($this.AllowNull -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The path is null, but the validation parameters 'AllowNull' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($item -eq '' -And (-Not ($this.AllowEmptyString -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The path is an empty string, but the validation parameters 'AllowEmptyString' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($this.MustExist -And $hasValue)
			{
				$exists = Test-Path -Path $item
				
				if($exists)
				{
					if($this.DirectoryOnly -And -Not ((Get-Item $item) -Is [System.IO.DirectoryInfo]))
					{
						Throw [System.ArgumentException]::new("The validation parameter 'DirectoryOnly' is specified, but the path '$item' is not a directory.")
					}
					
					if($this.FileOnly -And -Not ((Get-Item $item) -Is [System.IO.FileInfo]))
					{
						Throw [System.ArgumentException]::new("The validation parameter 'FileOnly' is specified, but the path '$item' is not a file.")
					}
				}
				else
				{
					Throw [System.IO.FileNotFoundException]::new("The validation parameter 'MustExist' is specified, but the path '$item' does not exist.")
				}
			}
			
			if($this.AllowedExtensions.Length -gt 0)
			{
				$ext = (Get-Item $item).Extension
				$valid = $false
				
				foreach($ae in $this.AllowedExtensions)
				{
					$e = $ae.ToLower().Replace('.', '')
					if($e -eq $ext.ToLower())
					{
						$valid = $true
						break
					}
				}
				
				if(-Not $valid)
				{
					Throw [System.ArgumentException]::new("The validation parameter 'AllowedExtensions' is specified, but the extension '$ext' is not specified.")
				}
			}
			
			try
			{	
				if($hasValue)
				{
					if(Test-Path $item)
					{
						if ((Get-Item $item) -Is [System.IO.DirectoryInfo])
						{
							[System.IO.DirectoryInfo]$item = $item
						}
						
						if ((Get-Item $item) -Is [System.IO.FileInfo])
						{
							[System.IO.FileInfo]$item = $item
						}
					}
				}
			}
			catch
			{
				Throw [System.ArgumentException]::new("The path '$item' is not valid or may contain illegal characters.")
			}
		}
	}
}

class ValidateVariable : System.Management.Automation.ValidateArgumentsAttribute
{
	[bool]		$AllowNull = $false
	[bool]		$AllowEmptyString = $false
	[bool]		$AllowNullOrEmptyString = $false
	
	ValidateVariable()
	{
	}
	
    [void] Validate([object]$name, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
		$items = @()
		if($name -Is [Array])
		{
			$items = $name
		}
		else
		{
			$items += $name
		}
		
		foreach($item in $items)
		{
			$hasValue = ($item -ne $null -And $item.Length -gt 0)
			
			if($item -eq $null -And (-Not ($this.AllowNull -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The name is null, but the validation parameters 'AllowNull' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($item -eq '' -And (-Not ($this.AllowEmptyString -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The name is an empty string, but the validation parameters 'AllowEmptyString' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($hasValue -And -Not ($item -Match '^[a-zA-Z_$][a-zA-Z-_$0-9]*$'))
			{
				Throw [System.ArgumentException]::new("The name '$item' is not a valid variable name.")
			}
		}
	}
}

class ValidateDriveLetter : System.Management.Automation.ValidateArgumentsAttribute
{
	[bool]		$MustExist = $false
	[bool]		$AllowNull = $false
	[bool]		$AllowEmptyString = $false
	[bool]		$AllowNullOrEmptyString = $false
	
	ValidateDriveLetter()
	{
	}
	
    [void] Validate([object]$drive, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
		$items = @()
		if($drive -Is [Array])
		{
			$items = $drive
		}
		else
		{
			$items += $drive
		}
		
		foreach($item in $items)
		{
			$hasValue = ($item -ne $null -And $item.Length -gt 0)
			
			if($item -eq $null -And (-Not ($this.AllowNull -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The drive letter is null, but the validation parameters 'AllowNull' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($item -eq '' -And (-Not ($this.AllowEmptyString -Or $this.AllowNullOrEmptyString))) 
			{
				Throw [System.ArgumentNullException]::new("The drive letter is an empty string, but the validation parameters 'AllowEmptyString' or 'AllowNullOrEmptyString' are not specified.")
			}
			
			if($hasValue -And -Not ($drive -Match '^[a-zA-Z]{1}:?\\?$'))
			{
				Throw [System.ArgumentException]::new("The drive letter '$item' is not in a valid format.")
			}
			
			if($drive.Length -eq 1)
			{
				$testDrive = $item + ":\"  
			}
			else
			{
				$testDrive = $item
			}
			
			if($this.MustExist -And $hasValue)
			{
				$exists = Test-Path -Path $testDrive
				
				if(-Not $exists)
				{
					Throw [System.IO.FileNotFoundException]::new("The validation parameter 'MustExist' is specified, but the drive letter '$item' does not exist.")
				}
			}
		}
	}
}