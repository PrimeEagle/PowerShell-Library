# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:codeRootDir    	               			= "D:\My Code\"																							# absolute path of code root directory (all code)
$global:codeScriptsRootDir        	   			= "$($codeRootDir)PowerShell Scripts\"																	# absolute path of code scripts root directory (PowerShell scripts, subdirectory of codeRootDir)
$global:modulesDir					   			= "${codeScriptsRootDir}Modules\"																		# absolute path of PowerShell modules directory
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:svnTortoiseExe            	   			= 'C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe'													# absolute path of Tortoise SVN .exe
$global:scriptEditorExe           	   			= 'C:\Program Files\Notepad++\notepad++.exe'															# absolute path of Notepad++ .exe
$global:visualStudioExe               			= 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe'				# absolute path of Visual Studio
$global:visualStudioCodeExe            			= 'C:\Users\johnv\AppData\Local\Programs\Microsoft VS Code\Code.exe'									# absolute path of Visual Studio Code
$global:iisExpressExe                 			= 'C:\Program Files (x86)\IIS Express\iisexpress.exe'													# absolute path of IIS Express
$global:ssmsExe                   	   			= 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe'				# absolute path of SQL Server Management Studio
$global:msbuildExe		               			= 'C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe'	# absolute path of MSBuild
$global:usbDiskEjectExe							= 'C:\Program Files\USB Disk Ejector\USB_Disk_Eject.exe'												# absolute path of USB Disk Eject
$global:sevenZipExe								= 'C:\Program Files\7-Zip\7z.exe'																		# absolute path of 7-Zip
$global:restartUsbPortExe						= 'C:\Program Files\Restart USB Port\RestartUsbPort.exe'											    # absolute path of RestartUsbPort.exe
$global:versionFilename							= 'version.txt'																						    # name of version file
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Subversion config
$global:svnWebUrlBase				   			= 'https://matrix.tplinkdns.com'																		# SVN server domain URL
$global:svnWebPort					   			= 8443																									# SVN server port number
$global:svnCodeRootUrl                			= "$($svnWebUrlBase):$([string]$svnWebPort)/svn/MyCode/"												# SVN server code root URL
$global:svnCodeTagsUrl                			= "$($svnCodeRootUrl)Tags/"																				# SVN server code tags URL
$global:svnCodeScriptsRootUrl		   			= "$($svnCodeRootUrl)PowerShell Scripts/"																# SVN server code scripts root URL
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Git config

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:maxStatusLength				   			= $Host.UI.RawUI.BufferSize.Width																		# max size of Write-Status messages, in characters
$global:minimumPowershellVersion	   			= 7																										# minimum version of PowerShell required for scripts
$global:numUSBDrives				   			= 14																									# number of expected USB drives, when checking
$global:logTimeout					   			= 30																									# timeout for waiting for log file to be unlocked (in seconds)
$global:numCopyThreads							= 12																									# maximum number of parallel copy threads
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:hostDefaultTag				   			= ''																									# default prefix tag for Write-DisplayHost
$global:hostLogDefaultTag			   			= '[Host]: '																							# default prefix tag for Write-DisplayHost in log
$global:infoDefaultTag				   			= ''																									# default prefix tag for Write-DisplayInfo
$global:infoLogDefaultTag			   			= '[Info]: '																							# default prefix tag for Write-DisplayInfo in log
$global:traceDefaultTag				   			= '[Trace]: '																							# default prefix tag for Write-DisplayTrace
$global:traceLogDefaultTag			   			= '[Trace]: '																							# default prefix tag for Write-DisplayTrace in log
$global:statusDefaultTag			   			= ''																									# default prefix tag for Write-DisplayStatus
$global:statusLogDefaultTag		   				= '[Status]: '																							# default prefix tag for Write-DisplayStatus in log
$global:debugDefaultTag			   				= '[Debug]: '																							# default prefix tag for Write-DisplayDebug
$global:debugLogDefaultTag			   			= '[Debug]: '																							# default prefix tag for Write-DisplayDebug in log
$global:errorDefaultTag			   				= '[Error]: '																							# default prefix tag for Display-Error
$global:errorLogDefaultTag			   			= '[Error]: '																							# default prefix tag for Display-Error in log
$global:warningDefaultTag			   			= '[Warning]: '																							# default prefix tag for Write-DisplayWarning
$global:warningLogDefaultTag		   			= '[Warning]: '																							# default prefix tag for Write-DisplayWarning in log
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:styleNormalForegroundColor				= [ConsoleColor]::Gray																						
$global:styleNormalBackgroundColor				= [ConsoleColor]::Black																						
$global:styleTitleForegroundColor				= [ConsoleColor]::Cyan																						
$global:styleTitleBackgroundColor				= [ConsoleColor]::Black																						
$global:styleSubtitleForegroundColor			= [ConsoleColor]::White																						
$global:styleSubtitleBackgroundColor			= [ConsoleColor]::Black																						
$global:styleErrorForegroundColor				= [ConsoleColor]::Black																						
$global:styleErrorBackgroundColor				= [ConsoleColor]::Red																						
$global:styleWarningForegroundColor				= [ConsoleColor]::Black																						
$global:styleWarningBackgroundColor				= [ConsoleColor]::Yellow																						
$global:styleProgressNormalForegroundColor		= [ConsoleColor]::Green																						
$global:styleProgressNormalBackgroundColor		= [ConsoleColor]::Black																						
$global:styleProgressHighlightForegroundColor	= [ConsoleColor]::Yellow																						
$global:styleProgressHighlightBackgroundColor	= [ConsoleColor]::Black

