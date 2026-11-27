import { Hono } from 'hono';

export type AppEnv = { Bindings: { DB: D1Database; PRODUCT_NAME: string } };

export const app = new Hono<AppEnv>();

// Saúde da API e do banco (sem dados de negócio).
app.get('/api/v1/health', async (c) => {
  let db: 'ok' | 'erro' = 'ok';
  try {
    await c.env.DB.prepare('select 1').first();
  } catch {
    db = 'erro';
  }
  return c.json({ status: db === 'ok' ? 'ok' : 'degradado', produto: c.env.PRODUCT_NAME, db }, db === 'ok' ? 200 : 503);
});

export default app;
