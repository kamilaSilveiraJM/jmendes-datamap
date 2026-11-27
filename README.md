# J. Mendes DataMap

Plataforma corporativa de governança e descoberta de informações: indicadores, dados, sistemas, integrações, planilhas, dashboards, responsáveis e áreas — com o **Mapa Corporativo de Informações**.

- Contexto, análise e arquitetura: [`docs/00_START.md`](docs/00_START.md)
- Regras de contribuição: [`CONTRIBUTING.md`](CONTRIBUTING.md)

**Stack (inicial):** Cloudflare (Pages + Workers + D1), React + TypeScript. Auth: Microsoft Entra ID.
**Catálogo guarda apenas metadados — nunca dados pessoais ou conteúdo operacional.**

## Desenvolvimento local

Pré-requisitos: Node 20+ e conta Cloudflare (a conta da J. Mendes).

```bash
npm install                     # gera package-lock.json (commitar na primeira execução)
npm run typecheck && npm test
npx wrangler login              # uma vez
npx wrangler d1 create jmendes-datamap   # copiar o database_id para api/wrangler.toml
npm run db:migrate:local        # aplica db/migrations no D1 local
npm run dev:api                 # http://localhost:8787/api/v1/health
npm run dev:web                 # http://localhost:5173
```

`npm run db:check` valida as migrations em SQLite sem Cloudflare.
