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
  hostname VARCHAR(45) NOT NULL,
  modelo VARCHAR(45) NOT NULL,
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
('09560-850', 'Rod. Hélio Smidt', '1', 'GRU', 'Cumbica', 'Guarulhos', 'SP', 'Sudeste'),  -- Aeroporto de GRU
('21041-253', 'Av. Vinte de Janeiro', 's/n', 'GRU', 'Galeão', 'Rio de Janeiro', 'RJ', 'Sudeste'),  -- Galeão
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

INSERT INTO maquina (fkFilial, numeroSerial, enderecoMac, hostname, modelo) VALUES
(1, 'SN1001', '00:1A:2B:3C:4D:5E', 'maquina-1', 'ABC'),
(1, 'SN1002', '00:1A:2B:3C:4D:5F', 'maquina-2', 'ABC'),
(2, 'SN1003', '00:1A:2B:3C:4D:60', 'maquina-3', 'ABC'),
(2, 'SN1004', '00:1A:2B:3C:4D:61', 'maquina-4', 'DEF'),
(3, 'SN1005', '00:1A:2B:3C:4D:62', 'maquina-5', 'DEF'),
(3, 'SN1006', '00:1A:2B:3C:4D:63', 'maquina-6', 'DEF'),
(4, 'SN1007', '00:1A:2B:3C:4D:64', 'maquina-7', 'GHI'),
(4, 'SN1008', '00:1A:2B:3C:4D:65', 'maquina-8', 'GHI'),
(5, 'SN1009', '00:1A:2B:3C:4D:66', 'maquina-9', 'GHI'),
(5, 'SN1010', '00:1A:2B:3C:4D:67', 'maquina-10', 'XYZ');

-- Inserir componentes (4 por máquina)
INSERT INTO componente (fkMaquina, componente, especificacao) VALUES
(1, 'Processador', 'Ryzen 3'), (1, 'RAM', 'Kingston 16GB'), (1, 'Armazenamento', 'Samsung SSD 1TB'), (1, 'Rede', 'Intel Gigabit'),
(2, 'Processador', 'Intel i5'), (2, 'RAM', 'Corsair 32GB'), (2, 'Armazenamento', 'WD Blue 2TB'), (2, 'Rede', 'Realtek 1G'),
(3, 'Processador', 'Intel i7'), (3, 'RAM', 'HyperX 8GB'), (3, 'Armazenamento', 'Crucial 1TB'), (3, 'Rede', 'TP-Link 1G'),
(4, 'Processador', 'Ryzen 5'), (4, 'RAM', 'G.Skill 16GB'), (4, 'Armazenamento', 'Seagate 2TB'), (4, 'Rede', 'D-Link 1G'),
(5, 'Processador', 'Intel Xeon'), (5, 'RAM', 'Patriot 8GB'), (5, 'Armazenamento', 'Kingston SSD 500GB'), (5, 'Rede', 'Intel Ethernet'),
(6, 'Processador', 'Ryzen 7'), (6, 'RAM', 'Corsair 16GB'), (6, 'Armazenamento', 'Samsung SSD 2TB'), (6, 'Rede', 'Realtek 2.5G'),
(7, 'Processador', 'Intel i9'), (7, 'RAM', 'Kingston 32GB'), (7, 'Armazenamento', 'WD Black 1TB'), (7, 'Rede', 'TP-Link 1G'),
(8, 'Processador', 'Ryzen 9'), (8, 'RAM', 'G.Skill 8GB'), (8, 'Armazenamento', 'Crucial SSD 2TB'), (8, 'Rede', 'D-Link 2.5G'),
(9, 'Processador', 'Intel Xeon'), (9, 'RAM', 'HyperX 16GB'), (9, 'Armazenamento', 'Seagate 1TB'), (9, 'Rede', 'Intel Gigabit'),
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
select gravidade, count(idCapturaAlerta) as qtdAlertas, especificacao, componente, terminal, WEEK(momento) as semanas, idUsuario, idMaquina from captura_alerta join metrica on fkMetrica = idMetrica join componente on fkComponente = idComponente join maquina on fkMaquina = idMaquina join filial on maquina.fkFilial = idFilial join usuarioFilial on usuarioFilial.fkFilial = idFilial join usuario on fkUsuario = idUsuario where momento >= DATE_SUB(NOW(), INTERVAL 30 DAY)
group by gravidade, especificacao, componente, terminal, semanas, idUsuario, idMaquina;

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