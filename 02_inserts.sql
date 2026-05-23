-- ============================================================
--  N688 AMBIENTE DE DADOS — UNIFOR
--  Dados de exemplo — Clínica Médica
-- ============================================================

SET search_path TO clinica;

INSERT INTO especialidade (nome, descricao, area_medica) VALUES
('Cardiologia',  'Doencas do coracao e sistema cardiovascular', 'Clinica Medica'),
('Pediatria',    'Saude de criancas e adolescentes',            'Clinica Medica'),
('Ortopedia',    'Ossos, articulacoes e sistema muscular',       'Cirurgia'),
('Dermatologia', 'Doencas da pele, cabelo e unhas',              'Clinica Medica'),
('Neurologia',   'Sistema nervoso central e periferico',         'Clinica Medica');

INSERT INTO convenio (nome, cnpj, telefone, email, tipo_plano, abrangencia) VALUES
('Unimed Fortaleza', '00000000000191', '(85) 3299-0000', 'contato@unimed.com.br',     'Empresarial', 'Nacional'),
('Bradesco Saude',   '00000000000272', '(11) 3448-0000', 'contato@bradescosaude.com', 'Individual',  'Nacional'),
('Hapvida',          '00000000000353', '(85) 3199-0000', 'atendimento@hapvida.com',   'Familiar',    'Regional'),
('Amil',             '00000000000434', '(11) 4004-0000', 'atendimento@amil.com.br',   'Empresarial', 'Nacional');

INSERT INTO sala (numero, andar, tipo, capacidade, equipamentos, disponivel) VALUES
('101', 1, 'Consultorio', 1, 'Estetoscopio, esfigmomanometro, balanca',     TRUE),
('102', 1, 'Consultorio', 1, 'Estetoscopio, otoscopio, balanca pediatrica', TRUE),
('201', 2, 'Consultorio', 1, 'Raio-X portatil, maca ortopedica',            TRUE),
('202', 2, 'Consultorio', 1, 'Dermatoscopio, fototerapia LED',              TRUE),
('301', 3, 'Emergencia',  3, 'Monitor cardiaco, desfibrilador, oximetro',   TRUE);

INSERT INTO medicamento (nome_comercial, principio_ativo, fabricante, apresentacao, concentracao, tipo_receita) VALUES
('Losartana',   'Losartana Potassica',  'EMS',      'Comprimido', '50mg',       'comum'),
('Amoxicilina', 'Amoxicilina',          'Medley',   'Capsula',    '500mg',      'antimicrobiano'),
('Dipirona',    'Metamizol Sodico',     'Sanofi',   'Comprimido', '500mg',      'comum'),
('Ritalina',    'Metilfenidato',        'Novartis', 'Comprimido', '10mg',       'controlada'),
('Dorflex',     'Orfenadrina+Dipirona', 'Sanofi',   'Comprimido', '35mg+300mg', 'comum'),
('Atenolol',    'Atenolol',             'EMS',      'Comprimido', '25mg',       'comum'),
('Fluoxetina',  'Fluoxetina',           'Medley',   'Capsula',    '20mg',       'controlada');

INSERT INTO funcionario (nome, cpf, cargo, telefone, email, data_admissao, salario) VALUES
('Dr. Carlos Mendes',   '11111111111', 'Medico',        '(85) 99111-0001', 'carlos@clinica.com',   '2019-03-10', 18000.00),
('Dra. Fernanda Lima',  '22222222222', 'Medico',        '(85) 99111-0002', 'fernanda@clinica.com', '2020-07-15', 16000.00),
('Dr. Roberto Alves',   '33333333333', 'Medico',        '(85) 99111-0003', 'roberto@clinica.com',  '2018-01-20', 17500.00),
('Dra. Patricia Costa', '44444444444', 'Medico',        '(85) 99111-0004', 'patricia@clinica.com', '2021-05-03', 15000.00),
('Ana Paula Souza',     '55555555555', 'Recepcionista', '(85) 99111-0005', 'ana@clinica.com',      '2022-02-01',  2800.00),
('Joao Pedro Barros',   '66666666666', 'Recepcionista', '(85) 99111-0006', 'joao@clinica.com',     '2023-08-10',  2800.00),
('Marcia Oliveira',     '77777777777', 'Administrador', '(85) 99111-0007', 'marcia@clinica.com',   '2017-06-15',  5500.00);

-- medico usa o mesmo id gerado em funcionario
INSERT INTO medico (id_medico, crm, id_especialidade) VALUES
(1, 'CRM-CE 12345', 1),
(2, 'CRM-CE 23456', 2),
(3, 'CRM-CE 34567', 3),
(4, 'CRM-CE 45678', 4);

INSERT INTO paciente (nome, cpf, data_nascimento, sexo, telefone, email,
                      logradouro, cidade, estado, cep, tipo_sanguineo, alergias) VALUES
