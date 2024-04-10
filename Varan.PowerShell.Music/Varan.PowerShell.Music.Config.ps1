#
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$global:codeScriptsDir           	   = "$($codeScriptsRootDir)Music\"								# absolute path of code scripts directory
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:museScoreExe            	   = 'C:\Program Files\MuseScore 3\bin\MuseScore3.exe'			# absolute path of MuseScore .exe
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:displayHost				       = $true														# enable display to console for Write-DisplayHost
$global:displayInfo				   	   = $false														# enable display to console for Write-DisplayInfo
$global:displayTrace				   = $true														# enable display to console for Write-DisplayTrace
$global:displayDebug				   = $true														# enable display to console for Write-DisplayDebug
$global:displayStatus				   = $true														# enable display to console for Write-DisplayStatus
$global:displayError				   = $true														# enable display to console for Display-Error
$global:displayWarning				   = $true														# enable display to console for Write-DisplayWarning
$global:displayHostFilterInclude	   = @('')														# list of functions to include in Host (if empty, all are included)
$global:displayHostFilterExclude	   = @('')														# list of functions to exclude from Host (if empty, nothing is excluded)
$global:displayInfoFilterInclude	   = @('')														# list of functions to include in Info (if empty, all are included)
$global:displayInfoFilterExclude	   = @('')														# list of functions to exclude from Info (if empty, nothing is excluded)
$global:displayTraceFilterInclude	   = @('')														# list of functions to include in Trace (if empty, all are included)
$global:displayTraceFilterExclude	   = @('')														# list of functions to exclude from Trace (if empty, nothing is excluded)
$global:displayDebugFilterInclude	   = @('')														# list of functions to include in Debug (if empty, all are included)
$global:displayDebugFilterExclude	   = @('')														# list of functions to exclude from Debug (if empty, nothing is excluded)
$global:displayStatusFilterInclude	   = @('')														# list of functions to include in Status (if empty, all are included)
$global:displayStatusFilterExclude	   = @('')														# list of functions to exclude from Status (if empty, nothing is excluded)
$global:displayErrorFilterInclude	   = @('')														# list of functions to include in Error (if empty, all are included)
$global:displayErrorFilterExclude	   = @('')														# list of functions to exclude from Error (if empty, nothing is excluded)
$global:displayWarningFilterInclude    = @('')														# list of functions to include in Warning (if empty, all are included)
$global:displayWarningFilterExclude    = @('')														# list of functions to exclude from Warning (if empty, nothing is excluded)
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:logEnabled					   = $false														# enable logging
$global:logHost					   	   = $true														# enable logging for Write-DisplayHost (requires $log to be enabled)
$global:logInfo					   	   = $true														# enable logging for Write-DisplayInfo (requires $log to be enabled)
$global:logTrace					   = $true														# enable logging for Write-DisplayTrace (requires $log to be enabled)
$global:logDebug					   = $true														# enable logging for Write-DisplayDebug (requires $log to be enabled)
$global:logStatus					   = $true														# enable logging for Write-DisplayStatus (requires $log to be enabled)
$global:logError					   = $true														# enable logging for Display-Error (requires $log to be enabled)
$global:logWarning					   = $true														# enable logging for Write-DisplayWarning (requires $log to be enabled)
$global:logHostFilterInclude		   = @('')														# list of functions to include in Host (if empty, all are included)
$global:logHostFilterExclude		   = @('')														# list of functions to exclude from Host (if empty, nothing is excluded)
$global:logInfoFilterInclude		   = @('*')														# list of functions to include in Info (if empty, all are included)
$global:logInfoFilterExclude		   = @('')														# list of functions to exclude from Info (if empty, nothing is excluded)
$global:logTraceFilterInclude		   = @('')														# list of functions to include in Trace (if empty, all are included)
$global:logTraceFilterExclude		   = @('')														# list of functions to exclude from Trace (if empty, nothing is excluded)
$global:logDebugFilterInclude		   = @('')														# list of functions to include in Debug (if empty, all are included)
$global:logDebugFilterExclude		   = @('')														# list of functions to exclude from Debug (if empty, nothing is excluded)
$global:logStatusFilterInclude		   = @('')														# list of functions to include in Status (if empty, all are included)
$global:logStatusFilterExclude		   = @('')														# list of functions to exclude from Status (if empty, nothing is excluded)
$global:logErrorFilterInclude		   = @('')														# list of functions to include in Error (if empty, all are included)
$global:logErrorFilterExclude		   = @('')														# list of functions to exclude from Error (if empty, nothing is excluded)
$global:logWarningFilterInclude	   	   = @('')														# list of functions to include in Warning (if empty, all are included)
$global:logWarningFilterExclude	   	   = @('')														# list of functions to exclude from Warning (if empty, nothing is excluded)
$global:logFile					   	   = "$($codeScriptsDir)mulog.txt"								# absolute path of log file
$global:maxLinesPerLog				   = 15000														# max lines per log file, before creating a new file
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:versionFile			   	   	   = 'version.txt'											    # file that contains version info
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:svnCodeScriptsUrl			   = "$($svnCodeScriptsRootUrl)mu"								# SVN server code scripts URL
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:usbDriveCheckInterval		   = 25															# when looping through directories, how often to check that all USB drives are still connected
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:musicTempPath				   = 'G:\Burn\VST'												# absolute path of temp music directory
$global:musicLaptopTempPath			   = 'D:\lib'													# absolute path of temp music directory on laptop
$global:music1Path					   = 'I:\Music'													# absolute path of external drive MUSIC1
$global:music2Path					   = 'J:\Music'													# absolute path of external drive MUSIC2
$global:music3Path					   = 'K:\Music'													# absolute path of external drive MUSIC3
$global:music4Path					   = 'L:\Music'													# absolute path of external drive MUSIC4
$global:music5Path					   = 'M:\Music'													# absolute path of external drive MUSIC5
$global:music6Path					   = 'N:\Music'													# absolute path of external drive MUSIC6
$global:music7Path					   = 'O:\Music'													# absolute path of external drive MUSIC7
$global:musicBackup1Path			   = 'P:\Music'													# absolute path of external drive MUSICBACKUP1
$global:musicBackup2Path			   = 'Q:\Music'													# absolute path of external drive MUSICBACKUP2
$global:musicBackup3Path			   = 'R:\Music'													# absolute path of external drive MUSICBACKUP3
$global:musicBackup4Path			   = 'S:\Music'													# absolute path of external drive MUSICBACKUP4
$global:musicBackup5Path			   = 'T:\Music'													# absolute path of external drive MUSICBACKUP5
$global:musicBackup6Path			   = 'U:\Music'													# absolute path of external drive MUSICBACKUP6
$global:musicBackup7Path			   = 'V:\Music'													# absolute path of external drive MUSICBACKUP7
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:music1DeviceId					= 'USB\VID_1058&PID_25E2\575839314536363238585236'			# hardware ID of Music 1
$global:music2DeviceId					= 'USB\VID_1058&PID_25E2\575834314442364344543541'			# hardware ID of Music 2
$global:music3DeviceId					= 'USB\VID_1058&PID_2627\5758363145433937374D415A'			# hardware ID of Music 3
$global:music4DeviceId					= 'USB\VID_0BC2&PID_2344\MSFT30NACACAFD'					# hardware ID of Music 4
$global:music5DeviceId					= 'USB\VID_0BC2&PID_2343\MSFT30NACAHTLS'					# hardware ID of Music 5
$global:music6DeviceId					= 'USB\VID_0BC2&PID_2344\MSFT30NACALRC4'					# hardware ID of Music 6
$global:music7DeviceId					= 'USB\VID_0BC2&PID_2344\MSFT30NACM95FK'					# hardware ID of Music 7
$global:musicBackup1DeviceId			= 'USB\VID_1058&PID_25E2\575841314534383832343755'			# hardware ID of Music 1 Backup
$global:musicBackup2DeviceId			= 'USB\VID_1058&PID_25E2\575832314439383745315056'			# hardware ID of Music 2 Backup
$global:musicBackup3DeviceId			= 'USB\VID_1058&PID_2627\57583332443130375A4C3345'			# hardware ID of Music 3 Backup
$global:musicBackup4DeviceId			= 'USB\VID_0BC2&PID_2344\MSFT30NACACAEE'					# hardware ID of Music 4 Backup
$global:musicBackup5DeviceId			= 'USB\VID_0BC2&PID_2343\MSFT30NACAHTLF'					# hardware ID of Music 5 Backup
$global:musicBackup6DeviceId			= 'USB\VID_0BC2&PID_2344\MSFT30NACALRC6'					# hardware ID of Music 6 Backup
$global:musicBackup7DeviceId			= 'USB\VID_0BC2&PID_2344\MSFT30NACM9KYF'					# hardware ID of Music 7 Backup
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$global:stopOnWarning				   = $true														# whether to stop (exit) when there is a warning
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# directories to be removed during cleanup
$global:undesiredDirectories = @(
								'__MACOSX',
								'.pulse',
								'Mac OS',
								'MAC',
								'*.app'
						)

# files to be removed during cleanup
$global:undesiredFiles = @(
								'.DS_STORE',
								'desktop.ini',
								'file_id.diz',
							   '*.dmg',
							   '*.md5',
							   '*.sfv',
							   '*.url',
							   '*demo*.mp3',
							   '*demo*.mp4',
							   '*installation*.mp4',
							   'Установка.txt',
							   'ЧИТАЙ README.txt'
					   )			
										   
# file extensions for compressed types
$global:compressedFileTypes = @(
								'rar',
								'zip',
								'7z',
								'7z.001',
								'gz',
								'tar',
								'zip.001',
								'iso'
						)
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# change phrases from one thing to another (only on word boundaries).
$global:phrasesToChange = [ordered]@{
								'16bit'									= '16-bit';
								'24bit'									= '24-bit';
								'70''s'									= '70s';
								'Bass Station 2'						= 'Bass Station II';
								'Basses Pads'							= 'Basses, Pads';
								'Blankfor.ms'							= 'BlankFor.ms';
								'Ernesto vs Bastian'					= 'Ernesto vs. Bastian';
								'Junior Porciuncula'					= 'Júnior Porciúncula'
								'Lennar Digital'						= 'LennarDigital';
								'Part I'								= 'Part 1';
								'Part II'								= 'Part 2';
								'Part III'								= 'Part 3';
								'Part IV'								= 'Part 4';
								'Part V'								= 'Part 5';
								'plug in'								= 'plugin';
								'plug ins'								= 'plugins';
								'Serum Wave'							= 'Serum'
								'Silence and Other Sounds'				= 'Silence+Other Sounds';
								'smartcomp'								= 'smart-comp';
								'smartlimit'							= 'smart-limit';
								'smartreverb'							= 'smart-reverb';
								'Spectrasonic'							= 'Spectrasonics';
								'TAQS IM'								= 'TAQS.IM';
								'Uhe'									= 'u-he';
								'Vol I'									= 'Vol 1';
								'Vol II'								= 'Vol 2';
								'Vol III'								= 'Vol 3';
								'Vol IV'								= 'Vol 4';
								'Vol V'									= 'Vol 5';
								'volume'								= 'vol. ';
								'W.A. Production'						= 'W. A. Production';
								'W.A.Production'						= 'W. A. Production';
								'Xfer Audio'							= 'Xfer Records';
								'Xfer Serum'							= 'Xfer Records Serum';
						}


# the keyword used for all labeled editions
$global:labeledEditionKeyword = 'edition'

# these phrases have the word in $labeledEditionKeyword after them and are in parenthesis. The values after them are exceptions.
$global:labeledEditions = @{
								'ACID'									= @('Acid Drops', 'Acid House', 'CV Acid', 'Magix Acid');
								'AIFF'									= @();
								'bobdule'								= @();
								'Close'									= @();
								'Decent'								= @();
								'Diamond'								= @();
								'Free'									= @('8Dio free');
								'Full'									= @();
								'HALion'								= @('Steinberg Halion');
								'iLok'									= @();
								'Kontakt'								= @('Battery and Kontakt', 'Big Bob Kontakt', 'Kontakt Manager', 'Kontakt NICNT', 'Kontakt Snapshots', 'Native Instruments Kontakt', 'Theo Krueger Kontakt');
								'Mirage'								= @('FrozenPlain Mirage', 'Mirage Vocal', 'ModeAudio Mirage');
								'Standard'								= @();
								'UDS'									= @();
								'VST2'									= @();
								'VST3'									= @();
						}
											
# symbols to change (not only on word boundaries)
$global:symbolsToChange = @{
								'['										= '(';
								']'										= ')';
								'..'									= '';
								'--'									= '';
								'.-'									= '';
								'-.'									= '';
						}

# these phrases are not treated as version numbers
$global:versionNumberExceptions = @(
								'Soundbank PX V8',
								'D-50 90s',
								'6 666',
								'808 909',
								'14 808'
						)
						
# these phrases are not treated as volume numbers
$global:volumeNumberExceptions = @(
								'SQ80 V'
						)
						
