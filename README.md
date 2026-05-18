# Cursor Agents Workshop - NYC Taxi Edition

Ein 60-Minuten-Workshop mit Cursor im Agent-Mode und spezialisierten Subagenten fuer:
Data Engineering -> Analytics -> Machine Learning -> Visualization -> API

Du tippst einen Prompt - die Agenten erledigen den Rest.

## Quickstart

```
git clone <repo-url> cursor-agents-workshop
cd cursor-agents-workshop
make setup
make start
```

Voraussetzungen: Python 3.10+, Cursor, make, uv (siehe https://docs.astral.sh/uv/).

## Agenten

Im Ordner `.cursor/rules/` liegt pro Subagent eine Rule. Cursor aktiviert sie automatisch:

| Agent | Datei | Aktiv in | Stack |
|-------|-------|----------|-------|
| Orchestrator | 00_orchestrator.mdc | ueberall (always) | - |
| Data Engineering | 01_data_eng.mdc | `pipelines/**` | DuckDB + Polars |
| Analytics | 02_analytics.mdc | `queries/**` | DuckDB SQL |
| Machine Learning | 03_ml.mdc | `models/**` | scikit-learn + MLflow |
| Visualization | 04_viz.mdc | `dashboards/**` | Streamlit + Plotly |
| API | 05_api.mdc | `api/**` | FastAPI + uvicorn |

## Workshop-Ablauf (60 Min)

| Zeit | Block |
|------|-------|
| 0-10 | Setup & Intro |
| 10-20 | Demo: Ein Prompt -> Orchestrator delegiert live |
| 20-35 | Hands-on: DE + Analytics |
| 35-50 | Hands-on: ML + Viz |
| 50-60 | Bonus: API & Q&A |

Konkrete Prompts -> `PROMPTS.md`.

## Befehle

```
make setup        # Dependencies + NYC-Taxi-Daten laden
make start        # Cursor + MLflow oeffnen
make api          # FastAPI auf http://localhost:8000/docs
make dashboard    # Streamlit auf http://localhost:8501
make mlflow       # MLflow auf http://localhost:5000
make clean        # aufraeumen
```
