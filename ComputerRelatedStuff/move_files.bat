@echo off
set source=C:\path\to\source
set destination=C:\path\to\destination
echo Moving files from %source% to %destination%...
move %source%\* %destination%
echo Files moved.
pause
rem #soon will add option to tell where to move in command prompt