# these phrases will be removed when renaming files (keys are values to be removed, the values are exceptions to those)
$global:phrasesToRemove = @{
								'(Free)'								= @();
								'(SCENE) DISCOVER'						= @();
								'0Th3rside'								= @();
								'32 Bit'								= @();
								'32-Bit'								= @();
								'4395-TeamCub'							= @();
								'4395-TeamCubea'						= @();
								'4395-TeamCubeado'						= @();
								'4395-TeamCubeadoo'						= @();
								'4395-TeamCubeadooby'					= @();
								'64 Bit'								= @();
								'64-Bit'								= @();
								'AAX'									= @();
								'AMXD'									= @();
								'Arcadia'								= @();
								'Articstorm'							= @();
								'AUDIOWAREZ'							= @();
								'Bonus Sample Pack'						= @();
								'BTCR'									= @();
								'by Tryroom'							= @();
								'CE'									= @('956 CE', 'CE Acoustic');
								'Crackingpatching'						= @();
								'CR8'									= @('CR8 Creative Sampler');
								'CRD'									= @();
								'DECiBEL'								= @();
								'DISCOVER'								= @();
								'DVD9'									= @();
								'DVDR'									= @();
								'EXPANION'								= @();
								'FIXED'									= @();
								'FLARE'									= @('Polar Flare');
								'FXP DECiBEL'							= @();
								'Incl'									= @();
								'Incl Emulator'							= @();
								'Iso'									= @();
								'Keygen'								= @('Keygen Library', 'Voxengo Keygen');
								'Kontakt'								= @('Battery and Kontakt', 'Kontakt Snapshots', 'Kontakt Pro', 'Native Instruments Kontakt', '(Kontakt)', 'Kontakt Version', 'Kontakt Manager', 'Kontakt WIPS', 'Kontakt SIPS', 'Kontakt Libraries', 'Kontakt Library', 'R2R Kontakt NICNT Generator', 'R2R Team Kontakt Manager', 'for Kontakt', 'Kontakt Manager', 'Kontakt NICNT');
								'Lin'									= @();
								'Linux'									= @();
								'MAC'									= @();
								'MacOS'									= @();
								'Magnetrixx'							= @();
								'MIDI'									= @('MIDI & Loops', 'Loops & MIDI', 'MIDI Collection', 'MIDI Pack', 'Jazz Brush MIDI', 'MIDI Velocity', 'MIDI for EZkeys', 'MIDI for EZbass', 'Piz MIDI', 'TXR1 MIDI', 'MIDI Bundle', 'MIDI Pack', 'MIDI Loops', 'SmartScore 64 MIDI', 'XBox MIDI Control', 'OSC MIDI Server');
								'MOCHA'									= @();
								'MORiA'									= @();
								'MULTI6'								= @();
								'MULTiFORMAT'							= @();
								'Multilingual'							= @();
								'NKI'									= @();
								'NO INSTALL'							= @();
								'Oddsox'								= @();
								'Ohsie'									= @();
								'Osx'									= @();
								'PART01'								= @();
								'PART02'								= @();
								'PART03'								= @();
								'PART04'								= @();
								'PART1' 								= @();
								'PART2' 								= @();
								'PART3' 								= @();
								'PART4' 								= @();
								'Patch and Keygen'						= @();
								'Patched and Keygen'					= @();
								'Patched'								= @();
								'Portable'								= @();
								'Proper'								= @();
								'R2R'									= @('R2R version', 'R2R Kontakt Manager', 'R2R Kontakt NICNT Generator', 'R2R Team Kontakt Manager', 'R2R Steinberg Silk Emulator', 'R2R ASCEMU2', 'R2R u-he Serial Index Calculator');
								'R4E'									= @();
								'READ NFO'								= @();
								'Regged'								= @();
								'REPACK'								= @();
								'Ret'									= @();
								'Retail'								= @();
								'Sample Pack'							= @('Syence Sample Pack', 'Hyperbits Sample Pack', 'The Sample Pack Maker', 'Loopmasters Sample Pack');
								'SCENE DISCOVER'						= @();
								'SCENE'									= @('Expansion Scene');
								'Setup'									= @();
								'SYMLINK Installer'						= @();
								'SYNTHiC4TE'							= @();
								'Tcd'									= @();
								'TeamCubea'								= @();
								'TeamCubeado'							= @();
								'Teamcubeadooby'						= @();
								'Unlocked'								= @();
								'V R'									= @();
								'VR'									= @('SVT-VR');
								'VST'									= @('VST Buzz', 'Budde VST', 'VST Ambidecoder', '(VST)', 'VST Live Pro');
								'VST2'									= @('VST2 version', 'VST2 edition');
								'VST3'									= @('VST3 version', 'VST3 edition');
								'VSTi'									= @('VSTi Scope');
								'WAV DECiBEL'							= @();
								'WAV'									= @('Essential WAV');
								'WIN64'									= @();
								'WIN MAC LIN'							= @();
								'WIN MAC'								= @();
								'WIN'									= @();
								'www zonatorrent com'					= @();
								'www.zonatorrent.com'					= @();
								'x32x64'								= @();
								'x64'									= @();
								'x86'									= @();
								'Zip'									= @();
						}

