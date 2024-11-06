@echo off
echo Organizing files by extension...
for %%f in (*.*) do (
    mkdir "%%~xf" 2>nul
    move "%%f" "%%~xf\"
)
echo Files organized.
pause
