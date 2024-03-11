echo off
cls

:init
setlocal EnableDelayedExpansion

echo ---------------------------------------------------------------------
echo This script helps you create an VDHX file. You will be prompted specify
echo a name, location, and size of the virtual disk.
echo.
echo DO NOT CLOSE THIS WINDOW - it will close automatically when completed.
echo ---------------------------------------------------------------------
echo.
echo.

:SetVHDParameters
set vhdName=Win11
set vhdPath=%CD%
set /A vhdSize=1024*64+300+18
set vhdLetter=C:
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
set /P vhdSize=Size in MB? (default is %vhdSize%): %=%
if not [%vhdPath:~-1%]==[\] set vhdPath=%vhdPath%\

:Main
echo CREATE VDISK FILE="%vhdPath%%vhdName%.vhdx" MAXIMUM=%vhdSize% TYPE=expandable > diskpart.txt
echo SELECT VDISK FILE="%vhdPath%%vhdName%.vhdx" >> diskpart.txt
echo ATTACH VDISK >> diskpart.txt
echo CONVERT GPT >> diskpart.txt
echo DETACH VDISK >> diskpart.txt
diskpart /s diskpart.txt > nul 2>&1
if %ERRORLEVEL% neq 0 goto SetVHDParameters
del diskpart.txt

:EOF
echo.
echo.
setlocal DisableDelayedExpansion
echo Your VHDX file was created!
echo You can create partitions and format it manually.
echo.
echo.
pause
EXIT
