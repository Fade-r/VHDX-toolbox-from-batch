echo off
cls

:init
setlocal EnableDelayedExpansion

echo ---------------------------------------------------------------------
echo This script helps you compact an VDHX file. You will be prompted
echo specify the name and path of the virtual disk.
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

:Main
echo SELECT VDISK file="%vhdPath%%vhdName%.vhdx" > diskpart.txt
echo COMPACT VDISK >> diskpart.txt
diskpart /s diskpart.txt > nul 2>&1
if %ERRORLEVEL% neq 0 goto SetVHDParameters
del diskpart.txt

:EOF
echo.
echo.
setlocal DisableDelayedExpansion
echo Compact completed!
echo.
echo.
pause
exit
