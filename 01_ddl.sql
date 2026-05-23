-- ============================================================
--  N688 AMBIENTE DE DADOS — UNIFOR
--  Projeto: Sistema de Clínica Médica
--  Database: faculdade | Schema: clinica
-- ============================================================

CREATE SCHEMA IF NOT EXISTS clinica;

SET search_path TO clinica;

-- 1. ESPECIALIDADE
CREATE TABLE especialidade (
    id_especialidade SERIAL       PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    descricao        TEXT,
    area_medica      VARCHAR(80),
    created_at       TIMESTAMP    DEFAULT NOW()
);

-- 2. CONVENIO
CREATE TABLE convenio (
    id_convenio SERIAL       PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    cnpj        CHAR(14)     UNIQUE NOT NULL,
    telefone    VARCHAR(20),
    email       VARCHAR(150),
    tipo_plano  VARCHAR(50),
    abrangencia VARCHAR(50),
    created_at  TIMESTAMP    DEFAULT NOW()
);

-- 3. SALA
CREATE TABLE sala (
    id_sala      SERIAL      PRIMARY KEY,
    numero       VARCHAR(10) NOT NULL,
    andar        SMALLINT,
    tipo         VARCHAR(50) NOT NULL,
    capacidade   SMALLINT    DEFAULT 1,
    equipamentos TEXT,
    disponivel   BOOLEAN     DEFAULT TRUE
);

-- 4. MEDICAMENTO
CREATE TABLE medicamento (
    id_medicamento  SERIAL       PRIMARY KEY,
    nome_comercial  VARCHAR(150) NOT NULL,
    principio_ativo VARCHAR(150) NOT NULL,
    fabricante      VARCHAR(150),
    apresentacao    VARCHAR(100),
    concentracao    VARCHAR(50),
    tipo_receita    VARCHAR(50),
    created_at      TIMESTAMP    DEFAULT NOW()
);

-- 5. FUNCIONARIO — entidade base (recepcionistas, admins e médicos)
CREATE TABLE funcionario (
    id_funcionario SERIAL       PRIMARY KEY,
    nome           VARCHAR(150) NOT NULL,
    cpf            CHAR(11)     UNIQUE NOT NULL,
    cargo          VARCHAR(80)  NOT NULL,
    telefone       VARCHAR(20),
    email          VARCHAR(150),
    data_admissao  DATE         NOT NULL,
    salario        NUMERIC(10,2),
    created_at     TIMESTAMP    DEFAULT NOW()
);

-- 6. PACIENTE
CREATE TABLE paciente (
    id_paciente     SERIAL       PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    cpf             CHAR(11)     UNIQUE NOT NULL,
    data_nascimento DATE         NOT NULL,
    sexo            CHAR(1)      CHECK (sexo IN ('M','F','O')),
    telefone        VARCHAR(20),
    email           VARCHAR(150),
    logradouro      VARCHAR(200),
    cidade          VARCHAR(100),
    estado          CHAR(2),
    cep             CHAR(8),
    tipo_sanguineo  VARCHAR(5),
    alergias        TEXT,
    created_at      TIMESTAMP    DEFAULT NOW()
);

-- 7. MEDICO — especialização de FUNCIONARIO (herança: mesmo ID)
--    Para criar um médico: INSERT em funcionario, depois INSERT em medico com o id gerado
CREATE TABLE medico (
    id_medico        INT         PRIMARY KEY,
    crm              VARCHAR(20) UNIQUE NOT NULL,
    id_especialidade INT         NOT NULL,
    CONSTRAINT fk_medico_funcionario
        FOREIGN KEY (id_medico)
        REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_medico_especialidade
        FOREIGN KEY (id_especialidade)
        REFERENCES especialidade(id_especialidade)
);

-- 8. CONSULTA — hub central do sistema
--    id_convenio NULL = consulta particular (sem plano)
CREATE TABLE consulta (
    id_consulta SERIAL      PRIMARY KEY,
    data_hora   TIMESTAMP   NOT NULL,
    status      VARCHAR(30) NOT NULL DEFAULT 'agendada'
                CHECK (status IN ('agendada','realizada','cancelada','faltou')),
    tipo        VARCHAR(50) NOT NULL DEFAULT 'consulta',
    observacao  TEXT,
    sintomas    TEXT,
    diagnostico TEXT,
    valor       NUMERIC(8,2),
    id_paciente INT         NOT NULL,
    id_medico   INT         NOT NULL,
    id_sala     INT,
    id_convenio INT,
    created_at  TIMESTAMP   DEFAULT NOW(),
    CONSTRAINT fk_consulta_paciente
        FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_consulta_medico
        FOREIGN KEY (id_medico)   REFERENCES medico(id_medico),
    CONSTRAINT fk_consulta_sala
        FOREIGN KEY (id_sala)     REFERENCES sala(id_sala),
    CONSTRAINT fk_consulta_convenio
        FOREIGN KEY (id_convenio) REFERENCES convenio(id_convenio)
);

-- 9. PRESCRICAO — entidade associativa N:N (CONSULTA <-> MEDICAMENTO)
CREATE TABLE prescricao (
    id_prescricao     SERIAL       PRIMARY KEY,
    id_consulta       INT          NOT NULL,
    id_medicamento    INT          NOT NULL,
    dose              VARCHAR(100) NOT NULL,
    frequencia        VARCHAR(100) NOT NULL,
    duracao_dias      SMALLINT,
    via_administracao VARCHAR(50),
    observacao        TEXT,
    CONSTRAINT fk_prescricao_consulta
        FOREIGN KEY (id_consulta)    REFERENCES consulta(id_consulta),
    CONSTRAINT fk_prescricao_medicamento
        FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento),
    CONSTRAINT uq_prescricao UNIQUE (id_consulta, id_medicamento)
);

-- 10. PACIENTE_CONVENIO — entidade associativa N:N (PACIENTE <-> CONVENIO)
CREATE TABLE paciente_convenio (
    id_paciente     INT         NOT NULL,
    id_convenio     INT         NOT NULL,
    numero_carteira VARCHAR(50) NOT NULL,
    data_inicio     DATE        NOT NULL,
    data_validade   DATE,
    tipo_cobertura  VARCHAR(80),
    PRIMARY KEY (id_paciente, id_convenio),
    CONSTRAINT fk_pc_paciente
        FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_pc_convenio
        FOREIGN KEY (id_convenio) REFERENCES convenio(id_convenio)
);
