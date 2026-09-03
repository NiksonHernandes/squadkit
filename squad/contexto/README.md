# contexto\ — base de conhecimento do Squad {{PROJETO}}

É o que faz o squad não errar. Três passos para montá-la (1 sessão de Claude Code resolve):

## 1. Despeje os documentos do projeto aqui

Visão de produto, arquitetura, contratos/APIs, histórias do PO, planejamentos de sprint, atas,
decisões. Formato livre (md, docx, xlsx, pdf) — prefira markdown.
Documentos .docx podem ser lidos extraindo o zip: `Copy-Item <arq>.docx $env:TEMP\d.zip;
Expand-Archive $env:TEMP\d.zip $env:TEMP\d -Force` → texto em `word\document.xml` (limpar tags).

## 2. Monte o `_INDICE.md` (o mapa — todo agente lê ELE primeiro)

Peça ao Claude: *"leia tudo do contexto e monte o _INDICE.md no padrão do squad"*. Seções:
- **Regras de manuseio** — credenciais (uso para ACESSO, nunca em entregável), como ler .docx,
  significado de [VIVO] vs [HISTORICO].
- **⭐ FATOS CANÔNICOS** — tabela que RESOLVE contradições entre documentos (versões de stack,
  nomes, decisões que mudaram). É a seção mais valiosa: docs sempre se contradizem; um agente que
  lê dois docs conflitantes sem canon escolhe errado.
- **Documentos VIVOS** (o que consultar com confiança, 1 linha cada) e **HISTÓRICOS**.
- **Documentos fora desta pasta** (caminho absoluto) que são imprescindíveis.

## 3. Monte o `HISTORICO.md` (a memória viva)

O que foi feito por sprint (e POR QUÊ), estado atual VERIFICADO no código (não no planejado),
para onde o projeto vai (roadmap/marcos), dívidas e pendências transversais.
**Validar contra o código real e o board antes de escrever** — planos mentem, o repo não.
Atualizar ao fim de cada sprint.

## 4. O `MAPA-DO-PROJETO.md` (o retrato vivo, em linguagem acessível)

Um panorama do projeto para QUALQUER pessoa entender em 5 minutos — inclusive quem não é técnica:
o que ele faz, como as peças se encaixam, onde as coisas ficam. Diferente do `_INDICE` (referência
de fatos) e do `HISTORICO` (linha do tempo), o mapa é a **visão de conjunto narrada** do estado
atual. É um **recurso opcional** — o usuário decide no onboarding (`/montar-contexto` ou
`/montar-squad`) e pode **ligar/desligar** quando quiser (campo `mapaProjeto` no manifesto
`.squadkit.json`). Quando ligado, o `/montar-contexto` gera a primeira versão e a esteira o
**revisa ao final de cada task** (atualiza se defasou · pergunta na dúvida · mantém limpo).
Mecânica: `_core\orquestracao\mapa-do-projeto.md`.

## Regras da pasta

- Documento novo → colocar aqui **e adicionar a linha no `_INDICE.md`** (senão os agentes não acham).
- Arquivo de credenciais (se houver): agentes usam para ACESSAR serviços; segredo nunca vai para
  spec/relatório/código/commit. Prefira cofre quando existir.
- Leitura é SELETIVA via índice — nenhum agente carrega a pasta inteira.