# phrases in unprocessed file names that should be case sensitive
# developers, standard expansion terms, dashes to keep, periods to keep, and commas to keep will be automatically added to this list
$global:caseSensitivePhrases = @(
								"Blue Cat's",
								"Blue Cat’s",
								"DBJ's",
								"DJ Pierre’s",
								'(with',
								'1920s',
								'2040z',
								'20s',
								'25th',
								'30s',
								'3ds Max',
								'3DX',
								'40s',
								'44thFloor',
								'4AM',
								'4FX',
								'4MER',
								'50s',
								'50th',
								'5AM',
								'60s',
								'6FX',
								'70s',
								'714CE',
								'7th',
								'80s',
								'808s',
								'8Dio CAGE',
								'8Dio CASE',
								'90s',
								'a',
								'A Taste of Heaven',
								'AAA',
								'AB Assist',
								'ABC',
								'ABJ',
								'Accusonus ERA',
								'ACE',
								'ACID',
								'Acid House',
								'AcouFiend',
								'AcoustiClap',
								'ADPTR',
								'ADSR',
								'ADSR DrumMachine',
								'AetherArp',
								'AI',
								'AIFF',
								'AIR Music',
								'AIRA',
								'AIV',
								'AizerX',
								'ALIBI',
								'ALX',
								'AmberWood',
								'AmbiDecoder',
								'AME',
								'ampLion',
								'AmpliTube',
								'an',
								'AnalogQ',
								'and',
								'AngryComp',
								'APC',
								'AraabMuzik',
								'ARCUS',
								'Aria Sounds Aria',
								'ARIA',
								'Ark 1 The',
								'Ark 2 The',
								'Ark 3 The',
								'Ark 4 The',
								'Ark 5 The',
								'ARK Facility',
								'Artist Expansion The',
								'as',
								'ASHRAM',
								'ASIO',
								'ASIO4ALL',
								'ASMR',
								'ASR',
								'at',
								'audio2score',
								'AudioCipher',
								'AudioGridder',
								'AudioRealism',
								'AudioScore',
								'AURORROR',
								'Auryn64',
								'AutoGain',
								'AutoLatch',
								'AVA',
								'AWP',
								'AX',
								'AZONIC',
								'BaseHead',
								'BBC',
								'BBE',
								'BeatBox',
								'BFD',
								'BFractal',
								'BHK',
								'BI',
								'BigTone',
								'BioTek',
								'BiP',
								'BIV',
								'BL',
								'BlueBeast',
								'BlueDepth',
								'BMS',
								'BreadSlicer',
								'BreakTweaker',
								'BT',
								'BTD',
								'BusComp',
								'BussPressor',
								'but',
								'BVA',
								'by',
								'CamelSpace',
								'CE',
								'CFA',
								'ChamberTron',
								'ChanComp',
								'ChilloutEngine',
								'Chip64',
								'ChordieApp',
								'ChordPotion',
								'ChordWizard',
								'CineBells',
								'CineBrass',
								'CineHarps',
								'CineHarpsichord',
								'CineMap',
								'Cinematique Instruments KLANG',
								'CineOrch',
								'CinePerc',
								'CinePiano',
								'CineStrings',
								'CineToms',
								'CineWinds',
								'CL',
								'CLANGGG',
								'Clarinet in A',
								'Classic EPs',
								'ClipGain',
								'CMusic',
								'CompExp',
								'CompuRhythm',
								'CoreBass',
								'CP-70',
								'CP-70 V',
								'Cr2',
								'CS',
								'CS15D',
								'CubeSuite',
								'CurveEQ',
								'CustomVibe',
								'CV',
								'CV8X4',
								'CyberLink',
								'CyberWorld',
								'Cymatics Prism',
								'CZ',
								'DAG',
								'DarkLight',
								'DarkLord',
								'DaVinci',
								'DAW',
								'DAWcentrix',
								'DAWConnect',
								'DC',
								'DCAM',
								'DDMF',
								'Deadton5',
								'dearVR',
								'DEBIRD',
								'Decimort2',
								'deCoda',
								'DeepAudio',
								'DeepTech',
								'Devastor2',
								'DiBiQuadro',
								'DJ',
								'DLC',
								'DMX',
								'DNA',
								'DNB',
								'DOPE',
								'DoubleComb',
								'DoubleComp',
								'DownBeat',
								'Drum n Bass',
								'DrumBooth',
								'DS',
								'DSEQ',
								'DSI',
								'DSP',
								'DX',
								'DX7',
								'DyingStar',
								'EAReverb',
								'EasyABC',
								'EBX',
								'ED',
								'EDEN',
								'Edit Part Instrument Names Plugin',
								'EDM',
								'eDNA',
								'EDS06s',
								'EFX',
								'EGP',
								'EkoRain',
								'EKSSBOX',
								'ElectraX',
								'ElectroNylon',
								'eLicenser',
								'Elixer - The Lost Tapes',
								'EMISYNTH',
								'EMP',
								'EMT',
								'EMX',
								'Enigma 2 The',
								'EntropyEQ',
								'EnvShaper',
								'EP',
								'EPS',
								'EQ',
								'Equator2',
								'EQHack',
								'EQP',
								'ES',
								'ESP',
								'Essential WAV',
								'EssEQ',
								'EVI',
								'EX',
								'EXOVERB',
								'EXOVERB MICRO',
								'EXP A',
								'EXP B',
								'EXP C',
								'EXP D',
								'EXP E',
								'EXP',
								'EXZ',
								'EZbass',
								'EZdrummer',
								'EZkeys',
								'EZmix',
								'EZX',
								'Falcon Expansion SubCulture',
								'FANTOM',
								'Fazortan2',
								'FET',
								'FETpressor',
								'FFB',
								'FiDef',
								'Fishbird3',
								'FlexRouter',
								"Flippin'Grooves",
								'FloppyTron',
								'FLPN',
								'FlyingHand',
								'FM',
								'Focusrite FAST',
								'for',
								'Forensics10',
								'From Mars',
								'from',
								'FS1R',
								'FST',
								'FTS',
								'FunkMasters',
								'FutureCZ',
								'FutureX',
								'FX',
								'FYSX',
								'Gain12',
								'Gain24',
								'Gain60',
								'Gassed Up',
								'GateVerb',
								'GBR',
								'Geist2',
								'GEQ',
								'GetGood',
								'GForce',
								'GFX',
								'GhostViewer',
								'GlissEQ',
								'GoldWave',
								'GrainShift',
								'Groovemate ONE',
								'GS',
								'GSatPlus',
								'GT',
								'GTA',
								'Guitar Rig',
								'Guitar Rig Pro',
								'Guitar T',
								'GuitarFX',
								'Guitars DE',
								'H.A.L.',
								'HalfTime',
								'HALion',
								'HALO',
								'HandsUp',
								'HarmBode',
								'HarmoniEQ',
								'HATEFISh',
								'HATZ',
								'HBL',
								'HD',
								'Heat Up Expansion The',
								'HertzRider2',
								'Hg2O',
								'HGF',
								'HolyVerb',
								'HouseEngine',
								'HQ',
								'HQPlayer',
								'HR Strings',
								'HumbuckerGuitar',
								'I',
								'IBZ',
								'if',
								'II',
								'III',
								'IIx',
								'IK'
								'IK Multimedia ARC',
								'iLok',
								'ImpactSoundworks',
								'in',
								'IndiaVoice',
								'InfiniStrip',
								'InfoBay',
								'Initial Audio Heat Up',
								'INSPIRATA',
								'InstaComposer',
								'InstaScale',
								'IR',
								'IRs',
								'is',
								'ISL',
								'IV',
								'IX',
								'JD 850',
								'JD-Xi'
								'JENtwo',
								'JM',
								'Josh Levy BOOM',
								'JP',
								'JP-08',
								'JST',
								'JSTSideWidener',
								'JU-06A',
								'JUNO-106 The',
								'K-Devices',
								'KineticSoundPrism',
								'KIViR',
								'KLM',
								'KnobKraft',
								'KRON',
								'KRZ',
								'KS',
								'KSHMR',
								'KV',
								'LA Atmos',
								'LA Drum',
								'LA Modern Percussion',
								'LA Scoring',
								'LA Synthesizer',
								'LA Synths',
								'LatencyMon',
								'Lectric Panda',
								'LED',
								'LFO',
								'liftFX',
								'LIMINAL',
								'Linn60',
								'LIP',
								'LIPP',
								'LIV',
								'LM-Correct',
								'LoopMash',
								'loopMIDI',
								'LP',
								'LPC',
								'LPM',
								'LSS',
								'Lunacy Audio CUBE',
								'LXP',
								'LXR',
								'M3G',
								'M4L',
								'Mark79',
								'Mars Minipops',
								'Mars Sid',
								'Mars TOM',
								'MarsPeaks',
								'MasterCheck',
								'MasterQ2',
								'MasterTool',
								'MAudioPlugins',
								'MBEQ',
								'MBira',
								'MC',
								'MCRS',
								'MCompleteBundle',
								'MDE',
								'MegaMagic',
								'MelodicFlow',
								'MeloDramatik',
								'MetroTone',
								'MFB',
								'MG',
								'MI',
								'MicroComposer',
								'MicroToner',
								'MicroTune',
								'MidBooster',
								'MIDI',
								'MIM',
								'MiniMeters',
								'MiniPops',
								'MiniXD',
								'MIR',
								'MIV',
								'MJUC',
								'MK',
								'Mk2',
								'Mk3',
								'MkII',
								'MkIII',
								'MKSensation',
								'ML',
								'MMC',
								'MODO BASS',
								'MODO DRUM',
								'MOK Waverazor',
								'MonoPoly',
								'MoPol',
								'MorphVerb',
								'MorphVOX',
								'MPC',
								'MS',
								'MSED',
								'Multiband Waveshaper',
								'MultiMode',
								'MuseScore',
								'MVP',
								'MYSTXRIVL',
								'NanoHost',
								'Native Instruments Effects The',
								'Native Instruments Keys The',
								'NCH',
								'NDLR',
								'NeuralQ',
								'NICNT',
								'niveau filter',
								'nor',
								'NotateMe',
								'NoteAlter',
								'NoteFilter',
								'NoteHumanizer',
								'NoteLatch',
								'NotePerformer',
								'NuElectro',
								'NUGEN Audio',
								'NY',
								'NYC',
								'OB',
								'Ocean Swift Synthesis Enterprise The',
								'OCTA',
								'of',
								'off',
								'OK',
								'OldSkoolVerb',
								'oldTimer',
								'oldTimer2',
								'oldTimerMB',
								'OMI',
								'on',
								'OP-X',
								'OPW',
								'or',
								'Orchestral Tools SINE',
								'Orpheus The',
								'OS',
								'OSC',
								'OSL',
								'OVO',
								'PAKs',
								'part',
								'PastToFutureReverbs',
								'PaulXStretch',
								'PCM',
								'per',
								'PF',
								'Phase28',
								'PhaseTool',
								'PhoenixVerb',
								'PhotoScore',
								'PianoVerb2',
								'PIF',
								'PitchShift',
								'PML',
								'pocketBlakus',
								'PoiZone',
								'PolyBrute',
								'PolySirin',
								'PopRock',
								'PopSticks',
								'Positive Grid BIAS',
								'PowerDirector',
								'PowerISO',
								'PPG',
								'PRISM',
								'PRO-II',
								'ProAudio',
								'ProMars',
								'ProWave',
								'ProximityEQ',
								'PRS',
								'PSDN',
								'PSP',
								'PSR',
								'PTF',
								'PX',
								'QuadraChor',
								'QuirQuiQ',
								'r8brain PRO',
								'r8brain',
								'RadioMaximus',
								'Ray5',
								'RC',
								'RE',
								'RealGuitar',
								'RealiBanjo',
								'RealiDrums',
								'RealiWhistle',
								'ReaMIDI',
								'ReaPack',
								'Reason RE',
								'ReCenter',
								'ReDominator',
								'Redoptor2',
								'Reed106',
								'Reed200',
								'reFX Vintage DrumKits',
								'ReSwitch IN',
								'ReSwitch',
								'ReSwitcher',
								'RetroMod',
								'RetroVibes',
								'REV',
								'rev2',
								'ReValver',
								'ReVoicer',
								'RhythmCutter',
								'RIG',
								'RipX',
								'RM 50',
								'RMX',
								'RnB',
								'RND',
								'Roland Cloud Trap X',
								'Roland VS',
								'RoughRider',
								'rtpMIDI',
								'Rucker Collective The Essentials',
								'RX',
								'S2X',
								'Sabroi AS',
								'SampleDelay',
								'SampleTank',
								'SBC',
								'SC',
								'SDRR',
								'SDS',
								'SDSV',
								'SDX',
								'SE',
								'SEIDS',
								'Sequencer Bundle A',
								'SEQui2R',
								'SerumFX',
								'SFX',
								'SG',
								'SH',
								'SH-01A',
								'ShaperBox',
								'Shevannai The',
								'SID',
								'Sinevibes Collection',
								'SIPS',
								'SIV',
								'SJ',
								'SketchCassette',
								'SliceX',
								'SlowMo',
								'SM',
								'SmartEQ',
								'SmartEQ3',
								'SmartScore',
								'SMFX',
								'SNESVerb',
								'SOE',
								'SongKey',
								'Soothe2',
								'Sound Mangling ONE',
								'Sound Mangling TWO',
								'Sound Mangling THREE',
								'SoundWeaver',
								'SP 909',
								'SPAN',
								'SparkVerb',
								'SpectraLayers',
								'SpectralDiff',
								'SPF',
								'Spitfire Audio LABS The',
								'Spitfire Audio LABS',
								'Spitfire Audio Origins The',
								'SplineEQ',
								'SpringBox',
								'SRP',
								'SRX',
								'StereoDelta',
								'STEREOLAB',
								'StereoPan',
								'StereoView',
								'StereoWidth',
								'Store n Forward',
								'Strix Instruments Kangling The',
								'Strobe2',
								'StrumMaker',
								'Stubble07',
								'StudioTools',
								'SubColours',
								'SubCulture',
								'Suit73',
								'SunBox',
								'SuperNATURAL',
								'SuperVolu2',
								'SWAM',
								'SWS',
								'Sylenth1',
								'syntAX',
								'Synth1',
								'SynthMaster',
								'Syntorus2',
								'SYS100M',
								'SZA',
								't00b',
								'TapeEcho',
								'TapinRadio',
								'TATAT',
								'TC',
								'TE',
								'TesslaSE',
								'TGTools',
								'TH',
								'The Sickening',
								'the',
								'ThirtyOne',
								'This Is 909',
								'TI',
								'TiCo',
								'TinyBox',
								'tkDelay',
								'TMB',
								'to',
								'Toontrack EMX The',
								'Toontrack EZX In',
								'Toontrack EZX The',
								'Toontrack SDX The',
								'Toraverb2',
								'TouchOSC',
								'TransMIDIfier',
								'TripleCheese',
								'TripleDrive',
								'TrixMate',
								'TruePianos',
								'TRX',
								'TSM',
								'tuneXplorer',
								'TV',
								'Twisted ReActon',
								'TX16W',
								'UBERLOUD',
								'UDS',
								'UDU',
								'UFO',
								'UFX',
								'UI',
								'UK',
								'UL',
								'UltraMini',
								'UmanskyBass',
								'UnDistort',
								'up',
								'USA',
								'UTL',
								'UVI Falcon Expansion The',
								'UVI Soundbank The',
								'V',
								'v2018',
								'ValhallaDSP',
								'VariSpeed',
								'VC',
								'VeloScaler',
								'VG',
								'VHorns',
								'VHS',
								'VI',
								'via',
								'VII',
								'VIII',
								'VideoMeld',
								'VintageWarmer2',
								'Viola da Gamba',
								'Violin A',
								'Violin B',
								'VIPZONE ',
								'Vir2 Instruments BASiS',
								'Vir2',
								'VisLM',
								'Vocal Tools The',
								'VocalKitchen',
								'VocalSynth',
								'VoiCode',
								'vol',
								'von',
								'VOX Breaking',
								'VOX Future',
								'VOX Purple',
								'VoxChops',
								'Voxengo Span',
								'VReeds',
								'VSM',
								'VSR',
								'VST Buzz',
								'VST',
								'VSTi Scope'
								'VTines',
								'VUMT',
								'WASAPI',
								'WaveLab',
								'WavePad',
								'WaveRunner',
								'WaveShaper',
								'WIPS',
								'WoodBox',
								'WRLD',
								'WT',
								'WTFM',
								'WTV2',
								'X',
								'X3M',
								'XBase',
								'XBass',
								'XBox',
								'XEO',
								'XILS',
								'XImpact',
								'XL',
								'XLN',
								'xLPG',
								'XO',
								'XotoPad',
								'XOXO',
								'XP',
								'XPro',
								'XRATED',
								'XT',
								'XTC',
								'Xtra',
								'XXX',
								'XY',
								'yet',
								'ymVST',
								'ZX'
						)

# regular expression patterns and their replacements to change in unprocessed file names				
$global:patternsToReplace = [ordered]@{
								'\(\)'															= '';
								'\(\s+\)'														= '()';
								'\bv1.0$'														= '';
								'\bv1.0.0$'														= '';
								'(?i)^Roland Cloud\b'											= 'Roland';
								'(?i)(?<!-)(?<!-)\bhihat\b'										= 'hi-hat';
								'(?i)(?<!-)\bhi hat\b'											= 'hi-hat';
								'(?i)(?<!-)(?<!-)\blofi\b'										= 'lo-fi';
								'(?i)(?<!-)\blo fi\b'											= 'lo-fi';
								'(?i)(?<!-)\bhifi\b'											= 'hi-fi';
								'(?i)(?<!-)\bhi fi\b'											= 'hi-fi';
								'(?i)(?<!-)\bhiphop\b'											= 'hip-hop';
								'(?i)(?<!-)\bhip hop\b'											= 'hip-hop';
						}

# developers with dashes will automatically be added to this list
$global:dashesToKeep = @(
								'12-inch',
								'12-string',
								'16-bit',
								'24-bit',
								'26-inch',
								'32-bit',
								'5-string',
								'6-string',
								'64-bit',
								'8-bit',
								'9-string',
								'A-Range',
								'A-Series',
								'Ad-Libs',
								'Alt-Rock',
								'Auto-Align',
								'Auto-Tune',
								'Auto-Vari',
								'B-3X',
								'Band-Splitter',
								'Break-able',
								'C-605P',
								'Capella-Scan',
								'Clar-Duduk',
								'CP-70',
								'CV-I',
								'CV-O',
								'Damm-Space',
								'De-esser',
								'De-Esser',
								'Dyna-Mite',
								'E-Oud',
								'Elixer - The Lost Tapes',
								'Ernesto vs. Bastian',
								'ES-01',
								'EVE-AT1',
								'EVE-AT4',
								'EVE-MP5',
								'F-em',
								'G-Brass',
								'HG-2',
								'Hi-Fi',
								'Hip-Hop',
								'HY-SeqCollection2',
								'In-Serenity',
								'InfoBay-In',
								'InfoBay-Out',
								'IQ-Limiter',
								'IQ-Reverb',
								'IRCAM Lab The',
								'Isolate-X',
								'J-Trick',
								'JD-Xi'
								'JP-08',
								'JU-06A',
								'JUNO-106',
								'JUNO-60',
								'JUPITER-8',
								'JX-3P',
								'JX-8P',
								'K-Devices',
								'K-Size',
								'Kawai-EX',
								'LF-Max',
								'LF-Punch',
								'LM-Correct',
								'Lo-Fi',
								'MDE-X',
								'Mel-Lofi',
								'Mercury-4',
								'MINI-NICNT',
								'Modern Hip-Hop Beats',
								'Neo-Soul',
								'Nu-Disco',
								'OB-E',
								'One-Shot',
								'One-Shots',
								'One-Words',
								'OP-X',
								'PeQ-213',
								'Plug-ins',
								'Pop-Funky',
								'Pop-Rock',
								'Post-Rock',
								'Pro-II',
								'Pro-R',
								'R-50e',
								'Rave-O-Lution',
								'Re-Code',
								'Re-Strings',
								'Re-Tron',
								'RE-Vision',
								'Retro-fi',
								'Rhythm-1',
								'RX-21L',
								'S-Gear',
								'Sci-Fi',
								'SDZ001-100',
								'Semi-Hollow',
								'SH-01A',
								'Sly-Fi',
								'smart-comp',
								'smart-limit',
								'smart-reverb',
								'Strontium-90',
								'Sub-Tone',
								'Super-7',
								'SVT-VR',
								'SY85-TG500',
								'Synth-Pop',
								'Synth-Werk',
								'SYSTEM-100',
								'SYSTEM-8',
								'T-RackS',
								'Tech-House',
								'TG-8H',
								'TAL-U-NO-LX',
								'TH-U',
								'TH-U',
								'TR-8S',
								'TR-8S',
								'TSAR-1R',
								'Tube-Tech',
								'Twin-L',
								'Two-faces',
								'u-he',
								'Ultra TKT',
								'UVX-10P',
								'UVX-3P',
								'V-Cii',
								'V-Collection',
								'V-Metal',
								'V-Station',
								'W-Bagpipes',
								'W-DirectBass',
								'W-FabBass',
								'W-Flugelhorn',
								'W-Shaker',
								'W-Timpani',
								'W-TubularBells',
								'W-Xylophone',
								'WURL-e',
								'X-EIGHT',
								'X-Loops'
						)

