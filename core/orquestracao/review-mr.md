# /review-mr — atuar sobre a revisão humana de um MR já aberto (core, vale para QUALQUER CLI/IDE de IA)

> 🌐 **Idioma de interação: o idioma do projeto instalado.**

## Quando usar

Depois que um MR foi aberto (por `/abrir-mr` ou manualmente) e o **revisor humano** (arquiteto da
empresa) comentou nele no GitLab — aprovando ou pedindo ajuste. `/review-mr` lê essa revisão real e
atua: corrige, valida, implementa o que faltar, ou apenas informa que não há pendência.

Esta é a revisão **externa** (humana, no GitLab), diferente do review **interno** do squad-arquiteto
que já aconteceu antes de abrir o MR (esteira, item 4). Não repita aquele review aqui — o que importa
agora é o que o humano escreveu.

## Pré-condição (inviolável)

**Só roda se o MR já existir e estiver `opened`.** Se o card/MR não existir ou já estiver
fechado/mergeado, aborta e informa — não é papel desta skill abrir MR (isso é `/abrir-mr`) nem agir
sobre MR já mergeado (isso é QA pós-merge, acionado pelo humano).

## Entrada

`/review-mr #<card>` ou `/review-mr !<MR>` — card ou MR específico.

- `#card` → resolve para o(s) MR(s) vinculados a esse card (board e/ou busca no GitLab pelo número do
  card no título/descrição/branch).
- `!MR` → usa direto, sem resolução.
- Card com **mais de um MR aberto**: por padrão processa só o que vier explícito no comando. Para
  tratar todos de uma vez, o humano pede explicitamente — ex.: `/review-mr #6734 atuar em todos`.

## Leitura (duas vezes: ao começar e antes de publicar a resposta)

1. **Todas as notas do MR pela API** (`GET /projects/:id/merge_requests/:iid/notes`, paginado,
   filtrando `system == false`) — nunca confiar só no que foi colado no chat; o revisor pode ter
   deixado mais de uma nota, e pode comentar mais enquanto o squad trabalha.
2. **Comentários do card no board** — a correção às vezes chega lá, não só no MR.
3. Monta uma lista **numerada** do que a revisão pede, item a item, antes de decidir o que fazer.

## Antes de agir

Comenta no card (aba Comentários) algo como **"iniciando verificação"** — sinaliza que o squad está
processando a revisão, antes de qualquer correção.

## Caso 1 — aprovado, sem pendência

- **Não mexe no card nem no MR** além do que já estava.
- **Só reporta ao humano, no chat**: resumo do veredito e qualquer observação do revisor que não seja
  bloqueante.
- Merge continua sendo decisão do humano — esta skill **nunca mergeia** e **nunca marca o card como
  concluído/Done** (isso é depois do QA pós-merge, fora do escopo daqui).

## Caso 2 — pede ajuste

1. **Roteia a correção para o dev da área certa.** Tenta retomar o **mesmo** subagente que fez a
   implementação original (se ainda vivo/retomável na sessão — contexto preservado). Se não for
   possível (sessão nova, agente não resumível), despacha um dev **novo** com o SPEC original + o
   diff da branch + o texto **exato** dos pontos da revisão embutidos no prompt — nunca repassa
   "aprovação" ou "decisão" como se fosse o humano falando diretamente ao subagente.
2. **Push na mesma branch** (nunca branch nova). Se a branch de integração do projeto andou por baixo
   nesse meio tempo, atualiza por **merge**, nunca rebase — preserva os SHAs que a revisão já citou.
3. **Confere internamente** (squad-arquiteto revalida o delta contra o SPEC) antes de considerar o
   ponto resolvido — não aceita "a IA disse que corrigiu" sem reexecutar a prova.
4. **Comenta no card** o que foi feito em cada atualização — texto visível (sem tags/HTML-escape ao
   reconferir a publicação, não byte a byte).
5. **Repete a busca de notas do MR** antes de fechar o ciclo — revisor ativo pode ter comentado mais
   coisa enquanto o squad trabalhava; se sobrou algo não coberto, diz isso, não finge que está tudo
   atendido.

## Regra mestre (inviolável)

**Nunca mergeia. Nunca aprova nem resolve discussão do MR fingindo ser o revisor humano. Nunca marca
o card como concluído/Done** — fechamento é sempre manual, depois do QA pós-merge.

## Relato final

O que foi lido (quantas notas, de quando), o que foi feito (ou "nada a fazer — aprovado sem
pendência"), e o estado atual do MR/card.
