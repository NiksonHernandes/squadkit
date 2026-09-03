# Mapa do Projeto {{PROJETO}} — core (vale para QUALQUER CLI/IDE de IA)

> 🌐 **Idioma de saída: {{IDIOMA}}.** O mapa é escrito neste idioma. As instruções-fonte podem estar
> em outro idioma — isso NÃO muda o idioma de saída.

**O que é:** um retrato VIVO e ACESSÍVEL do projeto — o que ele faz, como as peças se encaixam e
onde as coisas ficam. Fica em `{{RAIZ}}\squad\contexto\MAPA-DO-PROJETO.md` e é **revisado ao final
de CADA card/task**, para nunca ficar defasado. É o documento que qualquer pessoa abre para
entender o projeto em 5 minutos — inclusive quem **não é técnico**. ⭐

**Escrito para gente, não só para dev.** Regra de ouro do tom: se um leitor sem base técnica não
entender uma frase, ela está errada aqui. Explique em linguagem do dia a dia; quando um termo
técnico for inevitável, diga entre parênteses o que ele significa na prática. O detalhe técnico
profundo (payloads de API, comandos de setup) mora nos docs do `squad-docs`, não aqui.

## Como ele se diferencia dos outros artefatos (não duplique)

| Artefato | Papel | Como difere do mapa |
|---|---|---|
| `contexto\_INDICE.md` | fatos canônicos + o que vale quando docs se contradizem | é referência de consulta; o mapa é a visão de conjunto narrada |
| `contexto\HISTORICO.md` | memória por sprint (o que foi feito e por quê) | é linha do tempo; o mapa é o retrato do estado ATUAL |
| `PROGRESSO-<task>.md` (diário) | progresso de UMA task no Git | é efêmero por task; o mapa é permanente e do projeto todo |
| docs do `squad-docs` (README/API) | documentação técnica detalhada | é para quem vai codar/integrar; o mapa é o panorama para qualquer um |

O mapa **aponta** para esses outros documentos ("os detalhes de X estão em…"); não copia o conteúdo
deles. Menos duplicação = menos coisa para ficar defasada.

## Ativação e reversão — é escolha do usuário ⭐

Este recurso é **opcional e reversível**. Quem decide se o projeto terá doc/arquitetura viva por
task é o **usuário**, no onboarding:
- **`/montar-contexto`** (se houver entrevista): a IA pergunta se ele quer as atualizações por task.
- **`/montar-squad`** (se NÃO houve entrevista, ou se ficou indeciso): a IA pergunta ali.

A decisão fica no manifesto **`{{RAIZ}}\squad\.squadkit.json`**, campo **`mapaProjeto`** (`true`/`false`).
É a **fonte da verdade**: a esteira só roda o passo do mapa quando `mapaProjeto` é `true`.

**Reverter a qualquer momento** (mudou de ideia): o usuário pede "desligar/ligar o mapa do projeto"
(ou edita o campo). **Desligar NÃO apaga** o `MAPA-DO-PROJETO.md` já existente — apenas para de
mantê-lo; **religar** retoma a manutenção do ponto em que está (na volta, faça um review para
tirar a defasagem acumulada).

**Modelo do mantenedor, calibrado ao nível do projeto (momentâneo).** Ao LIGAR, o designer do squad
faz um **review total do projeto** (tamanho/complexidade do código e do domínio, integrações,
criticidade, volume de docs) e recomenda o modelo do **papel dono** (`squad-docs`, ou nota para o
orquestrador se ausente) proporcional ao nível — projeto simples → modelo econômico; médio →
custo-benefício; grande/crítico → desempenho. É uma recomendação **momentânea**, reavaliada no
`/fechar-sprint` conforme o projeto cresce. Registre em `squad\MODELOS.md`. Detalhe do fluxo em
`montar-squad.md`.

## Quando dispara — ao FINAL de cada card/task (quando ligado) ⭐

**Só quando `mapaProjeto` = `true` no manifesto.** Se estiver `false`, pule este passo por completo
(nada de mapa, nada de linha `Mapa:` — a task fecha normalmente).

Com o recurso ligado, o gatilho é o **FECHAMENTO** da task na esteira (§7 da esteira de entrega;
passo final do modo EXECUTAR), depois do review aprovado e ANTES do gate de merge humano. Fechar
uma task sem passar por este processo é fechar pela metade — o mapa é parte do pacote de entrega.

Também dispara na criação da base de conhecimento (`/montar-contexto` gera a primeira versão, se
ligado) e é revisado no `/fechar-sprint` (rede de segurança de fim de ciclo).

## O processo — 4 passos a cada fechamento

