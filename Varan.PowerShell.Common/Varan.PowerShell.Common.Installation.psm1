using module Varan.PowerShell.Validation

# ---------- Symbolic Links ----------
function Add-SymbolicLink
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param ( [Parameter(Mandatory = $true)]   [string]$LinkPath,
            [Parameter(Mandatory = $true)]   [string]$TargetPath,
            [Parameter(Mandatory = $true)]   [DiskItem]$Type
          )

    Process
    {   
		Write-Host "Adding symbolic link '$LinkPath'..." -NoNewLine
        if(-Not (Test-Path -Path $LinkPath))
        {
            if($Type -eq [DiskItem]::Directory)
            {
                try 
				{
                    cmd /c mklink /d """$LinkPath""" """$TargetPath"""
					Write-Host "success."
                } 
				catch 
				{
                    Write-Error "failed."
                }
            }
            
            if($Type -eq [DiskItem]::File)
            {
                try 
				{
                    cmd /c mklink """$LinkPath""" """$TargetPath"""
					Write-Host "success."
                } 
				catch 
				{
                    Write-Error "failed."
                }
            }
        }
        else {
            Write-Host "already exists."
        }
    }
}

function Remove-SymbolicLink
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param ( [Parameter(Mandatory = $true)]   [string]$LinkPath
          )

    Process
    {   
		Write-Host "Removing symbolic link '$LinkPath'..." -NoNewLine
		
        if(Test-Path -Path $LinkPath)
        {
            try 
			{
                (Get-Item $LinkPath).Delete()
				Write-Host "success."
            } 
			catch 
			{
                Write-Error "failed."
            }
        }
        else {
            Write-Host "does not exist."
        }
    }
}

function Test-SymbolicLink
{
    [CmdletBinding(SupportsShouldProcess)]
    param ( [Parameter(Mandatory = $true)]   [string]$LinkPath
          )

    Process
    {   
        $item = Get-Item $LinkPath -Force -ErrorAction SilentlyContinue
        
        return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
    }
}

# ---------- Profile Lines ----------
function Add-LineToProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)]   [string]$Text
          )

    Process
    {   
		Write-Host "Adding line to profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $exists = Confirm-FileHasLine -Path $profile -Equals $Text -IgnoreWhitespace
            
            if(-Not $exists)
            {
                Add-IntoFileSection -Path $profile -Text $Text -Section $Text -IgnoreWhitespace -DefaultToEnd
				Write-Host "success."
            }
            else {
                Write-Host "already exists."
            }
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Remove-LineFromProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)]   [string]$Text
          )

    Process
    {   
		Write-Host "Removing line from profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            Remove-FromFile -Path $profile -Text $Text -IgnoreWhitespace
			Write-Host "success."
        }
        else {
            Write-Error "profile not found."
        }
    }
}

