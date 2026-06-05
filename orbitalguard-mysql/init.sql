CREATE DATABASE IF NOT EXISTS orbitalguard_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE orbitalguard_db;

CREATE TABLE IF NOT EXISTS cidade (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    estado      VARCHAR(2)   NOT NULL,
    latitude    DOUBLE       NOT NULL,
    longitude   DOUBLE       NOT NULL,
    populacao   INT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alerta (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    cidade_id     BIGINT       NOT NULL,
    nivel         VARCHAR(20)  NOT NULL,
    descricao     VARCHAR(255) NOT NULL,
    tipo_desastre VARCHAR(50)  NOT NULL,
    data_hora     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo         TINYINT(1)   NOT NULL DEFAULT 1,
    CONSTRAINT fk_alerta_cidade FOREIGN KEY (cidade_id) REFERENCES cidade(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Cidades monitoradas
INSERT INTO cidade (nome, estado, latitude, longitude, populacao) VALUES
('São Paulo',        'SP', -23.5505, -46.6333, 12300000),
('Rio de Janeiro',   'RJ', -22.9068, -43.1729, 6750000),
('Manaus',           'AM',  -3.1190, -60.0217, 2200000),
('Porto Alegre',     'RS', -30.0346, -51.2177, 1500000),
('Recife',           'PE',  -8.0539, -34.8811, 1650000),
('Belém',            'PA',  -1.4558, -48.5039, 1500000),
('Curitiba',         'PR', -25.4284, -49.2733, 1950000),
('Salvador',         'BA', -12.9714, -38.5014, 2900000),
('Belo Horizonte',   'MG', -19.9191, -43.9386, 2700000),
('Florianópolis',    'SC', -27.5954, -48.5480, 520000);

-- Alertas com diferentes níveis e tipos
INSERT INTO alerta (cidade_id, nivel, descricao, tipo_desastre, data_hora, ativo) VALUES
(1,  'ALTO',    'Risco elevado de alagamentos na zona leste',          'ENCHENTE',     '2025-06-01 08:00:00', 1),
(1,  'MEDIO',   'Monitoramento ativo de chuvas intensas',              'ENCHENTE',     '2025-06-01 10:00:00', 1),
(2,  'CRITICO', 'Deslizamento iminente na Zona Norte',                 'DESLIZAMENTO', '2025-06-02 07:30:00', 1),
(3,  'ALTO',    'Focos de incêndio detectados via satélite',           'QUEIMADA',     '2025-06-02 14:00:00', 1),
(4,  'CRITICO', 'Nível do Guaíba acima do limite crítico',             'ENCHENTE',     '2025-06-03 06:00:00', 1),
(5,  'MEDIO',   'Acumulado de chuva acima da média histórica',         'ENCHENTE',     '2025-06-03 09:00:00', 1),
(6,  'ALTO',    'Queimadas no entorno da região metropolitana',        'QUEIMADA',     '2025-06-03 11:00:00', 1),
(7,  'BAIXO',   'Precipitação dentro dos limites normais',             'ENCHENTE',     '2025-06-04 08:00:00', 0),
(8,  'ALTO',    'Risco de deslizamento em encostas da cidade',         'DESLIZAMENTO', '2025-06-04 10:00:00', 1),
(9,  'MEDIO',   'Satélite identificou movimentação de solo',           'DESLIZAMENTO', '2025-06-04 12:00:00', 1),
(10, 'BAIXO',   'Chuvas dentro da normalidade sazonal',                'ENCHENTE',     '2025-06-05 07:00:00', 0),
(3,  'CRITICO', 'Expansão de queimadas detectada via imagem orbital',  'QUEIMADA',     '2025-06-05 09:00:00', 1);
