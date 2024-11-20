@echo off
setlocal enabledelayedexpansion
::Problems
::1 there is a problem where you have to enter the answer that you pick from 1-8 twice to actually change to the one you want
::2 refreshes too much
::3 pages will go past 4 even tho there are technically only 3 pages
:: Get the original system timezone and save it in a variable
for /f "tokens=*" %%a in ('tzutil /g') do set ORIGINAL_TIMEZONE=%%a

:: Trim leading and trailing spaces from the timezone string (if any)
set ORIGINAL_TIMEZONE=%ORIGINAL_TIMEZONE: =%

:: Define timezones list (can be expanded as needed)
set timezones[0]=UTC
set timezones[1]=Pacific Standard Time
set timezones[2]=Eastern Standard Time
set timezones[3]=Central Standard Time
set timezones[4]=Mountain Standard Time
set timezones[5]=Greenwich Standard Time
set timezones[6]=Central European Standard Time
set timezones[7]=Indian Standard Time
set timezones[8]=Hawaiian Standard Time
set timezones[9]=Alaskan Standard Time
set timezones[10]=Atlantic Standard Time
set timezones[11]=AUS Eastern Standard Time
set timezones[12]=China Standard Time
set timezones[13]=Japan Standard Time
set timezones[14]=Brasilia Standard Time
set timezones[15]=Argentina Standard Time
set timezones[16]=West Pacific Standard Time
set timezones[17]=Central Africa Time
set timezones[18]=Singapore Standard Time
set timezones[19]=Israel Standard Time
set timezones[20]=Samoa Standard Time
set timezones[21]=Tonga Time
set timezones[22]=Fiji Standard Time
set timezones[23]=Moscow Standard Time
set timezones[24]=Cape Verde Time
set timezones[25]=Mauritius Time
:: Add more timezones as needed

:: Calculate the total number of timezones
set totalTimezones=26

:: Define the number of timezones per page
set /a maxTimezonesPerPage=8

:: Calculate the number of pages (rounding up)
set /a totalPages=(%totalTimezones% + %maxTimezonesPerPage% - 1) / %maxTimezonesPerPage%

:: Define page variables
set currentPage=0

:main
cls
echo Your original timezone is: %ORIGINAL_TIMEZONE%
echo.
echo Select a Timezone (Page %currentPage% of %totalPages%):
echo.

:: Display the timezones for the current page
set /a startIndex=%currentPage%*%maxTimezonesPerPage%
set /a endIndex=%startIndex%+%maxTimezonesPerPage%-1

:: Loop to display timezones on current page
for /l %%i in (%startIndex%,1,%endIndex%) do (
    if defined timezones[%%i] (
        set /a displayNumber=%%i+1
        echo !displayNumber!. !timezones[%%i]!
    )
)

echo.
echo Press 1-%maxTimezonesPerPage% to select a timezone.
echo Press 9 for next page.
echo Press 0 for previous page.
echo Press R to revert to the original timezone.
echo Press Q to quit.

:: Clear any previous input by forcing a fresh input prompt
set choice=
set /p choice=Enter choice: 

:: Handle the user input
if /i "%choice%"=="Q" exit
if "%choice%"=="9" (
    if %currentPage% lss %totalPages%-1 (
        set /a currentPage+=1
    )
    goto main
)
if "%choice%"=="0" (
    if %currentPage% gtr 0 (
        set /a currentPage-=1
    )
    goto main
)
if /i "%choice%"=="R" (
    echo Reverting to the original timezone: %ORIGINAL_TIMEZONE%
    tzutil /s "%ORIGINAL_TIMEZONE%"
    echo Timezone reverted successfully.
    pause
    goto main
)

:: Handle timezone selection
:: Ensure the input is a number between 1 and the number of timezones per page
if "%choice%" geq "1" if "%choice%" leq "%maxTimezonesPerPage%" (
    set /a index=%choice%-1+%currentPage%*%maxTimezonesPerPage%
    if defined timezones[%index%] (
        set TIMEZONE=!timezones[%index%]!
        echo You selected !TIMEZONE!
        :: Change the system timezone
        tzutil /s "!TIMEZONE!"
        echo.
        echo Current date and time in !TIMEZONE!:
        echo Date: %date%
        echo Time: %time%
        pause
    ) else (
        echo Invalid selection. Please choose a valid option.
        pause
    )
) else (
    echo Invalid input. Please choose a valid option.
    pause
)

goto main
