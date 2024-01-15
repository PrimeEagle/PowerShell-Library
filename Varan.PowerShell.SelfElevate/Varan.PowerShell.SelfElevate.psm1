function Open-ElevatedConsole 
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $CallerScriptPath,  # Path of the calling script

        [Parameter()]
        [Hashtable] $OriginalBoundParameters  # Original bound parameters
    )

    # Check if the script is already running as an administrator.
    if (net.exe session 2>$null) 
    { 
        Write-Host "Running as admin."
        return 
    }

    # Reconstruct the command line with the original bound parameters.
    $commandLine = "& `"$CallerScriptPath`" "
    foreach ($paramName in $OriginalBoundParameters.Keys) {
        $paramValue = $OriginalBoundParameters[$paramName]
        if ($paramValue -is [string]) {
            $paramValue = "`"$paramValue`""
        }
        $commandLine += "-$paramName $paramValue "
    }

    # Encode the command for execution.
    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commandLine))

    # Determine the PowerShell executable (use 'pwsh.exe' for PowerShell Core)
    $psExecutable = "pwsh.exe"

    # Start a new PowerShell process with elevated privileges.
    Start-Process -Verb RunAs -FilePath $psExecutable -ArgumentList "-noexit", "-encodedCommand", $encodedCommand

    # Exit, reporting the success of starting the process.
    exit ($LASTEXITCODE, (1, 0)[$?])
}