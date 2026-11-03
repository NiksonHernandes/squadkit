---
name: abrir-mr
description: Abre o MR (GitLab) de uma entrega do squad {{PROJETO}} já revisada e aprovada internamente, e publica a mesma descrição como comentário no card do board. Use when o usuário pedir /abrir-mr.
---

🌐 Idioma de saida: **{{IDIOMA}}**. Siga FIELMENTE `{{RAIZ}}\squad\_core\orquestracao\abrir-mr.md`
(fonte única entre CLIs).

Notas específicas do Claude Code:
- Despache o `squad-arquiteto` (via Agent tool) para executar a chamada de API (GitLab + board) e
  redigir a descrição — ele já tem o método de acesso documentado no próprio papel.
- Nunca mergeia, nunca aprova, nunca marca card como concluído — só cria o MR e o comentário.
- Se o MR da branch já existir, não duplique: reporte o IID existente.
