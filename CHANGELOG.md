# Changelog — SquadKit

## 0.9.2 — 2026-09-02 · Integração de MCP aos agentes (pergunta na entrevista → fiação no montar-squad)

- **`/montar-contexto` pergunta por MCPs**: ao fim da entrevista, a IA pergunta se o usuário quer
  **conectar o squad** a alguma ferramenta via MCP (Atlassian/Jira/Confluence, Trello, Figma,
  GitHub/GitLab, Notion, Google Drive…), ancorando os exemplos no que ele já citou. Anota, por MCP:
  ferramenta · para quê · papel provável. Não força (não usa/não conhece → segue sem, adiciona depois).
- **`/montar-squad` liga o MCP ao papel certo**: novo princípio de composição mapeia cada MCP aos
  papéis que realmente usam (Figma → front/ux; Atlassian/Trello → PO/PM/analista do board; repos →
  quem versiona; Notion/Drive → docs/analista) — sem espalhar pelo squad todo. Os MCPs aparecem na
  **proposta** (linha própria, decisão do humano). No Build, as tools do MCP entram nas `tools:` do
  papel e a nota "(Requer <X> MCP instalado.)" na `description` (mesmo padrão do Playwright MCP).
- **Segurança**: MCP dá **ACESSO**; o segredo mora na conexão (config do cliente/IDE, do humano),
  nunca no papel/artefato/commit/log. Mudança só no core; wrappers herdam.

## 0.9.1 — 2026-09-02 · Entrevista de contexto calibrada pelo perfil de quem responde

- **`/montar-contexto` — Passo 0 na Fase 1**: antes das 8 perguntas, a IA descobre COM QUEM está
  falando (leigo/pessoal · TI/dev · PO/gestor/negócio · especialista do domínio; aceita perfil misto)
  e calibra profundidade e vocabulário por uma **tabela de calibração** — mesmo tema, perguntas mais
  técnicas ou mais simples conforme o interlocutor. Fallback seguro: não encaixou → trata como leigo e
  sobe o nível se perceber fluência. O perfil é gravado no topo de `entrevista.md` (os papéis herdam o tom).
- **Completude sobre pressa**: as 8 perguntas viram o *núcleo*; a IA acrescenta perguntas de
  aprofundamento e prioriza o contexto mais completo possível, mesmo que a entrevista se estenda — sem
  contradizer o modo RÁPIDO (que reduz o escopo de ingestão de docs, não o rigor da entrevista).
- Mudança só no core (`core/orquestracao/montar-contexto.md`); wrappers (Claude Code, Antigravity)
  apontam para ele e herdam automaticamente.

## 0.9.0 — 2026-09-02 · Diário de bordo no Git (pareceres de progresso por marco)

- **Nova skill padrão `diario-de-bordo`**: pequenas atualizações de progresso no repositório ao longo
  da task — não só a entrega final. Formato **enxuto**: uma **tabela** `Quando | Etapa | Atualização`
  que ganha uma linha curta por marco (Abertura ao criar a branch, Evento, Revisão, QA, Bloqueio,
  Fechamento). Fonte única CLI-neutra em `core/orquestracao/diario-de-bordo.md`; wrapper de skill do
  Claude Code. Tudo em português (script salvo em UTF-8 c/ BOM; saída UTF-8 sem BOM — acentos corretos).
- **Vitrine na descrição do PR/MR**: na abertura, o diário abre um **PR/MR em rascunho (DRAFT)** e
  mantém a **descrição** com a mesma tabela a cada marco (bloco gerenciado entre marcadores, sem apagar
  o texto do humano) — abrir a branch/PR já mostra o andamento. O PR fica DRAFT; "pronto" + merge é do humano.
- **Registro universal**: arquivo `PROGRESSO-<task>.md` (a mesma tabela) commitado/pushado na branch
  `squad/*` (funciona em GitHub, GitLab e qualquer host, sem depender de `gh`/`glab`). Sem repo/remote →
  arquivo local, sem push. Herda as regras da esteira: só branch `squad/*`, nunca merge, nunca
  `--no-verify` (hook guardião ativo).
- **Marco BLOQUEIO**: quando uma task trava e para (esteira §Bloqueios), a linha do diário mostra ao
  humano, na descrição do PR, o motivo do bloqueio.
- **Cadência por MARCO, não por relógio**: agente não tem timer confiável na execução; os marcos
  mapeiam nas transições que a esteira já tem (regra: onde atualiza o SPRINT.md, atualiza o diário).
