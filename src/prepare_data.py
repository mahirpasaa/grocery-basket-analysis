"""Convert the raw Instacart CSVs into Parquet so the SQL layer runs fast.

Usage:
    python src/prepare_data.py

Expects the Kaggle CSVs in ./data (see README). Writes ./data/parquet/*.parquet.
"""
from pathlib import Path

import duckdb

DATA = Path(__file__).resolve().parents[1] / "data"
OUT = DATA / "parquet"

TABLES = {
    "orders": "orders.csv",
    "order_products": "order_products__prior.csv",
    "products": "products.csv",
    "aisles": "aisles.csv",
    "departments": "departments.csv",
}


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    con = duckdb.connect()
    for table, csv in TABLES.items():
        src = DATA / csv
        if not src.exists():
            raise FileNotFoundError(f"Missing {src}. Download the dataset first (see README).")
        dst = OUT / f"{table}.parquet"
        con.execute(
            f"COPY (SELECT * FROM read_csv_auto('{src.as_posix()}')) "
            f"TO '{dst.as_posix()}' (FORMAT PARQUET, COMPRESSION ZSTD)"
        )
        rows = con.execute(f"SELECT COUNT(*) FROM '{dst.as_posix()}'").fetchone()[0]
        print(f"{table:<15} {rows:>12,} rows -> {dst.name}")


if __name__ == "__main__":
    main()
