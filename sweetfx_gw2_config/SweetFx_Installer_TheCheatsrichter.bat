
@echo off
::change this url to download and install different version!
::the downloadfile has to be a .zip file!
set url= http://sweetfx.thelazy.net/wp-content/uploads/2014/03/SweetFX-Configurator_standalone_with_SweetFX_1.5.1.7z

::###########################


echo ########################
echo 12.10.2015
echo TheCheatsrichter
echo Sweet FX Installer/Updater for GW2
echo ########################
echo.
echo This BAT requires:
echo [*]	A internet connection
echo [*]	To be placed in your Guild Wars 2 gamefolder!!
echo [*]	Rights to copy/move/rename files
echo.
echo This BAT will automatically:
echo [*]	Close GuildWars2!!
echo [*]	Close SweetFxConfigurator!!
echo [*]	Download the SweetFx 1.5.1 Configurator
echo [*]	Copy d3d9.dll,dxgi.dll and injector.ini into the GuildWars2 bin folder
echo [*]	Create a backup of the bin folder at 
echo    	"%cd%/sweetfxback/"
echo.
echo off


pause
goto start

:killprocess
echo [-] GuildWars2 is currently running!
echo [-] Trying to shut down Gw2.exe!
taskkill /im Gw2.exe
timeout 5 > Nul
tasklist | find /i /n "gw2.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo [-] GW2.exe is still running! Please close it manually!
	pause
	goto start
	) else (
	echo [+] GW2.exe successfully closed!
	goto start
	)
	
:killprocess2

echo [-] SweetFxConfigurator is currently running!
echo [-] Trying to shut down SweetFx_config.exe!
taskkill /im SweetFx_config.exe
timeout 5 > Nul
tasklist | find /i /n "SweetFx_config.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo [-] SweetFx_config.exe is still running! Please close it manually!
	pause
	goto start
	) else (
	echo [+] SweetFx_config.exe successfully closed!
	goto start
	)


:start

echo [*] Checking if Gw2.exe is running...
tasklist | find /i /n "gw2.exe">NUL
if "%ERRORLEVEL%"=="0" 	(
	goto killprocess
	) else (
	echo [+] Gw2.exe not running.
	)
	
echo [*] Checking if SweetFx_config.exe is running...
tasklist | find /i /n "SweetFx_config.exe">NUL
if "%ERRORLEVEL%"=="0" 	(
	goto killprocess2
	) else (
	echo [+] SweetFx_config.exe not running.
	)

:pathcheck	
echo [*] Checking Path...
if not exist %cd%\gw2.exe ( 
echo [-] Gw2.exe not found! BAT file not in Guild Wars 2 gamefolder?!
pause
goto end
)
if not exist %cd%\bin ( 
echo [-] %cd%\bin folder not found! BAT file not in Guild Wars 2 gamefolder?!
pause
goto end
)
	
:download
echo [*] Downloading SweetFx...
set dpath = echo %cd%
echo [*] Setting download path to : %cd%
pause
bitsadmin.exe /transfer "SweetFxDownload" %url% "%cd%/sweetfxcheats.zip"
if "%ERRORLEVEL%"=="0" 	(
	echo [+] Sweetfxcheats.zip sucessfully downloaded!
	) else (
	echo [-] Download failed! Please check your Internet connection!
	pause
	goto end
	)
	
	
:unzip
echo [*] Extrating .zip file...
timeout 2 > nul
setlocal
cd /d %~dp0
Call :UnZipFile "%cd%\" "%cd%\sweetfxbycheats.zip"
exit /b

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%

if not exist "%cd%\SweetFX Configurator" (
echo [-] Extraction failed! Check Download URL! DownloadFile not a .zip?
pause
goto end
)

:backup
echo [*] Creating backup folder at...
echo	 (%cd%\sweetfxback\)
timeout 2 > nul
if not exist "%cd%\sweetfxback\" mkdir "%cd%\sweetfxback\"
xcopy /s /Y "%cd%\bin" "%cd%\sweetfxback" >nul

:removeold
echo [*] Checking for existing SweetFX installation...
timeout 2 > nul

if exist "%cd%\bin\d3d9.dll" (
echo [-] Existing d3d9.dll found! Removing...
del %cd%\bin\d3d9.dll >nul
)
if exist "%cd%\bin\dxgi.dll" (
echo [-] Existing dxgi.dll found! Removing...
del %cd%\bin\dxgi.dll >nul
)
if exist "%cd%\bin\injector.ini" (
echo [-] Existing injector.ini found! Removing...
del %cd%\bin\injector.ini >nul
)

:copynew
echo [*] Copying new SweetFX Setup...
timeout 2 > nul
copy /Y "%cd%\SweetFX Configurator\SweetFX\d3d9.dll" "%cd%\bin\d3d9.dll" >nul
copy /Y "%cd%\SweetFX Configurator\SweetFX\dxgi.dll" "%cd%\bin\dxgi.dll" >nul
copy /Y "%cd%\SweetFX Configurator\SweetFX\injector.ini" "%cd%\bin\injector.ini" >nul

:finish
timeout 1 >nul
echo [+] SETUP SUCESSFULL! ENJOY :) Greetings TheCheatsrichter!
echo [*] Launching SweetFX Configurator...
timeout 5 > nul
call "%cd%\SweetFX Configurator\SweetFX_config.exe"
