@echo off
echo Trigonometry Calculator
echo.
echo 1. Sine
echo 2. Cosine
echo 3. Tangent
echo 4. Exit
set /p choice=Choose a function: 
if %choice%==1 goto sine
if %choice%==2 goto cosine
if %choice%==3 goto tangent
if %choice%==4 exit

:sine
set /p angle=Enter angle in degrees: 
set /a radians=angle*31416/1800000
set /a sine=sin(radians)
echo Sine(%angle%) = %sine%
pause
goto trigonometry_calculator

:cosine
set /p angle=Enter angle in degrees: 
set /a radians=angle*31416/1800000
set /a cosine=cos(radians)
echo Cosine(%angle%) = %cosine%
pause
goto trigonometry_calculator

:tangent
set /p angle=Enter angle in degrees: 
set /a radians=angle*31416/1800000
set /a tangent=tan(radians)
echo Tangent(%angle%) = %tangent%
pause
goto trigonometry_calculator
