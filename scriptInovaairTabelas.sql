DROP DATABASE IF EXISTS innovaair;

CREATE DATABASE IF NOT EXISTS innovaair;
USE innovaair;

# CRIAÇÃO DAS TABELAS
CREATE TABLE IF NOT EXISTS cliente (
  idCliente INT PRIMARY KEY AUTO_INCREMENT,
  razaoSocial VARCHAR(105) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  email VARCHAR(255) NOT NULL,
  telefone VARCHAR(11) NOT NULL
);

CREATE TABLE IF NOT EXISTS cargo (
  idCargo INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  nivelAcesso INT NOT NULL
);

CREATE TABLE IF NOT EXISTS usuario (
  idUsuario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  email VARCHAR(255) NOT NULL,
  senha VARCHAR(30) NOT NULL,
  fkCliente INT NOT NULL,
  fkCargo INT NOT NULL,
  CONSTRAINT fk_usuario_cliente FOREIGN KEY (fkCliente) REFERENCES cliente (idCliente),
  CONSTRAINT fk_usuario_cargo FOREIGN KEY (fkCargo) REFERENCES cargo(idCargo)
);

CREATE TABLE IF NOT EXISTS endereco (
  idEndereco INT PRIMARY KEY AUTO_INCREMENT,
  cep CHAR(9) NOT NULL,
  logradouro VARCHAR(100) NOT NULL,
  numero VARCHAR(45) NOT NULL,
  aeroporto VARCHAR(45),
  bairro VARCHAR(45) NOT NULL,
  cidade VARCHAR(45) NOT NULL,
  estado VARCHAR(45) NOT NULL,
  regiao VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS filial (
  idFilial INT PRIMARY KEY AUTO_INCREMENT,
  terminal VARCHAR(30) NOT NULL,
  setor VARCHAR(30) NOT NULL,
  fkCliente INT NOT NULL,
  fkEndereco INT NOT NULL,
  CONSTRAINT fk_filial_cliente FOREIGN KEY (fkCliente) REFERENCES cliente(idCliente),
  CONSTRAINT fk_filial_endereco FOREIGN KEY (fkEndereco) REFERENCES endereco (idEndereco)
);

CREATE TABLE IF NOT EXISTS usuarioFilial(
    fkUsuario INT NOT NULL,
    fkFilial INT NOT NULL,
    primary key (fkUsuario, fkFilial)
);

CREATE TABLE IF NOT EXISTS maquina (
  idMaquina INT PRIMARY KEY AUTO_INCREMENT,
  fkFilial INT NOT NULL, #Fk Não-Relacional // Por ser outro database
  numeroSerial VARCHAR(45) NOT NULL,
  enderecoMac VARCHAR(45) NOT NULL,
  nomeModelo VARCHAR(45) NOT NULL,
  hostname VARCHAR(45) NOT NULL,
  CONSTRAINT filialMaquina FOREIGN KEY (fkFilial) REFERENCES filial(idFilial)
);

CREATE TABLE IF NOT EXISTS componente (
  idComponente INT PRIMARY KEY AUTO_INCREMENT,
  fkMaquina INT NOT NULL,
  componente VARCHAR(45) NOT NULL,
  especificacao VARCHAR(100) NOT NULL,
  CONSTRAINT fk_componente_maquina FOREIGN KEY (fkMaquina) REFERENCES maquina (idMaquina)
);

CREATE TABLE IF NOT EXISTS metrica (
  idMetrica INT PRIMARY KEY AUTO_INCREMENT,
  metrica VARCHAR(45) NOT NULL,
  limiteMaximo INT,
  limiteMinimo INT,
  fkComponente INT NOT NULL,
  CONSTRAINT fk_metrica_componente FOREIGN KEY (fkComponente) REFERENCES componente (idComponente)
);
select * from metrica;
CREATE TABLE IF NOT EXISTS captura_alerta (
  idCapturaAlerta INT PRIMARY KEY AUTO_INCREMENT,
  valorCapturado FLOAT NOT NULL,
  momento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  gravidade VARCHAR(20) NOT NULL,
  fkMetrica INT NOT NULL,
  CONSTRAINT fk_alerta_metrica FOREIGN KEY (fkMetrica) REFERENCES metrica (idMetrica)
);

INSERT INTO cliente (razaoSocial, cnpj, email, telefone) VALUES
('InnovaAir', '12345678000188', 'inovaair@technology.com', '1133224455'),
('TAM LINHAS AÉREAS S.A. A LATAM', '12345678000188', 'contato@latam.com.br', '1133224455');

INSERT INTO cargo VALUES
(1, 'Administrador', 7),
(2, 'Gerente', 6),
(3, 'Analista', 5),
(4, 'Tecnico', 4);

INSERT INTO usuario VALUES
(default, 'InnovaAir', 'inovaair@technology.com', 'Admin123@', 1, 1),
(default, 'Roberto', 'roberto@latam.com', 'Senha123@', 2, 2),
(default, 'Estela', 'estela@latam.com', 'Senha123@', 2, 3),
(default, 'Kátia', 'katia@latam.com', 'Senha123@', 2, 4);

INSERT INTO endereco (cep, logradouro, numero, aeroporto, bairro, cidade, estado, regiao) VALUES
('09560-850', 'Rod. Hélio Smidt', '1', 'Internacional de Guarulhos (GRU)', 'Cumbica', 'Guarulhos', 'SP', 'Sudeste'),  -- Aeroporto de GRU
('21041-253', 'Av. Vinte de Janeiro', 's/n', 'Internacional de Guarulhos (GRU)', 'Galeão', 'Rio de Janeiro', 'RJ', 'Sudeste'),  -- Galeão
('31742-010', 'Av. Carlos Drummond', '5.600', 'GALEÃO', 'de Confins', 'Belo Horizonte', 'MG', 'Sudeste'),  -- Confins
('81530-900', 'Av. Rocha Pombo', 's/n', 'Afonso Pena', 'Água Verde', 'Curitiba', 'PR', 'Sul'),  -- Afonso Pena
('91010-971', 'Av. Severo Dulius', '9000', 'Salgado Filho', 'São João', 'Porto Alegre', 'RS', 'Sul'); -- Salgado Filho

INSERT INTO filial (terminal, setor, fkCliente, fkEndereco) VALUES
('1', 'Embarque Internacional', 2, 1),  -- GRU
('2', 'Carga Aérea', 2, 2),  -- Galeão
('3', 'Administrativo', 2, 3),  -- Confins
('4', 'Segurança', 2, 4),  -- Curitiba
('5', 'Operações', 2, 5);  -- Porto Alegre

INSERT INTO usuarioFilial VALUES
(2,1),
(2,2),
(3,1),
(3,3),
(4,4),
(4,5);


INSERT INTO maquina (fkFilial, numeroSerial, enderecoMac, hostname, nomeModelo) VALUES
(1, 'SN1001', '00:1A:2B:3C:4D:5E', 'maquina-1', 'Asus ExpertCenter'),
(2, 'SN1002', '00:1A:2B:3C:4D:5F', 'maquina-2', 'Asus ExpertCenter'),
(1, 'SN1003', '00:1A:2B:3C:4D:60', 'maquina-3', 'Asus ExpertCenter'),
(2, 'SN1004', '00:1A:2B:3C:4D:61', 'maquina-4', 'Asus ExpertCenter'),
(1, 'SN1005', '00:1A:2B:3C:4D:62', 'maquina-5', 'Lenovo ThinkCentre'),
(2, 'SN1006', '00:1A:2B:3C:4D:63', 'maquina-6', 'Lenovo ThinkCentre'),
(1, 'SN1007', '00:1A:2B:3C:4D:64', 'maquina-7', 'HP EliteDesk'),
(2, 'SN1008', '00:1A:2B:3C:4D:65', 'maquina-8', 'HP EliteDesk'),
(1, 'SN1009', '00:1A:2B:3C:4D:66', 'maquina-9', 'HP EliteDesk'),
(2, 'SN1010', '00:1A:2B:3C:4D:67', 'maquina-10', 'Acer Veriton');

-- Inserir componentes (4 por máquina)
INSERT INTO componente (fkMaquina, componente, especificacao) VALUES
(1, 'Processador', 'Ryzen 3'), (1, 'RAM', 'Kingston 16GB'), (1, 'Armazenamento', 'Samsung SSD 1TB'), (1, 'Rede', 'Intel Gigabit'),
(2, 'Processador', 'Ryzen 3'), (2, 'RAM', 'Kingston 16GB'), (2, 'Armazenamento', 'Samsung SSD 1TB'), (2, 'Rede', 'Intel Gigabit'),
(3, 'Processador', 'Ryzen 3'), (3, 'RAM', 'Kingston 16GB'), (3, 'Armazenamento', 'Samsung SSD 1TB'), (3, 'Rede', 'Intel Gigabit'),
(4, 'Processador', 'Ryzen 3'), (4, 'RAM', 'Kingston 16GB'), (4, 'Armazenamento', 'Samsung SSD 1TB'), (4, 'Rede', 'Intel Gigabit'),
(5, 'Processador', 'Intel Xeon'), (5, 'RAM', 'Patriot 8GB'), (5, 'Armazenamento', 'Kingston SSD 500GB'), (5, 'Rede', 'Intel Ethernet'),
(6, 'Processador', 'Intel Xeon'), (6, 'RAM', 'Patriot 8GB'), (6, 'Armazenamento', 'Kingston SSD 500GB'), (6, 'Rede', 'Intel Ethernet'),
(7, 'Processador', 'Intel i9'), (7, 'RAM', 'Kingston 32GB'), (7, 'Armazenamento', 'WD Black 1TB'), (7, 'Rede', 'TP-Link 1G'),
(8, 'Processador', 'Intel i9'), (8, 'RAM', 'Kingston 32GB'), (8, 'Armazenamento', 'WD Black 1TB'), (8, 'Rede', 'TP-Link 1G'),
(9, 'Processador', 'Intel i9'), (9, 'RAM', 'Kingston 32GB'), (9, 'Armazenamento', 'WD Black 1TB'), (9, 'Rede', 'TP-Link 1G'),
(10, 'Processador', 'Ryzen 5'), (10, 'RAM', 'Corsair 16GB'), (10, 'Armazenamento', 'Kingston 512GB'), (10, 'Rede', 'Intel Ethernet');

-- Inserir métricas para cada componente (supondo ids de componente consecutivos)
-- RAM: porcentagemUso
INSERT INTO metrica (metrica, limiteMinimo, limiteMaximo, fkComponente) VALUES
('porcentagemUso', 20, 90, 2), ('porcentagemUso', 25, 85, 6), ('porcentagemUso', 30, 80, 10), ('porcentagemUso', 20, 95, 14),
('porcentagemUso', 15, 75, 18), ('porcentagemUso', 25, 85, 22), ('porcentagemUso', 30, 80, 26), ('porcentagemUso', 20, 95, 30),
('porcentagemUso', 15, 75, 34), ('porcentagemUso', 25, 85, 38);

-- Processador: porcentagemUso, processos, tempoAtividade
INSERT INTO metrica (metrica, limiteMinimo, limiteMaximo, fkComponente) VALUES
('porcentagemUso', 30, 95, 1), ('processos', 500, 4000, 1), ('tempoAtividade', NULL, NULL, 1),
('porcentagemUso', 35, 90, 5), ('processos', 400, 3000, 5), ('tempoAtividade', NULL, NULL, 5),
('porcentagemUso', 25, 85, 9), ('processos', 200, 2000, 9), ('tempoAtividade', NULL, NULL, 9),
('porcentagemUso', 20, 80, 13), ('processos', 600, 3500, 13), ('tempoAtividade', NULL, NULL, 13),
('porcentagemUso', 30, 95, 17), ('processos', 500, 4000, 17), ('tempoAtividade', NULL, NULL, 17),
('porcentagemUso', 25, 85, 21), ('processos', 300, 2500, 21), ('tempoAtividade', NULL, NULL, 21),
('porcentagemUso', 35, 90, 25), ('processos', 450, 3500, 25), ('tempoAtividade', NULL, NULL, 25),
('porcentagemUso', 20, 80, 29), ('processos', 500, 4000, 29), ('tempoAtividade', NULL, NULL, 29),
('porcentagemUso', 30, 95, 33), ('processos', 350, 3000, 33), ('tempoAtividade', NULL, NULL, 33),
('porcentagemUso', 35, 90, 37), ('processos', 600, 4000, 37), ('tempoAtividade', NULL, NULL, 37);

-- Armazenamento: porcentagemUso
INSERT INTO metrica (metrica, limiteMinimo, limiteMaximo, fkComponente) VALUES
('porcentagemUso', 40, 95, 3), ('porcentagemUso', 30, 85, 7), ('porcentagemUso', 35, 90, 11), ('porcentagemUso', 25, 75, 15),
('porcentagemUso', 30, 85, 19), ('porcentagemUso', 35, 90, 23), ('porcentagemUso', 25, 75, 27), ('porcentagemUso', 30, 85, 31),
('porcentagemUso', 35, 90, 35), ('porcentagemUso', 25, 75, 39);

-- Rede: velocidadeUpload, velocidadeDownload
INSERT INTO metrica (metrica, limiteMinimo, limiteMaximo, fkComponente) VALUES
('velocidadeUpload', 10, 100, 4), ('velocidadeDownload', 20, 200, 4),
('velocidadeUpload', 15, 150, 8), ('velocidadeDownload', 25, 250, 8),
('velocidadeUpload', 20, 120, 12), ('velocidadeDownload', 30, 220, 12),
('velocidadeUpload', 10, 110, 16), ('velocidadeDownload', 20, 210, 16),
('velocidadeUpload', 15, 140, 20), ('velocidadeDownload', 25, 240, 20),
('velocidadeUpload', 20, 130, 24), ('velocidadeDownload', 30, 230, 24),
('velocidadeUpload', 10, 105, 28), ('velocidadeDownload', 20, 205, 28),
('velocidadeUpload', 15, 145, 32), ('velocidadeDownload', 25, 245, 32),
('velocidadeUpload', 20, 135, 36), ('velocidadeDownload', 30, 235, 36),
('velocidadeUpload', 10, 115, 40), ('velocidadeDownload', 20, 215, 40);

-- VIEW LUCAS
CREATE VIEW dashRobertoModelos as
select gravidade, count(idCapturaAlerta) as qtdAlertas, especificacao, componente, terminal, WEEK(momento) as semanas, idUsuario, idMaquina, nomeModelo from captura_alerta join metrica on fkMetrica = idMetrica join componente on fkComponente = idComponente join maquina on fkMaquina = idMaquina join filial on maquina.fkFilial = idFilial join usuarioFilial on usuarioFilial.fkFilial = idFilial join usuario on fkUsuario = idUsuario where momento >= DATE_SUB(NOW(), INTERVAL 28 DAY)
group by gravidade, especificacao, componente, terminal, semanas, idUsuario, idMaquina, nomeModelo;

create view DashRobertoModelosMenor as
WITH ranked_especificacoes AS (
  SELECT
	idUsuario,
    componente,
    especificacao,
    COUNT(idCapturaAlerta) AS qtd_alertas,
    ROW_NUMBER() OVER (
      PARTITION BY componente
      ORDER BY COUNT(idCapturaAlerta)
    ) AS posicao
  FROM componente
  JOIN metrica ON fkComponente = idComponente
  LEFT JOIN captura_alerta ON fkMetrica = idMetrica
  JOIN maquina on fkMaquina = idMaquina
  JOIN filial on maquina.fkFilial = idFilial
  JOIN usuarioFilial on usuarioFilial.fkFilial = idFilial
  JOIN usuario on fkUsuario = idUsuario
  WHERE componente IN ('Processador', 'RAM', 'Rede', 'Armazenamento')
  GROUP BY componente, especificacao, idUsuario
)
SELECT idUsuario, componente, especificacao, qtd_alertas
FROM ranked_especificacoes
WHERE posicao = 1;

-- VIEW GUILHERME
CREATE VIEW dashRobertoDesempenho as
SELECT
      m.hostname AS totem,
      f.terminal AS terminal,
      u.Idusuario as usuario,
      SUM(CASE WHEN ca.gravidade = 'critico' THEN 1 ELSE 0 END) AS critico,
      SUM(CASE WHEN ca.gravidade = 'alto' THEN 1 ELSE 0 END) AS alto,
      SUM(CASE WHEN ca.gravidade = 'baixo' THEN 1 ELSE 0 END) AS baixo,
      SUM(CASE WHEN ca.gravidade IN ('critico', 'alto', 'baixo') THEN 1 ELSE 0 END) AS total_alertas
    FROM maquina m
    JOIN filial f ON m.fkFilial = f.idFilial
    LEFT JOIN componente c ON c.fkMaquina = m.idMaquina
    LEFT JOIN metrica me ON me.fkComponente = c.idComponente
    join usuarioFilial uf on uf.fkFilial = idfilial
    join usuario u on uf.fkUsuario = u.idUsuario
    LEFT JOIN captura_alerta ca ON ca.fkMetrica = me.idMetrica AND ca.momento >= NOW() - INTERVAL 1 DAY
    GROUP BY totem, terminal, usuario;

-- DADOS SIMULADOS:
SELECT * from metrica;
-- RAM
/* INSERT INTO captura_alerta (valorCapturado, momento, gravidade, fkMetrica) VALUES
(71.0, '2025-03-01 08:00:00', 'baixa', 1),
(70.5, '2025-03-02 09:00:00', 'baixa', 1),
(70.2, '2025-03-03 10:00:00', 'baixa', 1),
(71.3, '2025-03-04 11:00:00', 'baixa', 1),
(72.0, '2025-03-05 12:00:00', 'baixa', 1),
(70.9, '2025-03-06 13:00:00', 'baixa', 1),
(71.7, '2025-03-07 14:00:00', 'baixa', 1),
(72.5, '2025-03-08 15:00:00', 'baixa', 1),
(70.3, '2025-03-09 16:00:00', 'baixa', 1),
(73.0, '2025-03-10 17:00:00', 'baixa', 1),
(71.1, '2025-03-11 08:00:00', 'baixa', 1),
(72.4, '2025-04-12 09:00:00', 'baixa', 1),
(71.6, '2025-04-13 10:00:00', 'baixa', 1),
(70.8, '2025-04-14 11:00:00', 'baixa', 1),
(73.5, '2025-04-15 12:00:00', 'baixa', 1),
(71.2, '2025-05-16 13:00:00', 'baixa', 1),
(70.7, '2025-05-17 14:00:00', 'baixa', 1),
(72.3, '2025-05-18 15:00:00', 'baixa', 1),
(71.4, '2025-05-19 16:00:00', 'baixa', 1),
(75.6, '2025-05-20 17:00:00', 'baixa', 1),
(88.5, '2025-03-21 08:00:00', 'alta', 1),
(89.0, '2025-03-22 09:00:00', 'alta', 1),
(87.0, '2025-03-23 10:00:00', 'alta', 1),
(90.0, '2025-03-24 11:00:00', 'alta', 1),
(89.5, '2025-03-25 12:00:00', 'alta', 1),
(88.7, '2025-03-26 13:00:00', 'alta', 1),
(86.0, '2025-03-27 14:00:00', 'alta', 1),
(87.3, '2025-03-28 15:00:00', 'alta', 1),
(88.2, '2025-03-29 16:00:00', 'alta', 1),
(89.7, '2025-03-30 17:00:00', 'alta', 1),
(85.0, '2025-03-31 08:00:00', 'alta', 1),
(88.1, '2025-04-01 09:00:00', 'alta', 1),
(89.3, '2025-04-02 10:00:00', 'alta', 1),
(86.5, '2025-04-03 11:00:00', 'alta', 1),
(90.0, '2025-04-04 12:00:00', 'alta', 1),
(87.5, '2025-04-05 13:00:00', 'alta', 1),
(88.8, '2025-04-06 14:00:00', 'alta', 1),
(89.9, '2025-04-07 15:00:00', 'alta', 1),
(86.2, '2025-05-08 16:00:00', 'alta', 1),
(87.9, '2025-05-09 17:00:00', 'alta', 1),
(88.0, '2025-05-10 08:00:00', 'alta', 1),
(89.4, '2025-05-11 09:00:00', 'alta', 1),
(86.9, '2025-05-12 10:00:00', 'alta', 1),
(91.0, '2025-03-13 11:00:00', 'critico', 1),
(92.3, '2025-03-14 12:00:00', 'critico', 1),
(95.0, '2025-04-15 13:00:00', 'critico', 1),
(93.4, '2025-04-16 14:00:00', 'critico', 1),
(94.7, '2025-05-17 15:00:00', 'critico', 1),
(96.2, '2025-05-18 16:00:00', 'critico', 1),
(98.0, '2025-05-19 17:00:00', 'critico', 1);

-- ARMAZENAMENTO
INSERT INTO captura_alerta (valorCapturado, momento, gravidade, fkMetrica) VALUES
(71.0, '2025-03-01 08:00:00', 'baixa', 41),
(70.5, '2025-03-02 09:00:00', 'baixa', 41),
(70.2, '2025-03-03 10:00:00', 'baixa', 41),
(71.3, '2025-03-04 11:00:00', 'baixa', 41),
(72.0, '2025-03-05 12:00:00', 'baixa', 41),
(70.9, '2025-03-06 13:00:00', 'baixa', 41),
(71.7, '2025-03-07 14:00:00', 'baixa', 41),
(72.5, '2025-03-08 15:00:00', 'baixa', 41),
(70.3, '2025-03-09 16:00:00', 'baixa', 41),
(73.0, '2025-03-10 17:00:00', 'baixa', 41),
(71.1, '2025-03-11 08:00:00', 'baixa', 41),
(72.4, '2025-04-12 09:00:00', 'baixa', 41),
(71.6, '2025-04-13 10:00:00', 'baixa', 41),
(70.8, '2025-04-14 11:00:00', 'baixa', 41),
(73.5, '2025-04-15 12:00:00', 'baixa', 41),
(71.2, '2025-05-16 13:00:00', 'baixa', 41),
(70.7, '2025-05-17 14:00:00', 'baixa', 41),
(72.3, '2025-05-18 15:00:00', 'baixa', 41),
(71.4, '2025-05-19 16:00:00', 'baixa', 41),
(75.6, '2025-05-20 17:00:00', 'baixa', 41),
(88.5, '2025-03-21 08:00:00', 'alta', 41),
(89.0, '2025-03-22 09:00:00', 'alta', 41),
(87.0, '2025-03-23 10:00:00', 'alta', 41),
(88.2, '2025-03-24 11:00:00', 'alta', 41),
(89.5, '2025-03-25 12:00:00', 'alta', 41),
(88.7, '2025-03-26 13:00:00', 'alta', 41),
(86.0, '2025-03-27 14:00:00', 'alta', 41),
(87.3, '2025-03-28 15:00:00', 'alta', 41),
(88.2, '2025-03-29 16:00:00', 'alta', 41),
(89.7, '2025-03-30 17:00:00', 'alta', 41),
(85.0, '2025-03-31 08:00:00', 'alta', 41),
(88.1, '2025-04-01 09:00:00', 'alta', 41),
(89.3, '2025-04-02 10:00:00', 'alta', 41),
(86.5, '2025-04-03 11:00:00', 'alta', 41),
(87.5, '2025-04-05 13:00:00', 'alta', 41),
(88.8, '2025-04-06 14:00:00', 'alta', 41),
(89.9, '2025-04-07 15:00:00', 'alta', 41),
(86.2, '2025-05-08 16:00:00', 'alta', 41),
(87.9, '2025-05-09 17:00:00', 'alta', 41),
(88.0, '2025-05-10 08:00:00', 'alta', 41),
(89.4, '2025-05-11 09:00:00', 'alta', 41),
(86.9, '2025-05-12 10:00:00', 'alta', 41),
(90.0, '2025-03-24 11:00:00', 'critico', 41),
(91.0, '2025-03-13 11:00:00', 'critico', 41),
(92.3, '2025-03-14 12:00:00', 'critico', 41),
(95.0, '2025-04-15 13:00:00', 'critico', 41),
(93.4, '2025-04-16 14:00:00', 'critico', 41),
(94.7, '2025-05-17 15:00:00', 'critico', 41),
(96.2, '2025-05-18 16:00:00', 'critico', 41),
(98.0, '2025-05-19 17:00:00', 'critico', 41);

--  CPU
INSERT INTO captura_alerta (valorCapturado, momento, gravidade, fkMetrica) VALUES
(75.0, '2025-03-01 08:00:00', 'baixa', 11),
(76.5, '2025-03-02 09:00:00', 'baixa', 11),
(76.2, '2025-03-03 10:00:00', 'baixa', 11),
(75.3, '2025-03-04 11:00:00', 'baixa', 11),
(76.0, '2025-03-05 12:00:00', 'baixa', 11),
(77.9, '2025-03-06 13:00:00', 'baixa', 11),
(79.7, '2025-03-07 14:00:00', 'baixa', 11),
(78.5, '2025-03-08 15:00:00', 'baixa', 11),
(79.3, '2025-04-09 16:00:00', 'baixa', 11),
(78.0, '2025-04-10 17:00:00', 'baixa', 11),
(79.1, '2025-04-11 08:00:00', 'baixa', 11),
(79.4, '2025-04-12 09:00:00', 'baixa', 11),
(78.6, '2025-04-13 10:00:00', 'baixa', 11),
(75.8, '2025-05-14 11:00:00', 'baixa', 11),
(79.5, '2025-05-15 12:00:00', 'baixa', 11),
(77.2, '2025-05-16 13:00:00', 'baixa', 11),
(77.7, '2025-05-17 14:00:00', 'baixa', 11),
(76.3, '2025-05-18 15:00:00', 'baixa', 11),
(76.4, '2025-05-19 16:00:00', 'baixa', 11),
(79.6, '2025-05-20 17:00:00', 'baixa', 11),
(89.5, '2025-03-21 08:00:00', 'alta', 11),
(88.0, '2025-03-22 09:00:00', 'alta', 11),
(86.0, '2025-03-23 10:00:00', 'alta', 11),
(97.0, '2025-03-24 11:00:00', 'alta', 11),
(89.5, '2025-03-25 12:00:00', 'alta', 11),
(87.7, '2025-03-26 13:00:00', 'alta', 11),
(87.0, '2025-03-27 14:00:00', 'alta', 11),
(88.3, '2025-03-28 15:00:00', 'alta', 11),
(89.2, '2025-03-29 16:00:00', 'alta', 11),
(90.7, '2025-03-30 17:00:00', 'alta', 11),
(86.0, '2025-03-31 08:00:00', 'alta', 11),
(89.1, '2025-03-01 09:00:00', 'alta', 11),
(90.3, '2025-03-02 10:00:00', 'alta', 11),
(87.5, '2025-04-03 11:00:00', 'alta', 11),
(91.0, '2025-04-04 12:00:00', 'alta', 11),
(88.5, '2025-04-05 13:00:00', 'alta', 11),
(89.8, '2025-04-06 14:00:00', 'alta', 11),
(90.9, '2025-05-07 15:00:00', 'alta', 11),
(87.2, '2025-05-08 16:00:00', 'alta', 11),
(88.9, '2025-05-09 17:00:00', 'alta', 11),
(89.0, '2025-05-10 08:00:00', 'alta', 11),
(90.4, '2025-05-11 09:00:00', 'alta', 11),
(87.9, '2025-05-12 10:00:00', 'alta', 11),
(92.0, '2025-05-13 11:00:00', 'critico', 11),
(93.3, '2025-03-14 12:00:00', 'critico', 11),
(96.0, '2025-04-15 13:00:00', 'critico', 11),
(94.4, '2025-04-16 14:00:00', 'critico', 11),
(95.7, '2025-05-17 15:00:00', 'critico', 11),
(97.2, '2025-05-18 16:00:00', 'critico', 11),
(99.0, '2025-05-19 17:00:00', 'critico', 11);
 */

-- DROP TABLE captura_alerta;

CREATE OR REPLACE VIEW detalhes_Modelo AS
SELECT 
    maquina.idMaquina,
    maquina.numeroSerial,
    maquina.enderecoMac,
    maquina.nomeModelo,
    maquina.hostname,
    maquina.fkFilial,
    componente.componente,
    componente.especificacao,
    metrica.metrica,
    metrica.limiteMinimo,
    metrica.limiteMaximo,
    metrica.fkComponente,
    metrica.idMetrica,
    captura_alerta.valorCapturado,
    captura_alerta.momento,
    captura_alerta.gravidade
FROM maquina
LEFT JOIN componente ON componente.fkMaquina = maquina.idMaquina
LEFT JOIN metrica ON metrica.fkComponente = componente.idComponente
LEFT JOIN captura_alerta ON captura_alerta.fkMetrica = metrica.idMetrica;
SELECT * from detalhes_Modelo;

SELECT * FROM captura_alerta;

-- Total de alertas dos ultimos 3 meses
SELECT COUNT(*) AS total_alertas_cpu_ultimo_mes
FROM captura_alerta ca
JOIN metrica m ON ca.fkMetrica = m.idMetrica
JOIN componente c ON m.fkComponente = c.idComponente
WHERE m.metrica = 'porcentagemUso'
  AND c.componente = 'RAM'
  AND ca.momento >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

SELECT 
  MONTH(ca.momento) AS mes,
  YEAR(ca.momento) AS ano,
  COUNT(*) AS total_alertas
FROM captura_alerta ca
JOIN metrica m ON ca.fkMetrica = m.idMetrica
JOIN componente c ON m.fkComponente = c.idComponente
WHERE m.metrica = 'porcentagemUso'
  AND c.componente = 'RAM'
  AND ca.momento BETWEEN '2025-03-01' AND '2025-05-31'
GROUP BY YEAR(ca.momento), MONTH(ca.momento)
ORDER BY ano, mes;

-- Ultimos 3 mêses
-- RAM
CREATE OR REPLACE VIEW view_alertas_ultimos_3_meses_ram AS
SELECT 
  DATE_FORMAT(ca.momento, '%M') AS mes,
  COUNT(*) AS total_alertas
FROM captura_alerta ca
JOIN metrica m ON ca.fkMetrica = m.idMetrica
JOIN componente c ON m.fkComponente = c.idComponente
WHERE m.metrica = 'porcentagemUso'
  AND c.componente = 'RAM'
  AND ca.momento >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH), '%Y-%m-01')
  AND ca.momento <  DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
