echo off
cls

:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~dpnx0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
net file 1>nul 2>nul
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
echo.
echo **************************************
echo Invoking UAC for Privilege Escalation
echo **************************************

echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
echo args = "ELEV " >> "%vbsGetPrivileges%"
echo For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
echo args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
echo Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

echo UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
echo args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
echo UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul & shift /1)

echo ---------------------------------------------------------------------
echo This script helps you differencing an VDHX file. You will be prompted
echo specify the name and path of the parent virtual disk.
echo.
echo DO NOT CLOSE THIS WINDOW - it will close automatically when completed.
echo ---------------------------------------------------------------------
echo.
echo.

:SetVHDParameters
set vhdName=Win11
set vhdPath=%CD%
echo To accept the default options, just press enter
echo.
echo.
echo Hints:
echo     *Paths must be fully qualified (i.e. H:, F:\Images, etc.)
echo     *Size must be a number in MB (500, 102400, etc.)
echo.
echo.
set /P vhdName=File name? (default is Win11): %=%
set /P vhdPath=Location? (default path is %CD%): %=%
if not [%vhdPath:~-1%]==[\] set vhdPath=%vhdPath%\

:FindVersionNumber
set "maxVersion=-1"
for %%F in ("%vhdPath%%vhdName%_v*.vhdx") do (
    set "filename=%%~nF"
    set "version=!filename:*%vhdName%_v=!"
    set "version=!version:_archived=!"
    if !version! gtr !maxVersion! (
        set "maxVersion=!version!"
    )
)
set /a "version=%maxVersion%+1"

:Main
rename "%vhdPath%%vhdName%.vhdx" "%vhdName%_v%version%.vhdx"
echo SELECT VDISK file="%vhdPath%%vhdName%_v%version%.vhdx" > diskpart.txt
echo COMPACT VDISK >> diskpart.txt
echo CREATE VDISK FILE="%vhdPath%%vhdName%.vhdx" PARENT="%vhdPath%%vhdName%_v%version%.vhdx" >> diskpart.txt
diskpart /s diskpart.txt > nul 2>&1
if %ERRORLEVEL% neq 0 goto SetVHDParameters
del diskpart.txt

:EOF
echo.
echo.
setlocal DisableDelayedExpansion
echo Differencing completed!
echo Your new VHDX file is renamed to %vhdName%.vhdx
echo.
echo.
pause
exit
