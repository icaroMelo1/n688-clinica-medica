# DER — Diagrama Entidade-Relacionamento
## Sistema de Clínica Médica

```mermaid
erDiagram
    ESPECIALIDADE ||--o{ MEDICO : "possui"
    ESPECIALIDADE {
        int id_especialidade PK
        varchar nome
        text descricao
        varchar area_medica
    }

    FUNCIONARIO ||--|| MEDICO : "e um"
    FUNCIONARIO {
        int id_funcionario PK
        varchar nome
        char cpf UK
        varchar cargo
        varchar telefone
        varchar email
        date data_admissao
        numeric salario
    }

    MEDICO {
        int id_medico PK,FK
        varchar crm UK
        int id_especialidade FK
    }

    MEDICO ||--o{ CONSULTA : "realiza"

    PACIENTE ||--o{ CONSULTA : "faz"
    PACIENTE {
        int id_paciente PK
        varchar nome
        char cpf UK
        date data_nascimento
        char sexo
        varchar telefone
        varchar email
        varchar logradouro
        varchar cidade
        varchar tipo_sanguineo
        text alergias
    }

    SALA ||--o{ CONSULTA : "recebe"
    SALA {
        int id_sala PK
        varchar numero
        smallint andar
        varchar tipo
        boolean disponivel
    }

    CONVENIO ||--o{ CONSULTA : "cobre"
    CONVENIO {
        int id_convenio PK
        varchar nome
        char cnpj UK
        varchar tipo_plano
        varchar abrangencia
    }

    CONSULTA ||--|{ PRESCRICAO : "gera"
    CONSULTA {
        int id_consulta PK
        timestamp data_hora
        varchar status
        varchar tipo
        text sintomas
        text diagnostico
        numeric valor
        int id_paciente FK
        int id_medico FK
        int id_sala FK
        int id_convenio FK
    }

    MEDICAMENTO ||--|{ PRESCRICAO : "aparece em"
    MEDICAMENTO {
        int id_medicamento PK
        varchar nome_comercial
        varchar principio_ativo
        varchar fabricante
        varchar apresentacao
        varchar tipo_receita
    }

    PRESCRICAO {
        int id_prescricao PK
        int id_consulta FK
        int id_medicamento FK
        varchar dose
        varchar frequencia
        smallint duracao_dias
        varchar via_administracao
    }

    PACIENTE }o--o{ CONVENIO : "possui"
    PACIENTE_CONVENIO {
        int id_paciente PK,FK
        int id_convenio PK,FK
        varchar numero_carteira
        date data_inicio
        date data_validade
        varchar tipo_cobertura
    }
```

## Relacionamentos

| Entidades | Tipo | Descrição |
|---|---|---|
| ESPECIALIDADE → MEDICO | 1:N | Uma especialidade pode ter vários médicos |
| FUNCIONARIO → MEDICO | 1:1 | Todo médico é um funcionário (herança) |
| PACIENTE → CONSULTA | 1:N | Um paciente pode ter várias consultas |
| MEDICO → CONSULTA | 1:N | Um médico pode realizar várias consultas |
| SALA → CONSULTA | 1:N | Uma sala pode receber várias consultas |
| CONVENIO → CONSULTA | 1:N | Um convênio pode cobrir várias consultas |
| CONSULTA ↔ MEDICAMENTO | N:N | Via entidade associativa PRESCRICAO |
| PACIENTE ↔ CONVENIO | N:N | Via entidade associativa PACIENTE_CONVENIO |
