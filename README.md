# Grays Web Scraper Automation Script

This document provides a comprehensive guide to understanding and utilizing the `run_docker_only.bat` script for automating the Grays Web Scraper using Docker. It also covers the installation and setup of the `tee` utility, essential for logging script output.

## Table of Contents

1.  **Overview**
2.  **Script Breakdown: `run_docker_only.bat`**
3.  **Docker Setup**
4.  **Installing and Setting Up `tee`**
    * **Method 1: Using Git for Windows (Detailed)**
    * **Method 2: Using Cygwin**
    * **Method 3: Using WSL (Windows Subsystem for Linux)**
    * **Method 4: Using Chocolatey (Recommended)**
5.  **Running the Script**
6.  **Troubleshooting**
7.  **Contributing**

## 1.  Overview

The `run_docker_only.bat` script automates the execution of a Docker container that runs the Grays Web Scraper. It handles Docker startup, directory navigation, container execution, and comprehensive logging. This script is designed for ease of use and reliability in an automated environment, such as Windows Task Scheduler.

## 2.  Script Breakdown: `run_docker_only.bat`

```batch
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
```

* **Logging:** The script initializes a log file (`script_log.txt`) and uses `tee` to append output to both the console and the log file.
* **Directory Navigation:** It changes the current directory to the location of the Docker project.
* **Docker Check and Startup:** It checks if Docker is running and starts it if necessary, waiting for it to fully initialize.
* **Container Execution:** It runs the Docker container `grays_scraper` with a volume mount to the project directory, enabling the container to access local files.
* **Error Handling:** It checks for errors during container execution and logs appropriate messages.
* **Completion Logging:** It logs the script's completion time.

## 3.  Docker Setup

Before running the script, ensure Docker Desktop is installed and running on your Windows machine.

* **Install Docker Desktop:** Download and install Docker Desktop from the official Docker website.
* **Verify Installation:** Open a command prompt or PowerShell and run `docker --version` to verify the installation.
* **Build Docker Image:** Navigate to the `GraysScrapingUsingAsync` directory and build the Docker image using `docker build -t grays_scraper .`.

## 4.  Installing and Setting Up `tee`

The `tee` utility is used for logging script output. Here are several methods to install it on Windows:

### Method 1: Using Git for Windows (Detailed)

This method leverages the Git for Windows installation, which often includes a suite of Unix-like utilities, including `tee`. This is a convenient option if you already have Git installed on your system.

* **Verification of Git for Windows Installation:**
    * Open Command Prompt or PowerShell and type `git --version`.
    * If Git is not installed, download it from git-scm.com and install, choosing the option to "Use Git from the Windows Command Prompt".
* **Locating the `tee` Utility:**
    * Navigate to `C:\Program Files\Git\usr\bin` and run `tee --version`.
* **Adding Git's `bin` Directory to the System PATH (If Necessary):**
    * Search for "Environment Variables" in the Start Menu.
    * Select "Edit the system environment variables".
    * Click "Environment Variables...".
    * Edit the "Path" variable in System variables.
    * Add `C:\Program Files\Git\usr\bin` to the list.
    * Restart Command Prompt or PowerShell.
* **Verification:**
    * Run `tee --version` from any directory.

### Method 2: Using Cygwin

Cygwin provides a Unix-like environment for Windows.

* **Install Cygwin:** Download and install Cygwin from cygwin.com.
* **Select Packages:** Choose the `coreutils` package during installation.
* **Add to PATH:** Add the Cygwin bin directory (e.g., `C:\cygwin64\bin`) to your system's PATH.

### Method 3: Using WSL (Windows Subsystem for Linux)

WSL allows you to run a Linux environment directly on Windows.

* **Enable WSL:** Enable WSL and install a Linux distribution from the Microsoft Store.
* **Install `coreutils`:** Open your WSL terminal and run `sudo apt-get update && sudo apt-get install coreutils`.
* **Access from Windows:** Use `wsl tee` from the Windows command prompt, or add the wsl path to the windows path.

### Method 4: Using Chocolatey (Recommended)

Chocolatey is a package manager for Windows.

* **Install Chocolatey:** Follow the instructions on chocolatey.org.
* **Install `coreutils`:** Open an elevated command prompt and run `choco install coreutils`.
* **Verify Installation:** Run `tee --version`.

## 5.  Running the Script

* Ensure Docker is running.
* Place the `run_docker_only.bat` script in a convenient location.
* Double-click the script to execute it.
* Monitor the console for output and check the `script_log.txt` file for detailed logs.

## 6.  Troubleshooting

* **Docker Errors:** Check Docker Desktop logs and ensure the Docker image is built correctly.
* **`tee` Errors:** Verify `tee` is correctly installed and added to the system's PATH.
* **Script Errors:** Review the `script_log.txt` file for detailed error messages.
* **Path Errors:** Verify all file paths in the script are correct.

## 7.  Contributing

Contributions to improve the script or documentation are welcome. Please submit pull requests or open issues on the project's repository.
