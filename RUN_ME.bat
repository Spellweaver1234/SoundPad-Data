@echo off
set /p msg="Enter commit message (or press Enter for 'Update sounds'): "
if "%msg%"=="" set msg=Update sounds

echo --- 1. Generating JSON ---
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update_sounds.ps1"

echo --- 2. Adding files to Git ---
git add .

echo --- 3. Committing ---
git commit -m "%msg%"

echo --- 4. Pushing to GitHub ---
git push

echo --- DONE! ---
pause
