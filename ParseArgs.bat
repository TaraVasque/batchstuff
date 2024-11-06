:: Create a script with input option/mandatory flags/param
:: Script is able to treat:
:: 1- /h option that call usage (and exit)
:: 2- an option with 1 param
:: 3- an option with 2 params that can be repeated (multiple input option)
:: 4- an optional flag
:: 5- a mandatory switch flag
:: 6- a mandatory 1st param
:: 7- an unknown number of param (from 2 to n)
::
:: The script also call usage and exit for:
:: 1- an unknown option
:: 2- an incorrect number of param need by an option
:: 3- an incorrect number of mandatory param
::
@echo off

setlocal enableextensions enabledelayedexpansion	

set SCRIPT=%0
set STOP=false

:: I prefer put usage and parseArgs method at the beginning of file
:: so I need to go to a MAIN programme put lower
goto :_MAIN

::=============================================================================
:: usage
::=============================================================================
:_usage
	echo Usage: %SCRIPT% [-h] [-o OPT_1] [-m OPT_3 OPT_4 [... -m OPT_X OPT_Y]] [-f] (-u or -v) (PARAM1) (ELEM_1 ... ELEM_N)
	echo.
	echo Option:
	echo     -h                 Show this help and quit.
	echo     -o OPT_1           Option 1
	echo     -m OPT_3 OPT_4     Multiple Option 3 et 4
	echo     -f                 Flag F
	echo.
    echo Mandatory
	echo     -u or -v           Flag T is set to U or V
	echo     PARAM1	            parameter
	echo     ELEM_N list        space separated list of argument
	
	set STOP=true
	goto :EOF

::=============================================================================
:: parseArgs
::=============================================================================
:_parseArgs
	REM Set every input variables
	set ARG_O=
	set argMid=0
	set ARG_M[%argMid%].text=
	set ARG_M[%argMid%].val=
	set FLAG_F=0
	set FLAG_T=
	set PARAM=
	set elemIdx=0
	set ELEM[%elemIdx%]=
	
	REM Get all parameters and put them in an array
	REM count number of param input
	set nbrArgs=0
	set nbrParam=0
	:__loopInput
	if not [%1]==[] (
		set INPUT[%nbrArgs%]=%1
		set /a "nbrArgs+=1"
		shift
		goto  :__loopInput
	)

	REM set option paramaters needed for analyze
	REM set to 3 because the max optionnal param nbr is "/c param1 param2" == 3 parts
	set idInput1=0
	set /a "idInput2=idInput1+1"
	set /a "idInput3=idInput2+1"
	call set opt1=%%INPUT[%idInput1%]%%
	call set opt2=%%INPUT[%idInput2%]%%
	call set opt3=%%INPUT[%idInput3%]%%

	REM start the args analyze loop
	:__loopArgs
		set missing=0
		if [%opt1%]==[] goto :__endLoopArgs 
		set opt11=%opt1:~0,1%

		if [%opt11%]==[-] (
			REM It is an option 
			if /i [%opt1%]==[-h] (
				REM Option -h => usage and exit
				call :_usage
				goto :EOF
			) 
			if /i [%opt1%]==[-o] (
				REM Option -a param1
				REM param1 => ARG_O
				call :_checkArg_O %opt2%
				if errorlevel 1 exit /b 1
				
				set /a "idInput1+=1"
				set /a "idInput2+=1"
				set /a "idInput3+=1"
					
				goto :__endcase
			)
			if /i [%opt1%]==[-m] (
				REM Option -m param1 param2
				REM param1 => ARG_M[n].text
				REM param2 => ARG_M[n].val
				call :_checkArg_M %opt2% %opt3%
				if errorlevel 1 exit /b 1
				
				set /a "argMid+=1"
				set /a "idInput1+=2"
				set /a "idInput2+=2"
				set /a "idInput3+=2"
				goto :__endcase
			)
			if /i [%opt1%]==[-f] (
				set FLAG_F=1
				goto :__endcase
			)
			if /i [%opt1%]==[-u] (
				set FLAG_T=U
				goto :__endcase
			) 
			if /i [%opt1%]==[-v] (
				set FLAG_T=V
				goto :__endcase
			)
			echo Unknown option: %opt1%
			echo.
			call :_usage
			goto :EOF
			)
			:__endcase

		if not [%opt11%]==[-] (
			REM It is a parameter
			if %nbrParam%==0 (
				set PARAM=%opt1%
				set /a "nbrParam+=1"
			)
			if not %nbrParam%==0 (
				set ELEM[%elemIdx%]=%opt1%
				set /a "elemIdx+=1"
				set /a "nbrParam+=1"
			)
		)
		set /a "idInput1+=1"
		set /a "idInput2+=1"
		set /a "idInput3+=1"

		REM before each new loop, you must reinit every variable
		REM set opt1=
		REM set opt2=
		set opt11=
		set opt21=
		set opt31=
		call set opt1=%%INPUT[%idInput1%]%%
		call set opt2=%%INPUT[%idInput2%]%%
		call set opt3=%%INPUT[%idInput3%]%%

		goto :__loopArgs

	:__endLoopArgs
	
	REM Check mandatory param
	if [%FLAG_T%]==[] (
		echo.
		echo ERROR Missing mandatory flag
		echo.
		call :_usage
		goto :EOF
	)
	if %nbrParam%==0 (
		echo.
		echo ERROR Missing mandatory param
		echo.
	)
	if %nbrParam%==1 (
		echo.
		echo ERROR Missing mandatory param
		echo.
	)
	
	
	exit /b 0
