@echo off
::#############################################################################
::# LOGGER for batch
::#############################################################################
::# Some predefined logging function with color
::# 
::# 

call:%*
:: return the ErrorLevel to caller
:: do not forget to add a case for 2, 3, ... if needed
if ErrorLevel 1 (
	exit /b 1
) else if ErrorLevel 0 (
	exit /b 0
)

REM #----------------------------------------------------------------------------
:_setLog
	REM # usage: call :_setLog (loglevel) (batchname) [logfilename]
	
	REM # Init DEBUGLEVEL can be:
	REM #    0 - Error
	REM #    1 - 0 + Warning
	REM #    2 - 1 + info (default)
	REM #    3 - 2 + debug traces
	if "%1" == "ERROR" (
		set LOGLEVEL=0
	) else if "%1" == "WARNING" (
		set LOGLEVEL=1
	) else if "%1" == "INFO" (
		set LOGLEVEL=2
	) else if "%1" == "DEBUG" (
		set LOGLEVEL=3
	) else exit /b 1

	Set FICLOG=%REPLOG%\%2.log
	
	echo LOGLEVEL set to %LOGLEVEL%
	echo FICLOG set to %FICLOG%

	If /I "%3"=="" (
		If Not Exist %REPLOG% MD %REPLOG% > Nul 2>&1
		If Exist %FICLOG% Move /y %FICLOG% %FICLOG%.sav > Nul 2>&1
	) Else (
		Set FICLOG=%3
	)
	
	exit /b 0

REM #----------------------------------------------------------------------------
:_questionYesNo
	REM # Ask question (in blue) with choice= Y|N
	REM # Return 1 if No, 0 if Yes
	call :_log_question "%1 ? "
	choice /c yn /n
	
	REM # Always start with highest possible choice to lower
	REM # N => ErrorLevel 2
	REM # Y => ErrorLevel 1 == any ErrorLevel diff to 0
	If Errorlevel 2 (
		Call :_log_info "N" /f
		
		REM # Print some specific message if exist
		if "%2" NEQ "" (
			Call :_log_warning %2
		)

		REM # Do some specific subfunction if needed
		if "%3" NEQ "" (
			Call :_questionYesNo_%3
		)

		Exit /b 1
	)

	Call :_log_info "Y" /f
	Exit /b 0
REM #----------------------------------------------------------------------------
:_questionYesNo_subfunc1
	echo Do _questionYesNo_subfunc1
:_questionYesNo_subfunc2
	echo Do _questionYesNo_subfunc2

REM #----------------------------------------------------------------------------
REM # Wrapper to call the log function where it is (today Utils.bat)
:_log_wrapper
	if %1 == INFO (
		call :_log_info %2 %3
	) else if %1 == TITLE1 (
		call :_log_title1 %2 %3
	) else if %1 == TITLE2 (
		call :_log_title2 %2 %3
	) else if %1 == TITLE3 (
		call :_log_title3 %2 %3
	) else if %1 == WARNING (
		call :_log_warning %2 %3
	) else if %1 == ERROR (
		call :_log_error %2 %3
	) else if %1 == DEBUG (
		call :_log_debug %2 %3
	) else if %1 == SUCCESS (
		call :_log_success %2 %3
	) else if %1 == QUESTION (
		call :_log_question %2 %3
	) else (
		call :_log_info %2 %3
	)
	
	goto :eof
	
REM #----------------------------------------------------------------------------
:_log_title1
	REM
	REM ##########################################################################
	REM #                                                                        #
	REM # MESSAGE                                                                
	REM #                                                                        #
	REM ##########################################################################
	call :_log_info "."
	call :_log_info "##########################################################################" %~2
	call :_log_info "#                                                                        #" %~2
	call :_log_info "#  %~1"  %~2
	call :_log_info "#                                                                        #" %~2
	call :_log_info "##########################################################################" %~2

	goto :eof
REM #----------------------------------------------------------------------------
:_log_title2
	REM
	REM ===================================================
	REM   MESSAGE                                                                
	REM ===================================================
	call :_log_info "."
	call :_log_info "===================================================" %~2
	call :_log_info "  %~1"  %~2
	call :_log_info "===================================================" %~2

	goto :eof
REM #----------------------------------------------------------------------------
:_log_title3
	REM ---------------------------------------------------
	REM -  MESSAGE                                                                
	REM ---------------------------------------------------

	call :_log_info "---------------------------------------------------" %~2
	call :_log_info "-  %~1"  %~2
	call :_log_info "---------------------------------------------------" %~2

	goto :eof
