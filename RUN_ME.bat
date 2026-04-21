@echo off
cd /d "%~dp0"
title Testing Cycle Tracker - GUB CSE-210
color 0B

echo.
echo ============================================================
echo  Mobile App Testing Cycle Tracker
echo  Green University of Bangladesh — CSE 210 (D4)
echo  Student: Asraful Islam Tonmoy  ^|  ID: 242002127
echo ============================================================
echo.

REM ── Step 1: Check Python ──────────────────────────────────
python --version >nul 2>&1
IF ERRORLEVEL 1 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python from https://python.org
    pause
    exit /b
)
echo [OK] Python found.

REM ── Step 2: Install / upgrade packages ───────────────────
echo.
echo [SETUP] Installing required packages...
echo         (This runs only once — future starts will be faster)
echo.
pip install streamlit mysql-connector-python pandas plotly --quiet --no-warn-script-location
IF ERRORLEVEL 1 (
    echo [ERROR] pip install failed. Check your internet connection.
    pause
    exit /b
)
echo [OK] All packages ready.

REM ── Step 3: Launch Streamlit ──────────────────────────────
echo.
echo [START] Launching dashboard...
echo         Browser will open at: http://localhost:8501
echo.
echo         Press Ctrl+C in this window to stop the server.
echo.
python -m streamlit run testing_tracker_streamlit.py --server.port 8501 --browser.gatherUsageStats false

pause