**1. Verificar defasagem.** Olhe o que a task REALMENTE mudou (o diff/os arquivos entregues, a spec
cumprida) e compare com o que o mapa descreve hoje. Pergunte-se: depois desta entrega, alguma frase
do mapa ficou **desatualizada, incompleta ou uma versão atrás** da realidade? Áreas que costumam
defasar: nova funcionalidade ou tela, uma peça que passou a existir/deixou de existir, mudança em
como duas partes conversam, novo lugar onde algo é guardado, decisão que muda o rumo.

**2. Decidir (com o gate de dúvida).** Três saídas possíveis:
   - **Mudou algo do retrato → ATUALIZE** o mapa agora (passo 3) e registre "Mapa: atualizado".
   - **Nada do retrato mudou** (task interna, refino, correção que não altera o panorama) → **não
     mexa** e registre "Mapa: sem mudança — <motivo em 1 linha>". Manter limpo também é decisão.
   - **Em dúvida se vale atualizar** (mudou algo de fronteira, não está claro se é relevante para o
     retrato) → **PERGUNTE ao usuário**, objetivamente, se ele quer que o mapa seja atualizado —
     mostrando o que mudou e sua recomendação. Não atualize no escuro nem ignore no escuro. Enquanto
     não houver resposta, registre "Mapa: pergunta pendente".

**3. Escrever mantendo LIMPO e ACESSÍVEL.** Ao atualizar:
   - **Substitua, não empilhe.** Reescreva a parte afetada; NÃO vá acrescentando parágrafos até virar
     um acúmulo. O que morreu, sai (a linha do tempo é papel do `HISTORICO.md`, não do mapa).
   - **Derive do real, não do planejado.** Descreva o que a entrega FEZ, não o que se pretendia fazer.
   - **Linguagem do dia a dia** (ver regra de ouro acima). Frases curtas. Prefira "onde os pedidos
     ficam guardados" a jargão de banco de dados.
   - **Só o que importa para desenvolver o projeto** dali para a frente: o que existe, para que serve,
     como as peças se conectam, onde ficam, o que é regra inegociável. Corte o supérfluo.

**4. Registrar a decisão.** No pacote de fechamento da task (e no diário, se houver), inclua UMA
linha: `Mapa: atualizado` · `Mapa: sem mudança — <motivo>` · `Mapa: pergunta pendente`. É o que
torna este passo auditável — o fechamento não fica "verde" sem essa linha.

## Estrutura sugerida do arquivo (mantenha enxuta)

Seções curtas; corte a que não se aplica ao projeto. Um leitor deve entender o projeto lendo só isto:

```
# Mapa do Projeto — {{PROJETO}}
> Retrato vivo e em linguagem acessível. Atualizado ao final de cada task.
> Última atualização: <AAAA-MM-DD> · na task <id>

## Em uma frase
<o que o projeto é e para quem, sem jargão>

## O que dá para fazer com ele (as capacidades principais)
<lista curta do que o projeto entrega hoje, em linguagem de usuário>

## Como as peças se encaixam
<as partes principais e como conversam — pode ser uma lista ou um diagrama simples;
 explique cada peça em uma linha, sem termo técnico solto>

## Onde as coisas ficam
<mapa de "para achar X, olhe em Y": pastas/áreas principais e o que vive em cada uma>

## Regras que não se quebram
<as poucas regras inegociáveis do projeto — aponte para os fatos canônicos do _INDICE>

## Para se aprofundar
<ponteiros: detalhes técnicos → docs do squad-docs; histórico → HISTORICO.md; o que vale → _INDICE.md>
```

Diagrama é bem-vindo se ajudar a leitura (um `mermaid` simples de blocos), desde que continue
legível para quem não é técnico. Sem diagrama grande e cheio de detalhe — isso é doc técnico.

## Quem escreve (dono único)

- `squad-docs`, quando instalado (é o dono deste artefato, como de toda documentação derivada).
- **Sem `squad-docs`**: o **ORQUESTRADOR** faz, no fechamento — é leve o suficiente. O papel que
  entregou a task NÃO edita o mapa direto (dono único evita conflito); ele sinaliza ao orquestrador
  o que mudou no retrato.

## Regras invioláveis (herdadas da esteira)

1. **Honestidade.** O mapa descreve o que EXISTE de verdade, verificado na entrega — nunca o que se
   planejou e não saiu. Sem funcionalidade fantasma ("UI Potemkin" também vale para documentação).
2. **Acessível de verdade.** Escrito para leigo entender; termo técnico só com tradução ao lado.
3. **Limpo por construção.** Substitui em vez de empilhar; remove o que morreu; não duplica o que já
   está no `_INDICE.md`, no `HISTORICO.md`, no código ou nos docs técnicos — aponta para eles.
4. **Dúvida vira pergunta, não improviso.** Incerto se atualiza? Pergunta ao usuário com recomendação.
5. **Sem segredos.** Token/senha/URL interna sensível jamais no mapa.
6. **Idioma {{IDIOMA}}** em todo o mapa, independentemente do idioma destas instruções.
