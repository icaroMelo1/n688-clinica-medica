# MER — Modelo Entidade-Relacionamento
## Sistema de Clínica Médica

> Notação: **PK** = chave primária | **FK** = chave estrangeira | **UK** = único

---

## Representação Visual (Mermaid)

```mermaid
classDiagram
    direction TB

    class ESPECIALIDADE {
        +INT id_especialidade PK
        +VARCHAR(100) nome
        +TEXT descricao
        +VARCHAR(80) area_medica
        +TIMESTAMP created_at
    }

    class FUNCIONARIO {
        +INT id_funcionario PK
        +VARCHAR(150) nome
        +CHAR(11) cpf UK
        +VARCHAR(80) cargo
        +VARCHAR(20) telefone
        +VARCHAR(150) email
        +DATE data_admissao
        +NUMERIC(10,2) salario
        +TIMESTAMP created_at
    }

    class MEDICO {
        +INT id_medico PK FK
        +VARCHAR(20) crm UK
        +INT id_especialidade FK
    }

    class PACIENTE {
        +INT id_paciente PK
        +VARCHAR(150) nome
        +CHAR(11) cpf UK
        +DATE data_nascimento
        +CHAR(1) sexo
        +VARCHAR(20) telefone
        +VARCHAR(150) email
        +VARCHAR(200) logradouro
        +VARCHAR(100) cidade
        +CHAR(2) estado
        +CHAR(8) cep
        +VARCHAR(5) tipo_sanguineo
        +TEXT alergias
        +TIMESTAMP created_at
    }

    class CONVENIO {
        +INT id_convenio PK
        +VARCHAR(150) nome
        +CHAR(14) cnpj UK
        +VARCHAR(20) telefone
        +VARCHAR(150) email
        +VARCHAR(50) tipo_plano
        +VARCHAR(50) abrangencia
        +TIMESTAMP created_at
    }

    class SALA {
        +INT id_sala PK
        +VARCHAR(10) numero
        +SMALLINT andar
        +VARCHAR(50) tipo
        +SMALLINT capacidade
        +TEXT equipamentos
        +BOOLEAN disponivel
    }

    class MEDICAMENTO {
        +INT id_medicamento PK
        +VARCHAR(150) nome_comercial
        +VARCHAR(150) principio_ativo
        +VARCHAR(150) fabricante
        +VARCHAR(100) apresentacao
        +VARCHAR(50) concentracao
        +VARCHAR(50) tipo_receita
        +TIMESTAMP created_at
    }

    class CONSULTA {
        +INT id_consulta PK
        +TIMESTAMP data_hora
        +VARCHAR(30) status
        +VARCHAR(50) tipo
        +TEXT observacao
        +TEXT sintomas
        +TEXT diagnostico
        +NUMERIC(8,2) valor
        +INT id_paciente FK
        +INT id_medico FK
        +INT id_sala FK
        +INT id_convenio FK
        +TIMESTAMP created_at
    }

    class PRESCRICAO {
        +INT id_prescricao PK
        +INT id_consulta FK
        +INT id_medicamento FK
        +VARCHAR(100) dose
        +VARCHAR(100) frequencia
        +SMALLINT duracao_dias
        +VARCHAR(50) via_administracao
        +TEXT observacao
    }

    class PACIENTE_CONVENIO {
        +INT id_paciente PK FK
        +INT id_convenio PK FK
        +VARCHAR(50) numero_carteira
        +DATE data_inicio
        +DATE data_validade
        +VARCHAR(80) tipo_cobertura
    }

    ESPECIALIDADE "1" --> "0..*" MEDICO : possui
    FUNCIONARIO "1" --> "1" MEDICO : e um
    MEDICO "1" --> "0..*" CONSULTA : realiza
    PACIENTE "1" --> "0..*" CONSULTA : faz
    SALA "1" --> "0..*" CONSULTA : recebe
    CONVENIO "1" --> "0..*" CONSULTA : cobre
    CONSULTA "1" --> "1..*" PRESCRICAO : gera
    MEDICAMENTO "1" --> "1..*" PRESCRICAO : aparece em
    PACIENTE "1" --> "0..*" PACIENTE_CONVENIO : possui
    CONVENIO "1" --> "0..*" PACIENTE_CONVENIO : cobre
```

---

## Notação Relacional Formal

```
ESPECIALIDADE (
    <u>id_especialidade</u>,
    nome,
    descricao,
    area_medica,
    created_at
)

FUNCIONARIO (
    <u>id_funcionario</u>,
    nome,
    cpf*,
    cargo,
    telefone,
    email,
    data_admissao,
    salario,
    created_at
)

MEDICO (
    <u>id_medico</u> ───► FUNCIONARIO(id_funcionario),
    crm*,
    id_especialidade ───► ESPECIALIDADE(id_especialidade)
)

CONVENIO (
    <u>id_convenio</u>,
    nome,
    cnpj*,
    telefone,
    email,
    tipo_plano,
    abrangencia,
    created_at
)

SALA (
    <u>id_sala</u>,
    numero,
    andar,
    tipo,
    capacidade,
    equipamentos,
    disponivel
)

MEDICAMENTO (
    <u>id_medicamento</u>,
    nome_comercial,
    principio_ativo,
    fabricante,
    apresentacao,
    concentracao,
    tipo_receita,
    created_at
)

PACIENTE (
    <u>id_paciente</u>,
    nome,
    cpf*,
    data_nascimento,
    sexo,
    telefone,
    email,
    logradouro,
    cidade,
    estado,
    cep,
    tipo_sanguineo,
    alergias,
    created_at
)

CONSULTA (
    <u>id_consulta</u>,
    data_hora,
    status,
    tipo,
    observacao,
    sintomas,
    diagnostico,
    valor,
    id_paciente  ───► PACIENTE(id_paciente),
    id_medico    ───► MEDICO(id_medico),
    id_sala      ───► SALA(id_sala),
    id_convenio  ───► CONVENIO(id_convenio),
    created_at
)

PRESCRICAO (
    <u>id_prescricao</u>,
    id_consulta    ───► CONSULTA(id_consulta),
    id_medicamento ───► MEDICAMENTO(id_medicamento),
    dose,
    frequencia,
    duracao_dias,
    via_administracao,
    observacao,
    UNIQUE (id_consulta, id_medicamento)
)

PACIENTE_CONVENIO (
    <u>id_paciente</u> ───► PACIENTE(id_paciente),
    <u>id_convenio</u> ───► CONVENIO(id_convenio),
    numero_carteira,
    data_inicio,
    data_validade,
    tipo_cobertura
)
```

> Legenda: `<u>atributo</u>` = chave primária | `atributo*` = atributo único | `───►` = chave estrangeira

---

## Cardinalidades

| Relacionamento | Cardinalidade | Tipo |
|---|---|---|
| ESPECIALIDADE → MEDICO | (1,1) : (0,N) | 1:N |
| FUNCIONARIO → MEDICO | (1,1) : (1,1) | 1:1 (herança) |
| PACIENTE → CONSULTA | (1,1) : (0,N) | 1:N |
| MEDICO → CONSULTA | (1,1) : (0,N) | 1:N |
| SALA → CONSULTA | (1,1) : (0,N) | 1:N |
| CONVENIO → CONSULTA | (0,1) : (0,N) | 1:N (opcional) |
| CONSULTA ↔ MEDICAMENTO | (0,N) : (0,N) | N:N via PRESCRICAO |
| PACIENTE ↔ CONVENIO | (0,N) : (0,N) | N:N via PACIENTE_CONVENIO |
