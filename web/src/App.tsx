import { useEffect, useState } from 'react';

type Saude = { status: string; produto: string; db: string };

export function App() {
  const [saude, setSaude] = useState<Saude | null>(null);
  const [erro, setErro] = useState(false);
  useEffect(() => {
    fetch('/api/v1/health').then((r) => r.json()).then(setSaude).catch(() => setErro(true));
  }, []);
  return (
    <main>
      <header><h1>J. Mendes DataMap</h1></header>
      <p>Mapa corporativo de informações — ambiente de desenvolvimento.</p>
      <p>API: {erro ? 'indisponível' : saude ? `${saude.status} (banco: ${saude.db})` : 'verificando…'}</p>
    </main>
  );
}
