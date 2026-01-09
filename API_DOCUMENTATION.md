# Documentation API - Browser Use

## Endpoints disponibles

### 0. Test de santé

**GET** `/api/v1/health`

Vérifie que l'API est accessible.

#### Réponse

```json
{
  "status": "ok",
  "database_connected": true
}
```

### 1. Lancer un agent avec une configuration complète

**POST** `/api/v1/agents/run`

Lance un agent Browser Use avec une configuration complète passée via l'API.

#### Requête

```json
{
  "task": "Rechercher des informations sur Python et créer un résumé",
  "task_id": "optional-custom-task-id",
  "config": {
    "llm": {
      "provider": "ollama",
      "model_name": "qwen2.5:7b",
      "temperature": 0.6,
      "base_url": "http://localhost:11434",
      "use_vision": true,
      "ollama_num_ctx": 16000
    },
    "browser": {
      "headless": false,
      "window_width": 1280,
      "window_height": 1100,
      "keep_browser_open": false
    },
    "agent": {
      "max_steps": 100,
      "max_actions": 10,
      "max_input_tokens": 128000,
      "tool_calling_method": "auto"
    }
  }
}
```

#### Ou utiliser un preset sauvegardé

```json
{
  "task": "Rechercher des informations sur Python",
  "config_name": "ma_config_prod"
}
```

#### Réponse

```json
{
  "success": true,
  "task_id": "uuid-de-la-tache",
  "message": "Agent lancé avec succès",
  "status": "pending"
}
```

#### Exemples avec cURL

**Linux/Mac:**
```bash
curl -X POST http://127.0.0.1:7788/api/v1/agents/run \
  -H "Content-Type: application/json" \
  -d '{
    "task": "Rechercher des informations sur Python",
    "config": {
      "llm": {
        "provider": "ollama",
        "model_name": "qwen2.5:7b",
        "temperature": 0.6,
        "base_url": "http://localhost:11434",
        "use_vision": true
      },
      "browser": {
        "headless": false,
        "window_width": 1280,
        "window_height": 1100
      },
      "agent": {
        "max_steps": 100,
        "max_actions": 10
      }
    }
  }'
```

**Windows (PowerShell):**
```powershell
$body = Get-Content test_api.json -Raw
Invoke-RestMethod -Uri "http://127.0.0.1:7788/api/v1/agents/run" -Method Post -Body $body -ContentType "application/json"
```

**Windows (cmd avec fichier JSON):**
```cmd
curl -X POST http://127.0.0.1:7788/api/v1/agents/run -H "Content-Type: application/json" -d @test_api.json
```

### 2. Sauvegarder un preset de configuration

**POST** `/api/v1/configs/presets`

Sauvegarde un preset de configuration pour réutilisation.

#### Requête

```json
{
  "name": "ma_config_prod",
  "description": "Configuration pour la production",
  "config": {
    "llm": {
      "provider": "ollama",
      "model_name": "qwen2.5:7b",
      "temperature": 0.6,
      "base_url": "http://localhost:11434",
      "use_vision": true
    },
    "browser": {
      "headless": false,
      "window_width": 1280,
      "window_height": 1100
    },
    "agent": {
      "max_steps": 100,
      "max_actions": 10
    }
  }
}
```

### 3. Lister les presets de configuration

**GET** `/api/v1/configs/presets`

Retourne la liste de tous les presets sauvegardés.

### 4. Récupérer le statut d'une tâche

**GET** `/api/v1/tasks/{task_id}`

Récupère les informations d'une tâche en cours ou terminée.

#### Réponse

```json
{
  "id": 1,
  "task_id": "uuid-de-la-tache",
  "task_description": "Rechercher des informations sur Python",
  "agent_type": "browser_use",
  "status": "running",
  "result_data": null,
  "error_message": null,
  "created_at": "2024-01-01T12:00:00",
  "started_at": "2024-01-01T12:00:01",
  "completed_at": null
}
```

### 5. Lister les tâches

**GET** `/api/v1/tasks?status=running&limit=50`

Liste les tâches, optionnellement filtrées par statut.

## Configuration par défaut

Si aucune configuration n'est fournie, une configuration par défaut est utilisée (codée en dur dans `app/src/api/default_config.py`) :

```python
{
    "llm": {
        "provider": "ollama",
        "model_name": "qwen2.5:7b",
        "temperature": 0.6,
        "base_url": "http://localhost:11434",
        "use_vision": True
    },
    "browser": {
        "headless": False,
        "window_width": 1280,
        "window_height": 1100
    },
    "agent": {
        "max_steps": 100,
        "max_actions": 10
    }
}
```

## Exemples de configurations

### Configuration avec OpenAI

```json
{
  "llm": {
    "provider": "openai",
    "model_name": "gpt-4o",
    "temperature": 0.6,
    "use_vision": true
  },
  "browser": {
    "headless": false
  },
  "agent": {
    "max_steps": 100
  }
}
```

### Configuration headless

```json
{
  "llm": {
    "provider": "ollama",
    "model_name": "qwen2.5:7b",
    "base_url": "http://localhost:11434"
  },
  "browser": {
    "headless": true,
    "window_width": 1280,
    "window_height": 1100
  },
  "agent": {
    "max_steps": 100
  }
}
```

## Structure de configuration complète

```json
{
  "llm": {
    "provider": "string (requis)",
    "model_name": "string (requis)",
    "temperature": "float (défaut: 0.6)",
    "base_url": "string (optionnel)",
    "api_key": "string (optionnel, utilise .env si non fourni)",
    "ollama_num_ctx": "int (défaut: 16000, pour Ollama uniquement)",
    "use_vision": "bool (défaut: true)"
  },
  "browser": {
    "headless": "bool (défaut: false)",
    "disable_security": "bool (défaut: false)",
    "browser_binary_path": "string (optionnel)",
    "browser_user_data_dir": "string (optionnel)",
    "use_own_browser": "bool (défaut: false)",
    "keep_browser_open": "bool (défaut: false)",
    "window_width": "int (défaut: 1280)",
    "window_height": "int (défaut: 1100)",
    "cdp_url": "string (optionnel)",
    "wss_url": "string (optionnel)"
  },
  "agent": {
    "max_steps": "int (défaut: 100)",
    "max_actions": "int (défaut: 10)",
    "max_input_tokens": "int (défaut: 128000)",
    "tool_calling_method": "string (défaut: 'auto')",
    "override_system_prompt": "string (optionnel)",
    "extend_system_prompt": "string (optionnel)"
  },
  "planner_llm": {
    "provider": "string (optionnel)",
    "model_name": "string (optionnel)",
    "temperature": "float (optionnel)",
    "use_vision": "bool (optionnel)"
  }
}
```
