-- J. Mendes DataMap — 0001 modelo inicial (Cloudflare D1 / SQLite)
-- Convenções: id = UUID gerado pela aplicação; datas = ISO 8601 UTC (TEXT);
-- campos "obrigatórios no BRD" são NULLáveis aqui e validados na SUBMISSÃO (AV-08);
-- valores de listas controladas ficam em config_lista (AV-25).
PRAGMA foreign_keys = ON;

CREATE TABLE config_lista (
  lista  TEXT NOT NULL,
  codigo TEXT NOT NULL,
  rotulo TEXT NOT NULL,
  ordem  INTEGER NOT NULL DEFAULT 0,
  ativo  INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  PRIMARY KEY (lista, codigo)
);

CREATE TABLE config_parametro (
  chave TEXT PRIMARY KEY,
  valor TEXT NOT NULL
);

CREATE TABLE area (
  id        TEXT PRIMARY KEY,
  nome      TEXT NOT NULL,
  sigla     TEXT,
  tipo      TEXT NOT NULL DEFAULT 'AREA' CHECK (tipo IN ('GERENCIA','AREA')),  -- AV-13
  parent_id TEXT REFERENCES area(id),
  ativo     INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1))
);
CREATE UNIQUE INDEX ux_area_nome ON area(nome COLLATE NOCASE);

CREATE TABLE pessoa (
  id       TEXT PRIMARY KEY,
  entra_oid TEXT UNIQUE,            -- objectId no Microsoft Entra ID
  nome     TEXT NOT NULL,
  email    TEXT UNIQUE,
  cargo    TEXT,
  area_id  TEXT REFERENCES area(id),
  ativo    INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1))
);

CREATE TABLE pessoa_perfil (          -- AV-11 (perfis propostos)
  pessoa_id TEXT NOT NULL REFERENCES pessoa(id),
  perfil    TEXT NOT NULL CHECK (perfil IN ('ADMIN','DONO','CURADOR','ENTREVISTADOR','CONSULTA','SEGURANCA_PRIVACIDADE')),
  area_id   TEXT REFERENCES area(id),  -- escopo opcional por área/onda
  PRIMARY KEY (pessoa_id, perfil, area_id)
);

