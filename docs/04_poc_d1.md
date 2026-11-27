# POC de desempenho do modelo (D1) — v0.1

Issue #9 (POC D1) — **resultado parcial**. Script: `poc/poc_d1.py` (dados 100% sintéticos, sem dados reais).

## Volume informado (MVP – dados do RH, 27/11/2026)
39 indicadores · 200 dados · 11 sistemas · 32 planilhas · 25 dashboards.
Estimados por mim (**A Validar**): processos 20, integrações 15, pessoas 30, áreas 6 (por fator).

## Método
SQLite 3.53 em memória (mesmo motor do D1) com as migrations 0001–0004. Fator 1 = volume do RH; fator 10 = projeção multi-onda (≈1.500 arestas e ≈15.000 arestas). Mediana de 30 execuções (10 na prof. 3).

## Resultados (mediana, ms)

| Consulta | Fator 1 | Fator 10 | Meta (BRD) |
|---|---|---|---|
| Grafo, profundidade 1 a partir do indicador | 1,3 | 15,8 | ≤ 3.000 |
| Grafo, profundidade 2 | 1,4 | 15,7 | ≤ 3.000 |
| Grafo, profundidade 3 (569 nós no fator 10) | 1,6 | 16,3 | ≤ 3.000 |
| Busca FTS (sem acento, limite 50) | 0,03 | 0,03 | ≤ 2.000 |
| Dashboard resumo | 0,07 | 0,83 | ≤ 3.000 |
| Itens vencidos | 0,02 | 0,13 | ≤ 3.000 |

## Conclusões
1. **O modelo atende com folga** ao volume do RH e à projeção de 10× (CTE recursiva, FTS5 e views).
2. O custo do grafo é **praticamente fixo** (≈ varredura das arestas da view), não depende da profundidade. Cresce linearmente com o número de arestas; em ~15 mil ainda é ≈16 ms. Se passar de ~100 mil arestas, trocar por consultas por nó (índices já existem nas tabelas de vínculo).
3. Nós **Área/Pessoa** ficaram fora da travessia, como definido; sem isso o grafo se espalha.
4. Decisão provisória: **manter D1** (ADR 003).

## O que esta POC NÃO prova (pendente para fechar a Issue #9)
- **Latência real do D1** (rede Worker↔D1, cold start, limites de consultas por invocação e do plano contratado): exige executar em conta Cloudflare.
- Concorrência de escrita e importação Excel em lote.
- Tamanho real do banco no plano (volume é pequeno; confirmar limites do plano contratado).

**Próximo passo:** repetir `poc_d1.py` adaptado ao D1 real (Wrangler `d1 execute --remote`) assim que houver conta/projeto Cloudflare e acesso de rede para instalar o Wrangler.