# developers with periods will automatically be added to this list
$global:periodsToKeep = @(
								'Dr. Dre',
								'Ernesto vs. Bastian',
								'H.A.L.',
								'ha.pi',
								'lo.ki',
								'Mr.',
								'No.',
								'ro.ki',
								'VI.ONE',
								'www.zonatorrent.com'
						)

# developers with commas will automatically be added to this list
$global:commasToKeep = @(
								'666, The Sickening',
								'Brass, Percussion, Timpani',
								'Brushes, Rods, and Mallets',
								'DR-55, DR-110, DR-220',
								'Sylenth1,',
								'Serum,',
								'Spire,',
								'TGX-85, Yamaha',
								'Vocals, Chants,',
								'Basses, Pads,'
						)
						
# developers with underscores will automatically be added to this list
$global:underscoresToKeep = @(
								'bx_cleansweep',
								'bx_console',
								'bx_masterdesk',
								'bx_oberhausen',
								'bx_rockrack',
								'bx_solo',
								'bx_subfilter'
						)

# phrases that aren't capitalized even at the start of a title
# developers starting with lowercase letters will automatically be added to this list
$global:exceptionsToFirstWordCapital = @(
								'iLok'
						)		

# directories that are not optimized if they are the only directory
$global:directoriesToIgnoreForOptimize = @(
								'Documentation',
								'Installer',
								'Instruments',
								'Resources',
								'Samples',
								'Snapshots',
								'vst'
						)						

# reserverd phrases that should be ignored when listing arhives
$global:sevenZipReservedPhrases = @(
								'7-Zip',
								'Error',
								'Warning',
								'Listing archive',
								'Path = ',
								'Physical Size = ',
								'Tail Size = ',
								'Solid = ',
								'Blocks = ',
								'Encrypted = ',
								'Multivolume = ',
								'Volumes = ',
								'Type = ',
								'Characteristics = ',
								'Volume Index = ',
								'Scanning the drive for archives:',
								'Total Physical Size =',
								'Total archives size:'
						)
								
# when the platform type is EXE, these phrases in the path map to these platforms
$global:pathExePlatforms = @{
								'3DElite'								= @('EXE');
								'Aberrant DPS'							= @('VST2', 'VST3');
								'Accentize'								= @('VST2', 'VST3');
								'Acon Digital Acoustica'				= @('EXE');
								'Acon Digital'							= @('VST2', 'VST3');
								'AIR Music Technology'					= @('VST2', 'VST3');
								'Ample Sound'							= @('NativeInstrumentsKontaktLibrary');
								'Arturia'								= @('VST2', 'VST3');
								'Assistant'								= @('EXE');
								'Audiomodern'							= @('VST2', 'VST3');
								'BBE Sound'								= @('VST2', 'VST3');
								'Black Salt Audio'						= @('VST2', 'VST3');
								'Blue Cat Audio'						= @('VST2', 'VST3');
								'Caelum Audio'							= @('VST3');
								'Celemony'								= @('EXE');
								'Cherry Audio'							= @('VST2', 'VST3', 'EXE');
								'Credland Audio'						= @('VST2', 'VST3');
								'Cycling 74'							= @('EXE');
								'Downloader'							= @('EXE');
								'Excite Audio'							= @('VST2', 'VST3');
								'FabFilter'								= @('VST2', 'VST3');
								'Freakshow Industries'					= @('VST2', 'VST3');
								'Initial Audio'							= @('VST2');
								'iZotope'								= @('VST2', 'VST3', 'EXE');
								'Kia'									= @('VST2');
								'Klevgrand'								= @('VST2');
								'Kong Audio'							= @('NativeInstrumentsKontaktLibrary');
								'Korg'									= @('VST2');
								'Kushview'								= @('VST2', 'VST3');
								'License Manager'						= @('EXE');
								'Manager'								= @('EXE');
								'Music Developments'					= @('VST2', 'VST3');
								'Musio'									= @('EXE');
								'Native Access'							= @('EXE');
								'Native Instruments'					= @('NativeInstrumentsKontaktLibrary');
								'Nomad Factory'							= @('VST2', 'VST3');
								'Overloud'								= @('VST2');
								'Physical Audio'						= @('VST2', 'VST3');
								'Player'								= @('EXE');
								'Polyverse Music'						= @('VST2');
								'Rolie Blocks'							= @('RoliBlocks');
								'Rolie Equator'							= @('RoliEquator');
								'Samplescience'							= @('VST2', 'VST3');
								'Schaack Audio Technologies'			= @('VST2');
								'Software Center'						= @('EXE');
								'Steinberg'								= @('EXE');
								'Toontrack'								= @('VST2', 'VST3', 'EXE');
								'Venomode'								= @('VST2');
								'Vienna Ensemble'						= @('EXE');
								'WAVDSP'								= @('VST2');
								'Xfer Records'							= @('VST2');
								'XLN Audio'								= @('VST2');
						}

# when the platform type is not a match, these phrases in the path map to these platforms
$global:pathNonMatchPlatforms = @{
					
						}																									

# phrases to identify XSample products, to skip
$global:xsamplePhrases = @(
								'xsample',
								'xl_',
								'xhl_',
								'xpe_',
								'xail_',
								'xl.ini'
						)

# phrases to exclude from expansion replacements
$global:expansionReplacementExceptions = @(
								'kyurumi pack',
								'level 8 pack',
								'modulation patches',
								'moog patches',
								'retlav pack',
								'sample pack',
								'wavetable pack'
						)

# phrases to identify expansions
$global:expansionIndicators = @(
								'bank',
								'banks',
								'content',
								'expansion',
								'pack',
								'packs',
								'patches',
								'presets',
								'sound bank',
								'sound banks',
								'sound kit',
								'soundbank',
								'soundbanks'
						)
						
