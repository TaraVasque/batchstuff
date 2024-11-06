@echo off
echo Pythagorean Theorem Calculator
echo.
set /p a=Enter side a: 
set /p b=Enter side b: 
set /a c=a*a+b*b
set /a sqrt_c=0
for /L %%i in (1,1,%c%) do (
    set /a sqrt_c=%%i
    if !sqrt_c!*sqrt_c! GTR %c% (
        set /a sqrt_c=%%i-1
        goto :found
    )
)
:found
echo Hypotenuse: %sqrt_c%
pause
