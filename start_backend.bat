@echo off
title Cloud-Based Placement Management System - Backend Server
echo ====================================================================
echo   Cloud-Based Placement Management System - Backend Server
echo   ADBMS Minor Project for Cloud Computing
echo ====================================================================
echo.
echo [1/2] Checking backend dependencies...
python -c "import sqlite3; print('SQLite Database Engine: Ready')"
echo.
echo [2/2] Launching Backend Server on port 8080...
echo Opening http://localhost:8080 in your default web browser...
start http://localhost:8080
echo.
echo Backend is active and connected. Keep this window open while using the app.
echo Press Ctrl+C in this window to stop the server.
echo ====================================================================
python "%~dp0runner\app.py"
pause