# ---------- Aliases in profile ----------
function Add-AliasToProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Script,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Alias
          )

    Process
    {   
		Write-Host "Adding alias '$Alias' to profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $aliasStr = "if(-Not (Get-Alias -Name $Alias -ErrorAction SilentlyContinue)) { New-Alias -Name `"$Alias`" -Value $Script }"
            $exists = Confirm-FileHasLine -Path $profile -Equals $aliasStr -IgnoreWhitespace

            if(-Not $exists)
            {
                Add-IntoFileSection -Path $profile -Text $aliasStr -Section "if(-Not (Get-Alias -Name $Alias" -IgnoreWhitespace -DefaultToEnd
				Write-Host "success."
            }
            else {
                Write-Host "already exists."
            }
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Remove-AliasFromProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Script,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Alias
          )

    Process
    {   
		Write-Host "Removing alias '$Alias' from profile..." -NoNewLine
	
        if(Test-Path -Path $profile)
        {
            $aliasStr = "if(-Not (Get-Alias -Name $Alias -ErrorAction SilentlyContinue)) { New-Alias -Name `"$Alias`" -Value $Script }"
			$exists = Confirm-FileHasLine -Path $profile -Equals $aliasStr -IgnoreWhitespace
			
			if($exists)
			{
				Remove-FromFile -Path $profile -Text $aliasStr -IgnoreWhitespace
				if(Get-Alias -Name $Alias -ErrorAction SilentlyContinue) { Remove-Alias -Name $Alias }
				Write-Host "success."
			}
			else
			{
				Write-Host "not found."
			}
        }
        else {
            Write-Error "profile not found."
        }
    }
}

# ---------- Profile path variables ----------
function Add-Path
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Line,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Path
          )
	
	Process
	{
		$namePortion = $Line.Split("=")[0].Replace("+", "").Trim();
		$pathPortion = $Line.Split("=")[1].Replace("`"", "").Replace("'", "").Replace(";;", ";").Trim();
		
		$paths = $pathPortion.Split(";")
		$newPath = $Path
		if(-Not $Path.EndsWith('\'))
		{
			$newPath += '\'
		}
		$paths += $newPath
		$trimmedAndFilteredArray = $paths | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
		
		$combinedPaths = ($trimmedAndFilteredArray -Join ';')
		$result = "$namePortion += `";$combinedPaths`""

		return $result
	}
}

function Remove-Path
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Line,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Path
          )
	
	Process
	{
		$result = $Line.Replace(";" + $Path, "").Replace($Path + ";", "").Replace($Path, "").Replace(";;", ";").Trim()
		
		return $result
	}
}

function Add-PathToProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$PathVariable,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Path
          )

    Process
    {   
        Write-Host "Adding path '$Path' to profile..." -NoNewLine
        
        if(Test-Path -Path $profile)
        {
			$Name = "`$Env:$PathVariable"
            $variableExists = Confirm-FileHasLine -Path $profile -StartsWith $Name -IgnoreWhitespace
            $pathExists = Confirm-FileHasLine -Path $profile -StartsWith $Name -Contains $Path -IgnoreWhitespace
            
            if(-Not $variableExists)
            {
                $pathLine = "$Name += `";$Path`""
                Add-IntoFileSection -Path $profile -Text $pathLine -Section $Name -IgnoreWhitespace -DefaultToEnd
                Write-Host "success."
            }
            elseif(-Not $pathExists)
            {
                $profileContent = Get-Content -Path $profile
                $updatedContent = @()
                foreach ($line in $profileContent) {
                    if ($line -like "$Name*") {
						$updatedLine = (Add-Path -Line $line -Path $Path)
                        $updatedContent += $updatedLine
                    } else {
                        $updatedContent += $line
                    }
                }
                $updatedContent | Set-Content -Path $profile
                Write-Host "success."
            }
            else {
                Write-Host "already exists."
            }
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Remove-PathFromProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$PathVariable,
            [Parameter(Position = 1, Mandatory = $true)] [string]$Path
          )

    Process
    {   
		Write-Host "Removing path '$Path' from profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
			$Name = "`$Env:$PathVariable"
			$variableExists = Confirm-FileHasLine -Path $profile -StartsWith $Name -IgnoreWhitespace
            $pathExists = Confirm-FileHasLine -Path $profile -StartsWith $Name -Contains $Path -IgnoreWhitespace
			
			if(-Not $variableExists)
			{
				Write-Host "variable '$Name' not found."
			}
			elseif(-Not $pathExists)
			{
				Write-Host "not found."
			}
			else
			{
				$profileContent = Get-Content -Path $profile
                $updatedContent = @()
                foreach ($line in $profileContent) {
                    if ($line -like "$Name*") {
						$updatedLine = Remove-Path -Line $line -Path $Path
                        $updatedContent += $updatedLine
                    } else {
                        $updatedContent += $line
                    }
                }
                $updatedContent | Set-Content -Path $profile
                Write-Host "success."
			}
        }
        else {
            Write-Error "profile not found."
        }
    }
}

# ---------- Module using statements to profile ----------
function Add-UsingModuleToProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Path
          )

    Process
    {   
		Write-Host "Adding module using for '$(Split-Path $Path -Leaf)' to profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $module = "using module `"$Path`""
            $exists = Confirm-FileHasLine -Path $profile -Equals $module -IgnoreWhitespace
            
            if(-Not $exists)
            {
                Add-IntoFileSection -Path $profile -Text $module -Section $module -IgnoreWhitespace -DefaultToStart
				Write-Host "success."
            }
            else {
                Write-Host "already exists."
            }
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Remove-UsingModuleFromProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Path
          )

    Process
    {  
		Write-Host "Removing module using for '$(Split-Path $Path -Leaf)' from profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $module = "using module `"$Path`""
			$exists = Confirm-FileHasLine -Path $profile -Equals $module -IgnoreWhitespace
			
			if($exists)
			{
				Remove-FromFile -Path $profile -Text $module -IgnoreWhitespace
				Write-Host "success."
			}
			else
			{
				Write-Host "not found."
			}
        }
        else {
            Write-Error "profile not found."
        }
    }
}

