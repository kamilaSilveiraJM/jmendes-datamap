-- 0002 views: nós/arestas do Mapa Corporativo e dashboard
CREATE VIEW vw_grafo_nos AS
SELECT 'INDICADOR' AS tipo, id, nome, area_id AS area_id, criticidade AS criticidade, status FROM indicador WHERE ativo=1 UNION ALL
SELECT 'DADO' AS tipo, id, nome, area_id AS area_id, criticidade AS criticidade, status FROM dado WHERE ativo=1 UNION ALL
SELECT 'SISTEMA' AS tipo, id, nome, area_id AS area_id, criticidade AS criticidade, status FROM sistema WHERE ativo=1 UNION ALL
SELECT 'PROCESSO' AS tipo, id, nome, area_id AS area_id, NULL AS criticidade, status FROM processo WHERE ativo=1 UNION ALL
SELECT 'RELATORIO' AS tipo, id, nome, area_id AS area_id, criticidade AS criticidade, status FROM relatorio WHERE ativo=1 UNION ALL
SELECT 'PLANILHA' AS tipo, id, nome, area_id AS area_id, criticidade AS criticidade, status FROM planilha WHERE ativo=1 UNION ALL
SELECT 'INTEGRACAO' AS tipo, id, nome, NULL AS area_id, criticidade AS criticidade, status FROM integracao WHERE ativo=1 UNION ALL
SELECT 'AREA', id, nome, parent_id, NULL, NULL FROM area WHERE ativo=1 UNION ALL
SELECT 'PESSOA', id, nome, area_id, NULL, NULL FROM pessoa WHERE ativo=1;

-- Arestas dirigidas; a API trata como não-direcionadas ao navegar.
CREATE VIEW vw_grafo_arestas AS
SELECT 'INDICADOR' AS origem_tipo, indicador_id AS origem_id, 'DADO' AS destino_tipo, dado_id AS destino_id, 'COMPOSTO_POR' AS relacao FROM indicador_dado
UNION ALL SELECT 'INDICADOR', indicador_id, 'AREA', area_id, 'CONSUMIDO_POR' FROM indicador_consumidor
UNION ALL SELECT 'INDICADOR', indicador_id, 'RELATORIO', relatorio_id, 'EXIBIDO_EM' FROM indicador_relatorio
UNION ALL SELECT 'INDICADOR', indicador_id, 'PROCESSO', processo_id, 'APOIA' FROM indicador_processo
UNION ALL SELECT 'INDICADOR', indicador_id, 'PLANILHA', planilha_id, 'USA_PLANILHA' FROM indicador_planilha
UNION ALL SELECT 'DADO', dado_id, 'SISTEMA', sistema_id, papel FROM dado_sistema
UNION ALL SELECT 'DADO', dado_id, 'PLANILHA', planilha_id, 'ARMAZENADO_EM' FROM dado_planilha
UNION ALL SELECT 'DADO', dado_id, 'INTEGRACAO', integracao_id, 'TRAFEGA_EM' FROM dado_integracao
UNION ALL SELECT 'RELATORIO', relatorio_id, 'DADO', dado_id, 'CONSOME' FROM relatorio_dado
UNION ALL SELECT 'PLANILHA', planilha_id, 'SISTEMA', sistema_id, 'LIGADA_A' FROM planilha_sistema
UNION ALL SELECT 'SISTEMA', sistema_id, 'PROCESSO', processo_id, 'SUPORTA' FROM sistema_processo
UNION ALL SELECT 'INTEGRACAO', id, 'SISTEMA', sistema_origem_id, 'ORIGEM' FROM integracao WHERE sistema_origem_id IS NOT NULL
UNION ALL SELECT 'INTEGRACAO', id, 'SISTEMA', sistema_destino_id, 'DESTINO' FROM integracao WHERE sistema_destino_id IS NOT NULL
UNION ALL SELECT 'RELATORIO', id, 'SISTEMA', sistema_id, 'EXECUTA_EM' FROM relatorio WHERE sistema_id IS NOT NULL
UNION ALL SELECT 'INDICADOR', id, 'AREA', area_id, 'PERTENCE_A' FROM indicador WHERE area_id IS NOT NULL
UNION ALL SELECT 'DADO', id, 'AREA', area_id, 'PERTENCE_A' FROM dado WHERE area_id IS NOT NULL
UNION ALL SELECT 'SISTEMA', id, 'AREA', area_id, 'PERTENCE_A' FROM sistema WHERE area_id IS NOT NULL
UNION ALL SELECT 'PROCESSO', id, 'AREA', area_id, 'PERTENCE_A' FROM processo WHERE area_id IS NOT NULL
UNION ALL SELECT 'RELATORIO', id, 'AREA', area_id, 'PERTENCE_A' FROM relatorio WHERE area_id IS NOT NULL
UNION ALL SELECT 'PLANILHA', id, 'AREA', area_id, 'PERTENCE_A' FROM planilha WHERE area_id IS NOT NULL
UNION ALL SELECT tipo_ativo, ativo_id, 'PESSOA', pessoa_id, papel FROM ativo_responsavel
UNION ALL SELECT 'PESSOA', id, 'AREA', area_id, 'LOTADO_EM' FROM pessoa WHERE area_id IS NOT NULL;

-- Dashboard executivo (RF-DASH-001). Filtros por área aplicados na API.
CREATE VIEW vw_dashboard_resumo AS
SELECT
  (SELECT COUNT(*) FROM indicador WHERE ativo=1) AS total_indicadores,
  (SELECT COUNT(*) FROM dado      WHERE ativo=1) AS total_dados,
  (SELECT COUNT(*) FROM sistema   WHERE ativo=1) AS total_sistemas,
  (SELECT COUNT(*) FROM processo  WHERE ativo=1) AS total_processos,
  (SELECT COUNT(*) FROM dado d WHERE d.ativo=1 AND NOT EXISTS (SELECT 1 FROM ativo_responsavel r WHERE r.tipo_ativo='DADO' AND r.ativo_id=d.id AND r.papel='DONO')) AS dados_sem_dono,
  (SELECT COUNT(*) FROM dado WHERE ativo=1 AND lgpd IS NULL) AS dados_sem_lgpd,
  (SELECT COUNT(*) FROM planilha  WHERE ativo=1) AS total_planilhas;

CREATE VIEW vw_vencidos AS
SELECT 'INDICADOR' AS tipo_ativo, id, nome, area_id, proxima_revisao FROM indicador WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'DADO', id, nome, area_id, proxima_revisao FROM dado WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'SISTEMA', id, nome, area_id, proxima_revisao FROM sistema WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'PROCESSO', id, nome, area_id, proxima_revisao FROM processo WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'RELATORIO', id, nome, area_id, proxima_revisao FROM relatorio WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'PLANILHA', id, nome, area_id, proxima_revisao FROM planilha WHERE ativo=1 AND proxima_revisao < date('now')
UNION ALL SELECT 'INTEGRACAO', id, nome, NULL, proxima_revisao FROM integracao WHERE ativo=1 AND proxima_revisao < date('now');
