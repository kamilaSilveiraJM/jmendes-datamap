import { describe, it, expect } from 'vitest';
import { app } from '../src/index';

const dbOk = { prepare: () => ({ first: async () => ({ 1: 1 }) }) } as unknown as D1Database;
const dbFalha = { prepare: () => ({ first: async () => { throw new Error('x'); } }) } as unknown as D1Database;

describe('GET /api/v1/health', () => {
  it('retorna 200 quando o banco responde', async () => {
    const r = await app.request('/api/v1/health', {}, { DB: dbOk, PRODUCT_NAME: 'J. Mendes DataMap' });
    expect(r.status).toBe(200);
    expect(await r.json()).toEqual({ status: 'ok', produto: 'J. Mendes DataMap', db: 'ok' });
  });
  it('retorna 503 quando o banco falha', async () => {
    const r = await app.request('/api/v1/health', {}, { DB: dbFalha, PRODUCT_NAME: 'x' });
    expect(r.status).toBe(503);
  });
});