- **Helper determinístico `scripts/diario.ps1`** (`-Repo -Task -Branch -Base -Marco -Resumo`, flags
  `-SemPR -SemPush`): adiciona a linha na tabela + commit + push + abrir/atualizar a descrição do PR/MR
  draft; recusa operar fora de branch `squad/*` (guarda contra a principal); nunca trava a task se o PR falhar.
- Integrado na esteira (transições, despacho por ondas, fechamento, tabela de donos), nos papéis
  dev (front/back/dados/mobile) + devops, e no `ROLE-TEMPLATE.md` (papéis futuros já nascem com o gancho).

## 0.8.3 — 2026-07-20 · Modo rápido de contexto + expectativa de tempo (telemetria do 1º teste ponta a ponta)

- Teste real (7Risk): ~1h de setup (montar-contexto+squad) e ~40 min/task. Números saudáveis para o
  rigor, mas a 1h é barreira de abandono e faltava gerenciar expectativa. Ações:
- **`/montar-contexto` em 2 modos**: ⚡ RÁPIDO (MVP de contexto ~15-20 min, índice `[PARCIAL]`
  enriquecido sob demanda — padrão) e 🔍 COMPLETO (varredura total ~1h, base definitiva). Reduz o
  ESCOPO, nunca o RIGOR (todo fato canônico ainda vem com evidência).
- **README (EN+PT): seção "Quanto tempo leva?"** — demo 5 min; setup one-time 15min–1h; por task
  dezenas de min como preço do rigor (calibrável). Define a expectativa e o trade-off velocidade×confiança.

## 0.8.2 — 2026-07-20 · Fluxo contínuo + entrega sem-git (2 bugs de fundo do teste no CMD)

- **fix (fluxo orgânico):** a esteira mandava "feche o chat e abra um novo" para o dev pegar a task
  do arquiteto — quebrava a proposta inteira. Agora a esteira tem a regra ⭐ **FLUXO CONTÍNUO**:
  tudo roda numa ÚNICA conversa, um papel passando para o outro sem interrupção; "sessão nova" só
  existe UMA vez, após o `/montar-squad` criar papéis novos (manutenção, não operação). Corrigido
  na esteira, no adapter do Claude Code e no modo executar.
- **fix (git em pasta sem repo):** os papéis dev assumiam `branch/push` — quebrava na demo e em
  qualquer squad que não é repositório git (análise, conteúdo, vida pessoal). Novo conceito
  **modo de entrega**: repo git com remote → branch `squad/*` + push; sem repo → arquivos direto,
  sem branch/commit/push. Os devs (front/back/dados/mobile) detectam o modo antes de entregar.
- Demo declarada **standalone (sem git)** na SPEC-DEMO-1 e no DEMO.md — o dev cria os arquivos
  direto e roda `node --test`, sem tentar commit em repo inexistente.

## 0.8.1 — 2026-07-20 · fix: pwsh vs powershell (feedback de dev em teste real)

- **fix**: máquinas Windows sem PowerShell 7 só têm `powershell` (5.1); os scripts rodavam, mas as
  mensagens impressas e os hooks usavam `pwsh` hardcoded → quebravam. Agora o instalador **detecta
  o SO** (`$env:OS`) e usa `powershell` no Windows / `pwsh` no macOS/Linux — tanto no `{{PWSH}}` dos
  hooks quanto nas linhas de "próximos passos" impressas. Testado sob 5.1: imprime `powershell`.
- Docs (README EN/PT, PERSONALIZACAO, DEMO.md): nota explícita "no Windows sem PS7, use `powershell`
  no lugar de `pwsh`".

## 0.8.0 — 2026-07-20 · README bilíngue + pacote de idioma

- **README bilíngue**: `README.md` (inglês, principal — máxima visibilidade no GitHub) +
  `README.pt-BR.md`, com seletor de idioma no topo de cada (o GitHub renderiza o README.md; o
  seletor de links é a convenção universal, GitHub não alterna sozinho).
- **Pacote de idioma** (`-Idioma`): o usuário escolhe em que idioma os agentes RESPONDEM e escrevem
  os artefatos (specs, relatórios, board) — default `Portugues (Brasil)`, aceita qualquer
  (English, Espanol…). Separa idioma de SAÍDA do idioma dos arquivos-fonte: os agentes leem
  instruções em qualquer idioma e respondem no escolhido. Placeholder `{{IDIOMA}}` resolvido na
  instalação e injetado na esteira, montar-contexto/squad, fechar-sprint, ROLE-TEMPLATE (invariante)
  e nos pontos de entrada dos adapters (AGENTS.md, INICIAR.md, cursor, vscode, skills Claude).
  `-Interativo` pergunta o idioma (7/7); gravado no manifesto e preservado pelo atualizar-squad.

