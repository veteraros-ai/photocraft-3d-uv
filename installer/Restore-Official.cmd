@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-Official.ps1"
if errorlevel 1 (
  echo Restore did not finish. Read the message above.
  pause
  exit /b 1
)
pause
