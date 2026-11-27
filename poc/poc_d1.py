"""POC de desempenho do modelo (SQLite = motor do D1). Dados 100% sintéticos.
Uso: python3 -I poc/poc_d1.py [fator]   (fator 1 = volume do RH; 10 = projeção multi-onda)"""
import sqlite3, glob, random, time, sys, uuid, statistics
F = int(sys.argv[1]) if len(sys.argv) > 1 else 1
random.seed(7)
c = sqlite3.connect(':memory:'); c.execute("PRAGMA foreign_keys=ON")
for f in sorted(glob.glob('db/migrations/*.sql')): c.executescript(open(f).read())
u = lambda: str(uuid.uuid4())
N = dict(area=6*F, pessoa=30*F, ind=39*F, dado=200*F, sis=11*F, plan=32*F, rel=25*F, proc=20*F, integ=15*F)
ids = {k: [u() for _ in range(v)] for k, v in N.items()}
ex = c.executemany
ex("insert into area(id,nome) values(?,?)", [(i, f"Área {n}") for n, i in enumerate(ids['area'])])
ex("insert into pessoa(id,nome,area_id) values(?,?,?)", [(i, f"Pessoa {n}", random.choice(ids['area'])) for n, i in enumerate(ids['pessoa'])])
ex("insert into sistema(id,nome,area_id) values(?,?,?)", [(i, f"Sistema {n}", random.choice(ids['area'])) for n, i in enumerate(ids['sis'])])
ex("insert into processo(id,nome,area_id) values(?,?,?)", [(i, f"Processo {n}", random.choice(ids['area'])) for n, i in enumerate(ids['proc'])])
ex("insert into relatorio(id,nome,area_id,sistema_id) values(?,?,?,?)", [(i, f"Dashboard {n}", random.choice(ids['area']), random.choice(ids['sis'])) for n, i in enumerate(ids['rel'])])
ex("insert into planilha(id,nome,area_id) values(?,?,?)", [(i, f"Planilha {n}", random.choice(ids['area'])) for n, i in enumerate(ids['plan'])])
ex("insert into indicador(id,nome,area_id) values(?,?,?)", [(i, f"Indicador {n}", ids['area'][n % len(ids['area'])]) for n, i in enumerate(ids['ind'])])
ex("insert into dado(id,nome,descricao,area_id,processo_id) values(?,?,?,?,?)", [(i, f"Dado {n} data desligamento", "descrição do dado", random.choice(ids['area']), random.choice(ids['proc'])) for n, i in enumerate(ids['dado'])])
ex("insert into integracao(id,nome,sistema_origem_id,sistema_destino_id) values(?,?,?,?)", [(i, f"Integração {n}", random.choice(ids['sis']), random.choice(ids['sis'])) for n, i in enumerate(ids['integ'])])
def pairs(a, b, k): return list({(random.choice(ids[a]), random.choice(ids[b])) for _ in range(k)})
ex("insert into indicador_dado values(?,?)", pairs('ind', 'dado', 39*F*6))
ex("insert into indicador_consumidor(indicador_id,area_id) values(?,?)", pairs('ind', 'area', 39*F*2))
ex("insert into indicador_relatorio values(?,?)", pairs('ind', 'rel', 39*F))
ex("insert into indicador_planilha values(?,?)", pairs('ind', 'plan', 39*F//2))
ex("insert into dado_sistema values(?,?,'ORIGEM',1)", pairs('dado', 'sis', 200*F))
ex("insert into dado_planilha values(?,?)", pairs('dado', 'plan', 100*F))
ex("insert into dado_integracao values(?,?)", pairs('dado', 'integ', 60*F))
ex("insert into relatorio_dado values(?,?)", pairs('rel', 'dado', 25*F*6))
ex("insert into ativo_responsavel values('DADO',?,?,'DONO')", [(d, random.choice(ids['pessoa'])) for d in ids['dado']])
c.execute("insert into busca_fts(tipo,id,nome,descricao) select 'DADO',id,nome,descricao from dado")
c.commit()
def t(sql, args=(), n=30):
    xs = []
    for _ in range(n):
        s = time.perf_counter(); r = c.execute(sql, args).fetchall(); xs.append((time.perf_counter()-s)*1000)
    return statistics.median(xs), max(xs), len(r)
GRAPH = """WITH RECURSIVE e AS (SELECT origem_tipo a,origem_id ai,destino_tipo b,destino_id bi FROM vw_grafo_arestas WHERE destino_tipo NOT IN ('AREA','PESSOA')
 UNION ALL SELECT destino_tipo,destino_id,origem_tipo,origem_id FROM vw_grafo_arestas WHERE destino_tipo NOT IN ('AREA','PESSOA')),
v(tipo,id,d) AS (SELECT ?,?,0 UNION SELECT e.b,e.bi,v.d+1 FROM v JOIN e ON e.a=v.tipo AND e.ai=v.id WHERE v.d<?)
SELECT tipo,id,min(d) FROM v GROUP BY tipo,id"""
print(f"fator={F}: " + ", ".join(f"{k}={v}" for k, v in N.items()))
print("arestas:", c.execute("select count(*) from vw_grafo_arestas").fetchone()[0])
for nome, sql, a in [
  ("grafo prof.1 (indicador)", GRAPH, ('INDICADOR', ids['ind'][0], 1)),
  ("grafo prof.2 (indicador)", GRAPH, ('INDICADOR', ids['ind'][0], 2)),
  ("grafo prof.3 (indicador)", GRAPH, ('INDICADOR', ids['ind'][0], 3)),
  ("grafo prof.2 (sistema)", GRAPH, ('SISTEMA', ids['sis'][0], 2)),
  ("busca FTS 'desligamento'", "select id from busca_fts where busca_fts match 'desligamento' limit 50", ()),
  ("dashboard resumo", "select * from vw_dashboard_resumo", ()),
  ("vencidos", "select * from vw_vencidos", ()),
  ("lista indicadores+dados (join)", "select i.nome,count(*) from indicador i join indicador_dado x on x.indicador_id=i.id group by i.id", ()),
]:
    m, mx, n = t(sql, a, 10 if 'prof.3' in nome else 30)
    print(f"{nome:34s} mediana={m:8.2f} ms  máx={mx:8.2f} ms  linhas={n}")
