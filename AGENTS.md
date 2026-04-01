# AGENTS.md

Este projeto existe para documentar o domínio comercial e manter o modelo de dados alinhado com essa narrativa.

## Arquivos principais

- `schema.sql`
- `docs/architecture.html`

## Regra central

- quando a regra de negócio ou a funcionalidade mudar, revisar a documentação
- quando a mudança impactar estrutura, atualizar também o `schema.sql`

Documentação e SQL devem permanecer consistentes.

## Organização do domínio

Hoje a documentação está organizada em cinco camadas:

1. Fundação
2. Oferta
3. Incentivo
4. Conversão
5. Canal e repasse

Essas camadas servem como referência para organizar o raciocínio e a documentação. Se o domínio evoluir, essa divisão também pode evoluir.

## Fluxo de trabalho

Ao receber uma mudança:

1. Entender a intenção de negócio.
2. Identificar a camada afetada.
3. Atualizar `docs/architecture.html`.
4. Atualizar `schema.sql` se houver impacto estrutural.
5. Garantir coerência entre explicação funcional e estrutura persistida.

## Diretrizes

- Não tratar `schema.sql` como artefato isolado.
- Não alterar apenas o HTML quando a estrutura mudou.
- Não alterar apenas o SQL quando a regra de negócio também precisa ser documentada.
- Preferir linguagem clara, formal e orientada a negócio.
- Deixar a parte técnica concentrada em diagramas, exemplos SQL e estrutura.

## Critério de qualidade

Uma mudança está boa quando:

- a regra de negócio ficou explícita
- a camada correta foi atualizada
- o `schema.sql` reflete o que está documentado
- a documentação continua simples, consistente e útil para leitura de negócio
