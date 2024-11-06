@echo off
set source=C:\path\to\source
set destination=C:\path\to\backup
echo Backing up files from %source% to %destination%...
xcopy %source% %destination% /s /e /h /i /y
echo Backup completed.
pause
