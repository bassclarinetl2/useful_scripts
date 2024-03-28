@echo off
SETLOCAL
SET /P TZ="Press 1 for Pacific Standard Time or 2 for Pacific Daylight Time"

2>NUL CALL :CASE_%TZ% # jump to :case_1, case_2 etc
IF ERRORLEVEL 1 CALL :DEFAULT_CASE # if no label

ECHO Done
EXIT /B

:CASE_1
  tztuil /S "Pacific Standard Time"
  GOTO END_CASE
:CASE_2
  tzutil /S "Pacific Daylight Time"
  GOTO END_CASE
:DEFAULT_CASE
  ECHO Unknown option %TZ%
  GOTO END_CASE
:END_CASE
  VER > NUL # reset ERRORLEVEL
  GOTO :EOF # reset from call