# ---------- Module import to current session ----------
function Add-ImportModuleToProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Module
          )

    Process
    {   
		Write-Host "Adding module import for '$Module' to profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $module = "Import-Module -Name $Module"
            $exists = Confirm-FileHasLine -Path $profile -Equals $module -IgnoreWhitespace
            
            if(-Not $exists)
            {
                Add-IntoFileSection -Path $profile -Text $module -Section $module -IgnoreWhitespace -DefaultToStart
				Write-Host "success."
            }
            else {
                Write-Host "already exists."
            }
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Remove-ImportModuleFromProfile
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param ( [Parameter(Position = 0, Mandatory = $true)] [string]$Module
          )

    Process
    {  
		Write-Host "Removing module using for '$Module' from profile..." -NoNewLine
		
        if(Test-Path -Path $profile)
        {
            $module = "Import-Module $Module"
			$exists = Confirm-FileHasLine -Path $profile -Equals $module -IgnoreWhitespace
			
			if($exists)
			{
				Remove-FromFile -Path $profile -Text $module -IgnoreWhitespace
				Write-Host "success."
			}
			else
			{
				Write-Host "not found."
			}
        }
        else {
            Write-Error "profile not found."
        }
    }
}

function Import-LocalModule
{
    [CmdletBinding()]
    param ( [Parameter(Mandatory = $true)] [string]$ModuleName )

    Process
    {
		Write-Host "Importing module '$ModuleName'..." -NoNewLine
		
		# Check if the module is already imported
        if (Get-Module -Name $ModuleName -ListAvailable) 
        {
            Write-Host "already imported."
            return
        }
		
        $moduleFound = $false
        $psModulePaths = $env:PSModulePath -split [System.IO.Path]::PathSeparator

        foreach ($path in $psModulePaths)
        {
            $modulePath = Join-Path -Path $path -ChildPath $ModuleName
            if (Test-Path -Path $modulePath)
            {
                $moduleFound = $true
                break
            }
        }

        if ($moduleFound)
        {
            try 
			{
                Import-Module -Name $ModuleName
                Write-Host "success."
            } catch {
                Write-Error "failed."
            }
        }
        else {
            Write-Warning "not found in `$env:PSModulePath`."
        }
    }
}

# ---------- Miscellaneous ----------		
function Format-Profile {
    Process {
        Write-Host "Cleaning up profile..." -NoNewLine
        
        if (Test-Path -Path $profile) {
            $lines = Get-Content -Path $profile

            $usingModuleLines = @()
			$importModuleLines = @()
            $envPathLines = @()
            $envModulePathLines = @()
            $aliasLines = @()
            $otherLines = @()

            foreach ($line in $lines) {
                if ([string]::IsNullOrWhiteSpace($line)) {
                    continue
                }

                switch -Regex ($line) {
                    '^using module' { $usingModuleLines += $line }
					'^Import-Module' { $importModuleLines += $line }
                    '^\$Env:Path \+=' { $envPathLines += $line }
                    '^\$Env:PSModulePath \+=' { $envModulePathLines += $line }
                    '^if\(-Not \(Get-Alias -Name' { $aliasLines += $line }
                    default { $otherLines += $line }
                }
            }

            $newProfile = @()

			if ($usingModuleLines.Count -gt 0) {
                $newProfile += $usingModuleLines
                $newProfile += ''
            }
			
            if ($envPathLines.Count -gt 0) {
                $newProfile += $envPathLines
                $newProfile += ''
            }
            
            if ($envModulePathLines.Count -gt 0) {
                $newProfile += $envModulePathLines
                $newProfile += ''
            }

            if ($importModuleLines.Count -gt 0) {
                $newProfile += $importModuleLines
                $newProfile += ''
            }
			
            if ($aliasLines.Count -gt 0) {
                $newProfile += $aliasLines
                $newProfile += ''
            }

            if ($otherLines.Count -gt 0) {
                $newProfile += $otherLines
            }
            
            $newProfile | Set-Content -Path $profile
            Write-Host "success."
        }
        else {
            Write-Error "Profile not found."
        }
    }
}

function Complete-Install
{
	Write-Host ""
	Write-Host "Done."
	Write-Host "Please close all PowerShell console windows and run it again in order to refresh your profile."
}


Export-ModuleMember -Function *