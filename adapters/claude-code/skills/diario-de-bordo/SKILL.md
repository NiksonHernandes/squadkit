---
name: diario-de-bordo
description: Diário de bordo no Git do squad {{PROJETO}} — publica pareceres de progresso da task na branch squad/* ao longo da execução (abertura, marcos, fechamento), não só na entrega final. Use when o usuário pedir /diario-de-bordo, "registra o progresso no git", "sobe um parecer", ou quando a esteira cruzar um marco (nova branch, fim de onda, pós-review, pós-QA, fechamento).
---

🌐 Idioma de saída: **{{IDIOMA}}**. Siga FIELMENTE `{{RAIZ}}\squad\_core\orquestracao\diario-de-bordo.md`
(fonte única entre CLIs) — marcos, formato do parecer, mecânica git e fallback sem-repo estão lá.

O diário é uma **tabela enxuta** (`Quando | Etapa | Atualização`) — uma linha curta por marco, na
branch `squad/<task>` e na descrição do PR/MR. **Uso manual:**
- `/diario-de-bordo abrir <task>` — cria/assume a branch `squad/<task>`, escreve a tabela com a
  primeira linha (Abertura) e abre o PR draft ("iniciei o progresso; vou fazer X").
- `/diario-de-bordo evento "<uma frase curta>"` — adiciona uma linha (ex.: "resolvi X; testes verdes").
- `/diario-de-bordo fechar <task>` — linha de Fechamento ("branch fechada; pendente: Z"), antes do gate.

Para não errar a mecânica de git, delegue ao helper determinístico (funciona em qualquer host —
GitHub/GitLab/etc.):
`pwsh -File squad\scripts\diario.ps1 -Repo <clone> -Task <id> -Branch squad/<task> -Base {{BRANCH}} -Marco <etapa> -Resumo "<uma frase curta>" [-Titulo "<título>"]`

Notas específicas do Claude Code:
- **Roda NESTA conversa, junto da esteira** — o orquestrador dispara o diário nas transições de fase
  (a cada `SPRINT.md` atualizado numa transição, sobe também o parecer), sem fechar/reabrir o chat.
- O hook guardião de git (`.claude\hooks\guard-git.ps1`) continua ativo: NADA de `--no-verify`. Se um
  hook de commit falhar, investigue a causa — não contorne.
- Só branch `squad/*`, nunca `{{BRANCH}}`, nunca merge — o diário registra, o humano mergeia.
- **Vitrine = descrição do PR/MR**: na abertura, abre um PR/MR em **rascunho (DRAFT)** e mantém a
  descrição atualizada a cada marco (bloco gerenciado, sem apagar o texto do humano) — assim, abrir a
  branch/PR já mostra o andamento. O PR fica DRAFT; "pronto" + merge é do humano.
- Marco **BLOQUEIO**: quando uma task trava e para (esteira §Bloqueios), sobe o parecer para o humano
  ver na hora "parado, esperando decisão X".
- É **best-effort**: sem `gh`/`glab`, o arquivo `PROGRESSO-<task>.md` na branch já é o registro
  completo. Nunca deixe o PR/MR bloquear a task.
