@echo off
title Pong Game in Batch
cls

rem -- Game Settings --
setlocal EnableDelayedExpansion
set width=40
set height=10
set "gameover=0"
set ballX=20
set ballY=5
set ballDX=1
set ballDY=1
set paddle1Y=4
set paddle2Y=4

rem -- Game loop --
:gameLoop
cls
call :drawBoard
call :moveBall
call :movePaddles
call :checkCollision
timeout /nobreak /t 0.1 >nul
goto gameLoop

rem -- Draw the game board --
:drawBoard
rem Draw the game area and paddles
for /L %%i in (1,1,%height%) do (
    set "line="
    for /L %%j in (1,1,%width%) do (
        set "pixel= "
        if %%i==1 if %%j==1 echo|set /p=#
        if %%i==%paddle1Y% if %%j==1 set "pixel=|"
        if %%i==%paddle2Y% if %%j==%width% set "pixel=|"
        if %%i==%ballY% if %%j==%ballX% set "pixel=O"
        set "line=!line!!pixel!"
    )
    echo !line!
)

goto :eof

rem -- Move ball --
:moveBall
set /a ballX+=ballDX
set /a ballY+=ballDY
goto :eof

rem -- Move paddles --
:movePaddles
set /p move="Paddle 1 (W/S) or Paddle 2 (I/K): "
if "!move!"=="W" set /a paddle1Y-=1
if "!move!"=="S" set /a paddle1Y+=1
if "!move!"=="I" set /a paddle2Y-=1
if "!move!"=="K" set /a paddle2Y+=1
goto :eof

rem -- Check for collisions --
:checkCollision
if %ballY% LSS 1 set ballDY=-ballDY
if %ballY% GEQ %height% set ballDY=-ballDY

if %ballX% LSS 2 if %ballY% GEQ %paddle1Y% if %ballY% LSS %paddle1Y%+3 set ballDX=-ballDX
if %ballX% GEQ %width%-1 if %ballY% GEQ %paddle2Y% if %ballY% LSS %paddle2Y%+3 set ballDX=-ballDX

rem -- Game over detection --
if %ballX% LSS 1 if %ballY% GEQ %height% set "gameover=1"
if %ballX% GEQ %width%-1 if %ballY% GEQ %height% set "gameover=1"

if "%gameover%"=="1" goto :gameOver
goto :eof

rem -- Game Over screen --
:gameOver
echo Game Over!
pause
exit