# standardized terms for expansions
$global:expansionHosts = @{
								'0-Coast'								= 'Make Noise 0-Coast';
								'Ableton'								= 'Ableton Live';
								'Abstract Vox'							= 'Digital Pro Sounds Abstract Vox';
								'Absynth'								= 'Native Instruments Absynth';
								'Absynth 4'								= 'Native Instruments Absynth 4';
								'Absynth 5'								= 'Native Instruments Absynth 5';
								'AIRA TB-3 Touch Bassline'				= 'Roland AIRA TB-3 Touch Bassline';
								'AIRA TR-8S'							= 'Roland AIRA TR-8S';
								'AmberWood Drums'						= 'YummyBeats AmberWood Drums';
								'AmberWood'								= 'YummyBeats AmberWood Drums';
								'Ambition'								= 'Sound Yeti Ambition';
								'Ana 2'									= 'Slate Digital Ana 2';
								'Ana'									= 'Slate Digital Ana 2';
								'Analog 4 and Digitone'					= 'Elektron Analog 4 and Digitone';
								'Analog Four MkII'						= 'Elektron Analog Four MkII';
								'Analog Lab V'							= 'Arturia Analog Lab V';
								'Analog Rytm MkII'						= 'Elektron Analog Rytm MkII';
								'Analog V'								= 'Arturia Analog Lab V';
								'Anyma Phi'								= 'Aodyo Instruments Anyma Phi';
								'Arcade'								= 'Output Arcade';
								'Argon8'								= 'Modal Electronics Argon8';
								'Avenger'								= 'Vengeance Sound Avenger';
								'Band in a Box'							= 'PG Music Band in a Box';
								'Bass Station II'						= 'Novation Bass Station II';
								'Battery and Kontakt'					= 'Native Instruments Battery and Kontakt';
								'Battery'								= 'Native Instruments Battery';
								'BBC2'									= 'TEControl BBC2';
								'BeatStep Pro'							= 'Arturia BeatStep Pro';
								'BFD'									= 'inMusic Brands BFD';
								'BFD3'									= 'inMusic Brands BFD3';
								'Blocks'								= 'Roli Blocks';
								'Blofeld'								= 'Waldorf Blofeld';
								'Boutique D-05'							= 'Roland Boutique D-05';
								'Boutique JP-08'						= 'Roland Boutique JP-08';
								'Boutique JU-06A'						= 'Roland Boutique JU-06A';
								'Boutique JX-03'						= 'Roland Boutique JX-03';
								'Boutique K-25m Keyboard'				= 'Roland Boutique K-25m Keyboard';
								'Boutique SE-02'						= 'Roland Boutique SE-02';
								'Boutique SH-01A'						= 'Roland Boutique SH-01A';
								'Cat'									= 'Behringer Cat';
								'ChordPotion'							= 'FeelYourSound ChordPotion';
								'Circuit Mono Station'					= 'Novation Circuit Mono Station';
								'Circuit'								= 'Novation Circuit';
								'Cobalt5S'								= 'Modal Electronics Cobalt5S';
								'Cobalt8'								= 'Modal Electronics Cobalt8';
								'Craft Synth 2.0'						= 'Modal Electronics Craft Synth 2.0';
								'Crave'									= 'Behringer Crave';
								'Cthulhu'								= 'Xfer Records Cthulhu';
								'CTK-3500'								= 'Casio CTK-3500';
								'CTK-4400'								= 'Casio CTK-4400';
								'Cubase and Nuendo'						= 'Steinberg Cubase and Nuendo';
								'Cubase'								= 'Steinberg Cubase';
								'CUBE'									= 'Lunacy Audio CUBE';
								'D-50'									= 'Roland D-50';
								'Dark Zebra'							= 'u-he Dark Zebra';
								'Decent Sampler'						= 'Decent Samples Decent Sampler';
								'Decent'								= 'Decent Samples Decent Sampler';
								'DeepMind 12'							= 'Behringer DeepMind 12';
								'DeepMind'								= 'Behringer DeepMind';
								'Deluge'								= 'Synthstrom Deluge';
								'DFAM'									= 'Moog DFAM';
								'Digitakt'								= 'Elektron Digitakt';
								'Digitone'								= 'Elektron Digitone';
								'Diva'									= 'u-he Diva';
								'Dorico'								= 'Steinberg Dorico';
								'DrumBrute Impact'						= 'Arturia DrumBrute Impact';
								'Dune 3'								= 'Synapse Audio Dune';
								'Dune'									= 'Synapse Audio Dune';
								'DX7'									= 'Yamaha DX7';
								'eDNA Earth'							= 'Spitfire Audio eDNA Earth';
								'Elastik'								= 'Ueberschall Elastik';
								'Electra'								= 'Tone2 Electra';
								'Electribe 2'							= 'Korg Electribe 2';
								'Elmyra'								= 'Neutral Labs Elmyra';
								'EPS'									= 'Ensoniq EPS';
								'Erae Touch'							= 'Embodme Erae Touch';
								'Erebus v3'								= 'Dreadbox Erebus v3';
								'Ethera Gold'							= 'Zero-G Ethera Gold';
								'Evolver'								= 'Sequential Evolver';
								'EZbass'								= 'Toontrack EZbass';
								'EZkeys'								= 'Toontrack EZkeys';
								'Falcon'								= 'UVI Falcon';
								'FANTOM'								= 'Roland Cloud FANTOM';
								'Finale'								= 'MakeMusic Finale';
								'Fire'									= 'Akai Fire';
								'FL Studio'								= 'Image-Line FL Studio';
								'FM7'									= 'Native Instruments FM7';
								'FM8'									= 'Native Instruments FM8';
								'Generate'								= 'Newfangled Audio Generate';
								'Grandmother'							= 'Moog Grandmother';
								'HALion'								= 'Steinberg HALion';
								'Heat Up'								= 'Initial Audio Heat Up';
								'Hive'									= 'u-he Hive';
								'Hydrasynth'							= 'ASM Hydrasynth';
								'Impact LX88+'							= 'Nektar Impact LX88+';
								'InstaChord'							= 'W. A. Production InstaChord';
								'Iris 2'								= 'iZotope Iris';
								'Iris'									= 'iZotope Iris';
								'JD-Xi'									= 'Roland JD-Xi';
								'Jupiter Xm'							= 'Roland Jupiter Xm';
								'K-2'									= 'Behringer K-2';
								'Kaoss Pad KP3+'						= 'Korg Kaoss Pad KP3+';
								'Kaoss Pad Quad'						= 'Korg Kaoss Pad Quad';
								'Kaossilator 2S'						= 'Korg Kaossilator 2S';
								'Kastle Drum'							= 'Bastl Instruments Kastle Drum';
								'Keylab 88 MkII'						= 'Arturia Keylab 88 MkII';
								'Keyscape and Omnisphere'				= 'Spectrasonics Keyscape and Omnisphere';
								'Keystation 88 Mk3'						= 'M-Audio Keystation 88 Mk3';
								'KeyStep Pro'							= 'Arturia KeyStep Pro';
								'Komplete Kontrol S61 Mk2'				= 'Native Instruments Komplete Kontrol S61 Mk2';
								'Komplete Kontrol'						= 'Native Instruments Komplete Kontrol';
								'Kontakt'								= 'Native Instruments Kontakt';
								'Launchpad Pro Mk3'						= 'Novation Launchpad Pro Mk3';
								'Lightpad Block M Studio Edition'		= 'ROLI Lightpad Block M Studio Edition';
								'Live'									= 'Ableton Live';
								'Liven XFM'								= 'Sonicware Liven XFM';
								'Lumi Studio Edition'					= 'ROLI Lumi Studio Edition';
								'M2'									= 'MOTU M2';
								'Maschine Mk3'							= 'Native Instruments Maschine Mk3';
								'Maschine'								= 'Native Instruments Maschine';
								'Massive X'								= 'Native Instruments MassiveX';
								'Massive'								= 'Native Instruments Massive';
								'MassiveX'								= 'Native Instruments MassiveX';
								'Max for Live'							= 'Ableton Max for Live';
								'MC-101'								= 'Roland MC-101';
								'Medusa v2'								= 'Polyend-Dreadbox Medusa v2';
								'MicroBrute'							= 'Arturia MicroBrute';
								'MicroFreak'							= 'Arturia MicroFreak';
								'Microkorg S'							= 'Korg Microkorg S';
								'Micromonsta 2'							= 'Audiothingies Micromonsta 2';
								'MIDI Fighter Twister'					= 'DJ Techtools MIDI Fighter Twister';
								'MIDI Merge 4'							= 'Midiplus MIDI Merge 4';
								'MIDIHub'								= 'Blokas MIDIHub';
								'MiniBrute 2S'							= 'Arturia MiniBrute 2S';
								'MiniBrute'								= 'Arturia MiniBrute 2S';
								'MiniLab Mk2'							= 'Arturia MiniLab Mk2';
								'Minilogue XD'							= 'Korg Minilogue XD';
								'Minilogue XD, Prologue, or NTS-1'		= 'Korg Minilogue XD, Prologue, or NTS-1';
								'Minilogue'								= 'Korg Minilogue';
								'Mininova'								= 'Novation Mininova';
								'Minitaur'								= 'Moog Minitaur';
								'Model D'								= 'Behringer Model D';
								'Model:Cycles'							= 'Elektron Model:Cycles';
								'Modwave'								= 'Korg Modwave';
								'Monark'								= 'Native Instruments Monark';
								'Monologue'								= 'Korg Monologue';
								'Monotron Delay'						= 'Korg Monotron Delay';
								'Monotron Duo'							= 'Korg Monotron Duo';
								'Monotron'								= 'Korg Monotron';
								'Mopho'									= 'Sequential Mopho';
								'MRCC'									= 'Conductive Labs MRCC';
								'MX-1'									= 'Roland MX-1';
								'nanoKey2'								= 'Korg nanoKey2';
								'nanoKontrol2'							= 'Korg nanoKontrol2';
								'nanoPad2'								= 'Korg nanoPad2';
								'NDLR'									= 'Conductive Labs NDLR';
								'Nebula'								= 'Acustica Audio Nebula';
								'Neutron'								= 'Behringer Neutron';
								'Nexus'									= 'reFX Nexus';
								'nn-xt'									= 'Reason Studios nn-xt Advanced Sampler';
								'nn-xt Advanced Sampler'				= 'Reason Studios nn-xt Advanced Sampler';
								'NTS-1'									= 'Korg NTS-1';
								'Nyx v2'								= 'Dreadbox Nyx v2';
								'OB-6'									= 'Sequential OB-6';
								'Octatrack MkII'						= 'Elektron Octatrack MkII';
								'Odyssey'								= 'Behringer Odyssey';
								'Omnisphere'							= 'Spectrasonics Omnisphere';
								'OP-1'									= 'Teenage Engineering OP-1';
								'opsix'									= 'Korg opsix';
								'Pathfinder WT'							= 'Ocean Swift Synthesis Pathfinder WT';
								'Pathfinder'							= 'Ocean Swift Synthesis Pathfinder WT';
								'Peak and Summit'						= 'Novation Peak and Summit';
								'Peak'									= 'Novation Peak';
								'Pigments'								= 'Arturia Pigments';
								'PlantWave'								= 'PlantWave PlantWave';
								'PO-12 Rhythm'							= 'Teenage Engineering PO-12 Rhythm';
								'PO-14 Sub'								= 'Teenage Engineering PO-14 Sub';
								'PO-16 Factory'							= 'Teenage Engineering PO-16 Factory';
								'PO-20 Arcade'							= 'Teenage Engineering PO-20 Arcade';
								'PO-24 Office'							= 'Teenage Engineering PO-24 Office';
								'PO-28 Robot'							= 'Teenage Engineering PO-28 Robot';
								'PO-32 Tonic'							= 'Teenage Engineering PO-32 Tonic';
								'PO-33 K.O!'							= 'Teenage Engineering PO-33 K.O!';
								'PO-35 Speak'							= 'Teenage Engineering PO-35 Speak';
								'PolyBrute'								= 'Arturia PolyBrute';
								'Portal'								= 'Output Portal';
								'Pro-1'									= 'Behringer Pro-1';
								'Proclethya'							= 'Dymai Sound Proclethya';
								'Prophet-6'								= 'Sequential Prophet-6';
								'Push 2'								= 'Ableton Push 2';
								'Pyramid'								= 'Squarp Pyramid';
								'Quantum'								= 'Emergence Audio Quantum';
								'R-07 Handheld Recorder'				= 'Roland R-07 Handheld Recorder';
								'RC-20'									= 'XLN Audio RC-20';
								'RC-202'								= 'Boss RC-202';
								'RD-6'									= 'Behringer RD-6';
								'RD-8'									= 'Behringer RD-8';
								'Reaktor'								= 'Native Instruments Reaktor';
								'Reaper'								= 'Cockos Reaper';
								'Reface CP'								= 'Yamaha Reface CP';
								'Reface CS'								= 'Yamaha Reface CS';
								'Reface DX'								= 'Yamaha Reface DX';
								'Reface YC'								= 'Yamaha Reface YC';
								'Repro'									= 'u-he Repro';
								'REV'									= 'Output REV';
								'RK-006 Portable USB MIDI/Gate Hub'		= 'Retrokits RK-006 Portable USB MIDI/Gate Hub';
								'Roland Cloud FANTOM'					= 'Roland Cloud FANTOM';
								'Roland Cloud'							= 'Roland Cloud';
								'Scaler'								= 'Plugin Boutique Scaler';
								'Scorch'								= 'Sauceware Audio Scorch';
								'Seaboard Rise 49'						= 'ROLI Seaboard Rise 49';
								'Sektor'								= 'Initial Audio Sektor';
								'Serum'									= 'Xfer Records Serum';
								'Shreddage'								= 'Impact Soundworks Shreddage';
								'Sibelius'								= 'Avid Sibelius';
								'Slice'									= 'Initial Audio Slice';
								'SP-404A'								= 'Roland SP-404A';
								'Spire'									= 'Reveal Sound Spire';
								'SQ-1'									= 'Korg SQ-1';
								'SQ-64'									= 'Korg SQ-64';
								'Strega'								= 'Make Noise Strega';
								'Streichfett'							= 'Waldorf Streichfett';
								'Strike MultiPad'						= 'Alesis Strike MultiPad';
								'String'								= 'Loomer String';
								'Studio One'							= 'PreSonus Studio One';
								'Subharmonicon'							= 'Moog Subharmonicon';
								'SubLab'								= 'Future Audio Workshop SubLab';
								'Substance'								= 'Output Substance';
								'Summit'								= 'Novation Summit';
								'Sundog and ChordPotion'				= 'FeelYourSound Sundog and ChordPotion';
								'Sundog'								= 'FeelYourSound Sundog';
								'Surge Mesh'							= 'Alesis Surge Mesh';
								'Sylenth'								= 'LennarDigital Sylenth1';
								'Sylenth1'								= 'LennarDigital Sylenth1';
								'Synth V'								= 'Dreamtonics Synthesizer V';
								'Synthesizer V'							= 'Dreamtonics Synthesizer V';
								'SynthV'								= 'Dreamtonics Synthesizer V';
								'TAL-U-NO-LX'							= 'TAL Software TAL-U-NO-LX';
								'TD-3'									= 'Behringer TD-3';
								'Tetra'									= 'Dave Smith Instruments Tetra';
								'The Dust Collector'					= 'Finegear The Dust Collector';
								'Thermal'								= 'Output Thermal';
								'Touch Control'							= 'ROLI Touch Control';
								'TR-8S'									= 'Roland TR-8S';
								'Tracker'								= 'Polyend Tracker';
								'Typhon'								= 'Dreadbox Typhon';
								'Unify'									= 'PlugInGuru Unify';
								'UNO Drum'								= 'IK Multimedia UNO Drum';
								'UNO Synth'								= 'IK Multimedia UNO Synth';
								'Urban Heat'							= 'Studio Trap Sounds Urban Heat';
								'UVI'									= 'UVI Workstation';
								'Vector'								= 'Beetlecrab s.r.o. Vector';
								'Verselab MV-1'							= 'Roland Verselab MV-1';
								'VirtualCZ'								= 'Plugin Boutique VirtualCZ';
								'Vital'									= 'Vital Audio Vital';
								'Volca Bass'							= 'Korg Volca Bass';
								'Volca Beats'							= 'Korg Volca Beats';
								'Volca Drum'							= 'Korg Volca Drum';
								'Volca FM'								= 'Korg Volca FM';
								'Volca Keys'							= 'Korg Volca Keys';
								'Volca Kick'							= 'Korg Volca Kick';
								'Volca Modular'							= 'Korg Volca Modular';
								'Volca Nubass'							= 'Korg Volca Nubass';
								'Volca Sample 2'						= 'Korg Volca Sample 2';
								'Volca Sample'							= 'Korg Volca Sample';
								'VT-4'									= 'Roland VT-4';
								'Wasp Deluxe'							= 'Behringer Wasp Deluxe';
								'Wave'									= 'Genki Instruments Wave';
								'Wavestate'								= 'Korg Wavestate';
								'Werkstatt-01'							= 'Moog Werkstatt-01';
								'X-Touch'								= 'Behringer X-Touch';
								'Zebra'									= 'u-he Zebra';
								'Zebra2'								= 'u-he Zebra2';
						}
						
# exception terms for expansions
$global:expansionExceptions = @(
								'Dorico Pro 4 Content',
								'Factory Presets',
								'HALion Sonic 3 Content',
								'HALion Sonic SE 3 Content',
								'Initial Audio Sektor Content',
								'Max for Live Essentials',
								'Miami Guitar',
								'Micro Massive Presets',
								'MIDI Pack',
								'Nord Modular Pack',
								'Patches Project Files',
								'Plugin Boutique VirtualCZ',
								'Sample Pack',
								'Soundbanks Big Collection',
								'Thermal',
								'Vocal Hazard Pack',
								'VST Live Pro'
						)

$global:specialExpansionFunctions = @{
								'Native Instruments'					= 'Get-ExpansionNativeInstruments';
								'Reason Studios'						= 'Get-ExpansionReasonStudios';
								'UVI'									= 'Get-ExpansionUvi';
						}
						
