# Parte 6 — Análise do Projeto
## Sistema de Clínica Médica

---

### 1. O modelo atende bem ao problema proposto?

Sim. As entidades cobrem os fluxos principais da clínica: cadastro de pacientes e funcionários, agendamento de consultas, alocação de salas, prescrição de medicamentos e gestão de convênios. A separação entre `funcionario` e `medico` permite registrar toda a equipe (recepcionistas, administradores e médicos) sem duplicar dados — médicos herdam os atributos comuns de funcionário e acrescentam apenas CRM e especialidade. A tabela `consulta` funciona como hub central, conectando paciente, médico, sala e convênio em um único registro.

---

### 2. Houve necessidade de normalização? Onde?

Sim, em dois pontos principais:

- **1FN:** Os convênios do paciente poderiam ter sido armazenados como uma lista em um único campo de texto. Isso violaria a 1FN. A solução foi criar a entidade associativa `paciente_convenio`, garantindo um valor por célula.
- **3FN:** Nome, CPF e salário do médico poderiam ter sido repetidos na tabela `consulta`. Isso criaria dependência transitiva — o nome dependeria do médico, não da consulta. A solução foi centralizar esses dados em `funcionario` e referenciar via chave estrangeira.

---

### 3. Quais consultas foram mais complexas?

A **Consulta 5** foi a mais complexa, por combinar três elementos distintos: INNER JOIN entre três tabelas, GROUP BY com COUNT e COUNT(DISTINCT), e uma subquery com HAVING para filtrar apenas medicamentos prescritos mais de uma vez. A **Consulta 2** também exigiu atenção por misturar INNER JOIN (obrigatório para especialidade) com LEFT JOIN (necessário para incluir médicos sem consultas realizadas no período), além de três funções agregadas simultâneas.

---

### 4. O uso de JOINs foi adequado?

Sim. Cada tipo de JOIN foi escolhido com propósito claro:

- **INNER JOIN** (Consulta 1): usado quando a correspondência é obrigatória — uma consulta sem paciente ou médico não faz sentido aparecer.
- **LEFT JOIN** (Consulta 3): necessário para listar todos os pacientes independentemente de terem convênio cadastrado, revelando pacientes sem plano.
- **RIGHT JOIN** (Consulta 4): partiu dos convênios para mostrar todos os planos, incluindo os sem uso — útil para auditoria de contratos.
- **Misto LEFT + INNER** (Consulta 2): o INNER JOIN garante que só médicos com especialidade aparecem, enquanto o LEFT JOIN evita omitir médicos que ainda não realizaram consultas.

---

### 5. Que melhorias poderiam ser feitas no modelo?

- **Prontuário:** adicionar uma entidade `prontuario` para registrar o histórico clínico completo do paciente ao longo do tempo, separado da consulta pontual.
- **Exames:** criar uma entidade `exame` vinculada à consulta, permitindo registrar resultados laboratoriais e de imagem.
- **Agendamento:** incluir um campo `id_funcionario_agendou` em `consulta` para rastrear qual recepcionista realizou o agendamento.
- **Auditoria:** adicionar campos `updated_at` e `deleted_at` (soft delete) nas tabelas principais para rastreabilidade de alterações.
- **Histórico de status:** uma tabela `consulta_historico` poderia registrar cada mudança de status (agendada → realizada, por exemplo) com timestamp e responsável.
