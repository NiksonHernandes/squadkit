---
name: review-mr
description: Lê a revisão humana de um MR já aberto do squad {{PROJETO}} (comentários do GitLab) e atua — corrige, valida ou só informa que não há pendência. Use when o usuário pedir /review-mr.
---

🌐 Idioma de saida: **{{IDIOMA}}**. Siga FIELMENTE `{{RAIZ}}\squad\_core\orquestracao\review-mr.md`
(fonte única entre CLIs).

Notas específicas do Claude Code:
- Só roda se o MR referenciado existir e estiver `opened` — caso contrário, aborte e informe.
- Correção/ajuste volta ao MESMO agente dev via SendMessage (contexto vivo) quando ele ainda estiver
  retomável nesta sessão; sessão nova sem histórico → despache um dev NOVO com o SPEC + diff + o
  texto exato da revisão embutidos no prompt.
- O hook anti-burla de testes está ativo (`.claude\hooks\anti-burla-teste.ps1` via settings.json).
- Aprovado sem pendência: só reporte no chat — nada de ação automática no card/MR, merge fica com o
  humano.