GROUP BY mes;

-- CPU
CREATE OR REPLACE VIEW view_alertas_ultimos_3_meses_cpu AS
SELECT 
  DATE_FORMAT(ca.momento, '%M') AS mes,
  COUNT(*) AS total_alertas
FROM captura_alerta ca
JOIN metrica m ON ca.fkMetrica = m.idMetrica
JOIN componente c ON m.fkComponente = c.idComponente
WHERE m.metrica = 'porcentagemUso'
  AND c.componente = 'Processador'
  AND ca.momento >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH), '%Y-%m-01')
  AND ca.momento <  DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
GROUP BY mes;

CREATE OR REPLACE VIEW view_alertas_ultimos_3_meses_ram_cpu AS
SELECT 
  DATE_FORMAT(ca.momento, '%M') AS mes,
  SUM(CASE WHEN c.componente = 'RAM' THEN 1 ELSE 0 END) AS total_alertas_ram,
  SUM(CASE WHEN c.componente = 'Processador' THEN 1 ELSE 0 END) AS total_alertas_cpu
FROM captura_alerta ca
JOIN metrica m ON ca.fkMetrica = m.idMetrica
JOIN componente c ON m.fkComponente = c.idComponente
WHERE m.metrica = 'porcentagemUso'
  AND ca.momento >= DATE_FORMAT(DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH), '%Y-%m-01')
  AND ca.momento <  DATE_FORMAT(CURRENT_DATE(), '%Y-%m-01')
