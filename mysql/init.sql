CREATE DATABASE IF NOT EXISTS dimdim_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dimdim_db;

CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    data_nascimento DATE
);

CREATE TABLE IF NOT EXISTS contas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    numero_conta VARCHAR(20) NOT NULL UNIQUE,
    tipo ENUM('CORRENTE','POUPANCA','SALARIO') NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0.00,
    data_abertura DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS transacoes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conta_id BIGINT NOT NULL,
    tipo ENUM('DEPOSITO','SAQUE','TRANSFERENCIA','PIX','TED','DOC') NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    descricao VARCHAR(200),
    data_transacao DATETIME NOT NULL,
    FOREIGN KEY (conta_id) REFERENCES contas(id)
);

INSERT INTO clientes (nome, cpf, email, telefone, data_nascimento) VALUES
('Ana Clara Souza',        '123.456.789-00', 'ana.souza@email.com',       '(11) 91234-5678', '1990-03-15'),
('Bruno Ferreira Lima',    '234.567.890-11', 'bruno.lima@email.com',      '(11) 92345-6789', '1985-07-22'),
('Carla Mendes Oliveira',  '345.678.901-22', 'carla.oliveira@email.com',  '(21) 93456-7890', '1992-11-08'),
('Diego Santos Rocha',     '456.789.012-33', 'diego.rocha@email.com',     '(31) 94567-8901', '1988-05-30'),
('Eduarda Costa Pires',    '567.890.123-44', 'eduarda.pires@email.com',   '(41) 95678-9012', '1995-09-14'),
('Felipe Araújo Martins',  '678.901.234-55', 'felipe.martins@email.com',  '(51) 96789-0123', '1983-01-27'),
('Gabriela Nunes Alves',   '789.012.345-66', 'gabriela.alves@email.com',  '(61) 97890-1234', '1997-06-03'),
('Henrique Vieira Castro', '890.123.456-77', 'henrique.castro@email.com', '(71) 98901-2345', '1991-12-19'),
('Isabela Correia Dias',   '901.234.567-88', 'isabela.dias@email.com',    '(81) 99012-3456', '1986-04-11'),
('João Pedro Barbosa',     '012.345.678-99', 'joao.barbosa@email.com',    '(11) 90123-4567', '1993-08-25');

INSERT INTO contas (cliente_id, numero_conta, tipo, saldo, data_abertura) VALUES
(1,  '0001-001234-5', 'CORRENTE',  12500.75,  '2020-01-10'),
(1,  '0001-001234-6', 'POUPANCA',   3200.00,  '2020-01-10'),
(2,  '0001-002345-1', 'CORRENTE',  45890.20,  '2018-06-15'),
(3,  '0001-003456-2', 'SALARIO',    8750.00,  '2021-03-01'),
(4,  '0001-004567-3', 'CORRENTE',   1200.50,  '2019-11-20'),
(5,  '0001-005678-4', 'POUPANCA',  22300.00,  '2022-02-14'),
(6,  '0001-006789-5', 'CORRENTE',  67400.90,  '2017-09-05'),
(7,  '0001-007890-6', 'SALARIO',    5600.00,  '2023-04-18'),
(8,  '0001-008901-7', 'CORRENTE',  15000.00,  '2020-07-30'),
(9,  '0001-009012-8', 'POUPANCA',   9875.30,  '2021-10-22'),
(10, '0001-010123-9', 'CORRENTE',  33200.60,  '2019-05-09');

INSERT INTO transacoes (conta_id, tipo, valor, descricao, data_transacao) VALUES
(1,  'DEPOSITO',      5000.00, 'Salário março',           '2026-03-05 08:00:00'),
(1,  'PIX',            350.00, 'Pagamento aluguel',       '2026-03-06 10:30:00'),
(1,  'SAQUE',          200.00, 'Saque caixa eletrônico',  '2026-03-07 14:15:00'),
(2,  'DEPOSITO',       800.00, 'Transferência poupança',  '2026-03-05 08:05:00'),
(3,  'TED',           3000.00, 'Pagamento fornecedor',    '2026-03-08 09:00:00'),
(3,  'PIX',            150.00, 'Compra supermercado',     '2026-03-10 18:45:00'),
(4,  'DEPOSITO',      8750.00, 'Crédito salário',         '2026-03-05 07:00:00'),
(4,  'PIX',           1200.00, 'Pagamento cartão',        '2026-03-12 20:00:00'),
(5,  'SAQUE',          500.00, 'Saque emergência',        '2026-03-11 11:00:00'),
(6,  'DEPOSITO',      2000.00, 'Rendimentos investimento','2026-03-01 00:01:00'),
(7,  'PIX',            250.00, 'Repasse rateio',          '2026-03-09 16:20:00'),
(7,  'DOC',           1800.00, 'Pagamento financiamento', '2026-03-15 10:00:00'),
(8,  'DEPOSITO',      8750.00, 'Crédito salário',         '2026-03-05 07:00:00'),
(8,  'TRANSFERENCIA',  500.00, 'Transferência conta filha','2026-03-13 13:00:00'),
(9,  'PIX',            320.00, 'Conta de luz',            '2026-03-14 09:30:00'),
(10, 'DEPOSITO',     10000.00, 'Entrada consultoria',     '2026-03-03 15:00:00'),
(10, 'TED',           5000.00, 'Pagamento parceiro',      '2026-03-16 11:00:00'),
(1,  'PIX',            180.00, 'Farmácia',                '2026-03-18 17:00:00'),
(3,  'PIX',            450.00, 'Restaurante jantar',      '2026-03-19 21:30:00'),
(6,  'SAQUE',         1000.00, 'Saque viagem',            '2026-03-20 08:00:00');