REM #----------------------------------------------------------------------------
:_log_info
	REM usage - Call Utils.bat :_log "message" [/f]
	REM     option /f to print message in filelog only
	REM               default: print in filelog and stdout
	REM
	REM note - to print a blank line - Call :_log "." [/f]
	if 2 LEQ %LOGLEVEL% (
		if "%~1" == "." (
			Echo %date:~-10% %time:~0,-3% -  >> %FICLOG% 2>&1
			if "%~2" NEQ "/f" Echo.		
		) else (
			Echo %date:~-10% %time:~0,-3% - %~1 >> %FICLOG% 2>&1
			if "%~2" NEQ "/f" Echo %~1
		)
	)
	goto :eof
	
REM #----------------------------------------------------------------------------
:_log_error
	REM usage - Call :_log_error "message" [/s]
	REM     option /s to print message in stdout only
	REM               default: print in filelog and stdout
	REM
	REM note - Will print it in RED if windows10
	if 0 LEQ %LOGLEVEL% (
		if "%~2" NEQ "/s" (
			Echo %date:~-10% %time:~0,-3% - ERROR - %~1 >> %FICLOG%
		)
		call :_isColorSupported
		if ErrorLevel 0 (
			REM [1m => Bold
			REM [91m => STRONG RED
			Echo [1m[91m %~1 [0m
		) else Echo %~1
	)
	Goto :eof
Rem ----------------------------------------------------------------------------
:_log_warning
	REM usage - Call :_log_warning "message" [/s]
	REM     option /s to print message on screen only
	REM               default: print in filelog and stdout
	REM
	REM note - Will print it in YELLOW if windows10
	if 1 LEQ %LOGLEVEL% (
		if "%~2" NEQ "/s" (
			Echo %date:~-10% %time:~0,-3% - WARN  - %~1 >> %FICLOG%
		)
		call :_isColorSupported
		if ErrorLevel 0 (
			REM [93m => STRONG YELLOW
			Echo [93m %~1 [0m
		) else Echo %~1
	)
	Goto :eof
Rem ----------------------------------------------------------------------------
:_log_debug
	REM usage - Call :_log_warning "message" [/s]
	REM     option /s to print message on screen only
	REM               default: print in filelog and stdout
	REM
	REM note - Will print it in YELLOW if windows10
	if 3 LEQ %LOGLEVEL% (
		if "%~2" NEQ "/s" (
			Echo %date:~-10% %time:~0,-3% - DEBUG  - %~1 >> %FICLOG%
		)
		call :_isColorSupported
		if ErrorLevel 0 (
			REM [36m => NORMAL YELLOW
			Echo [36m %~1 [0m
		) else Echo %~1
	)
	Goto :eof
Rem ----------------------------------------------------------------------------
:_log_success
	REM usage - Call :_log_warning "message" [/s]
	REM     option /s to print message on screen only
	REM               default: print in filelog and stdout
	REM
	REM note - Will print it in GREEN if windows10
	if 0 LEQ %LOGLEVEL% (
		if "%~2" NEQ "/s" (
			Echo %date:~-10% %time:~0,-3% - SUCCESS  - %~1 >> %FICLOG%
		)
		call :_isColorSupported
		if ErrorLevel 0 (
			REM [1m[92m => BOLD GREEN
			Echo [1m[92m %~1 [0m
		) else Echo %~1
	)
	Goto :eof
Rem ----------------------------------------------------------------------------
:_log_question
	REM usage - Call :_log_warning "message" [/s]
	REM     option /s to print message on screen only
	REM               default: print in filelog and stdout
	REM
	REM note - Will print it in BLUE if windows10
	if 0 LEQ %LOGLEVEL% (
		if "%~2" NEQ "/s" (
			Echo %date:~-10% %time:~0,-3% - %~1 >> %FICLOG%
		)
		call :_isColorSupported
		if ErrorLevel 0 (
			REM [96m => NORMAL BLUE
			Echo [96m %~1 [0m
		) else Echo %~1
	)
	Goto :eof
Rem ----------------------------------------------------------------------------

Rem ----------------------------------------------------------------------------
:_isColorSupported
	:: Color is supported for Windows 10 only
	:: Note on color: https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences?redirectedfrom=MSDN
	:: 
	setlocal
	set SUPPORT=0
	
	:: ver => Microsoft Windows [Version 10.0.14393]
	::        for windows version details: https://docs.microsoft.com/fr-fr/windows/win32/sysinfo/operating-system-version?redirectedfrom=MSDN
	::        get tokens 4, 5 (version) and 6 (build)
	for /f "tokens=4-6 delims=. " %%i in ('ver') do (
		set VERSION=%%i.%%j
		set BUILD=%%k
	)
	for /f "tokens=1 delims=]" %%i in ('echo %build%') do (
		set BUILD=%%i
	)

	if "%version%" == "10.0" (
		if %build% GEQ 16257 set SUPPORT=1
	) 

	if "%support%" == "1" exit /b 0

	exit /b 1
	endlocal
Rem ----------------------------------------------------------------------------

