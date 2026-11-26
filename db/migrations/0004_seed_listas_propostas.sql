-- 0004 listas controladas PROPOSTAS (AV-25) — definidas por delegação da responsável em 26/11/2026.
-- Revisar no workshop de validação (TAP Fase 3) com Segurança/Privacidade. Parametrizáveis via config_lista.
INSERT INTO config_lista(lista,codigo,rotulo,ordem) VALUES
 ('criticidade','CRITICA','Crítica',1),
 ('criticidade','ALTA','Alta',2),
 ('criticidade','MEDIA','Média',3),
 ('criticidade','BAIXA','Baixa',4),

 ('frequencia','TEMPO_REAL','Tempo real',1),
 ('frequencia','DIARIA','Diária',2),
 ('frequencia','SEMANAL','Semanal',3),
 ('frequencia','QUINZENAL','Quinzenal',4),
 ('frequencia','MENSAL','Mensal',5),
 ('frequencia','TRIMESTRAL','Trimestral',6),
 ('frequencia','SEMESTRAL','Semestral',7),
 ('frequencia','ANUAL','Anual',8),
 ('frequencia','SOB_DEMANDA','Sob demanda',9),

 -- LGPD (Lei 13.709/2018, art. 5º, I a III)
 ('lgpd','NAO_PESSOAL','Não contém dado pessoal',1),
 ('lgpd','PESSOAL','Dado pessoal',2),
 ('lgpd','PESSOAL_SENSIVEL','Dado pessoal sensível',3),
 ('lgpd','ANONIMIZADO','Dado anonimizado',4),

 ('confidencialidade','PUBLICA','Pública',1),
 ('confidencialidade','INTERNA','Interna',2),
 ('confidencialidade','CONFIDENCIAL','Confidencial',3),
 ('confidencialidade','RESTRITA','Restrita',4),

 ('qualidade','ALTA','Alta',1),
 ('qualidade','MEDIA','Média',2),
 ('qualidade','BAIXA','Baixa',3),
 ('qualidade','NAO_AVALIADA','Não avaliada',4),

 ('confiabilidade','ALTA','Alta',1),
 ('confiabilidade','MEDIA','Média',2),
 ('confiabilidade','BAIXA','Baixa',3),
 ('confiabilidade','NAO_AVALIADA','Não avaliada',4),

 ('tipo_consumo','DECISAO_EXECUTIVA','Decisão executiva (Diretoria/Conselho)',1),
 ('tipo_consumo','GERENCIAL','Acompanhamento gerencial',2),
 ('tipo_consumo','OPERACIONAL','Operacional',3),
 ('tipo_consumo','LEGAL_REGULATORIO','Legal / regulatório',4),

 ('tipo_relatorio','DASHBOARD','Dashboard',1),
 ('tipo_relatorio','RELATORIO_GERENCIAL','Relatório gerencial',2),
 ('tipo_relatorio','OUTRO','Outro',3),

 ('ciclo_vida','PLANEJADO','Planejado',1),
 ('ciclo_vida','EM_USO','Em uso',2),
 ('ciclo_vida','EM_DESCONTINUACAO','Em descontinuação',3),
 ('ciclo_vida','DESCONTINUADO','Descontinuado',4);