## 0.7.2 — 2026-07-19 · Evals automatizados (promptfoo) + dossiê Paperclip

- **Evals golden automatizados**: `evals\promptfoo\promptfooconfig.yaml` — os 3 cenários (bug
  plantado, spec ambígua, dado sem fonte) rodam contra os papéis REAIS via promptfoo, com matriz
  de modelos e asserts determinísticos (`npx promptfoo eval`). Cenários manuais continuam valendo.
- **`docs/PESQUISA-PAPERCLIP-2026-07.md`**: análise de código (~4k arquivos) do Paperclip —
  categoria adjacente (control plane de "empresas" de agentes, servidor+DB), enforcement 9/10
  (o melhor visto: HMAC em aprovações, consent-gate anti-replay, trust-tiers, budget hard-stop);
  não é spec-driven e o rigor dentro do run é BYO — o vão que o SquadKit preenche. Joias
  transferíveis registradas no ROADMAP (hash do diff na aprovação, consent-gate, trust-tiers).

## 0.7.1 — 2026-07-19 · Checkup adversarial completo (auditoria de ~89 arquivos, contexto fresco)

- **fix ALTO**: `HISTORICO-SPRINTS.md` → **`HISTORICO.md`** unificado em 6 arquivos (papéis
  po/pm/analista/arquiteto liam um arquivo que nunca era gerado).
- **fix ALTO (cross-platform)**: hooks agora usam `{{PWSH}}` resolvido por SO no instalador
  (powershell.exe no Windows, pwsh no macOS/Linux); anti-burla tolera separadores `/`;
  pré-requisito documentado no README.