('Joao Silva',     '10000000001', '1985-04-12', 'M', '(85) 98800-0001', 'joao@email.com',   'Rua das Flores, 10', 'Fortaleza', 'CE', '60000001', 'O+',  NULL),
('Maria Souza',    '10000000002', '1992-08-23', 'F', '(85) 98800-0002', 'maria@email.com',  'Av. Beira Mar, 200', 'Fortaleza', 'CE', '60000002', 'A+',  'Dipirona'),
('Pedro Santos',   '10000000003', '1978-11-05', 'M', '(85) 98800-0003', 'pedro@email.com',  'Rua do Sol, 55',     'Fortaleza', 'CE', '60000003', 'B-',  NULL),
('Lucia Ferreira', '10000000004', '2010-02-17', 'F', '(85) 98800-0004', 'lucia@email.com',  'Rua Verde, 88',      'Caucaia',   'CE', '62000004', 'AB+', NULL),
('Carlos Neto',    '10000000005', '1965-07-30', 'M', '(85) 98800-0005', 'carlos@email.com', 'Av. Abolicao, 300',  'Fortaleza', 'CE', '60000005', 'A-',  'Penicilina'),
('Ana Beatriz',    '10000000006', '1999-12-01', 'F', '(85) 98800-0006', 'ana@email.com',    'Rua Tiburcio, 14',   'Fortaleza', 'CE', '60000006', 'O-',  NULL),
('Rafael Gomes',   '10000000007', '1988-03-19', 'M', '(85) 98800-0007', 'rafael@email.com', 'Rua Pereira, 7',     'Maracanaú', 'CE', '61000007', 'B+',  NULL);

INSERT INTO paciente_convenio (id_paciente, id_convenio, numero_carteira,
                                data_inicio, data_validade, tipo_cobertura) VALUES
(1, 1, 'UNI-001-2022', '2022-01-01', '2026-12-31', 'Completa'),
(1, 2, 'BRA-001-2023', '2023-06-01', '2027-05-31', 'Basica'),
(2, 1, 'UNI-002-2021', '2021-03-01', '2025-02-28', 'Completa'),
(3, 3, 'HAP-003-2020', '2020-09-01', '2024-08-31', 'Familiar'),
(4, 3, 'HAP-004-2023', '2023-01-01', '2027-12-31', 'Familiar'),
(5, 4, 'AMI-005-2019', '2019-05-01', '2025-04-30', 'Empresarial'),
(6, 2, 'BRA-006-2024', '2024-02-01', '2028-01-31', 'Individual'),
(7, 1, 'UNI-007-2022', '2022-07-01', '2026-06-30', 'Completa');

INSERT INTO consulta (data_hora, status, tipo, sintomas, diagnostico,
                      valor, id_paciente, id_medico, id_sala, id_convenio) VALUES
('2024-01-10 08:00', 'realizada', 'consulta', 'Dor no peito, falta de ar',  'Hipertensao arterial',   250.00, 1, 1, 1, 1),
('2024-01-15 09:30', 'realizada', 'consulta', 'Febre, tosse, coriza',       'Gripe comum',            180.00, 4, 2, 2, 3),
('2024-02-03 10:00', 'realizada', 'consulta', 'Dor no joelho ao caminhar',  'Tendinite patelar',      220.00, 3, 3, 3, 3),
('2024-02-20 14:00', 'realizada', 'consulta', 'Manchas vermelhas na pele',  'Dermatite atopica',      200.00, 2, 4, 4, 1),
('2024-03-05 08:30', 'realizada', 'retorno',  'Acompanhamento hipertensao', 'Hipertensao controlada', 150.00, 1, 1, 1, 1),
('2024-03-12 11:00', 'realizada', 'consulta', 'Dor de cabeca frequente',    'Enxaqueca',              250.00, 5, 1, 5, 4),
('2024-04-01 09:00', 'realizada', 'consulta', 'Erupcao cutanea, coceira',   'Urticaria alergica',     200.00, 6, 4, 4, 2),
('2024-04-18 15:00', 'realizada', 'consulta', 'Dor nas costas, limitacao',  'Lombalgia cronica',      220.00, 7, 3, 3, 1),
('2024-05-07 08:00', 'cancelada', 'consulta', NULL,                         NULL,                     250.00, 2, 1, 1, 1),
('2024-05-20 10:30', 'realizada', 'consulta', 'Cansaco, palpitacoes',       'Arritmia sinusal',       280.00, 5, 1, 5, 4),
('2024-06-03 09:00', 'agendada',  'consulta', NULL,                         NULL,                     200.00, 3, 4, 4, 3),
('2024-06-10 14:30', 'faltou',    'retorno',  NULL,                         NULL,                     180.00, 4, 2, 2, 3),
('2024-06-15 11:00', 'realizada', 'consulta', 'Dor abdominal leve',         'Gastrite',               300.00, 6, 1, 1, NULL);

INSERT INTO prescricao (id_consulta, id_medicamento, dose, frequencia,
                        duracao_dias, via_administracao) VALUES
(1,  1, '50mg',  '1x ao dia',     30, 'oral'),
(1,  6, '25mg',  '1x ao dia',     30, 'oral'),
(2,  3, '500mg', 'a cada 6h',      5, 'oral'),
(2,  2, '500mg', 'a cada 8h',      7, 'oral'),
(3,  5, '1cp',   'a cada 8h',     10, 'oral'),
(4,  3, '500mg', 'se necessario',  7, 'oral'),
(5,  1, '50mg',  '1x ao dia',     60, 'oral'),
(5,  6, '25mg',  '1x ao dia',     60, 'oral'),
(6,  3, '500mg', 'a cada 6h',     10, 'oral'),
(7,  3, '500mg', 'se necessario',  5, 'oral'),
(8,  5, '1cp',   'a cada 8h',     15, 'oral'),
(10, 6, '25mg',  '1x ao dia',     30, 'oral'),
(10, 7, '20mg',  '1x ao dia',     60, 'oral'),
(13, 3, '500mg', 'a cada 8h',      7, 'oral');
