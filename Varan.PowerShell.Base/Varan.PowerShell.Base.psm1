[CmdletBinding(SupportsShouldProcess)]
param ()

$debugCategories = @('UI', 'Console', 'File')
$errorCategories = @('Device', 'Security', 'File', 'Syntax')
	
function Initialize-Base
{
	Add-Type -TypeDefinition @'
		public enum PrimaryMusicDrive 
		{
			Music1,
			Music2,
			Music3,
			Music4,
			Music5,
			Music6,
			Music7,
			MusicTemp,
			MusicLaptopTemp,
			All
		}
'@

	Add-Type -TypeDefinition @'
		public enum BackupMusicDrive 
		{
			MusicBackup1,
			MusicBackup2,
			MusicBackup3,
			MusicBackup4,
			MusicBackup5,
			MusicBackup6,
			MusicBackup7,
			All
	   }
'@

	Add-Type -TypeDefinition @'
	   public enum MusicDrive
	   {
			Music1,
			Music2,
			Music3,
			Music4,
			Music5,
			Music6,
			Music7,
			MusicTemp,
			MusicLaptopTemp,
			MusicBackup1,
			MusicBackup2,
			MusicBackup3,
			MusicBackup4,
			MusicBackup5,
			MusicBackup6,
			MusicBackup7,
			All
	   }
'@

	Add-Type -TypeDefinition @'
	   public enum DisplayStyle
	   {
			Title,
			Subtitle,
			Error,
			Warning,
			Normal,
			ProgressNormal,
			ProgressHighlight,
			Version,
			HelpTitle,
			HelpItem,
			HelpDescription,
			HelpPrompt,
			HelpInfo,
			HelpEmphasis,
			Done,
			SummaryHeader,
			SummaryNormal,
			SummaryFooter,
			SummaryPrompt,
			SummaryStatus,
			SummaryError,
			SummaryWarning
	   }
'@

	Add-Type -TypeDefinition @'
	   public enum DiskItemType
	   {
			File,
			Directory
	   }
'@

	Add-Type -TypeDefinition @'
	   public enum SummarySource
	   {
			Work,
			Error,
			Warning
	   }
'@

	Add-Type -TypeDefinition @'
	   public enum SummaryOutput
	   {
			Console,
			Grid,
			File
	   }
'@

	Add-Type -TypeDefinition @'
		public enum DebugAction 
		{
			Pause,
			Stop
		}
'@

	Add-Type -TypeDefinition @'
		public enum DiskItem 
		{
			File,
			Directory
		}
'@

	$debugCategoriesSource = "public enum DebugCategory { " + ($debugCategories | %{ $_ + "," }) + " }"
	Add-Type -TypeDefinition $debugCategoriesSource

	$errorCategoriesSource = "public enum ErrorCategory { " + ($errorCategories | %{ $_ + "," }) + " }"
	Add-Type -TypeDefinition $errorCategoriesSource
}

function Get-CommonParameterList
{
	$list = @('Debug', 'ErrorAction', 'ErrorVariable',
			  'InformationAction', 'InformationVariable',
			  'OutVariable', 'OutBuffer', 'PipelineVariable',
			  'Verbose', 'WarningAction', 'WarningVariable',
			  'WhatIf', 'Confirm')
	
	$list
}

