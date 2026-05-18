# Workshop-Prompts (Copy & Paste)

Cursor im Agent Mode oeffnen (Cmd/Ctrl + I) und die Prompts der Reihe nach ausprobieren.

## Demo (Minute 10-20) - Der Wow-Prompt

> Baue mir einen kompletten End-to-End Flow mit den NYC-Taxi-Daten:
> eine Cleaning-Pipeline, eine Analytics-Query fuer die Top-10 Pickup-Zonen,
> ein Modell zur Fahrpreis-Vorhersage, ein Dashboard und eine FastAPI fuer das Modell.
> Erklaere kurz deinen Plan und delegiere dann an die richtigen Subagenten.

## Hands-on 1: Data Engineering (20-28)

> Schreibe in pipelines/clean.py eine Polars-Pipeline:
> Rohdaten laden, ungueltige Zeilen filtern (negative Fares, 0 Distanz, > 6h Trips),
> Features bauen (trip_duration_min, pickup_hour, pickup_dayofweek, fare_per_mile),
> Output nach data/clean.parquet. Am Ende mit `uv run python pipelines/clean.py` ausfuehren.

## Hands-on 1: Analytics (28-35)

> Schreibe in queries/ drei SQL-Files:
> (1) Top-10 Pickup-Zonen nach Trips, (2) Avg Fare pro Stunde, (3) Payment-Type-Verteilung.
> Ergaenze queries/run.py, das eine SQL-Datei als Argument nimmt und das Ergebnis
> als Markdown-Tabelle printet. Fuehre alle drei einmal aus.

## Hands-on 2: Machine Learning (35-43)

> Trainiere in models/train.py ein Gradient-Boosting-Modell, das total_amount
> aus trip_distance, passenger_count, pickup_hour, pickup_dayofweek,
> PULocationID, DOLocationID vorhersagt. Nutze MLflow Tracking, sample auf 200k Zeilen,
> speichere als models/model.pkl. Zeig mir MAE und R2 am Ende.

## Hands-on 2: Visualization (43-50)

> Baue in dashboards/app.py ein Streamlit-Dashboard mit:
> 4 KPI-Karten, Bar Chart Trips pro Stunde, Top-10 Pickup-Zonen,
> Scatter Fare vs Distance, Pie Chart Payment-Types.
> Nutze DuckDB direkt gegen data/clean.parquet. Starte mit `make dashboard`.

## Bonus: API (50-60)

> Baue in api/serve.py eine FastAPI mit /health, /predict, /predict/batch.
> Modell aus models/model.pkl laden. Starte mit `make api` und teste an
> http://localhost:8000/docs.

Test-Request fuer Swagger:

```json
{
  "trip_distance": 3.5,
  "passenger_count": 1,
  "pickup_hour": 18,
  "pickup_dayofweek": 5,
  "PULocationID": 161,
  "DOLocationID": 236
}
```

## Zusatz-Prompts
- Filter fuer Wochentag/Stunde im Dashboard ergaenzen.
- Drei Modelle (Linear, RandomForest, GradientBoosting) vergleichen und alle in MLflow loggen.
- API um /explain-Endpoint (Feature-Importances) erweitern.
