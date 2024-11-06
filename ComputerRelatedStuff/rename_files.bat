@echo off
setlocal enabledelayedexpansion
set count=1
for %%f in (*.*) do (
    ren "%%f" file!count!%%~xf
    set /a count+=1
)
echo Files renamed.
pause
