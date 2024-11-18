@echo off
title Rock Paper Scissors
cls
echo Welcome to Rock Paper Scissors!
echo Choose one of the following:
echo 1. Rock
echo 2. Paper
echo 3. Scissors
set /p userChoice=Your choice (1-3): 

rem Generate computer's choice (random number between 1 and 3)
set /a computerChoice=%random% %% 3 + 1

if %userChoice%==%computerChoice% (
    echo It's a tie!
) else if %userChoice%==1 if %computerChoice%==3 (
    echo You win! Rock beats Scissors.
) else if %userChoice%==2 if %computerChoice%==1 (
    echo You win! Paper beats Rock.
) else if %userChoice%==3 if %computerChoice%==2 (
    echo You win! Scissors beats Paper.
) else (
    echo You lose! Better luck next time.
)

echo.
if %computerChoice%==1 echo Computer chose: Rock
if %computerChoice%==2 echo Computer chose: Paper
if %computerChoice%==3 echo Computer chose: Scissors

pause
