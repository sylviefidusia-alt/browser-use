# Script PowerShell pour tester l'API sur Windows
# Utilisation: .\test_api.ps1

$body = @{
    task = "Rechercher des informations sur Python"
    config = @{
        llm = @{
            provider = "ollama"
            model_name = "qwen2.5:7b"
            temperature = 0.6
            base_url = "http://localhost:11434"
            use_vision = $true
        }
        browser = @{
            headless = $false
            window_width = 1280
            window_height = 1100
        }
        agent = @{
            max_steps = 100
            max_actions = 10
        }
    }
} | ConvertTo-Json -Depth 10

$response = Invoke-RestMethod -Uri "http://127.0.0.1:7788/api/v1/agents/run" -Method Post -Body $body -ContentType "application/json"
$response | ConvertTo-Json -Depth 10
