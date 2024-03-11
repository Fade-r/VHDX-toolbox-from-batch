echo off
cls

:init
setlocal EnableDelayedExpansion

echo ---------------------------------------------------------------------
echo This script helps you expand an VDHX file. You will be prompted
echo specify the name, path, and new size of the virtual disk.
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
echo SELECT VDISK file="%vhdPath%%vhdName%.vhdx" > diskpart.txt
echo DETAIL VDISK >> diskpart.txt
diskpart /s diskpart.txt > output.txt
if %ERRORLEVEL% neq 0 goto SetVHDParameters
del diskpart.txt
for /f "tokens=2 delims= " %%a in ('findstr /n "^" "output.txt" ^| findstr /b "12:"') do (
    set "vhdSize=%%a"
)
del output.txt
set /P vhdSize=New size in MB? (original is %vhdSize%): %=%

:Main
echo SELECT VDISK file="%vhdPath%%vhdName%.vhdx" > diskpart.txt
echo EXPAND VDISK MAXIMUM=%vhdSize% >> diskpart.txt
diskpart /s diskpart.txt > nul 2>&1
if %ERRORLEVEL% neq 0 goto SetVHDParameters
del diskpart.txt

:EOF
echo.
echo.
setlocal DisableDelayedExpansion
echo Expand completed!
echo Please expand the *volume* manually.
echo.
echo.
pause
exit
