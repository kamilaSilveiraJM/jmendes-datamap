# Backlog do Produto — J. Mendes DataMap (v0.1)

Gerado a partir de BRD, TAP e Roteiro. Cada item é uma Issue (milestones **MVP**, **V1**, **V2**). Itens com **A Validar** dependem de decisão; fórmula de prioridade (AV-10) **não será implementada** antes de definida.

> Versões seguem o TAP 6.3 (MVP testável na semana 8; V1 até o mês 5; V2 até o mês 7). A distribuição do Mapa no MVP (AV-19) e do Dashboard (V1) aguarda confirmação.

## MVP

| Issue | Épico | Item | Origem | A Validar |
|---|---|---|---|---|
| #7 | Fundação | Scaffold Cloudflare (Pages + Worker Hono + Drizzle + Wrangler) | TAP 6.3; ADR 001-004 | — |
| #8 | Fundação | CI GitHub Actions: lint, testes, validação de migrations, deploy de preview | CONTRIBUTING | — |
| #9 | Fundação | POC D1: carga realista, CTE do grafo e busca FTS | AV-24 | AV-24 |
| #10 | Fundação | Autenticação Entra ID e RBAC por perfis | BRD 7; TAP 6.3 | AV-11 |
| #11 | Fundação | UI base: tema corporativo (Azul Turquesa #006579 e Preto), layout e menu | BRD 7 (Modelo de Navegação); instruções corporativas | — |
| #12 | Administração | Administração de áreas/gerências, pessoas e perfis | TAP 6.3 Administração | AV-13 |
| #13 | Administração | Administração de listas controladas e parâmetros | TAP 6.3; ADR 014 | — |
| #14 | Indicadores | RF-IND-001 Manter indicadores | BRD RF-IND-001 | — |
| #15 | Indicadores | RF-IND-002 Relacionar indicador aos dados | BRD RF-IND-002 | — |
| #16 | Indicadores | RF-IND-003 Consumidores do indicador | BRD RF-IND-003 | — |
| #17 | Dados | RF-DAD-001 Manter dados | BRD RF-DAD-001 | — |
| #18 | Dados | RF-DAD-002 Navegação bidirecional dado ↔ indicador | BRD RF-DAD-002 | — |
| #19 | Sistemas | RF-SIS-001 Manter sistemas | BRD RF-SIS-001 | AV-03 |
| #20 | Sistemas | RF-SIS-002 Relacionar dados e sistemas (origem/destino/consumo, fonte oficial) | BRD RF-SIS-002; TAP 4.3 | AV-06 |
| #21 | Catálogo | Manter processos | BRD 2.1; TAP 4.3 | AV-27 |
| #22 | Catálogo | Manter relatórios e dashboards | BRD 2.1; TAP 4.3 | AV-04 |
| #23 | Catálogo | Manter planilhas críticas (somente referência de localização) | TAP 4.3 | AV-03 |
| #24 | Catálogo | Pesquisa global, filtros, ficha do ativo e exportação Excel | TAP 6.3 Catálogo e pesquisa; BRD 7 | — |
| #25 | Governança | Responsáveis por ativo (Dono, Curador, Técnico) | BRD 2.1; TAP 6.3 | — |
| #26 | Governança | RF-WKF-001 Workflow: submissão, devolução, aprovação, publicação | BRD RF-WKF-001; TAP 6.3 | AV-07 |
| #27 | Governança | Revisões, histórico e auditoria de alterações | BRD RN-WKF-003; RNF Auditoria | — |
| #28 | Importação | Template Excel de coleta e importação com pré-validação | TAP 6.3 Coleta e ingestão; Roteiro (Anexo) | AV-20 |
| #29 | Mapa | API de vizinhança do grafo (profundidade, filtros, sem atravessar Área/Pessoa) | BRD RF-MAP-001; ADR 005/006 | — |
| #30 | Mapa | UI do Mapa Corporativo de Informações (iniciar por qualquer elemento) | Prompt do produto; BRD RN-MAP-001/002 | AV-19 |
| #43 | Transversal | Revisão de segurança e privacidade pré-produção | TAP 6.1 Fase 3; riscos | AV-21; AV-23 |
| #44 | Transversal | Testes de desempenho e disponibilidade (consulta 3 s, pesquisa 2 s, 99,5%) | BRD 7 | — |
| #45 | Transversal | Manual do usuário e orientação aos usuários do RH | TAP 6.1 Fase 4 | — |

## V1

| Issue | Épico | Item | Origem | A Validar |
|---|---|---|---|---|
| #31 | Mapa | Mapa: filtros, caminho, linhagem e análise de impacto | Prompt do produto; TAP 6.3 | — |
| #32 | Classificação | Classificação e riscos: criticidade, confidencialidade, LGPD, qualidade | TAP 6.3 Classificação e riscos | AV-05 |
| #33 | Integrações | Manter integrações/fluxos e linhagem | TAP 4.3 e 6.3 | AV-02 |
| #34 | Integrações | Regras relevantes (premissas/exceções) | TAP 4.3 | AV-28 |
| #35 | Sustentação | Recertificação e alertas 30/15/5 dias | BRD RF-REC-001 | AV-14 |
| #36 | Sustentação | Dashboard executivo com exportação Excel/PDF | BRD RF-DASH-001 | AV-13 |
| #37 | Sustentação | Consulta de trilha de auditoria | BRD 7 Auditoria; TAP 6.3 | — |
| #38 | Sustentação | Exportação completa e plano de backup | TAP 10 (dependência tecnológica) | AV-23 |

## V2

| Issue | Épico | Item | Origem | A Validar |
|---|---|---|---|---|
| #39 | Backlog IA | RF-BKO-001/002/003 Oportunidades: cadastro, vínculos e classificação | BRD RF-BKO-001..003 | — |
| #40 | Backlog IA | RF-BKO-004 Avaliação inicial e prioridade | BRD RF-BKO-004 | AV-10 |
| #41 | Backlog IA | RF-BKO-005/006 Status e integração com Portfólio de Inovação | BRD RF-BKO-005/006 | AV-16 |
| #42 | Backlog IA | RF-BKO-007 Dashboard do backlog e heatmaps de cobertura | BRD RF-BKO-007; TAP 6.3 V2 | — |

## Ordem sugerida de construção (MVP)

1. Fundação (scaffold, CI, POC D1, autenticação, UI base)
2. Administração e listas
3. Catálogo: indicadores → dados → sistemas → demais ativos
4. Responsáveis, workflow, revisões e auditoria
5. Pesquisa, exportação e importação Excel
6. Mapa Corporativo (API → UI)
7. Segurança/privacidade, desempenho e manual

Dependências críticas: POC D1 (decide a persistência), Entra ID (perfis), AV-23 (aprovação Cloudflare).