-- ===== ATIVOS =====
CREATE TABLE processo (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  finalidade TEXT,
  area_id TEXT REFERENCES area(id),
  entradas_saidas TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE sistema (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  fabricante TEXT,
  categoria TEXT,          -- config_lista 'categoria_sistema'
  finalidade TEXT,
  area_id TEXT REFERENCES area(id),   -- área proprietária (RN-SIS-002)
  criticidade TEXT,
  ciclo_vida TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE relatorio (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  tipo TEXT,               -- AV-04: DASHBOARD, RELATORIO... (config_lista 'tipo_relatorio')
  finalidade TEXT,
  audiencia TEXT,
  area_id TEXT REFERENCES area(id),
  frequencia TEXT,
  sistema_id TEXT REFERENCES sistema(id),   -- plataforma onde roda (ex.: Power BI)
  criticidade TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE indicador (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  objetivo TEXT,
  formula TEXT,
  area_id TEXT REFERENCES area(id),
  criticidade TEXT,
  frequencia TEXT,
  relatorio_origem_id TEXT REFERENCES relatorio(id),
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE UNIQUE INDEX ux_indicador_area_nome ON indicador(area_id, nome COLLATE NOCASE);  -- RN-IND-001/002

CREATE TABLE dado (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  area_id TEXT REFERENCES area(id),
  processo_id TEXT REFERENCES processo(id),
  frequencia_atualizacao TEXT,
  criticidade TEXT,
  lgpd TEXT,
  confidencialidade TEXT,
  qualidade_percebida TEXT,
  confiabilidade TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE planilha (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  finalidade TEXT,
  area_id TEXT REFERENCES area(id),
  localizacao TEXT,        -- referência controlada (link/caminho); NUNCA o conteúdo
  frequencia TEXT,
  criticidade TEXT,
  risco TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE integracao (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  sistema_origem_id TEXT REFERENCES sistema(id),
  sistema_destino_id TEXT REFERENCES sistema(id),
  frequencia TEXT,
  transformacao TEXT,
  criticidade TEXT,
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);
CREATE TABLE regra (
  id TEXT PRIMARY KEY,
  titulo TEXT NOT NULL,
  descricao TEXT NOT NULL,
  tipo TEXT CHECK (tipo IN ('PREMISSA','REGRA','EXCECAO')),
  status              TEXT NOT NULL DEFAULT 'RASCUNHO' CHECK (status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  revisao             INTEGER NOT NULL DEFAULT 1,
  ativo               INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1)),
  freq_recertificacao TEXT CHECK (freq_recertificacao IN ('TRIMESTRAL','SEMESTRAL','ANUAL')),
  ultima_revisao      TEXT,
  proxima_revisao     TEXT,
  criado_em           TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por          TEXT REFERENCES pessoa(id),
  atualizado_em       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  atualizado_por      TEXT REFERENCES pessoa(id)
);

-- ===== RELACIONAMENTOS =====
CREATE TABLE indicador_dado (            -- RF-IND-002 / RF-DAD-002 (bidirecional)
  indicador_id TEXT NOT NULL REFERENCES indicador(id),
  dado_id      TEXT NOT NULL REFERENCES dado(id),
  PRIMARY KEY (indicador_id, dado_id)
);
CREATE INDEX ix_indicador_dado_dado ON indicador_dado(dado_id);

CREATE TABLE indicador_consumidor (      -- RF-IND-003; RN-IND-007 via PK
  indicador_id TEXT NOT NULL REFERENCES indicador(id),
  area_id      TEXT NOT NULL REFERENCES area(id),
  tipo_consumo TEXT,
  frequencia   TEXT,
  PRIMARY KEY (indicador_id, area_id)
);
CREATE INDEX ix_indicador_consumidor_area ON indicador_consumidor(area_id);

CREATE TABLE indicador_relatorio (
  indicador_id TEXT NOT NULL REFERENCES indicador(id),
  relatorio_id TEXT NOT NULL REFERENCES relatorio(id),
  PRIMARY KEY (indicador_id, relatorio_id)
);
CREATE TABLE indicador_processo (
  indicador_id TEXT NOT NULL REFERENCES indicador(id),
  processo_id  TEXT NOT NULL REFERENCES processo(id),
  PRIMARY KEY (indicador_id, processo_id)
);
CREATE TABLE indicador_planilha (
  indicador_id TEXT NOT NULL REFERENCES indicador(id),
  planilha_id  TEXT NOT NULL REFERENCES planilha(id),
  PRIMARY KEY (indicador_id, planilha_id)
);

CREATE TABLE dado_sistema (              -- RF-SIS-002; AV-06
  dado_id    TEXT NOT NULL REFERENCES dado(id),
  sistema_id TEXT NOT NULL REFERENCES sistema(id),
  papel      TEXT NOT NULL CHECK (papel IN ('ORIGEM','DESTINO','CONSUMO')),
  fonte_oficial INTEGER NOT NULL DEFAULT 0 CHECK (fonte_oficial IN (0,1)),
  PRIMARY KEY (dado_id, sistema_id, papel)
);
CREATE INDEX ix_dado_sistema_sistema ON dado_sistema(sistema_id);

CREATE TABLE dado_planilha (
  dado_id     TEXT NOT NULL REFERENCES dado(id),
  planilha_id TEXT NOT NULL REFERENCES planilha(id),
  PRIMARY KEY (dado_id, planilha_id)
);
CREATE TABLE dado_integracao (           -- linhagem: quais dados trafegam
  dado_id       TEXT NOT NULL REFERENCES dado(id),
  integracao_id TEXT NOT NULL REFERENCES integracao(id),
  PRIMARY KEY (dado_id, integracao_id)
);
CREATE TABLE relatorio_dado (
  relatorio_id TEXT NOT NULL REFERENCES relatorio(id),
  dado_id      TEXT NOT NULL REFERENCES dado(id),
  PRIMARY KEY (relatorio_id, dado_id)
);
CREATE TABLE planilha_sistema (          -- planilha alimentada por / alimenta sistema
  planilha_id TEXT NOT NULL REFERENCES planilha(id),
  sistema_id  TEXT NOT NULL REFERENCES sistema(id),
  PRIMARY KEY (planilha_id, sistema_id)
);
CREATE TABLE sistema_processo (
  sistema_id  TEXT NOT NULL REFERENCES sistema(id),
  processo_id TEXT NOT NULL REFERENCES processo(id),
  PRIMARY KEY (sistema_id, processo_id)
);

-- Polimórficos (sem FK para o alvo — integridade validada na API; ver ADR-015)
CREATE TABLE ativo_responsavel (
  tipo_ativo TEXT NOT NULL CHECK (tipo_ativo IN ('INDICADOR','DADO','SISTEMA','PROCESSO','RELATORIO','PLANILHA','INTEGRACAO')),
  ativo_id   TEXT NOT NULL,
  pessoa_id  TEXT NOT NULL REFERENCES pessoa(id),
  papel      TEXT NOT NULL CHECK (papel IN ('DONO','CURADOR','TECNICO','RESPONSAVEL')),
  PRIMARY KEY (tipo_ativo, ativo_id, pessoa_id, papel)
);
CREATE INDEX ix_ativo_responsavel_pessoa ON ativo_responsavel(pessoa_id);

CREATE TABLE regra_vinculo (
  regra_id   TEXT NOT NULL REFERENCES regra(id),
  tipo_ativo TEXT NOT NULL CHECK (tipo_ativo IN ('INDICADOR','DADO','SISTEMA','PROCESSO','RELATORIO','PLANILHA','INTEGRACAO')),
  ativo_id   TEXT NOT NULL,
  PRIMARY KEY (regra_id, tipo_ativo, ativo_id)
);

-- ===== WORKFLOW, REVISÃO, RECERTIFICAÇÃO, AUDITORIA =====
CREATE TABLE revisao (                   -- snapshot imutável (RN-WKF-003)
  id TEXT PRIMARY KEY,
  tipo_ativo TEXT NOT NULL,
  ativo_id   TEXT NOT NULL,
  numero     INTEGER NOT NULL,
  snapshot   TEXT NOT NULL,             -- JSON do ativo + relacionamentos
  criado_em  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  criado_por TEXT REFERENCES pessoa(id),
  UNIQUE (tipo_ativo, ativo_id, numero)
);

CREATE TABLE workflow_evento (           -- RN-WKF-001/002; histórico preservado
  id TEXT PRIMARY KEY,
  tipo_ativo TEXT NOT NULL,
  ativo_id   TEXT NOT NULL,
  revisao    INTEGER NOT NULL,
  de_status  TEXT,
  para_status TEXT NOT NULL CHECK (para_status IN ('RASCUNHO','SUBMETIDO','EM_REVISAO','DEVOLVIDO','APROVADO','PUBLICADO')),
  pessoa_id  TEXT NOT NULL REFERENCES pessoa(id),
  comentario TEXT,
  em         TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX ix_wf_ativo ON workflow_evento(tipo_ativo, ativo_id);

CREATE TABLE recertificacao (            -- RF-REC-001 (histórico de recertificações)
  id TEXT PRIMARY KEY,
  tipo_ativo TEXT NOT NULL,
  ativo_id   TEXT NOT NULL,
  realizada_em TEXT NOT NULL,
  proxima_em   TEXT NOT NULL,
  responsavel_id TEXT REFERENCES pessoa(id),
  resultado  TEXT CHECK (resultado IN ('CONFIRMADO','ALTERADO'))
);

CREATE TABLE alerta (                    -- RN-REC-001..003
  id TEXT PRIMARY KEY,
  tipo_ativo TEXT NOT NULL,
  ativo_id   TEXT NOT NULL,
  proxima_revisao TEXT NOT NULL,
  dias_antes INTEGER NOT NULL CHECK (dias_antes IN (30,15,5)),
  destinatario_id TEXT NOT NULL REFERENCES pessoa(id),
  gerado_em  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  enviado_em TEXT,
  UNIQUE (tipo_ativo, ativo_id, proxima_revisao, dias_antes, destinatario_id)
);

CREATE TABLE auditoria (                 -- append-only
  id TEXT PRIMARY KEY,
  em TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  pessoa_id TEXT REFERENCES pessoa(id),
  acao TEXT NOT NULL CHECK (acao IN ('INCLUSAO','ALTERACAO','EXCLUSAO','APROVACAO','SUBMISSAO','DEVOLUCAO','PUBLICACAO','IMPORTACAO')),
  tipo_ativo TEXT,
  ativo_id   TEXT,
  antes      TEXT,
  depois     TEXT
);
CREATE INDEX ix_auditoria_ativo ON auditoria(tipo_ativo, ativo_id);
CREATE TRIGGER tg_auditoria_no_update BEFORE UPDATE ON auditoria BEGIN SELECT RAISE(ABORT,'auditoria é append-only'); END;
CREATE TRIGGER tg_auditoria_no_delete BEFORE DELETE ON auditoria BEGIN SELECT RAISE(ABORT,'auditoria é append-only'); END;
CREATE TRIGGER tg_revisao_no_update BEFORE UPDATE ON revisao BEGIN SELECT RAISE(ABORT,'revisao é imutável'); END;

-- ===== BACKLOG DE OPORTUNIDADES (V2) =====
CREATE TABLE oportunidade (
  id TEXT PRIMARY KEY,
  titulo TEXT NOT NULL,
  area_id TEXT REFERENCES area(id),
  processo_id TEXT REFERENCES processo(id),
  problema TEXT, impacto_atual TEXT, solucao_sugerida TEXT,
  categoria TEXT CHECK (categoria IN ('GOVERNANCA','QUALIDADE','ANALYTICS','AUTOMACAO','INTEGRACAO','SISTEMATIZACAO','PROCESSO','IA')),
  responsavel_id TEXT REFERENCES pessoa(id),
  nota_impacto INTEGER CHECK (nota_impacto BETWEEN 1 AND 5),
  nota_frequencia INTEGER CHECK (nota_frequencia BETWEEN 1 AND 5),
  nota_areas INTEGER CHECK (nota_areas BETWEEN 1 AND 5),
  nota_esforco INTEGER CHECK (nota_esforco BETWEEN 1 AND 5),
  -- prioridade calculada na API; fórmula/faixas pendentes (AV-10)
  status TEXT NOT NULL DEFAULT 'IDENTIFICADA' CHECK (status IN ('IDENTIFICADA','TRIAGEM_REALIZADA','ENCAMINHADA_PORTFOLIO','ARQUIVADA')),
  portfolio_iniciativa_id TEXT,
  encaminhada_em TEXT,
  aprovador_id TEXT REFERENCES pessoa(id),
  registrada_em TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE oportunidade_vinculo (      -- RF-BKO-002
  oportunidade_id TEXT NOT NULL REFERENCES oportunidade(id),
  tipo_ativo TEXT NOT NULL CHECK (tipo_ativo IN ('INDICADOR','DADO','SISTEMA','PROCESSO','PLANILHA')),
  ativo_id   TEXT NOT NULL,
  PRIMARY KEY (oportunidade_id, tipo_ativo, ativo_id)
);

-- ===== BUSCA =====
CREATE VIRTUAL TABLE busca_fts USING fts5(tipo UNINDEXED, id UNINDEXED, nome, descricao, tokenize='unicode61 remove_diacritics 2');
