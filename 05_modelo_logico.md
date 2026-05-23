# Modelo Lógico Relacional
## Sistema de Clínica Médica

```
ESPECIALIDADE (
    id_especialidade  INT          PK,
    nome              VARCHAR(100) NOT NULL,
    descricao         TEXT,
    area_medica       VARCHAR(80),
    created_at        TIMESTAMP
)

FUNCIONARIO (
    id_funcionario  INT          PK,
    nome            VARCHAR(150) NOT NULL,
    cpf             CHAR(11)     UK NOT NULL,
    cargo           VARCHAR(80)  NOT NULL,
    telefone        VARCHAR(20),
    email           VARCHAR(150),
    data_admissao   DATE         NOT NULL,
    salario         NUMERIC(10,2),
    created_at      TIMESTAMP
)

MEDICO (
    id_medico        INT         PK, FK → FUNCIONARIO(id_funcionario),
    crm              VARCHAR(20) UK NOT NULL,
    id_especialidade INT         FK → ESPECIALIDADE(id_especialidade)
)

CONVENIO (
    id_convenio  INT          PK,
    nome         VARCHAR(150) NOT NULL,
    cnpj         CHAR(14)     UK NOT NULL,
    telefone     VARCHAR(20),
    email        VARCHAR(150),
    tipo_plano   VARCHAR(50),
    abrangencia  VARCHAR(50),
    created_at   TIMESTAMP
)

SALA (
    id_sala      INT         PK,
    numero       VARCHAR(10) NOT NULL,
    andar        SMALLINT,
    tipo         VARCHAR(50) NOT NULL,
    capacidade   SMALLINT,
    equipamentos TEXT,
    disponivel   BOOLEAN
)

MEDICAMENTO (
    id_medicamento  INT          PK,
    nome_comercial  VARCHAR(150) NOT NULL,
    principio_ativo VARCHAR(150) NOT NULL,
    fabricante      VARCHAR(150),
    apresentacao    VARCHAR(100),
    concentracao    VARCHAR(50),
    tipo_receita    VARCHAR(50),
    created_at      TIMESTAMP
)

PACIENTE (
    id_paciente     INT          PK,
    nome            VARCHAR(150) NOT NULL,
    cpf             CHAR(11)     UK NOT NULL,
    data_nascimento DATE         NOT NULL,
    sexo            CHAR(1),
    telefone        VARCHAR(20),
    email           VARCHAR(150),
    logradouro      VARCHAR(200),
    cidade          VARCHAR(100),
    estado          CHAR(2),
    cep             CHAR(8),
    tipo_sanguineo  VARCHAR(5),
    alergias        TEXT,
    created_at      TIMESTAMP
)

CONSULTA (
    id_consulta  INT          PK,
    data_hora    TIMESTAMP    NOT NULL,
    status       VARCHAR(30)  NOT NULL,
    tipo         VARCHAR(50)  NOT NULL,
    observacao   TEXT,
    sintomas     TEXT,
    diagnostico  TEXT,
    valor        NUMERIC(8,2),
    id_paciente  INT          FK → PACIENTE(id_paciente),
    id_medico    INT          FK → MEDICO(id_medico),
    id_sala      INT          FK → SALA(id_sala),
    id_convenio  INT          FK → CONVENIO(id_convenio),   -- NULL = particular
    created_at   TIMESTAMP
)

PRESCRICAO (
    id_prescricao     INT          PK,
    id_consulta       INT          FK → CONSULTA(id_consulta),
    id_medicamento    INT          FK → MEDICAMENTO(id_medicamento),
    dose              VARCHAR(100) NOT NULL,
    frequencia        VARCHAR(100) NOT NULL,
    duracao_dias      SMALLINT,
    via_administracao VARCHAR(50),
    observacao        TEXT,
    UNIQUE(id_consulta, id_medicamento)         -- N:N resolvido
)

PACIENTE_CONVENIO (
    id_paciente     INT         PK, FK → PACIENTE(id_paciente),
    id_convenio     INT         PK, FK → CONVENIO(id_convenio),
    numero_carteira VARCHAR(50) NOT NULL,
    data_inicio     DATE        NOT NULL,
    data_validade   DATE,
    tipo_cobertura  VARCHAR(80)                 -- N:N resolvido
)
```

## Normalização aplicada

### 1FN — Primeira Forma Normal
Todos os atributos contêm valores atômicos (um valor por célula). Os telefones não foram agrupados em um único campo — cada entidade tem um campo `telefone` individual. Os convênios do paciente não foram listados num campo só — foram separados na tabela `paciente_convenio`.

### 2FN — Segunda Forma Normal
Não há dependências parciais. Nas tabelas com chave composta (`prescricao` e `paciente_convenio`), todos os atributos não-chave dependem da chave completa. Por exemplo, `dose` e `frequencia` em `prescricao` dependem do par `(id_consulta, id_medicamento)`, não apenas de um deles.

### 3FN — Terceira Forma Normal
Não há dependências transitivas. O nome e salário do médico ficam em `funcionario`, não em `consulta`. A especialidade fica em `especialidade`, não duplicada em `medico` ou `consulta`. O nome do convênio fica em `convenio`, não repetido em `paciente_convenio`.
