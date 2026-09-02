# Diário de bordo do Squad {{PROJETO}} — core (vale para QUALQUER CLI/IDE de IA)

> 🌐 **Idioma de saída: {{IDIOMA}}.** Todo parecer é escrito neste idioma. As instruções-fonte podem
> estar em outro idioma — isso NÃO muda o idioma de saída.

**O que é:** um registro CONTÍNUO de progresso da task publicado no Git ao longo da execução — não só
a entrega final. A cada marco, um **parecer** curto (feito até aqui / próximos passos) sobe para o
repositório, na branch da task. É a diferença entre "sumir e reaparecer com o PR pronto" e "deixar
um rastro auditável do trabalho enquanto ele acontece". ⭐

**Não confunda com a entrega.** A entrega (§7 da esteira) continua igual: branch `squad/*` + diff +
evidências + veredito, merge sempre humano. O diário é a CAMADA DE CADÊNCIA por cima disso — ele
NÃO mergeia, NÃO commita na `{{BRANCH}}`, NÃO contorna hook (nada de `--no-verify`). Mesmas regras
invioláveis de git da esteira.

## Quando dispara — POR MARCO (não por relógio) ⭐

Um agente não tem relógio confiável durante a execução; "de tempo em tempo" vira, na prática, "a cada
marco". Os marcos mapeiam direto nas fases que a esteira já tem:

| Marco | Quando | Quem dispara |
|---|---|---|
| **ABERTURA** | ao criar a branch `squad/<task>`, ANTES de escrever código | o dev da task (ou o orquestrador) |
| **ONDA-N** | cada onda do §7 fechada e revisada | o ORQUESTRADOR (na transição de fase) |
| **PÓS-REVIEW** | após o veredito do arquiteto (aprovado/reprovado + motivo) | o ORQUESTRADOR |
| **PÓS-QA** | após o QA rodar (pronto/bugs) | o ORQUESTRADOR |
| **BLOQUEIO** | quando a task trava e para (registrada em `SPRINT.md` §Bloqueios) | o ORQUESTRADOR |
| **FECHAMENTO** | na entrega ao humano (antes do gate de merge) | o ORQUESTRADOR |
| **LIVRE** | quando o humano pedir (`/diario-de-bordo`) ou num marco relevante extra | humano / agente |

Regra de bolso: **todo lugar onde a esteira manda atualizar o `SPRINT.md` numa transição, atualize
também o diário.** O `SPRINT.md` é o board interno do squad; o diário é a vitrine externa no Git.

## Onde/como publica — modo COM repositório git (remote) ⭐

Duas camadas, com propósitos diferentes:

- **A VITRINE — descrição do PR/MR** (o que você pediu: abrir a branch e já ver o andamento). Na
  ABERTURA, o diário abre um **PR/MR em rascunho (DRAFT)** cuja descrição já traz a **tabela de
  atualizações**; a cada marco, a descrição é **atualizada** com a mesma tabela (uma linha nova por
  marco). Fica sempre no topo, num **bloco gerenciado** entre marcadores
  `<!-- squad:diario -->` … `<!-- /squad:diario -->` — o diário só reescreve ESSE bloco, preservando
  qualquer texto que o humano tenha posto na descrição. O PR permanece **DRAFT**: quem marca "pronto"
  e mergeia é o humano. (Exige `gh` para GitHub ou `glab` para GitLab; sem eles, vale só a camada
  abaixo.)
- **O REGISTRO — arquivo `PROGRESSO-<task>.md`** na RAIZ do clone, **na branch `squad/<task>`**
  (nunca na `{{BRANCH}}`). É a **mesma tabela**, que só CRESCE (uma linha por marco) — versionada,
  auditável, visível no diff. Funciona em QUALQUER host, sem depender de `gh`/`glab`.

Mecânica de cada marco (pequena atualização):