$global:styleVersionForegroundColor				= [ConsoleColor]::Yellow																						
$global:styleVersionBackgroundColor				= [ConsoleColor]::Black

$global:styleHelpTitleForegroundColor			= [ConsoleColor]::Yellow																						
$global:styleHelpTitleBackgroundColor			= [ConsoleColor]::Black
$global:styleHelpItemForegroundColor			= [ConsoleColor]::Cyan																						
$global:styleHelpItemBackgroundColor			= [ConsoleColor]::Black
$global:styleHelpDescriptionForegroundColor		= [ConsoleColor]::DarkCyan																						
$global:styleHelpDescriptionBackgroundColor		= [ConsoleColor]::Black
$global:styleHelpPromptForegroundColor			= [ConsoleColor]::White																						
$global:styleHelpPromptBackgroundColor			= [ConsoleColor]::Black
$global:styleHelpInfoForegroundColor			= [ConsoleColor]::DarkBlue																						
$global:styleHelpInfoBackgroundColor			= [ConsoleColor]::Black
$global:styleHelpEmphasisForegroundColor		= [ConsoleColor]::Magenta																						
$global:styleHelpEmphasisBackgroundColor		= [ConsoleColor]::Black

$global:styleDoneForegroundColor				= [ConsoleColor]::DarkCyan																						
$global:styleDoneBackgroundColor				= [ConsoleColor]::Black

$global:styleSummaryHeaderForegroundColor		= [ConsoleColor]::Cyan																						
$global:styleSummaryHeaderBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryNormalForegroundColor		= [ConsoleColor]::DarkCyan																						
$global:styleSummaryNormalBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryFooterForegroundColor		= [ConsoleColor]::Yellow																						
$global:styleSummaryFooterBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryPromptForegroundColor		= [ConsoleColor]::Yellow																						
$global:styleSummaryPromptBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryStatusForegroundColor		= [ConsoleColor]::Cyan																						
$global:styleSummaryStatusBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryErrorForegroundColor		= [ConsoleColor]::Red																					
$global:styleSummaryErrorBackgroundColor		= [ConsoleColor]::Black
$global:styleSummaryWarningForegroundColor		= [ConsoleColor]::Yellow																						
$global:styleSummaryWarningBackgroundColor		= [ConsoleColor]::Black
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------