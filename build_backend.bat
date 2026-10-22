@echo off
title Compile Java Backend & Build WAR
echo ====================================================================
echo   Compiling Java Backend (Servlets, DAOs, Models) & Packaging WAR
echo ====================================================================
echo.
python "%~dp0build.py"
echo.
echo WAR file generated in build/PlacementManagement.war
echo Ready to deploy on Apache Tomcat / Eclipse / AWS EC2.
pause