::=============================================================================
:: sub function _checkArg_O for ARG_O
:_checkArg_O
	setlocal
	set param1=%1
	set first=
	REM # -o <arg>
	if [%param1%]==[] (
		echo ERROR -o Need one argument
		call :_usage
		exit /b 1
	) else (
		set first=%param1:~0,1%
	)
	if [%first%]==[-] (
		echo ERROR -o Need one argument
		call :_usage
		exit /b 1
	)
	endlocal
	
	set ARG_O=%1
	exit /b 0

::=============================================================================
:: sub function _checkArg_M for ARG_M
:_checkArg_M
	setlocal
	set param1=%1
	set param2=%2

	set first1=
	set first2=
	set missing=0
	if [%param1%]==[] (
		set missing=1
	) else (
		set first1=%param1:~0,1%
		if [%first1%]==[-] set missing=1
	)
	if [%param2%]==[] (
		set missing=1
	) else (
		set first2=%param2:~0,1%
		if [%first2%]==[-] set missing=1
	)

	if %missing%==1 (
		echo ERROR -m Need two arguments
		call :_usage
		goto :EOF
	)
	endlocal

	set ARG_M[%argMid%].text=%1
	set ARG_M[%argMid%].val=%2
	
	exit /b 0

::=============================================================================
:: _printArgs 
:: print argument after treatment in a human readable way
::     -f => FLAG_F printed as 0 or 1
::     -u or -v => FLAG_T printed as U or T
::     -o param => ARG_O (str) printed as param value
::     -m p1 p2 => ARG_M (list) printed as csv of text/val (e.g. p1/p2, p3/p4)
::     param => PARAM printed as param value
::     elem1 ... elemN => ELEM (list) printed as csv of elem (elem1, ..., elemN)
::=============================================================================
:_printArgs
	echo ARG_O:     %ARG_O%

	set argMid=0
	set ARG_M_STR=
	:__argMLoop
	if not defined ARG_M[%argMid%].text goto :__endArgMLoop
	call set ARG_M_id_txt=%%ARG_M[%argMid%].text%%
	call set ARG_M_id_val=%%ARG_M[%argMid%].val%%
	if "%ARG_M_STR%"=="" (
		set ARG_M_STR=%ARG_M_id_txt%/%ARG_M_id_val%
	) else (
		set ARG_M_STR=%ARG_M_STR%, %ARG_M_id_txt%/%ARG_M_id_val%
	)
	set /a "argMid+=1"
	GOTO :__argMLoop
	:__endArgMLoop
	echo ARG_M:     %ARG_M_STR%
	
	echo FLAG_F:    %FLAG_F%
	echo FLAG_T:    %FLAG_T%
	
	echo PARAM:     %PARAM%
	 		
	set i=0
	set ELEM_STR=
	:__elemLoop
	if not defined ELEM[%i%] goto :__endElemLoop
	call set VAL_ELEM_i=%%ELEM[%i%]%%
	if "%ELEM_STR%"=="" (
		set ELEM_STR=%VAL_ELEM_i%
	) else (
		set ELEM_STR=%ELEM_STR%,%VAL_ELEM_i%
	)
	set /a "i+=1"
	GOTO :__elemLoop
	:__endElemLoop
	echo ELEM:      %ELEM_STR%
	
	goto :eof

::=============================================================================
::=============================================================================
:: MAIN
::=============================================================================
::=============================================================================
:_MAIN
	set DEBUG=false
	CALL :_parseArgs %*
	if errorlevel 1 exit /b 1

	if "%STOP%"=="true" goto :EOF
	
	call :_printArgs
	
	echo.
	echo START SCRIPT
	echo.
 
GOTO :EOF
