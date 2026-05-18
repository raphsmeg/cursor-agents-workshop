# workshop.ps1 - Windows/PowerShell Helper fuer den Cursor Agents Workshop
# Nutzung:  .\workshop.ps1 <command>
#
# Verfuegbare Commands:
#   setup       Installiert Dependencies und laedt NYC-Taxi-Daten
#   start       Startet MLflow UI im Hintergrund und oeffnet Cursor
#   api         Startet FastAPI auf http://localhost:8000
#   dashboard   Startet Streamlit auf http://localhost:8501
#   mlflow      Startet MLflow UI auf http://localhost:5000
#   clean       Loescht generierte Daten, Models, Caches
#   help        Zeigt diese Hilfe

param(
    [Parameter(Position = 0)]
    [string]$Command = "help"
)

$ErrorActionPreference = "Stop"

function Test-Uv {
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        Write-Host ""
        Write-Host "uv ist nicht installiert." -ForegroundColor Red
        Write-Host "Installation (PowerShell als Admin):" -ForegroundColor Yellow
        Write-Host '  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"'
        Write-Host "Alternativ mit winget:" -ForegroundColor Yellow
        Write-Host "  winget install --id=astral-sh.uv"
        Write-Host ""
        exit 1
    }
}

switch ($Command.ToLower()) {
    "help" {
        Write-Host ""
        Write-Host "Cursor Agents Workshop - PowerShell Helper" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  .\workshop.ps1 setup       - Dependencies + NYC-Taxi-Daten laden"
        Write-Host "  .\workshop.ps1 start       - Cursor + MLflow oeffnen"
        Write-Host "  .\workshop.ps1 api         - FastAPI auf http://localhost:8000"
        Write-Host "  .\workshop.ps1 dashboard   - Streamlit auf http://localhost:8501"
        Write-Host "  .\workshop.ps1 mlflow      - MLflow UI auf http://localhost:5000"
        Write-Host "  .\workshop.ps1 clean       - aufraeumen"
        Write-Host ""
    }

    "setup" {
        Test-Uv
        Write-Host "==> Installiere Python dependencies (uv sync)..." -ForegroundColor Cyan
        uv sync
        Write-Host "==> Lade NYC-Taxi-Daten (~50 MB)..." -ForegroundColor Cyan
        uv run python data/download.py
        Write-Host ""
        Write-Host "Setup fertig! Weiter mit: .\workshop.ps1 start" -ForegroundColor Green
    }

    "start" {
        Test-Uv
        Write-Host "==> Starte MLflow UI im Hintergrund (http://localhost:5000)..." -ForegroundColor Cyan
        Start-Process -WindowStyle Hidden -FilePath "uv" `
            -ArgumentList "run", "python", "-m", "mlflow", "ui", "--host", "0.0.0.0", "--port", "5000"
        Start-Sleep -Seconds 2

        if (Get-Command cursor -ErrorAction SilentlyContinue) {
            Write-Host "==> Oeffne Cursor..." -ForegroundColor Cyan
            cursor .
        } else {
            Write-Host "Cursor CLI nicht gefunden - bitte Cursor manuell oeffnen in:" -ForegroundColor Yellow
            Write-Host "  $(Get-Location)"
            Write-Host "(Tipp: in Cursor Cmd-Palette -> 'Shell Command: Install cursor command')"
        }
        Write-Host ""
        Write-Host "Workshop bereit. Oeffne PROMPTS.md fuer die ersten Prompts." -ForegroundColor Green
    }

    "api" {
        Test-Uv
        Write-Host "==> Starte FastAPI auf http://localhost:8000/docs ..." -ForegroundColor Cyan
        uv run uvicorn api.serve:app --reload --host 0.0.0.0 --port 8000
    }

    "dashboard" {
        Test-Uv
        Write-Host "==> Starte Streamlit auf http://localhost:8501 ..." -ForegroundColor Cyan
        uv run python -m streamlit run dashboards/app.py
    }

    "mlflow" {
        Test-Uv
        Write-Host "==> Starte MLflow UI auf http://localhost:5000 ..." -ForegroundColor Cyan
        uv run python -m mlflow ui --host 0.0.0.0 --port 5000
    }

    "clean" {
        Write-Host "==> Raeume auf..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `
            data/*.parquet, mlruns, .venv, __pycache__, `
            pipelines/__pycache__, queries/__pycache__, models/__pycache__, `
            dashboards/__pycache__, api/__pycache__, .pytest_cache, models/*.pkl
        Write-Host "Aufgeraeumt." -ForegroundColor Green
    }

    default {
        Write-Host "Unbekannter Befehl: $Command" -ForegroundColor Red
        Write-Host "Hilfe mit: .\workshop.ps1 help"
        exit 1
    }
}
