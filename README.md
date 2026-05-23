# N688 Ambiente de Dados — Clínica Médica

Projeto final da disciplina **N688 Ambiente de Dados** — UNIFOR EAD.

**Domínio escolhido:** Sistema de Clínica Médica  
**Database:** `faculdade` | **Schema:** `clinica`  
**SGBD:** PostgreSQL 17  

---

## Estrutura do repositório

| Arquivo | Conteúdo |
|---|---|
| `01_ddl.sql` | Criação do schema e das 10 tabelas (DDL) |
| `02_inserts.sql` | Dados de exemplo para todas as tabelas |
| `03_queries.sql` | 5 consultas SQL com comentários explicativos |
| `04_der.md` | DER em Mermaid (diagrama entidade-relacionamento) |
| `05_modelo_logico.md` | Modelo lógico relacional + normalização (1FN/2FN/3FN) |
| `06_analise.md` | Análise crítica do modelo (Parte 6 da atividade) |

---

## Como executar

### Pré-requisito
PostgreSQL rodando localmente (ou via Docker).

### Passo a passo

```bash
# 1. Criar o database
psql -U postgres -c "CREATE DATABASE faculdade;"

# 2. Criar as tabelas
psql -U postgres -d faculdade -f 01_ddl.sql

# 3. Inserir os dados de exemplo
psql -U postgres -d faculdade -f 02_inserts.sql

# 4. Executar as consultas
psql -U postgres -d faculdade -f 03_queries.sql
```

---

## Modelo de dados

### Entidades (10 tabelas)

| Tabela | Papel |
|---|---|
| `especialidade` | Especialidades médicas (Cardiologia, Pediatria…) |
| `funcionario` | Base de todos os funcionários da clínica |
| `medico` | Especialização de funcionário — herança pelo mesmo ID |
| `paciente` | Dados cadastrais dos pacientes |
| `convenio` | Planos de saúde aceitos pela clínica |
| `sala` | Salas de atendimento e seus equipamentos |
| `medicamento` | Catálogo de medicamentos |
| `consulta` | Hub central — liga paciente, médico, sala e convênio |
| `prescricao` | Entidade associativa N:N entre consulta e medicamento |
| `paciente_convenio` | Entidade associativa N:N entre paciente e convênio |

### Relacionamentos

```
especialidade ──(1:N)──► medico ◄──(1:1)── funcionario
                             │
                         (1:N)▼
                           consulta ◄──(1:N)── paciente
                           │    │
                       (N:N)▼   └──(1:N)── sala
                       prescricao           │
                           │            convenio
                       (N:N)▼           (N:N via paciente_convenio)
                       medicamento
```

---

## Consultas implementadas

| # | Tipo | O que faz |
|---|---|---|
| 1 | INNER JOIN | Consultas realizadas com paciente, médico e especialidade |
| 2 | GROUP BY + agregação | Ranking de médicos por faturamento total |
| 3 | LEFT JOIN | Pacientes e seus convênios (inclusive sem plano) |
| 4 | RIGHT JOIN | Convênios e suas consultas (inclusive planos inativos) |
| 5 | JOIN + GROUP BY + Subquery | Medicamentos mais prescritos |

---

## Visualizar o DER

O arquivo `04_der.md` contém o diagrama em sintaxe **Mermaid**.  
Para visualizar:
- Cole o conteúdo do bloco mermaid em [mermaid.live](https://mermaid.live)
- Ou abra o arquivo no VS Code com a extensão **Markdown Preview Mermaid Support**
- Ou importe no [draw.io](https://draw.io) via **Extras → Edit Diagram**
