"""Laedt NYC Yellow Taxi Januar 2024 als Parquet (~50 MB)."""
from pathlib import Path
import sys
import urllib.request

URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet"
OUT = Path(__file__).parent / "yellow_tripdata_2024-01.parquet"


def main():
    if OUT.exists():
        mb = OUT.stat().st_size / 1024 / 1024
        print(f"Daten existieren bereits: {OUT} ({mb:.1f} MB)")
        return
    print(f"Lade {URL} ...")
    try:
        urllib.request.urlretrieve(URL, OUT)
    except Exception as e:
        print(f"Download fehlgeschlagen: {e}", file=sys.stderr)
        sys.exit(1)
    mb = OUT.stat().st_size / 1024 / 1024
    print(f"Fertig: {OUT} ({mb:.1f} MB)")


if __name__ == "__main__":
    main()