$global:nativeInstrumentsExpansions =
								@{
								'Amplified Funk'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Anima Ascent'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Aquarius Earth'						= @('Samples', 'Maschine', 'Battery', 'Monark')
								'Arcane Attic'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Artist Expansion Dj Khalil'			= @('Samples', 'Battery', 'Maschine', 'Monark')
								'Artist Expansion Sasha'				= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Artist Expansion The Stereotypes'		= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Astral Flutter'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Backyard Jams'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Basement Era'							= @('Samples', 'Maschine', 'Battery')
								'Black Arc'								= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Body Mechanik'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Bumpin Flava'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Burnt Hues'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Byte Riot'								= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Carbon Decay'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Caribbean Current'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Cavern Floor'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Certified Gold'						= @('Samples', 'Battery', 'Reaktor', 'Prism', 'Monark', 'Maschine')
								'Circuit Halo'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Reaktor', 'Prism')
								'Conant Gardens'						= @('Samples', 'Maschine', 'Battery')
								'Crate Cuts'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Crystal Daggers'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Dark Pressure'							= @('Samples', 'Maschine', 'Battery')
								'Decoded Forms'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Prism', 'Reaktor')
								'Deep Matter'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'District Xeo'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Drop Squad'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Elastic Thump'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Electric Touch'						= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Faded Reels'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Global Shake'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Golden Kingdom'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Grey Forge'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Halcyon Sky'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Reaktor', 'Prism')
								'Headland Flow'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Prism', 'Reaktor')
								'Helios Ray'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Hexagon Highway'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Ignition Code'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Indigo Dust'							= @('Samples', 'Maschine', 'Battery', 'Monark', 'Reaktor', 'Prism')
								'Infamous Flow'							= @('Samples', 'Maschine', 'Battery', 'Monark', 'Reaktor', 'Prism')
								'Infinite Escape'						= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Lazer Dice'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Lilac Glare'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Liquid Energy'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Lockdown Grind'						= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'London Grit'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Lone Forest'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Prism', 'Reaktor')
								'Lucid Mission'							= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Lunar Echoes'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Magnate Hustle'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Magnetic Coast'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Marble Rims'							= @('Samples', 'Maschine', 'Battery')
								'Massive Expansion Bump'				= @('Massive')
								'Massive Expansion Nocturnal State'		= @('Massive')
								'Massive Expansion Spectrum Quake'		= @('Massive')
								'Massive Expansion Stadium Flex'		= @('Massive')
								'Massive X Expansion Moebius'			= @('Massive X')
								'Massive X Expansion Our House'			= @('Massive X')
								'Massive X Expansion Pulse'				= @('Massive X')
								'Massive X Expansion Quest'				= @('Massive X')
								'Massive X Expansion Rush'				= @('Massive X')
								'Massive X Expansion Scene'				= @('Massive X')
								'Meteoric Rise'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Midnight Sunset'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Molten Veil'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Mother Board'							= @('Battery', 'Maschine', 'Massive', 'Monark')
								'Motor Impact'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Neo Boogie'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark', 'Prism')
								'Neon Drive'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Prism', 'Reaktor')
								'Opaline Drift'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Paradise Rinse'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Platinum Bounce'						= @('Samples', 'Maschine', 'Battery')
								'Polar Flare'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Prismatic Bliss'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Reaktor', 'Prism')
								'Prospect Haze'							= @('Samples', 'Maschine', 'Battery')
								'Pulswerk'								= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Pure Drip'								= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Queensbridge Story'					= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Radiant Horizon'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Raw Voltage'							= @('Samples', 'Maschine', 'Battery')
								'Resonant Blaze'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Rhythm Source'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Rising Crescent'						= @('Samples', 'Maschine', 'Battery', 'Massive', 'Prism', 'Reaktor')
								'Sacred Futures'						= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark', 'Reaktor')
								'Satin Looks'							= @('Samples', 'Battery', 'Maschine', 'Monark', 'Prism')
								'Sierra Grove'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Solar Breeze'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Monark')
								'Soul Magic'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'Static Friction'						= @('Samples', 'Maschine', 'Battery', 'Massive')
								'Street Swarm'							= @('Samples', 'Maschine', 'Battery', 'Monark', 'Prism', 'Reaktor')
								'Timeless Glow'							= @('Samples', 'Maschine', 'Battery', 'Kits', 'Massive', 'Monark', 'Reaktor', 'Prism')
								'Transistor Punch'						= @('Samples', 'Maschine', 'Battery')
								'Trill Rays'							= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
								'True School'							= @('Samples', 'Maschine', 'Battery')
								'Velvet Lounge'							= @('Samples', 'Maschine', 'Battery', 'Massive', 'Prism', 'Reaktor')
								'Vintage Heat'							= @('Samples', 'Maschine', 'Battery')
								'Warped Symmetry'						= @('Samples', 'Battery', 'Maschine', 'Massive', 'Monark')
						}
								
