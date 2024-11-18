@echo off
title Snake Game in Batch
cls

rem -- Game Settings --
setlocal EnableDelayedExpansion
set width=30
set height=10
set "gameover=0"
set score=0

rem -- Initialize Snake position --
set snakeX=15
set snakeY=5
set snakeLength=1

rem -- Initialize Snake body as a list of coordinates --
set "snakeBody=15,5"

rem -- Food position --
set foodX=10
set foodY=5

rem -- Direction variables --
set "direction=RIGHT"

rem -- Game loop --
:gameLoop
cls
call :drawBoard
call :processInput
call :moveSnake
call :checkCollision
call :checkFood
timeout /nobreak /t 1 >nul
goto gameLoop

rem -- Draw game board --
:drawBoard
rem Draw top border
for /L %%i in (1,1,%width%) do echo|set /p=#

echo.

rem Draw the game area and snake
for /L %%i in (1,1,%height%) do (
    set "line="
    for /L %%j in (1,1,%width%) do (
        set "pixel= "
        rem Check if the position is part of the snake
        for %%s in (%snakeBody%) do (
            set "part=%%s"
            set "x=!part:~0,1!"
            set "y=!part:~2,1!"
            if %%i==!y! if %%j==!x! set "pixel=O"
        )
        rem Draw food
        if %%i==%foodY% if %%j==%foodX% set "pixel=@"
        set "line=!line!!pixel!"
    )
    echo !line!
)

rem Draw bottom border
echo.
for /L %%i in (1,1,%width%) do echo|set /p=#
goto :eof

rem -- Process user input for movement --
:processInput
set /p move=Move (WASD): 
if /i "%move%"=="W" set "direction=UP"
if /i "%move%"=="S" set "direction=DOWN"
if /i "%move%"=="A" set "direction=LEFT"
if /i "%move%"=="D" set "direction=RIGHT"
goto :eof

rem -- Move snake based on current direction --
:moveSnake
set /a headX=%snakeX%
set /a headY=%snakeY%

rem Calculate the new position of the head
if "%direction%"=="UP" set /a headY-=1
if "%direction%"=="DOWN" set /a headY+=1
if "%direction%"=="LEFT" set /a headX-=1
if "%direction%"=="RIGHT" set /a headX+=1

rem Add the new head position to the snake's body
set snakeBody=%headX%,%headY%,%snakeBody%

rem Remove the tail of the snake (unless the snake grows)
for /f "tokens=1,2 delims=," %%a in ("%snakeBody%") do (
    set "snakeX=%%a"
    set "snakeY=%%b"
    set "snakeBody=%%c"
)
goto :eof

rem -- Check if snake collided with walls or itself --
:checkCollision
rem Check if the snake hits the borders
if %headX% LEQ 0 set "gameover=1"
if %headX% GEQ %width% set "gameover=1"
if %headY% LEQ 0 set "gameover=1"
if %headY% GEQ %height% set "gameover=1"

rem Check if the snake hits itself
for %%s in (%snakeBody%) do (
    set "part=%%s"
    set "x=!part:~0,1!"
    set "y=!part:~2,1!"
    if !x! equ %headX% if !y! equ %headY% set "gameover=1"
)

if "%gameover%"=="1" goto :gameOver
goto :eof

rem -- Check if the snake eats the food --
:checkFood
if %headX%==%foodX% if %headY%==%foodY% (
    set /a score+=1
    set snakeLength+=1
    rem Spawn new food
    set /a foodX=%random% %% %width%
    set /a foodY=%random% %% %height%
)
goto :eof

rem -- Game Over screen --
:gameOver
echo Game Over! Your score: %score%
pause
exit
