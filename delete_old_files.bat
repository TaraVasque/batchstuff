@echo off
set days=30
forfiles /p "C:\path\to\directory" /s /m *.* /d -%days% /c "cmd /c del @path"
echo Files older than %days% days deleted.
pause