# list of all developers
$global:developers = 			@(
								"D'Addario",
								"Hit'n'Mix",
								"Levy's Leathers",
								'1oogames',
								'2320 Click Entertainment',
								'2CAudio',
								'2MGT',
								'344 Audio',
								'3delite',
								'3M',
								'4Front',
								'4Knob',
								'5DOLLAKITS',
								'5Pin Media',
								'789Ten',
								'7Aliens',
								'8Dio',
								'91Vocals',
								'A Samples',
								'A.O.M.',
								'Aaron Venture',
								'Abelssoft',
								'Aberrant DSP',
								'Ableton',
								'Abletunes',
								'Abstract Sounds',
								'Abyssmedia',
								'Accentize',
								'Access',
								'Accusonus',
								'Ace Electronics',
								'Acon Digital',
								'Acon',
								'Acoustica',
								'Acousticsamples',
								'Acustica Audio',
								'Adam',
								'ADPTR AUDIO',
								'ADSR Sounds',
								'Adult Porn Sound Effects',
								'Aelyx Audio',
								'Aeon Payne',
								'AHS',
								'AIR Music Technology',
								'Aiyn Zahev Sounds',
								'Akai',
								'AKG Acoustics',
								'Alan Aztec',
								'Alchemy',
								'Alesis',
								'Alex Pfeffer',
								'Alex Retsis',
								'AlexB',
								'Alexkid',
								'Algonaut',
								'Alkman',
								'Alonso Sound',
								'Altar of Wisdom',
								'Amazon Basics',
								'Amazon',
								'Ampeg',
								'Ample Sound',
								'Amumu',
								'Analog Cases',
								'Analogue Drums',
								'Analogue',
								'Ancore Sounds',
								'Andante Instruments',
								'Andoer',
								'Andreas Pohl',
								'Angular Momentum',
								'Antares',
								'Anton Anru',
								'Aodyo Instruments',
								'Apisonic Labs',
								'Apollo Sound',
								'App Sound',
								'Apple',
								'Applied Acoustics Systems',
								'araabMUZIK x The Rucker Collective',
								'Arabic World Plugins',
								'Arctic Eagle',
								'Arduino',
								'Aria Sounds',
								'Arksun-Sound',
								'Arobas Music',
								'Art Vista',
								'ART',
								'Artall',
								'Arteria',
								'Articulated Sounds',
								'Artistry Audio',
								'ArtsAcoustic',
								'Arturia',
								'Asendo',
								'Ashampoo',
								'ASM',
								'Asonic',
								'Asus',
								'Atom Hub',
								'Aubit',
								'Auburn Sounds',
								'Audacity',
								'Auddict',
								'Audentity Records',
								'AudeoBox',
								'Audiffex',
								'Audio Blast',
								'Audio Boost',
								'Audio Brewers',
								'Audio Damage',
								'Audio Ease',
								'Audio Imperia',
								'Audio Juice',
								'Audio Modeling',
								'Audio Nebula',
								'Audio Ollie',
								'Audio Reward',
								'Audio-Technica',
								'AudioBoost',
								'Audiobro',
								'AudioCipher',
								'AudioCypher',
								'Audiofier',
								'AudioFriend',
								'Audiogrocery',
								'Audiolatry',
								'Audiologie',
								'Audiomodern',
								'Audiority',
								'Audiotent',
								'AudioThing',
								'Audiothingies',
								'Audority and Chris Hein',
								'Aura Qualic',
								'Aurora DSP',
								'Aux Urban',
								'Ava Music Group',
								'Avant',
								'Avantone',
								'Avid',
								'Aviram',
								'AVLT',
								'Avosound',
								'Awwbees',
								'Axiomatic Universe',
								'Aypebeatz',
								'Baauer',
								'Baby Audio',
								'Babylonwaves',
								'Bace Technologies',
								'Bastl Instruments',
								'Baulerd',
								'Baywood Audio',
								'BBC',
								'BBE Sound',
								'Be Wary Software',
								'Beat Butcha',
								'Beautiful Void Audio',
								'Beatmasters',
								'Beatnick Dee',
								'Beatrising',
								'Beatsburg',
								'Beatskillz',
								'Bechstein Digital',
								'Beetlecrab s.r.o.',
								'Behringer',
								'Bela D Media',
								'Belkin',
								'Bellatrix Audio',
								'Ben Osterhouse',
								'Best Service',
								'BFractal Music',
								'Big 5 Audio',
								'Big Bob',
								'Big Citi Loops',
								'Big EDM',
								'Big Fish Audio',
								'Big Room Sound',
								'BigSwingFace',
								'Bilione',
								'bitley sounds & refills',
								'Bitwig',
								'Blackmagic Design',
								'Black Box Analog Design',
								'Black Octopus Sound',
								'Black Rooster Audio',
								'Black Salt Audio',
								'Blakus',
								'BlankFor.ms',
								'BLEASS',
								'Blokas',
								'Blucoil',
								'Blue Cat Audio',
								'Blue',
								'BlueLab',
								'Bluezone',
								'Blvckout',
								'Bob Zawalich',
								'Bobby Blues',
								'Bolder Sounds',
								'Bollywood Sounds',
								'Boom Library',
								'Boris FX',
								'Boss',
								'Bovke',
								'Boz Digital Labs',
								'Brainworx',
								'Brandon Chapa',
								'Brett Lavallee',
								'BroBeatz',
								'Bunker 8 Digital Labs',
								'Bunker Samples',
								'Busy Works Beats',
								'BVA',
								'C.A Sound',
								'C2G',
								'Cable Matters',
								'CableClips',
								'CableCreation',
								'Cableguys',
								'Caelum Audio',
								'Cahaya',
								'Caline',
								'Camel Audio',
								'CanaKit',
								'Capella Software',
								'Capsun ProAudio',
								'Carma Studio',
								'Cartel Loops',
								'Cartel Sounds',
								'Casematix',
								'Casio',
								'Cecilio',
								'Celemony',
								'Chakev',
								'Chase Vibez',
								'Che',
								'Cherry Audio',
								'Chocolate Audio',
								'ChordWizard',
								'ChowDSP',
								'Chris Hein',
								'Christian Budde',
								'Christofmuc',
								'ChromaCast',
								'Chroí Music',
								'Cinematic Samples',
								'Cinematique Instruments',
								'Cinesamples',
								'Cinetools',
								'Cinetrance',
								'Cj Rhen',
								'Clark Audio',
								'Clark Samples',
								'Clayton',
								'Cloud Microphones',
								'Cloudmusic',
								'Cloudy Samples',
								'CMusic Production',
								'Cntrl Samples',
								'co2crea',
								'Cockos',
								'CodeFN42',
								'COLOVE',
								'Colugo',
								'Composers Tools',
								'Concept Samples',
								'Conductive Labs',
								'Continuata',
								'Cookin Soul',
								'Corsair',
								'Cradle and Jaycen Joshua',
								'Crampe',
								'Create Digital Music',
								'Credland Audio',
								'Crocus Soundware',
								'Crosley',
								'Crucial',
								'Cryptic',
								'Crypto Cipher',
								'CyberLink',
								'Cycling74',
								'Cymatics',
								'D16 Group',
								'Dabro Music',
								'Dada Life',
								'DAG Alliance',
								'Danyella Music',
								'Dark Intervals',
								'Databroth',
								'Dave Smith Instruments',
								'DavisLegend',
								'DDMF Supreme Audio Software',
								'Dear Reality',
								'Decent Samples',
								'DeepSky',
								'Delectable Records',
								'Dell',
								'Denise Audio',
								'Devicemeister',
								'Devious Machines',
								'DHPlugins',
								'Diamond Cut',
								'Diaspora',
								'DiBiQuadro Audio',
								'Dieguis Productions',
								'Diggy Loops',
								'Digi-toys',
								'Digilent',
								'Diginoiz',
								'Digital Deck Covers',
								'Digital Pro Sounds',
								'Digital Sound Factory',
								'Digital Suburban',
								'Dillon Bastan',
								'Direct',
								'Dirk Campbell',
								'Dirty Music',
								'Discovery Firm',
								'Discovery Sound',
								'Disformity',
								'Diversitility',
								'Diy Music Biz',
								'DJ 1Truth',
								'DJ Techtools',
								'DJ Tools',
								'DNB Academy',
								'Dodo Bird Music',
								'Dome of Doom',
								'Donna',
								'Donner',
								'DoubleY',
								'DRAYKI',
								'Dreadbox',
								'Dream Audio Tools',
								'Dreamtonics',
								'Drip',
								'Drivensounds',
								'Dropgun Samples',
								'Drum Vault',
								'Drum Workshop',
								'DS Audio',
								'dSONIQ',
								'Dude Clayy',
								'Dunlop',
								'Dupad',
								'Dymai Sound',
								'Dynasty Loops',
								'Dynasty',
								'e-instruments',
								'E-mu Systems',
								'E-RM',
								'eaReckon',
								'EarthMoments',
								'Earthquaker Devices',
								'EarthTone',
								'EastWest',
								'EBTECH',
								'Echo Sound Works',
								'Eclipsed Sounds',
								'EdgeSounds',
								'Edirol',
								'EDMBG',
								'Edu Prado Sounds',
								'Electric City Loops',
								'Elektron',
								'Element One',
								'Elements',
								'elysia',
								'Embertone',
								'Embodme',
								'Emergence Audio',
								'Empress Effects',
								'Engineering Samples',
								'Ensoniq',
								'Epic Stock Media',
								'Equinox Sounds',
								'Ergo Kukke',
								'Ergotron',
								'Erik Jackson',
								'Essential Audio',
								'Etekcity',
								'Eternal Waves',
								'Ethnaudio',
								'Eventide',
								'EverythingTurns',
								'Evolution of Sound',
								'Evolution Series',
								'Excite Audio',
								'Exotic Refreshment',
								'Expert Sleepers',
								'Exponential Audio',
								'Expressive-E',
								'FabFilter',
								'Fable Sounds',
								'Fairlight',
								'Fallout Music Group',
								'Famous Audio',
								'Fantastic Lab',
								'Faodzc',
								'Farfisa',
								'FatLoud',
								'Faxi Nadu',
								'Feed Your Soul Music',
								'FeelYourSound',
								'Fender',
								'Fernospazzin',
								'Ferpect Instruments',
								'Field and Foley',
								'Field Reports',
								'Findasound',
								'Finegear',
								'Finishing Move',
								'First Act',
								'Flameer',
								'Flintpope',
								'Flowrency',
								'FluffyAudio',
								'Flux',
								'Focusrite',
								'Force Sampling',
								'Forever 89',
								'Four4',
								'Fox Samples',
								'Fractal Sounds',
								'Fracture Sounds',
								'Freak Music',
								'Freakshow Industries',
								'Freaky Loops',
								'Freshly Squeezed Samples',
								'Fricke',
								'Friktion',
								'Frontline Producer',
								'FrozenPlain',
								'Full Bucket Music',
								'Fume Music',
								'Function Loops',
								'Furman',
								'Future Audio Workshop',
								'Future Loops',
								'Futurephonic',
								'Fvii',
								'FXpansion',
								'FYY',
								'FX23',
								'Gabe Miller',
								'Gamechanger Audio',
								'Gareth Morris',
								'Garritan',
								'Gator Cases',
								'Gator Frameworks',
								'GBR Loops',
								'Geekworm',
								'Genera Studios',
								'Generdyn',
								'Gengki Instruments',
								'Genki Instruments',
								'Genuine Soundware',
								'Get Down Samples',
								'GetGood Drums',
								'GForce Software',
								'Ghost Syndicate',
								'Ghosthack',
								'Gibson',
								'Gio Israel',
								'Giorgio Sancristoforo',
								'GLCON',
								'Glide Gear',
								'Glitchedtones',
								'Glitchedtones and Hidden Sound',
								'Glitchmachines',
								'Glorkglunk', 
								'Godlike Loops',
								'Godz',
								'GOGOi',
								'Goldbaby',
								'Golden Profit Electronics',
								'Golden Samples',
								'GoldWave',
								'Goodhertz',
								'GoPro',
								'Gospel Musicians',
								'Gothic Instruments',
								'Govee',
								'Gozye',
								'Grape Creative',
								'Green Light District',
								'Gretsch',
								'GSi',
								'Guilhermeosilva',
								'Guillermo Guareschi',
								'Gulbransen',
								'Hammond',
								'HandheldSound',
								'Hanz Tech',
								'Harmonic Subtones',
								'Harrison',
								'Hart Instruments',
								'Hauptwerk',
								'Have Audio',
								'Heavyocity',
								'Henney Major',
								'Hephaestus Sounds',
								'Hercules Stands',
								'Hexachords',
								'Hexloops',
								'Hidden Sound',
								'Hideaway Studio',
								'Hiits',
								'Hntmao',
								'HOFA',
								'Hollywood Edge',
								'Hologram Electronics',
								'Hookshow',
								'Hopkin Instrumentarium',
								'HoRNet',
								'Hosa',
								'Hot Seal',
								'Howard Smith',
								'HPFIX',
								'HQO',
								'HR Sounds',
								'HunterKiller',
								'HY-Plugins',
								'Hy2rogen',
								'HybridTwo',
								'Hyperbits',
								'Hypnus Records',
								'HZE',
								'Ibanez',
								'iBune',
								'Ice Digger',
								'Iceberg',
								'Ichiro Toda',
								'IK Multimedia',
								'Ilio Sonic',
								'Illformed',
								'Ilya Efimov',
								'Image Sounds',
								'Image-Line',
								'Impact Sounds',
								'Impact Soundworks',
								'Impact Studios',
								'Imperfect Samples',
								'Imperfect Sampling',
								'In Session Audio',
								'Indiginus',
								'Industrial Strength',
								'Inertia Sound Systems',
								'Infinit Audio',
								'Infinit Essentials',
								'Infinite Samples',
								'Initial Audio',
								'inMusic Brands',
								'Inner State',
								'Innovative Samples',
								'Innovtive Samples',
								'Insanity Samples',
								'Inspire Audio',
								'Inspired Acoustics',
								'Integraudio and SixthSample',
								'Intel',
								'Intentional Music',
								'IRCAM',
								'IrcamLab',
								'IsoAcoustics',
								'Isotonik Studios',
								'Ivosight',
								'Ivy Audio',
								'iZotope',
								'Jacob Borum',
								'James Kayne',
								'Jammcard Samples',
								'Jamvana',
								'Jeremy Wentworth',
								'Jerome Fontana',
								'jerryuhoo',
								'Jessica Saves',
								'Jingle Punks',
								'Joey Sturgis Tones',
								'Johnny Juliano',
								'JoMoX',
								'Jon Meyer Music',
								'Jonathan Kerr',
								'Joyo Audio',
								'JSAUX',
								'jtackaberry',
								'Julian Ray Music',
								'Julian Ray',
								'Jungle Loops',
								'jwdejong and sshlien',
								'Júnior Porciúncula',
								'Kali Audio',
								'Karanyi Sounds',
								'Karoryfer Samples',
								'KaruSale',
								'Kawai',
								'Kazrog',
								'KEDR Audio',
								'KeepForest',
								'Kent',
								'Ketron',
								'KFD',
								'Kia',
								'kiloHearts',
								'Kinetic Sound Prism',
								'Kingston',
								'Kirk Hunter Studios',
								'Kirnu',
								'Kit Makers',
								'Kits Kreme Audio',
								'Klanghelm',
								'Klevgrand',
								'Komorebi Audio',
								'Kong Audio',
								'Korg',
								'Kraft Music',
								'KRK',
								'Krotos',
								'Kuassa',
								'Kurzweil',
								'Kush Audio',
								'Kushview',
								'KV331 Audio',
								'Kyle Beats',
								'Kyurumi',
								'Laboratory Audio',
								'Laifuni',
								'lAZy fISh',
								'Leapwing Audio',
								'LED Samples',
								'Lekato',
								'LEKATO',
								'LennarDigital',
								'Leo Wood',
								'Level 8',
								'Lex Sounds',
								'Lexicon',
								'LFO Store',
								'LGND',
								'Lian Li',
								'Light and Sound',
								'LimoStudio',
								'Lindell Audio',
								'Line 6',
								'Linn Electronics',
								'LiquidSonics',
								'Little Bit',
								'Live Workflow Tools',
								'Lo Fi Audio',
								'Lo Fi',
								'Lo-Fi Audio',
								'Logan Richardson',
								'Logitech',
								'London Overground',
								'Loomer',
								'Loopmasters',
								'Loops 4 Producers',
								'Loops 4 Pros',
								'Loops de la Creme',
								'Looptone',
								'Loose Records',
								'Loot Audio',
								'Louis Flynn and xynothing',
								'LP24 Audio',
								'Lucid Samples',
								'Luftrum',
								'Luling Arts',
								'Lunacy Audio',
								'Lunatic Audio',
								'Lupulo Records',
								'Luxe',
								'Luxor',
								'Lyrebird Sounds',
								'M-Audio',
								'M3G Moguls',
								'MAAT',
								'Mackie',
								'Madrona Labs',
								'Maestro',
								'Mag Signature Sound',
								'Magix',
								'Magma',
								'Mahalo',
								'Mainroom Warehouse',
								'Mainstream Sounds',
								'Maizesoft',
								'Major Oscillator',
								'Make Noise',
								'Make Pop Music',
								'MakeMusic',
								'Malte Klima',
								'Mango Loops',
								'Marc Barnes Sounds',
								'Marc Houle',
								'Marcos Ciscar',
								'Martin von Frantzius',
								'Martinic',
								'Maserati Sparks',
								'Master Tones',
								'Mastering The Mix',
								'Mathew Lane',
								'Matkat Music',
								'Mattel Electronics',
								'Matteo Marini',
								'MAudio',
								'MaurizioB',
								'Mavrik Sounds',
								'Max for Cats',
								'MaxGear',
								'Mediamotion',
								'MeldaProduction',
								'Mellisonic',
								'Melodic Kings',
								'Melosonic',
								'Mercurial Tones',
								'Merging Technologies',
								'Meris',
								'Metro',
								'Mhamusic Mha',
								'Microhammer',
								'Midiplus',
								'Mifaso',
								'Mifoge',
								'Mildon',
								'Miles Kvndra',
								'Miles Stain',
								'Millennia',
								'MillSO',
								'Minimal Audio',
								'Minimal Tonal',
								'Mippy',
								'Mirai',
								'Misfit Digital',
								'Mistral Unizion Music',
								'MIXLAND Audio',
								'MixWave',
								'ML Sound Lab',
								'Mntra Instruments',
								'Moborest',
								'Modal Electronics',
								'Modartt',
								'ModeAudio',
								'Modeselektor',
								'Modwheel',
								'Mohawk',
								'Molgli',
								'Molores',
								'Mono',
								'Monoprice',
								'Monster Sounds',
								'Mooer',
								'Moog',
								'Moonboy',
								'Moozica',
								'Morris & Warheart',
								'MOTU',
								'Moukey',
								'Mouse Orchestra',
								'MS Records',
								'Muletone Audio',
								'Multiton Bits',
								'Munique Music',
								'Muramasa Audio',
								'Muse Group',
								'Mushroom Stamp Productions',
								'Music Developments',
								'Musical Sampling',
								'MusicLab',
								'Musicrow',
								'Music Work Center',
								'Musitek',
								'Mute Production',
								'MVP Platinium',
								'MVPloops',
								'MXR',
								'Mycrazything Sounds',
								'Myriad',
								'myVolts',
								'N Tune Music',
								'n-Track',
								'Nalbantov Software',
								'Nalbantov',
								'Nanoleaf',
								'Naroth Audio',
								'Native Instruments',
								'Naughty Seal Audio',
								'NavePoint',
								'Navi Retlav',
								'NCH Software',
								'Nektar',
								'Neocymatics',
								'Neon Wave',
								'Neoncastle',
								'Neural DSP Technologies',
								'Neuratron',
								'Neutral Labs',
								'New Beard Media',
								'New Bee Audio',
								'New Loops',
								'New Nation',
								'Newfangled Audio',
								'Nextmidi',
								'Nextronics',
								'Nicky Romero',
								'Nikon',
								'Nina Sung',
								'Nitelife Audio',
								'Noah Cuz & Kiri Gerbs',
								'Noah Mejia & Dynox',
								'Noiiz',
								'Noir Labs',
								'NoiseAsh',
								'Noisy Machines',
								'Nomad Factory',
								'Nonjuror',
								'norCTrack',
								'norCtrack',
								'Nord',
								'Norrland Samples',
								'Novation',
								'NovoNotes',
								'NS Musical',
								'NUGEN Audio',
								'O! Samples',
								'Oberheim',
								'Oblivion Sound',
								'Ocarina Wind',
								'Ocean Swift Synthesis',
								'Ochen K.',
								'ODD Samples',
								'Odyssey',
								'Oeksound',
								'Ohmforce',
								'Ollie',
								'Om Infinite Sound',
								'On the Keys',
								'On-Stage',
								'One Small Clue',
								'Oneway Audio',
								'Orange Tree Samples',
								'Orange',
								'Orb Plugins',
								'Orchestral Tools',
								'Organic Loops',
								'Organic Samples',
								'Oriental Sounds',
								'Origin Sound',
								'Origins of Audio',
								'Orla',
								'Ortega Guitars',
								'Otto Audio',
								'Output',
								'Overloud',
								'Oz Soft',
								'Pablo Decoder',
								'PACE',
								'Pad Pushers',
								'Palaguna',
								'Paper Stone Instruments',
								'Parallax Audio',
								'Party Design',
								'Pasow',
								'Past to Future Reverbs',
								'Payton Carter',
								'Pearl',
								'Peavey',
								'Pelham & Junior',
								'Performance Samples',
								'Perimeter Sound',
								'Pettinhouse',
								'PG Music',
								'Phil Speiser',
								'Photosounder',
								'Physical Audio',
								'Pianobook',
								'Pig Hog',
								'Pimoroni',
								'Pitch Innovations',
								'Piz MIDI',
								'Planet Samples',
								'PlantWave',
								'Platinum Audiolab',
								'Platinum Samples',
								'Plogue',
								'Plughugger',
								'Plugin Alliance',
								'Plugin Boutique',
								'PlugInGuru',
								'plusma',
								'PMI',
								'PML and Orchestral Tools',
								'PML',
								'Polaris Audio',
								'Polyend',
								'Polyend-Dreadbox',
								'Polyphonic Music Library',
								'Polyverse Music',
								'Polyvox',
								'Positive Grid',
								'Potillo',
								'Power Music Software',
								'PowerBridge',
								'Precisionsound',
								'Premier Sound',
								'PreSonus',
								'Prime Loops',
								'Pro Sound Effects',
								'Pro Studio Library',
								'ProCase',
								'ProCo',
								'Producer Loops',
								'ProducerGrind',
								'Producers Choice',
								'Production Master',
								'Prodyon',
								'Profanity Instruments',
								'ProjectSAM',
								'Proloops',
								'Prominy',
								'Prosoundz',
								'Protoolz',
								'PSE',
								'PSPaudioware',
								'Pulsar Audio',
								'Pulsar Modular',
								'Pulse',
								'Pulsed Records',
								'Puremagnetik',
								'Push Button Bang',
								'Pyjama Planet',
								'Pyle',
								'Q Up Arts',
								'Quasimidi',
								'Queen Chameleon',
								'QuikQuak',
								'Raimersoft',
								'Raising Jake Studios',
								'Rap',
								'Rare Percussion',
								'Raspberry Pi Foundation',
								'Rast Sound',
								'Rawoltage',
								'Rayzoon',
								'Razer',
								'RE-Vision Effects',
								'Realitone',
								'Realsamples',
								'Reason Studios',
								'Recovery Effects and Devices',
								'Red Room Audio',
								'Red Sounds',
								'Refractor Audio',
								'reFX',
								'Relab Development',
								'Relaximus',
								'Render Audio',
								'Renoise',
								'Replika Sound',
								'Resolume',
								'Resonance Sound',
								'Resonic',
								'Resplendence',
								'Retrokits',
								'Reveal Sound',
								'Revealed Recordings',
								'Rhodes',
								'Rhythmic Robot Audio',
								'Richoose',
								'Riemann Kollektion',
								'Rigid Audio',
								'Rinastore',
								'Rip Speakers',
								'Rob Lee Music',
								'Rob Papen',
								'Robert Henke',
								'Robert Todd',
								'Robson Nogueira',
								'Rockstix',
								'Rockville',
								'Roland',
								'ROLI',
								'Roli',
								'Rombo',
								'Rowin',
								'rs-met',
								'RSF',
								'Rubicon',
								'RV Samplepacks',
								'Ryb Home',
								'Sabroi',
								'Sakata',
								'Sample Freak',
								'Sample Fuel',
								'Sample Logic',
								'Sample Magic',
								'Sample Modeling',
								'Sample Station',
								'Sample Tools by Cr2',
								'Sample Tools',
								'Samplecraft',
								'SampleHero',
								'Sampleism',
								'Samplephonics',
								'Samples From Mars',
								'SampleScience',
								'Sampleso',
								'Sampleson',
								'Samplestar',
								'Sampletekk',
								'Sampletraxx',
								'Samplicity',
								'Samplified',
								'Samplitude',
								'Samson',
								'Samsung',
								'SanDisk',
								'Sauceware Audio',
								'Sauceware',
								'ScanScore',
								'Schaack Audio',
								'SCHOEPS',
								'Schylling',
								'Scotty Splash',
								'Screaming Bee',
								'Scuffham Amps',
								'Seagate',
								'Sedna',
								'Seismic Audio',
								'Sennheiser',
								'SensiLab',
								'Sequential',
								'Sequenz',
								'Serato',
								'Serge',
								'Serious Soundz',
								'Seven Sounds',
								'Seventh String',
								'Seymour Duncan',
								'SFXtools',
								'Shadow Hills',
								'ShamanStems',
								'Shanegrape',
								'Sharp',
								'Shockwave',
								'Shumno',
								'Shure',
								'Siberian Samples',
								'Sick Noise Instruments',
								'Sickrate & Siik',
								'Siel',
								'Signalyst',
								'Signum Audio',
								'Silence+Other Sounds',
								'Simmons',
								'Simon Foster',
								'simonsteur',
								'Simple Sam Samples',
								'Sinevibes',
								'Singomakers',
								'Siwengde',
								'Sixth Sample',
								'SKB',
								'Skeleton Samples',
								'Sketch Sampling',
								'Skinnerbox',
								'Skybox Audio',
								'SKYE Dynamics',
								'Skyes Audio',
								'Slade',
								'Slate and Ash',
								'Slate Digital',
								'Sly-Fi Digital',
								'SM White Label',
								'SmallPrint Ingredients',
								'Smokey Loops',
								'Smoovie',
								'Snigjat',
								'Softube',
								'Soifer Sound',
								'Solton',
								'Sonart Audio',
								'Sonible',
								'Sonic Acoustics',
								'Sonic Atoms',
								'Sonic Charge',
								'Sonic Collective',
								'Sonic Drive Media',
								'Sonic Elements',
								'Sonic Faction',
								'Sonic Implants',
								'Sonic Range',
								'Sonic Reality',
								'Sonic Scores',
								'Sonic Sound Supply',
								'Sonic Sounds',
								'Sonica Instruments',
								'Sonica',
								'Soniccouture',
								'Sonicware',
								'Sonicycle',
								'Sonivox',
								'Sonixinema',
								'Sonnox',
								'Sonokinetic',
								'Sonor',
								'Sonora Cinematic',
								'Sonosaurus',
								'Sontronics',
								'Sonus',
								'Sonuscore',
								'Soul Surplus',
								'Souldier',
								'Soulker',
								'Sound Aesthetics Sampling',
								'Sound Bankz',
								'Sound Doctrine',
								'Sound Dust',
								'Sound Guru',
								'Sound Ideas',
								'Sound Mangling',
								'Sound Master',
								'Sound Particles',
								'Sound Radix',
								'Sound Yeti',
								'Soundbox',
								'Soundclan Music',
								'Soundengine',
								'Soundethers',
								'Soundevice',
								'Soundfingers',
								'Soundiron',
								'Soundmasters',
								'Soundpaint',
								'Sounds to Sample',
								'Sounds2Inspire',
								'Soundspot',
								'Soundtheory',
								'SoundToys',
								'Soundtrack Loops',
								'Soundwrld',
								'Spamboots Loops',
								'SparkPackers',
								'SPARTA',
								'Spectrasonics',
								'Spektralisk',
								'SPF Samplers',
								'Sphera Records',
								'Spitfire Audio',
								'SPL',
								'Splash Sound',
								'Splice',
								'Squareheads',
								'Squarp',
								'ST2 Samples',
								'Stagecraft Software',
								'Standalone-Music',
								'Standtastic',
								'StarTech',
								'Streemproduction',
								'Stefano Maccarelli',
								'Steinberg',
								'Steve Pageot',
								'Steven Shaeffer',
								'Stickz',
								'Straight Ahead Samples',
								'Strategic Audio',
								'Strezov Sampling',
								'String Audio',
								'Strix Instruments',
								'Strymon',
								'Studio Linked',
								'Studio Major 7th',
								'Studio Plug',
								'Studio Trap Sounds',
								'Studiolinked',
								'Studiologic',
								'SubMission Audio',
								'Sugar Bytes',
								'Sunday Supply',
								'SuperStar O',
								'Suplong',
								'Supreme Samples',
								'Surge Sounds',
								'Surge Synthesizer',
								'Surreal Machines',
								'Suture Sound',
								'Suzuki',
								'SWS S&M',
								'Symphonic for Production',
								'Synapse Audio',
								'Synth Ctrl',
								'Synth Wizards',
								'Synthctrl Synthpop for Xfer Serum',
								'Synthesia',
								'Synthogy',
								'Synthpatches',
								'Synthstrom',
								'SyrinxSamples',
								'T.D. Samples',
								'TAL Software',
								'Taleweaver',
								'Tam LeTeet',
								'Tangent Edge',
								'TAQS.IM',
								'Taro',
								'Tascam',
								'TBProAudio',
								'TC Electronic',
								'Team R2R',
								'TeamDNR Collaborative Designs',
								'Technique Sounds',
								'TEControl',
								'Teenage Engineering',
								'Teknimension',
								'Teletone Audio',
								'Test Press',
								'TH Studio Production',
								'Thaloops',
								'The 44thFloor',
								'The Cell',
								'The Compound',
								'The Drum Broker',
								'The Last Haven',
								'The Loop',
								'The Lunch77',
								'The Midnight',
								'The Producers',
								'The Sample Company',
								'The Sample Pack Maker',
								'The Unfinished and Luftrum',
								'The Unfinished',
								'The Very Loud Indeed Co.',
								'Thenatan',
								'Theo Krueger',
								'Thick Sounds',
								'Thimeo',
								'Tifanso',
								'Tijn Wybenga',
								'Tisino',
								'Tobias Erichsen',
								'Togeo Studios',
								'Togu Audio',
								'Tokyo Dawn Labs',
								'Tom Wolfe',
								'Tone Empire',
								'Tone2',
								'ToneBoosters',
								'Tonehammer',
								'ToneLib',
								'Tonepusher',
								'Toolbox Samples',
								'Toontrack',
								'Topten Software',
								'Toshiba Records',
								'Touch Loops',
								'Toxic Samples',
								'TP-Link',
								'Tracktion Software',
								'Traktrain',
								'Trance Euphoria',
								'Trinniti',
								'Triple Spiral Audio',
								'Tritik',
								'Triune Digital',
								'Truetone',
								'Trumagine',
								'Tubbo',
								'Tunecraft Sounds',
								'Turbo Samples',
								'Tweakbench',
								'u-he',
								'UA Acoustics',
								'Ueberschall',
								'Ugritone',
								'UJAM',
								'UK Sinister',
								'UL The House of Sound',
								'Ulanzi',
								'Ultimate Patches',
								'Ultimate Support',
								'Umlaut',
								'Uneek Sounds',
								'Unfiltered Audio',
								'Unison',
								'UnitedPlugins',
								'Universal Sampling',
								'Univox',
								'Urban Hollywood Studios',
								'Ushuaia Music',
								'UT Wire',
								'UVI',
								'V Don',
								'VA',
								'Valhalla DSP',
								'Valious',
								'Vandalism Sounds',
								'Vangoa',
								'Vanilla Groove Studios',
								'Variety of Sound',
								'Vater Percussion',
								'VB-Audio',
								'Velcro',
								'Vember Audio',
								'venexxi',
								'Vengeance Sound',
								'Venomode',
								'Venus Theory',
								'Vermona',
								'Versilian Studios',
								'Vertical Sounds',
								'Vertigo Sound',
								'VGTrumpet',
								'VI Labs',
								'Vic Firth',
								'ViewSonic',
								'Vin Sound',
								'Vincenzo Bellanova',
								'Vintage Synth Pads',
								'Vinyl Audio',
								'VIPZONE',
								'Vir2 Instruments',
								'Virharmonic',
								'Virtual DJ',
								'Virtual Light',
								'Visco',
								'Visionary Robots Industries',
								'Vital Audio',
								'Vocal Roads',
								'Vochlea',
								'Volko Audio',
								'Volterock',
								'VOX',
								'Voxengo',
								'VSL',
								'VSTBuzz',
								'W. A. Production',
								'WaaSoundLab',
								'Waldorf',
								'Wallander Instruments',
								'WAVDSP',
								'Wave Alchemy',
								'Wave Arts',
								'Waveform Recordings',
								'Wavegrove',
								'Wavelet Audio',
								'Wavelet Theory',
								'Wavemachine Labs',
								'Waves Audio',
								'Wavesequencer',
								'Wavesfactory',
								'Wavosaur',
								'WavSupply',
								'Way Huge',
								'Way Out Ware',
								'WEDGE FORCE',
								'Wersi',
								'Western Digital',
								'Westgate Studios',
								'Westwood Instruments',
								'weyrerTon',
								'Whitenoise Records',
								'Whole Loops',
								'Wholesounds',
								'Willed',
								'Wingo',
								'Wizoo',
								'Wlodzimierz Grabowski',
								'WM Entertainment',
								'World Tour',
								'Wow! Records',
								'Wrap-It',
								'Wrongtools',
								'WXAudio',
								'Xenos Soundworks',
								'Xfer Records',
								'XILS-lab',
								'XLN Audio',
								'Xoxos',
								'XPERIMENTA Project',
								'XPix',
								'Xsample',
								'Xtant Audio',
								'XY Studio Tools',
								'XY StudioTools',
								'Yamaha',
								'Yarra Audio',
								'YnK Audio',
								'Yoobao',
								'Youlean',
								'YoungHitmakers',
								'Yuli Yolo',
								'Yum Audio',
								'YummyBeats',
								'Yuroun',
								'Yves Big City',
								'Zapzorn',
								'Zenhiser',
								'Zero-G',
								'Zoom',
								'Zplane',
								'ZTENKO',
								'Zynaptiq'
						)
						
# alternate names for some developers
$global:altDevelopers = @{
								'Roland'								= 'Roland Cloud';
						}