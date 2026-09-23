----------------------------------------------------------------------------------
-- MÓDULO 0.1: CRIAÇÃO E POVOAMENTO DA DIMENSÃO DE AISPs (BATALHÕES)
----------------------------------------------------------------------------------

-- Criando a tabela de dimensão para mapeamento dos nomes das AISPs
CREATE TABLE dbo.Dim_AISP (
    id_aisp INT PRIMARY KEY,
    nome_aisp NVARCHAR(150) NOT NULL
);

-- Preenchimento dos nomes por Batalhão/Área
INSERT INTO dbo.Dim_AISP (id_aisp, nome_aisp)
VALUES
(2,  N'Zona Sul'),
(3,  N'Grande Méier'),
(4,  N'Estácio / São Cristóvão / Centro Norte'),
(5,  N'Centro / Lapa / Santa Teresa / Zona Portuária'),
(6,  N'Grande Tijuca'),
(7,  N'São Gonçalo'),
(8,  N'Campos dos Goytacazes e região'),
(9,  N'Madureira e adjacências'),
(10, N'Centro-Sul Fluminense'),
(11, N'Nova Friburgo e região'),
(12, N'Niterói e Maricá'),
(14, N'Bangu / Realengo / Padre Miguel'),
(15, N'Duque de Caxias'),
(16, N'Olaria / Penha / Cordovil'),
(17, N'Ilha do Governador'),
(18, N'Jacarepaguá'),
(19, N'Copacabana / Leme'),
(20, N'Nova Iguaçu / Mesquita / Nilópolis'),
(21, N'São João de Meriti'),
(22, N'Maré / Bonsucesso / Ramos'),
(23, N'Leblon / Ipanema / Gávea / Rocinha / São Conrado'),
(24, N'Seropédica / Itaguaí / Paracambi / Queimados / Japeri'),
(25, N'Região dos Lagos'),
(26, N'Petrópolis'),
(27, N'Santa Cruz / Paciência / Sepetiba'),
(28, N'Volta Redonda / Barra Mansa e região'),
(29, N'Itaperuna e região'),
(30, N'Teresópolis e região'),
(31, N'Barra da Tijuca / Recreio / Itanhangá'),
(32, N'Macaé e região'),
(33, N'Angra dos Reis / Mangaratiba'),
(34, N'Magé / Guapimirim'),
(35, N'Itaboraí / Rio Bonito e região'),
(36, N'Santo Antônio de Pádua e região'),
(37, N'Resende / Itatiaia e região'),
(38, N'Três Rios e região'),
(39, N'Belford Roxo'),
(40, N'Campo Grande / Cosmos'),
(41, N'Irajá / Pavuna / Vicente de Carvalho');

-- Validação do preenchimento
SELECT *
FROM dbo.Dim_AISP
ORDER BY id_aisp;
