@echo off
:: Enable logging
set LOGFILE=C:\Users\77nim\OneDrive\Desktop\Practice\TaskSchedulerBATFiles\script_log.txt

:: Overwrite existing log file at the start
echo ============================== > "%LOGFILE%"
echo Script started at %DATE% %TIME% | tee -a "%LOGFILE%"
echo ============================== | tee -a "%LOGFILE%"

:: Change directory to the location of the Docker project
cd /d "C:\Users\77nim\OneDrive\Desktop\Practice\GraysWebScraping\GraysScrapingUsingAsync"
echo Changed working directory to: %CD% | tee -a "%LOGFILE%"

:: Check if Docker is running
docker info >nul 2>&1
IF ERRORLEVEL 1 (
    echo [ERROR] Docker is not running! Starting Docker... | tee -a "%LOGFILE%"
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    timeout /t 30 /nobreak >nul
)

:: Ensure Docker daemon is fully started
:wait
docker info >nul 2>&1
IF ERRORLEVEL 1 (
    echo Waiting for Docker to initialize... | tee -a "%LOGFILE%"
    timeout /t 5 /nobreak >nul
    goto wait
)

echo [SUCCESS] Docker is running! | tee -a "%LOGFILE%"

:: Run the Docker container with the correct volume mount and working directory
echo Running Docker container... | tee -a "%LOGFILE%"
docker run --rm -v "%cd%:/app" grays_scraper 2>&1 | tee -a "%LOGFILE%"

IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Docker container failed! Check logs. | tee -a "%LOGFILE%"
) ELSE (
    echo [SUCCESS] Docker container executed successfully! | tee -a "%LOGFILE%"
)

echo Task Completed! | tee -a "%LOGFILE%"

:: Log completion time
echo ============================== | tee -a "%LOGFILE%"
echo Script ended at %DATE% %TIME% | tee -a "%LOGFILE%"
echo ============================== | tee -a "%LOGFILE%"

pause
exit
