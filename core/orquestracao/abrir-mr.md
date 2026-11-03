# /abrir-mr — abrir o MR de uma entrega já revisada (core, vale para QUALQUER CLI/IDE de IA)

> 🌐 **Idioma de interação: o idioma do projeto instalado.** Escreva a descrição do MR e o comentário
> do card nesse idioma.

## Quando usar

Depois que uma task passou pelo **REVIEW interno do arquiteto** (esteira, item 4) e foi **APROVADA**
— branch pushada, diff dentro do orçamento, critérios de aceite provados. `/abrir-mr` é o passo que
materializa isso como MR real no GitLab + comentário no card do board. Não é um passo de código: não
implementa, não corrige, não decide se a task está pronta — isso já aconteceu antes.

Também serve para abrir o MR de uma correção que já foi re-revisada (ciclo de `/review-mr`) quando,
por algum motivo, o MR da branch ainda não existia.

**Nunca abre MR de task sem veredito de aprovação registrado na sessão.** Se não há esse veredito
(ex.: o usuário pede `/abrir-mr` "no escuro"), pare e pergunte — não infira aprovação.

## Entrada

`/abrir-mr <card(s)>` — um ou mais números de card **da janela de contexto da sessão atual**. Nunca
varra branches `squad/*` de sessões passadas só porque existem soltas no repo — só os cards que esta
conversa acabou de trabalhar.

## Pré-requisitos (checar antes de qualquer chamada de API)

1. **Branch resolvida e pushada** — vem do handoff da sessão (SPRINT.md/contexto), nunca inventada.
2. **Review interno aprovado** — se o veredito foi REPROVADO ou está pendente, não abrir; reportar.
3. **MR ainda não existe para essa branch** — checar antes (idempotência). Se já existir, **não
   duplicar**: reportar o IID existente e parar (isso é trabalho do `/review-mr`, não deste comando).
4. **Branch atualizada com a `develop`** (fetch + ahead/behind). Desatualizada não impede abrir, mas
   entra como aviso no relatório.
5. **Gate de orçamento de diff** (`validar-diff.ps1` do projeto) — estourou, não abre; reporta e
   devolve ao arquiteto para fatiar.

## Agrupamento de cards em um MR

- **1 card = 1 MR por padrão.**
- Agrupar vários cards num MR só quando a implementação **já está** numa branch/entrega única (decisão
  tomada no SPEC/execução, não aqui). Este comando nunca decide agrupar por conta própria.
- Entrega que cruza **repositórios** (branches irmãs): um MR **por repositório**, cada um citando o(s)
  MR(s) irmão(s) pelo nome do repo + IID e a ordem de merge entre eles.

## Conteúdo da descrição

Segue `squad/specs/MOLDE-MR.md` quando o projeto tiver esse arquivo (leia antes de escrever); na
ausência dele, usa a forma padrão: linha de abertura (card · o que fecha) → `Contexto/Problema` →
`Causa` → `Como resolvi` → `Fora de escopo` (declarado, nunca escondido) → `Evidência/Verificação`
(saída real de comando colada, nunca "os testes passam") → `Dependências e ordem de merge`.

A prosa é **humanizada e reescrita** a partir do SDD/relatório do dev (`core/best-practices/humanizador.md`)
— nunca cola trecho do SPEC. Regras que valem sempre:

- **Só artefato público.** Nada de `SPEC-*.md`, `CHECKLIST-*.md`, `AD-SQ-*`, "review do arquiteto",
  caminho local (`D:\...`), nome de container ou arquivo que só existe na máquina do líder. Cite o
  número do card, o arquivo do próprio repo, a migration, o pipeline, o MR irmão, a saída colada.
  Varra também o **vocabulário** do processo (`review`, `P1`/`P2`, `apontamento`, `esteira`,
  `squad-dev`), não só a sigla.
- **Declara dependência de terceiro** e **o que ficou fora do escopo** — quem revisa no GitLab não tem
  o board nem o SPEC do squad; sem isso, lê como entrega incompleta o que é entrega bloqueada.
- **Ambiguidade resolvida pelo squad** entra exposta, com o porquê em uma frase — é ali que o revisor
  humano contesta, se discordar.
- **Restrição de sequenciamento de merge** (ex.: "não mergear antes do card X"), quando existir, entra
  em **destaque** — no topo da descrição e de novo na seção de dependências.
- **Nenhum fato a mais na reescrita.** Perder um claim ao humanizar é erro igual a inventar um.

## Publicação

1. Abre o MR pela API do GitLab, **alvo sempre a branch de integração do projeto** (ex.: `develop`) —
   nunca `main`/`prod` sem instrução explícita do humano. Autor: a credencial do líder (não uma conta
   de robô). Reviewer: atribui o arquiteto humano do projeto automaticamente.
2. Varredura anti-vazamento no **texto final**, lido de volta da API (não no rascunho local) — se
   achar algo da lista acima, corrige e relê antes de seguir.
3. A **mesma descrição** (reescrita para o formato de comentário do board) é publicada como comentário
   no(s) card(s) correspondente(s) — aba **Comentários**, nunca a Description do card. Se a task não
   tiver card associado no board, fica só no MR.
4. Registra a abertura no handoff do board/sprint do projeto (ex.: `SPRINT.md`) e, se o projeto usa
   telemetria, a linha correspondente.

## Regra mestre (inviolável)

**Esta skill só cria o MR e o comentário — nunca mergeia, nunca aprova, nunca configura merge
automático, nunca marca o card como concluído.** Merge é sempre decisão manual do humano.

## Relato final

Link(s)/IID(s) do(s) MR(s) aberto(s), card(s) atualizado(s) com o comentário, e qualquer aviso retido
para o humano (branch desatualizada, dependência de terceiro, restrição de sequenciamento).
