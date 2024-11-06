@echo off
:menu
echo Simple Calculator
echo.
echo 1. Addition
echo 2. Subtraction
echo 3. Multiplication
echo 4. Division
echo 5. Exit
set /p choice=Choose an operation: 
if %choice%==1 goto add
if %choice%==2 goto subtract
if %choice%==3 goto multiply
if %choice%==4 goto divide
if %choice%==5 exit

:add
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a+b
echo Result: %result%
pause
goto menu

:subtract
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a-b
echo Result: %result%
pause
goto menu

:multiply
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a*b
echo Result: %result%
pause
goto menu

:divide
set /p a=Enter first number: 
set /p b=Enter second number: 
set /a result=a/b
echo Result: %result%
pause
goto menu
