.PHONY: setup start api dashboard mlflow clean help

help:
	@echo "make setup       - dependencies + NYC-Taxi-Daten"
	@echo "make start       - Cursor + MLflow UI"
	@echo "make api         - FastAPI auf http://localhost:8000"
	@echo "make dashboard   - Streamlit auf http://localhost:8501"
	@echo "make mlflow      - MLflow auf http://localhost:5000"
	@echo "make clean       - aufraeumen"

setup:
	@command -v uv >/dev/null 2>&1 || (echo "Bitte zuerst uv installieren: https://docs.astral.sh/uv/" && exit 1)
	uv sync
	uv run python data/download.py
	@echo "Setup fertig. Weiter mit: make start"

start:
	@uv run mlflow ui --host 0.0.0.0 --port 5000 > /tmp/mlflow.log 2>&1 &
	@command -v cursor >/dev/null 2>&1 && cursor . || echo "Bitte Cursor manuell oeffnen in $$(pwd)"
	@echo "Workshop bereit. Oeffne PROMPTS.md."

api:
	uv run uvicorn api.serve:app --reload --host 0.0.0.0 --port 8000

dashboard:
	uv run streamlit run dashboards/app.py

mlflow:
	uv run mlflow ui --host 0.0.0.0 --port 5000

clean:
	rm -rf data/*.parquet mlruns/ .venv/ __pycache__/ */__pycache__/ .pytest_cache/
