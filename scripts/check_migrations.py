"""Valida que todas as migrations aplicam em SQLite (motor do D1)."""
import sqlite3, glob, sys
c = sqlite3.connect(':memory:')
for f in sorted(glob.glob('db/migrations/*.sql')):
    c.executescript(open(f).read()); print('ok', f)
tabelas = c.execute("select count(*) from sqlite_master where type='table'").fetchone()[0]
print('tabelas:', tabelas)
sys.exit(0 if tabelas > 30 else 1)
