-- 0003 listas controladas — SOMENTE valores presentes na documentação (BRD/TAP).
-- Criticidade, frequência, LGPD, confidencialidade, qualidade e tipo de consumo: A VALIDAR (AV-25).
INSERT INTO config_lista(lista,codigo,rotulo,ordem) VALUES
 ('categoria_sistema','ERP','ERP',1),
 ('categoria_sistema','ALFRESCO','ALFRESCO',2),
 ('categoria_sistema','HCM','HCM',3),
 ('freq_recertificacao','TRIMESTRAL','Trimestral',1),
 ('freq_recertificacao','SEMESTRAL','Semestral',2),
 ('freq_recertificacao','ANUAL','Anual',3),
 ('categoria_oportunidade','GOVERNANCA','Governança de Dados',1),
 ('categoria_oportunidade','QUALIDADE','Qualidade de Dados',2),
 ('categoria_oportunidade','ANALYTICS','Analytics',3),
 ('categoria_oportunidade','AUTOMACAO','Automação',4),
 ('categoria_oportunidade','INTEGRACAO','Integração',5),
 ('categoria_oportunidade','SISTEMATIZACAO','Sistematização',6),
 ('categoria_oportunidade','PROCESSO','Processo',7),
 ('categoria_oportunidade','IA','Inteligência Artificial',8);
INSERT INTO config_parametro(chave,valor) VALUES
 ('produto_nome','J. Mendes DataMap'),
 ('alertas_dias','30,15,5'),
 ('exigir_lgpd_na_submissao','1');