1. **Append** de UMA LINHA na tabela do `PROGRESSO-<task>.md`: `| <quando> | <etapa> | <atualização> |`.
2. `git -C <clone> add PROGRESSO-<task>.md`
3. `git -C <clone> commit -m "chore(squad): diario <task> — <etapa>"` (SEM `--no-verify`, SEM `--no-gpg-sign`).
4. `git -C <clone> push origin squad/<task>`.
5. **Descrição do PR/MR (best-effort):** GitHub via `gh` (`gh pr create --draft …` na abertura,
   `gh pr edit <n> --body-file …` nos demais) ou GitLab via `glab`. Sem `gh`/`glab`: **pule
   silenciosamente** — o arquivo na branch já é o registro.

Para não errar a mecânica, use SEMPRE o helper determinístico — ele faz tudo isto (append + commit +
push + abrir/atualizar a descrição do PR draft), RECUSA operar fora de branch `squad/*` e nunca trava
a task se o PR falhar:
`pwsh -File squad\scripts\diario.ps1 -Repo <clone> -Task <id> -Branch squad/<task> -Base {{BRANCH}} -Marco <etapa> -Resumo "<uma frase curta>" [-Titulo "<título>"] [-SemPR]`

## Modo SEM repositório (ou repo sem remote) — demo, análise, conteúdo, planilhas

Igual à esteira: **NÃO** tente branch/commit/push (falha e polui). O diário vira um arquivo local
`{{RAIZ}}\squad\progresso\<task>.md` (mesmo formato, sem push). O helper detecta: sem `-Repo` (ou repo
sem remote), ele só escreve o arquivo local. O "registro" é o humano ler/manter o arquivo.

## Formato — uma tabela enxuta (pequenas atualizações)

Nada de relatório longo: **uma linha por marco**, curta e prática. O arquivo (e a descrição do PR/MR)
tem esta cara:

```
# Diário de bordo — Task <id>: <título>
Branch: squad/<id> · Início: <AAAA-MM-DD HH:mm>

## Atualização em tempo real

| Quando | Etapa | Atualização |
| --- | --- | --- |
| 2026-09-02 11:08 | Abertura   | Iniciei o progresso; vou fazer X e Y |
| 2026-09-02 11:30 | Evento     | Resolvi X; testes verdes |
| 2026-09-02 12:10 | Fechamento | Branch fechada, tudo atualizado; pendente: revisar Z |
```

A coluna **Etapa** vem do `-Marco`: `abertura` → Abertura · `evento`/`onda` → Evento · `review` →
Revisão · `qa` → QA · `bloqueio` → Bloqueio · `fechamento` → Fechamento (qualquer outro texto vira a
própria etapa). A **Atualização** é a sua frase curta (`-Resumo`) — se houver pendência, escreva na
própria frase. Sem seções, sem checklist: só o suficiente para bater o olho e entender o andamento.

## Regras invioláveis (herdadas da esteira — o diário NÃO abre exceção)

1. **Só branch `squad/*`.** O diário jamais commita/pusha na `{{BRANCH}}` nem mergeia. Merge é humano.
2. **Verificação não se contorna.** Nada de `--no-verify` / `--no-gpg-sign` / override de `hooksPath`
   (o hook guardião bloqueia; se um hook falha, investigue a causa).
3. **Sem credenciais no parecer.** Segredo entra na CONEXÃO (push, API do host), NUNCA no texto do
   diário/commit/comentário. Nem token, nem senha, nem URL com credencial embutida.
4. **Honestidade.** O parecer descreve o que REALMENTE foi feito; sem evidência inventada. Se um passo
   foi pulado ou falhou, o diário diz isso.
5. **Idioma {{IDIOMA}}** em todo parecer, independentemente do idioma destas instruções.
6. **Best-effort não trava a task.** Se o comentário no PR/MR falhar (sem `gh`/`glab`, sem PR), siga —
   o arquivo na branch é suficiente. O diário nunca deve bloquear a entrega.