GROUP BY mes
ORDER BY 
  STR_TO_DATE(mes, '%M');

-- Select TODOS 
SELECT * FROM view_alertas_ultimos_3_meses_ram_cpu;

-- Select Ram
SELECT * FROM view_alertas_ultimos_3_meses_ram;

-- Select Cpu
SELECT * FROM view_alertas_ultimos_3_meses_cpu;

-- Select alertas por nivel geral (não utilizado) 
SELECT gravidade, COUNT(*) AS quantidade_alertas
FROM captura_alerta
GROUP BY gravidade;

-- Select alertas por niveis por componente
CREATE OR REPLACE VIEW view_gravidade AS
SELECT 
  c.componente AS componente, 
  ca.gravidade, 
  COUNT(*) AS quantidade_alertas
FROM 
  captura_alerta ca 
JOIN 
  metrica m ON ca.fkMetrica = m.idMetrica
JOIN 
  componente c ON m.fkComponente = c.idComponente
WHERE 
  c.componente IN ('Processador', 'RAM')
GROUP BY 
  c.componente, ca.gravidade
ORDER BY 
  c.componente, ca.gravidade;
  
-- VIEW Endereço
CREATE OR REPLACE VIEW view_endereco AS
SELECT 
  u.nome AS usuario,
  e.aeroporto,
  e.logradouro,
  e.numero,
  e.bairro,
  e.cidade,
  e.estado,
  e.regiao