function Get-BaseParameterDefinitions
{
	[CmdletBinding()]
    param( 	[Parameter()]	
														[switch]		$IncludeMusicPathQueues
		 )
		 
	$pHelpDetail =				[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'HelpDetail'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @('Help', 'h', 'hd')
								DefaultValue		= $null
								HelpMessage			= 'Displays detailed help for script.'}

	$pHelpFull =				[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'HelpFull'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @('hf')
								DefaultValue		= $null
								HelpMessage			= 'Displays full help for script.'}

	$pHelpSynopsis =			[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'HelpSynopsis'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @('hs')
								DefaultValue		= $null
								HelpMessage			= 'Displays a brief, single line help for script.'}
								
	$pTrace =					[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'Trace'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'Runs script in trace mode for enhanced debug messages.'}

	$pSilent =					[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'Silent'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'Runs without displaying any output.'}

	$pSummary =					[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'Summary'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $true
								HelpMessage			= 'Shows a summary of results.'}	

	$pSummarySource =			[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'SummarySource'
								Mandatory			= $false
								DataType			= [SummarySource[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= @([SummarySource]::Work)
								HelpMessage			= 'Sets which summaries are shown.'}	

	$pSummaryOutput =			[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'SummaryOutput'
								Mandatory			= $false
								DataType			= [SummaryOutput[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= @([SummaryOutput]::Console)
								HelpMessage			= 'Sets which formats are used to show summaries.'}

	$pSummaryOutputFilename =	[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'SummaryFilename'
								Mandatory			= $false
								DataType			= [string]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'Sets the filename to use when outputting summary to a file.'}
								
	$pTesting =					[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'Testing'
								Mandatory			= $false
								DataType			= [switch]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'Runs in testing mode, which disables some checks.'}

	$pDebugItem =				[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'DebugItem'
								Mandatory			= $false
								DataType			= [string[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'Takes an action on a specific item.'}

	$pDebugItemAction =			[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'DebugItemAction'
								Mandatory			= $false
								DataType			= [DebugAction]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'What action to take when DebugItem is specified.'}
								
	$baseParameterDefinitions = @{
						'HelpDetail'				= $pHelpDetail;
						'HelpFull'					= $pHelpFull;
						'HelpSynopsis'				= $pHelpSynopsis;
						'Trace'						= $pTrace;
						'Silent'					= $pSilent;
						'Summary'					= $pSummary;
						'SummarySource'				= $pSummarySource;
						'SummaryOutput'				= $pSummaryOutput;
						'SummaryFilename'			= $pSummaryOutputFilename;
						'Testing'					= $pTesting;
						'DebugItem'					= $pDebugItem;
						'DebugItemAction'			= $pDebugItemAction;
					}
					
	if($IncludeMusicPathQueues)
	{													
		$pDrivePreset =	[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'DrivePreset'
								Mandatory			= $false
								DataType			= [MusicDrive[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'An array of pre-defined drive names to use.'}
								
		$pDriveLetter =	[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'DriveLetter'
								Mandatory			= $false
								DataType			= [string[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'An array of drive letters to use.'}
								
		$pDriveLabel =	[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'DriveLabel'
								Mandatory			= $false
								DataType			= [string[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'An array of drive labels to use.'}
								
		$pPath =	[PSCustomObject]@{
								PSTypename			= "BaseParameterInfo"
								Name				= 'Path'
								Mandatory			= $false
								DataType			= [string[]]
								ParameterSetName	= $null
								Position			= $null
								ValueFromPipeline	= $false
								DontShow			= $false
								Aliases				= @()
								DefaultValue		= $null
								HelpMessage			= 'An array of paths to use.'}
								
		$baseParameterDefinitions.DrivePreset = $pDrivePreset
		$baseParameterDefinitions.DriveLetter = $pDriveLetter
		$baseParameterDefinitions.DriveLabel = $pDriveLabel
		$baseParameterDefinitions.Path = $pPath
	}
		
	return $baseParameterDefinitions
}

function Build-BaseParameters 
{
	[CmdletBinding()]
    param( 	[Parameter()]	
														[switch]		$IncludeMusicPathQueues
		 )
		 
    $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
	$baseParameterDefinitions = Get-BaseParameterDefinitions -IncludeMusicPathQueues:$IncludeMusicPathQueues

    foreach($pKey in $baseParameterDefinitions.Keys) 
	{
        $dynAttribCol = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $dynAttrib = New-Object System.Management.Automation.ParameterAttribute
		$dynAttrib.Mandatory = $baseParameterDefinitions.Item($pKey).Mandatory
		$dynAttrib.ParameterSetName = $baseParameterDefinitions.Item($pKey).ParameterSetName
		$dynAttrib.Position = $baseParameterDefinitions.Item($pKey).Position
		$dynAttrib.ValueFromPipeline = $baseParameterDefinitions.Item($pKey).ValueFromPipeline
		$dynAttrib.DontShow = $baseParameterDefinitions.Item($pKey).DontShow
		$dynAttribCol.Add($dynAttrib)

		foreach($a in $baseParameterDefinitions.Item($pKey).Aliases)
		{
			$alias = [System.Management.Automation.AliasAttribute]::new($a)
			$dynAttribCol.Add($alias)
		}
		
        $dynParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter($pKey, $baseParameterDefinitions.Item($pKey).DataType, $dynAttribCol)
		$defaultValue = $baseParameterDefinitions.Item($pKey).DefaultValue

		if($defaultValue -ne $null)
		{
			$dynParam.Value = $baseParameterDefinitions.Item($pKey).DefaultValue
		}

        $paramDictionary.Add($pKey, $dynParam)  
    }
	
    return $paramDictionary         
}

Initialize-Base

Export-ModuleMember -Function *