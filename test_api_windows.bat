@echo off
REM Script batch pour tester l'API sur Windows
REM Utilisation: test_api_windows.bat

curl -X POST http://127.0.0.1:7788/api/v1/agents/run -H "Content-Type: application/json" -d @test_api.json

pause
