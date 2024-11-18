@echo off
title Guess the Number
cls
echo Welcome to Guess the Number!
echo I have chosen a number between 1 and 100. Try to guess it!

set /a "target=%random% %% 100 + 1"
set /a "attempts=0"
set "guessed=false"

:guessLoop
set /p "guess=Enter your guess: "
set /a "attempts+=1"

if %guess%==%target% (
    echo Congratulations! You guessed the number in %attempts% attempts.
    pause
    exit
) else if %guess% lss %target% (
    echo Too low! Try again.
) else (
    echo Too high! Try again.
)

goto guessLoop
