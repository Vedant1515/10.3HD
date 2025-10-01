@echo off
:loop
curl -s http://4.254.69.228/api/news > nul
echo .
timeout /t 1 /nobreak > nul
goto loop
