@echo off
:menu
cls
echo Select a calculator:
echo 1. Simple Calculator
echo 2. Pythagorean Theorem Calculator
echo 3. Trigonometric Calculator
echo 4. Exit
set /p choice=Enter your choice (1-4): 

if %choice%==1 goto simple
if %choice%==2 goto pythagorean
if %choice%==3 goto trigonometric
if %choice%==4 goto exit
goto menu

:simple
cls
set /p "expression=Enter the expression to calculate (e.g., 2+2): "
set /a result=%expression%
echo Result: %result%
pause
goto menu

:pythagorean
cls
set /p "a=Enter side a: "
set /p "b=Enter side b: "
set /a "c=a*a + b*b"
set /a "c=sqrt(c)"
echo Hypotenuse (c): %c%
pause
goto menu

:trigonometric
cls
echo Select a trigonometric function:
echo 1. Sine
echo 2. Cosine
echo 3. Tangent
set /p trig_choice=Enter your choice (1-3): 

set /p "angle=Enter the angle in degrees: "
set /a "radians=angle*3.14159/180"

if %trig_choice%==1 (
    set /a "result=sin(radians)"
    echo Sine(%angle%): %result%
)
if %trig_choice%==2 (
    set /a "result=cos(radians)"
    echo Cosine(%angle%): %result%
)
if %trig_choice%==3 (
    set /a "result=tan(radians)"
    echo Tangent(%angle%): %result%
)
pause
goto menu

:exit
exit
