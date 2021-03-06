:: dispatch.bat
::
:: $Revision: 1022 $
::
@ECHO off
setlocal

IF DEFINED USER (
   set USER_NAME=%USER%
) ELSE (
   set USER_NAME=%USERNAME%
)

rem Guess RDECK_BASE if not defined
set "CURRENT_DIR=%cd%"
if not "%RDECK_BASE%" == "" goto gotRdeckBase
set "RDECK_BASE=%CURRENT_DIR%"
if exist "%RDECK_BASE%\etc\profile.bat" goto gotRdeckBase
set "RDECK_BASE="
:gotRdeckBase

IF NOT EXIST "%RDECK_BASE%\etc\profile.bat" (
   ECHO Unable to source %RDECK_BASE%\etc\profile.bat
   GOTO:EOF
) ELSE (
	CALL "%RDECK_BASE%\etc\profile.bat"
)

IF NOT DEFINED RDECK_BASE (
   ECHO RDECK_BASE not set
   GOTO:EOF
)

IF "%JAVA_HOME%" =="" (
   echo JAVA_HOME not set
   GOTO:EOF
)
IF NOT EXIST "%JAVA_HOME%\bin\java.exe" (
   ECHO JAVA_HOME not set or set incorrectly
   GOTO:EOF
)

::
:: run dispatch main class
::
call "%JAVA_HOME%\bin\java.exe" ^
    %RDECK_CLI_OPTS% ^
    -Djava.ext.dirs=%RD_LIBDIR% ^
    -Drdeck.base="%RDECK_BASE%" ^
    %RDECK_SSL_OPTS% ^
    -Drdeck.traceExceptions="%RUNDECK_TRACE_EXCEPTIONS%" ^
    -Drdeck.cli.terse="%RUNDECK_CLI_TERSE%" ^
	com.dtolabs.rundeck.core.cli.ExecTool %*

IF NOT "%ERRORLEVEL%"=="0" GOTO:EXITSetup

:EXITSetup

EXIT /B %ERRORLEVEL%
