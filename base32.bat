@echo off
setlocal enabledelayedexpansion

:: Function to encode a string to Base32
:encode
set "input=%~1"
set "output="
for /l %%i in (0,5,31) do (
    set "chunk=!input:~%%i,5!"
    if "!chunk!" neq "" (
        set /a "value=0"
        for /l %%j in (0,1,4) do (
            set "char=!chunk:~%%j,1!"
            set /a "value=value<<5"
            if "!char!" neq "" (
                set /a "value=value+!char!"
            )
        )
        set "output=!output!!value!"
    )
)
echo !output!
goto :eof

:: Function to decode a Base32 string
:decode
set "input=%~1"
set "output="
for /l %%i in (0,7,31) do (
    set "chunk=!input:~%%i,8!"
    if "!chunk!" neq "" (
        set /a "value=0"
        for /l %%j in (0,1,7) do (
            set "char=!chunk:~%%j,1!"
            set /a "value=value<<5"
            if "!char!" neq "" (
                set /a "value=value+!char!"
            )
        )
        set "output=!output!!value!"
    )
)
echo !output!
goto :eof

:: Main script
if "%1"=="encode" (
    call :encode "%2"
) else if "%1"=="decode" (
    call :decode "%2"
) else (
    echo Usage: %0 encode|decode string
)