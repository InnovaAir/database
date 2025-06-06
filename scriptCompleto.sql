create database innovaair;

create user 'innova_admin'@'%' identified by 'InnovaairAdmin@123';

grant all on innovaair.* to 'innova_admin'@'%';

create user 'innova_client'@'%' identified by 'Innovaair@123';

grant select, insert on innovaair.maquina to 'innova_client'@'%';
grant select, insert on innovaair.componente to 'innova_client'@'%';
grant select, insert on innovaair.metrica to 'innova_client'@'%';
grant select, insert on innovaair.captura_alerta to 'innova_client'@'%';
grant insert on innovaair.dados_previsao to 'innova_client'@'%';
grant select on innovaair.filial to 'innova_client'@'%';

create user 'innova_s3'@'%' identified by 'Innovaair@123';

grant select on innovaair.cliente to 'innova_s3'@'%';
grant select on innovaair.filial to 'innova_s3'@'%';
grant select on innovaair.maquina to 'innova_s3'@'%';
grant select on innovaair.componente to 'innova_s3'@'%';
grant select on innovaair.metrica to 'innova_s3'@'%';

flush privileges;

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
  complemento VARCHAR(45),
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

INSERT INTO endereco (cep, logradouro, numero, complemento, bairro, cidade, estado, regiao) VALUES
('09560-850', 'Rod. Hélio Smidt', '1', 'Terminal 1', 'Cumbica', 'Guarulhos', 'SP', 'Sudeste'),  -- Aeroporto de GRU
('21041-253', 'Av. Vinte de Janeiro', 's/n', 'Terminal Principal', 'Galeão', 'Rio de Janeiro', 'RJ', 'Sudeste'),  -- Galeão
('31742-010', 'Av. Carlos Drummond', '5.600', 'Terminal 2', 'Confins', 'Belo Horizonte', 'MG', 'Sudeste'),  -- Confins
('81530-900', 'Av. Rocha Pombo', 's/n', 'Terminal de Passageiros', 'Água Verde', 'Curitiba', 'PR', 'Sul'),  -- Afonso Pena
('91010-971', 'Av. Severo Dulius', '9000', 'Terminal 1', 'São João', 'Porto Alegre', 'RS', 'Sul'); -- Salgado Filho

INSERT INTO filial (terminal, setor, fkCliente, fkEndereco) VALUES
('GRU', 'Embarque Internacional', 1, 1),  -- GRU
('Galeão', 'Carga Aérea', 2, 2),  -- Galeão
('de Confins', 'Administrativo', 2, 3),  -- Confins
('Principal - Afonso Pena', 'Segurança', 2, 4),  -- Curitiba
('Salgado Filho', 'Operações', 2, 5);  -- Porto Alegre

INSERT INTO usuarioFilial VALUES
(2,1),
(2,2);

INSERT INTO maquina (fkFilial, numeroSerial, enderecoMac, hostname) VALUES
(1, 'SN1001', '00:1A:2B:3C:4D:5E', 'maquina-1'),
(2, 'SN1002', '00:1A:2B:3C:4D:5F', 'maquina-2'),
(1, 'SN1003', '00:1A:2B:3C:4D:60', 'maquina-3'),
(2, 'SN1004', '00:1A:2B:3C:4D:61', 'maquina-4'),
(1, 'SN1005', '00:1A:2B:3C:4D:62', 'maquina-5'),
(2, 'SN1006', '00:1A:2B:3C:4D:63', 'maquina-6'),
(1, 'SN1007', '00:1A:2B:3C:4D:64', 'maquina-7'),
(2, 'SN1008', '00:1A:2B:3C:4D:65', 'maquina-8'),
(1, 'SN1009', '00:1A:2B:3C:4D:66', 'maquina-9'),
(2, 'SN1010', '00:1A:2B:3C:4D:67', 'maquina-10');

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

select * from dashRobertoDesempenho;

-- DROP TABLE captura_alerta;

SELECT * FROM captura_alerta;

CREATE VIEW identificar_enderecos AS
SELECT e.idEndereco, e.complemento, e.estado, u.idUsuario
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
