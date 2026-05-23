-- ============================================================
--  N688 AMBIENTE DE DADOS — UNIFOR
--  5 Consultas SQL — Clinica Medica
-- ============================================================

SET search_path TO clinica;

-- ============================================================
-- CONSULTA 1 — INNER JOIN
-- O que faz: lista todas as consultas realizadas trazendo o
-- nome do paciente, do medico e a especialidade.
-- O INNER JOIN garante que so aparecem registros com
-- correspondencia em todas as tabelas envolvidas.
-- Resultado esperado: 10 linhas, uma por consulta realizada,
-- com diagnostico preenchido e ordenadas por data.
-- ============================================================
SELECT
    c.id_consulta,
    p.nome        AS paciente,
    f.nome        AS medico,
    e.nome        AS especialidade,
    c.data_hora,
    c.diagnostico
FROM consulta c
INNER JOIN paciente      p ON p.id_paciente      = c.id_paciente
INNER JOIN medico        m ON m.id_medico         = c.id_medico
INNER JOIN funcionario   f ON f.id_funcionario    = m.id_medico
INNER JOIN especialidade e ON e.id_especialidade  = m.id_especialidade
WHERE c.status = 'realizada'
ORDER BY c.data_hora;


-- ============================================================
-- CONSULTA 2 — GROUP BY + COUNT + AVG + SUM
-- O que faz: gera um ranking de medicos por faturamento total,
-- mostrando quantas consultas cada um realizou e o valor medio
-- por atendimento. O LEFT JOIN garante que medicos sem
-- consultas realizadas tambem aparecem (com zeros).
-- Resultado esperado: 4 linhas, Dr. Carlos no topo
-- com R$ 1.230,00 em 5 consultas.
-- ============================================================
SELECT
    f.nome                     AS medico,
    e.nome                     AS especialidade,
    COUNT(c.id_consulta)       AS total_consultas,
    ROUND(AVG(c.valor), 2)     AS ticket_medio,
    SUM(c.valor)               AS faturamento_total
FROM medico        m
INNER JOIN funcionario   f ON f.id_funcionario   = m.id_medico
INNER JOIN especialidade e ON e.id_especialidade = m.id_especialidade
LEFT  JOIN consulta      c ON c.id_medico        = m.id_medico
                          AND c.status = 'realizada'
GROUP BY f.nome, e.nome
ORDER BY faturamento_total DESC NULLS LAST;


-- ============================================================
-- CONSULTA 3 — LEFT JOIN
-- O que faz: lista todos os pacientes e seus convenios.
-- Com LEFT JOIN, pacientes que nao possuem nenhum convenio
-- cadastrado tambem aparecem no resultado, com NULL no campo
-- de convenio — util para identificar pacientes sem plano.
-- Resultado esperado: 8 linhas. Joao aparece 2 vezes
-- por possuir dois planos (Unimed e Bradesco).
-- ============================================================
SELECT
    p.nome            AS paciente,
    p.cidade,
    cv.nome           AS convenio,
    pc.tipo_cobertura,
    pc.data_validade
FROM paciente              p
LEFT JOIN paciente_convenio pc ON pc.id_paciente = p.id_paciente
LEFT JOIN convenio          cv ON cv.id_convenio = pc.id_convenio
ORDER BY p.nome, cv.nome;


-- ============================================================
-- CONSULTA 4 — RIGHT JOIN
-- O que faz: parte dos convenios e mostra todas as consultas
-- vinculadas a cada plano. Convenios sem nenhuma consulta
-- associada tambem aparecem (com NULL) — util para identificar
-- planos inativos. A consulta particular (sem convenio)
-- nao aparece aqui, pois o ponto de partida e a tabela convenio.
-- Resultado esperado: 12 linhas. Amil, Bradesco, Hapvida
-- e Unimed com suas respectivas consultas.
-- ============================================================
SELECT
    cv.nome       AS convenio,
    cv.tipo_plano,
    c.id_consulta,
    p.nome        AS paciente,
    c.data_hora,
    c.valor
FROM consulta  c
RIGHT JOIN convenio cv ON cv.id_convenio = c.id_convenio
LEFT  JOIN paciente  p ON  p.id_paciente = c.id_paciente
ORDER BY cv.nome, c.data_hora;


-- ============================================================
-- CONSULTA 5 — JOIN + GROUP BY + Subquery
-- O que faz: ranking dos medicamentos mais prescritos,
-- filtrando apenas os que foram receitados mais de uma vez.
-- A subquery com HAVING elimina medicamentos prescritos
-- uma unica vez. O COUNT(DISTINCT) mostra quantos pacientes
-- diferentes receberam cada medicamento.
-- Resultado esperado: 4 medicamentos. Dipirona no topo
-- com 5 prescricoes para 4 pacientes distintos.
-- ============================================================
SELECT
    med.nome_comercial              AS medicamento,
    med.principio_ativo,
    COUNT(pr.id_prescricao)         AS vezes_prescrito,
    COUNT(DISTINCT c.id_paciente)   AS pacientes_distintos
FROM prescricao   pr
INNER JOIN medicamento med ON med.id_medicamento = pr.id_medicamento
INNER JOIN consulta    c   ON c.id_consulta      = pr.id_consulta
WHERE med.id_medicamento IN (
    SELECT id_medicamento
    FROM prescricao
    GROUP BY id_medicamento
    HAVING COUNT(*) > 1
)
GROUP BY med.nome_comercial, med.principio_ativo
ORDER BY vezes_prescrito DESC;