FROM 
  usuario u
JOIN 
  usuarioFilial uf ON u.idUsuario = uf.fkUsuario
JOIN 
  filial f ON uf.fkFilial = f.idFilial
JOIN 
  endereco e ON f.fkEndereco = e.idEndereco
WHERE 
  u.nome = 'Estela';

SELECT usuario, aeroporto FROM view_endereco;
  
  
/* VIEWS DO FEITOSA */
CREATE VIEW identificar_enderecos AS
SELECT e.idEndereco, e.aeroporto as complemento, e.estado, u.idUsuario
	FROM usuario AS u
    JOIN usuarioFilial as uf
    ON uf.fkUsuario = u.idUsuario
    JOIN filial as f
    ON uf.fkFilial = f.idFilial
    JOIN endereco as e
    ON f.fkEndereco = e.idEndereco;

# Obtem as metricas dos componentes de uma maquina
CREATE VIEW obter_metrica_componente AS 
SELECT m.idMetrica, c.Componente, m.limiteMaximo, m.limiteMinimo, maq.idMaquina, m.Metrica, c.fkMaquina
	FROM metrica as m 
	JOIN componente as c
	ON m.fkComponente = c.idComponente
	JOIN maquina as maq
	ON c.fkMaquina = maq.idMaquina;

# Obter os totens do Endereco do Usuario
CREATE VIEW obter_enderecos_usuario AS
SELECT e.idEndereco, 
    JSON_OBJECT(
		'idMaquina', m.idMaquina,
        'numeroSerial', m.numeroSerial,
		'enderecoMac', m.enderecoMac,
        'hostname', m.hostname,
        'metricas', JSON_OBJECT(
		'cpu', JSON_OBJECT(
			'maximo', (SELECT limiteMaximo FROM obter_metrica_componente WHERE Componente = "Processador" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina),
            'minimo', (SELECT limiteMinimo FROM obter_metrica_componente WHERE Componente = "Processador" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina)
            ),
		'ram', JSON_OBJECT(
			'maximo', (SELECT limiteMaximo FROM obter_metrica_componente WHERE Componente = "RAM" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina),
            'minimo', (SELECT limiteMinimo FROM obter_metrica_componente WHERE Componente = "RAM" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina)
            ),
		'disco', JSON_OBJECT(
			'maximo', (SELECT limiteMaximo FROM obter_metrica_componente WHERE Componente = "Armazenamento" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina),
            'minimo', (SELECT limiteMinimo FROM obter_metrica_componente WHERE Componente = "Armazenamento" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina)
            ),
		'rede', JSON_OBJECT(
			'maximo', (SELECT limiteMaximo FROM obter_metrica_componente WHERE Componente = "Rede" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina),
            'minimo', (SELECT limiteMinimo FROM obter_metrica_componente WHERE Componente = "Rede" and Metrica = "PorcentagemUso" and fkMaquina = m.idMaquina)
            )
    )
    ) as totem
    FROM filial as f
    JOIN maquina as m
    ON m.fkFilial = f.idFilial
    JOIN endereco as e
    ON f.fkEndereco = e.idEndereco;

select * from maquina;
select * from componente;
select * from metrica;
select * from captura_alerta;