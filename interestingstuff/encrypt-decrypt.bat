@echo off
:menu
cls
echo Select an option:
echo 1. Base32 Encode
echo 2. Base32 Decode
echo 3. Exit
set /p choice=Enter your choice (1-3): 

if %choice%==1 goto encode
if %choice%==2 goto decode
if %choice%==3 goto exit
goto menu

:encode
cls
set /p "input=Enter the string to encode: "
powershell -command "[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('%input%'))" > encoded.txt
set /p encoded=<encoded.txt
echo Encoded: %encoded%
del encoded.txt
pause
goto menu

:decode
cls
set /p "input=Enter the Base32 string to decode: "
powershell -command "[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('%input%'))" > decoded.txt
set /p decoded=<decoded.txt
echo Decoded: %decoded%
del decoded.txt
pause
goto menu

:exit
exit