- Contagens corrigidas (16 papéis; qa-browser na lista do montar-squad e do README) · prefixos de
  caminho completos no core (`squad\_core\best-practices\…`, `squad\scripts\…`) · fallbacks de
  dev-mobile/qa-browser na esteira · reviewer agora cita `revisao.md` + critério "template de IA"
  no próprio papel · `sync-skills` saiu do padrão (virou exemplo opt-in) · seguranca ganhou pasta
  própria (`squad\seguranca\`) · devs leem `_INDICE.md` (fatos canônicos) · validador de dono
  único tolerante às duas ordens da frase · AGENTS.md "28+" uniformizado.
- README: **pré-requisitos para não-técnicos** (git+pwsh, com o truque "peça à sua IA") e
  **glossário de 30 segundos** (esteira, spec, harness, canon, rédea, explain-back).
- PERSONALIZACAO reescrita: botões do instalador (§0), enforcement em 3 camadas (§5 — inclui o
  passo do `instalar-hook-git.ps1` por repo, agora também no fechamento do instalador).
- ROADMAP podado (itens entregues/duplicados removidos da seção PRÓXIMO).

## 0.7.0 — 2026-07-19 · Rédea, orçamento de diff, explain-back, guardas de git e modo demo

- **Níveis de rédea por task** (coluna no SPEC §7): `assistida` (humano aprova o PLANO antes do
  código) · `supervisionada` (padrão) · `autônoma` (rotina de baixo risco) — comportamento no
  despacho da esteira; arquiteto atribui na spec.
- **Orçamento de diff em código** (`validar-diff.ps1` + campo `diffMaximo` no manifesto, default
  400 linhas): estourou = reprova automática ANTES da leitura do review → volta ao arquiteto
  para fatiar. Enforcement da "mudança cirúrgica".
- **🧠 Explain-back obrigatório**: todo relatório de executor ABRE com 5 linhas explicando o que
  o diff faz e por quê; reviewer valida fidelidade (explain-back que não bate com o diff = P1).
- **Guardas de git multi-IDE**: detector de `--no-verify`/`core.hooksPath`/`--no-gpg-sign` no
  hook do Claude Code (que o VS Code/Copilot também lê) + adapters novos `.cursor/hooks.json` e
  `.agents/hooks.json` (Antigravity) — testados nos 3 dialetos de resposta.
- **Modo demo** (`demo-squad.ps1`): instala squad de exemplo com spec validada, roda os gates
  determinísticos na hora e entrega o roteiro de 5 minutos (`DEMO.md`) — "executar T-DEMO-1".

## 0.6.2 — 2026-07-19 · Método Karpathy (engenharia agêntica) como pré-voo

- **`engenharia-agentica.md`** (best-practice, injetada em TODO executor): as 5 Karpathy
  Guidelines como pré-voo obrigatório antes de produzir — suposições à mesa, restrição de
  simplicidade (teste do engenheiro sênior), mudança cirúrgica (toda linha do diff rastreia ao
  pedido), critério verificável antes de começar, execute-e-prove. + Rédea (autonomia
  proporcional à consequência) e anti-padrões nomeados para o reviewer citar.
- Esteira: o despacho de toda task agora instrui o pré-voo.
- ROADMAP: seção "novas funcionalidades candidatas" (níveis de rédea, orçamento de diff,
  explain-back, modo demo, coletar-custo, adapters de hook, guia Playwright MCP).

## 0.6.1 — 2026-07-19 · Design distintivo + papel qa-browser + 2 dossiês de pesquisa

- **`design-distintivo.md`** (best-practice OBRIGATÓRIA de ux/dev-front/dev-mobile): anti-template
  de IA — as 3 caras default do design gerado, ancoragem no assunto, plano de tokens antes do
  código, elemento-assinatura único, copy como material de design, piso de qualidade; "parece
  template de IA?" vira critério P1 do reviewer. Regra de adaptação: o canônico do projeto vence.
- **Papel `squad-qa-browser`** no catálogo (16º): QA que CLICA o fluxo E2E via Playwright MCP,
  roteiro derivado dos CA-n, evidência em arquivos por CA, modo regressão congelado.
- Dossiês de pesquisa versionados: telemetria de custo por CLI e hooks-com-veto + QA browser
  (`docs/PESQUISA-*.md`) — desenhos de implementação prontos no ROADMAP.

## 0.6.0 — 2026-07-19 · Harness a montante: rastreabilidade, hook universal, onboarding e 5 best-practices

- **Validador de rastreabilidade em código** (`validar-spec.ps1` v2): cobertura CA→task→verificação
  determinística sobre as chaves CA-n — CA sem task = reprovado; task citando CA inexistente =
  reprovado; CA sem verificação no §10 = aviso; imprime cobertura X/Y. (A versão determinística do
  `/analyze` do spec-kit.)
- **Hook anti-burla UNIVERSAL** (`instalar-hook-git.ps1`): git pre-commit que bloqueia commit
  modificando teste rastreado (allowlist humana respeitada; teste novo passa) — vale para QUALQUER
  IDE/CLI, não só Claude Code. Testado ponta a ponta.
- **Onboarding guiado** (`instalar-squad.ps1 -Interativo`): 6 perguntas em linguagem simples no
  lugar de flags — para usuário não-técnico (vida pessoal, vendas, conteúdo).
- **Gate de qualidade de spec na esteira**: antes do gate humano, o arquiteto gera o checklist da
  ESCRITA (`qualidade-de-spec.md` — "unit tests for English", ≥80% itens com rastreabilidade) e
  roda o validador — o humano recebe spec auditada, não rascunho.
- **+5 best-practices** (catálogo whenToUse, total 11): migração de banco, segurança de API
  (P0/P1), SEO/YouTube, finanças/planilhas pessoais, qualidade de spec.

## 0.5.1 — 2026-07-19 · Correções do primeiro teste de usuário em projeto real

- **fix:** `validar-squad.ps1` e `dashboard.ps1` derivam a raiz da PRÓPRIA localização
  (`<raiz>\squad\scripts\`) em vez do diretório atual — rodar de outro cwd validava o squad
  errado (bug reportado em instalação real); ambos imprimem a raiz em uso.
- **novo:** `atualizar-squad.ps1` — sincroniza `_core` + scripts + catálogo de instalações
  existentes (manifesto `squad/.squadkit.json`, gravado pelo instalador; instalações antigas
  aceitam os parâmetros via flags). Nunca toca contexto, equipe, board ou adapters.
- **novo:** `montar-contexto` termina com **📋 Resumo de Entendimento** obrigatório (o que é o
  projeto, inventário de leitura, fatos canônicos, decisões, contradições, riscos, perguntas) +
  loop de confirmação — correção do usuário sobrescreve inferência.

## 0.5.0 — 2026-07-19 · Antigravity + padrão AGENTS.md + upgrades da pesquisa de mercado

- **Google Antigravity** suportado (`-Ide antigravity`): `.agents/workflows/` (montar-contexto,
  montar-squad, squad, fechar-sprint como slash-workflows) + `.agents/agents.md`; Artifacts do
  Antigravity mapeados ao contrato de evidência.
- **AGENTS.md canônico instalado SEMPRE** (padrão agents.md / Linux Foundation — lido por Codex,
  Antigravity, Copilot, Windsurf, Devin e 25+ ferramentas).
- **Pesquisa de mercado** (6 repos clonados + 12 produtos): `docs/PESQUISA-MERCADO-2026-07.md`.
- SPEC upgrades: critérios **CA-n numerados** (rastreabilidade CA→task→teste) com formato **EARS**;
  §7 com **ondas de execução** (grafo de deps → paralelismo) e **complexidade 1-10** (>7 fatia
  antes); §11 log de clarificações.
- **Protocolo de clarificação** (máx 5 perguntas, múltipla-escolha com recomendação, respostas
  re-integradas na spec; defaults viram premissas auditáveis).
- Review: **camadas cegas paralelas** (adversarial/borda/gap-de-verificação/auditor de aceitação),
  **convergência com gap `não-pedido`** (pega scope creep) e severidade calibrada (só P0/P1 bloqueia).
- **Contrato de evidência por tipo de entrega** (front = fluxo clicado/screenshot — anti-"Potemkin UI").
- **Ciclo de vida do canon**: mudança de fato canônico gera relatório de impacto; "conflito se
  resolve corrigindo a spec, nunca diluindo o canon".
- ROLE-TEMPLATE: seção "Quando me acionar" (few-shot ✅/❌ de roteamento) — exigida no build.

## 0.4.0 — 2026-07-19 · Multi-CLI + contexto-primeiro + verificável em código

- **Multi-CLI/IDE**: core neutro em `core\` (fonte única) + adapters para Claude Code (skills,
  hook anti-burla, subagentes), Cursor (rules), Codex/OpenAI (AGENTS.md), VS Code Copilot
  (copilot-instructions) e genérico (`squad\INICIAR.md` — qualquer chat de IA).
- **`/montar-contexto`** (novo, o PRIMEIRO passo): entrevista + ingestão de docs + caça ativa a
  contradições → `_INDICE.md` com FATOS CANÔNICOS (com evidência) + `HISTORICO.md`.
- **Modelo é escolha do usuário**: papéis sem modelo fixo; `/montar-squad` sugere 3 por papel
  (desempenho/custo/custo-benefício via leaderboards) e registra em `squad\MODELOS.md`.
- **Validadores em código**: `validar-squad.ps1` (frontmatter, invariantes, placeholders, colisão
  de dono único, freio de ação irreversível) e `validar-spec.ps1` (§3/§5/§10 completas).
- **Evals golden** (`evals\`): bug plantado, spec ambígua, dado sem fonte — o harness testado
  como código.
- **`/fechar-sprint`** + `telemetria.csv` + `dashboard.ps1` (HTML de board+telemetria).
- **Best-practices com `whenToUse`** (`core\best-practices\`): modelos, spec-driven, evidência,
  revisão, análise de dados, conteúdo criativo — injetadas por papel no montar-squad.
- Novo domínio **pessoal/produtividade** + exemplo `squad-gestor-pessoal`.
- Instalador cross-platform (pwsh 7+ Win/macOS/Linux; compatível PS 5.1) com `-Ide` multi-valor.

## 0.3.0 — 2026-07-19 · Sob medida

- `/montar-squad` (descoberta → design com gate humano → build com gates BLOCKING), inspirado na
  análise de código do OpenSquad; `ROLE-TEMPLATE.md` com seções [INVARIANTE]; perfil `sob-medida`;
  catálogo+exemplos embarcados no projeto (`squad\_catalogo\`); exemplos youtube/pbm-farma/aidc7.

## 0.2.0 — 2026-07-19 · Composável

- Catálogo de 15 papéis + `perfis.json` (7 presets) + instalador `-Perfil`/`-Papeis`;
  esteira adaptativa com fallbacks por papel ausente; fase de concepção (BRIEF→PRD→HISTORIAS→UX).

## 0.1.0 — 2026-07-19 · Fundação

- Esqueleto extraído do squad 7Risk validado em produção (piloto FE-17): esteira spec-driven,
  memória de sprint em arquivos com dono único, hook anti-burla de testes, gates humanos.
