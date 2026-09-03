# Mapa do Projeto — Frete Rápido (demo)

> Retrato **vivo** e em **linguagem acessível** deste projeto — para qualquer pessoa entender em 5
> minutos, inclusive quem não é da área técnica. É **revisado ao final de cada card/task**.
>
> Última atualização: 2026-09-02 · no /montar-contexto (demo)

## Em uma frase

Uma loja online fictícia, a "Frete Rápido", cujo foco desta demonstração é **calcular o frete na
hora de fechar a compra** (o checkout).

## O que dá para fazer com ele

- Calcular quanto o cliente paga de frete a partir do peso do pedido e do destino.
- Barrar pedidos acima do peso permitido, com uma mensagem clara.

## Como as peças se encaixam

- **Carrinho/checkout**: onde o cliente confirma a compra e pede o cálculo do frete.
- **Cálculo de frete**: a peça que recebe o peso e devolve o valor a cobrar (o coração da demo).
- **Regras de valor**: garantem que todo dinheiro seja tratado com exatidão (nada de centavo errado).

## Onde as coisas ficam

| Para... | Olhe em... |
|---|---|
| entender a task da demo (o que fazer e como provar) | `..\specs\SPEC-DEMO-1.md` |
| ver o que vale quando há dúvida (regras firmes) | `_INDICE.md` (fatos canônicos) |
| saber de onde viemos e o que falta | `HISTORICO.md` |

## Regras que não se quebram

- **Dinheiro é sempre exato**: valores com 2 casas, contas feitas em centavos inteiros (nunca "quase
  certo"). — ver `_INDICE.md`
- **Peso máximo de 30 kg** (inclusive): acima disso, o pedido não passa.

## Para se aprofundar

- O que aconteceu e por quê (histórico): `HISTORICO.md`
- O que vale quando os documentos se contradizem: `_INDICE.md`
