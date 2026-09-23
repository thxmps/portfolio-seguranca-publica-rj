----------------------------------------------------------------------------------
-- MÓDULO 1: VISÃO GERAL E INTELIGÊNCIA TEMPORAL (ESTADO)
----------------------------------------------------------------------------------

-- Volume acumulado de crimes patrimoniais por região (2018-2025)
SELECT 
    D.regiao AS Regiao,
    SUM(F.quantidade_furto_veiculos) AS Total_Furto_Veiculos,
    SUM(F.quantidade_roubo_veiculo) AS Total_Roubo_Veiculos,
    SUM(F.quantidade_roubo_carga) AS Total_Roubo_Carga,
    SUM(F.quantidade_furto_veiculos) + SUM(F.quantidade_roubo_veiculo) + SUM(F.quantidade_roubo_carga) AS Volume_Total_Patrimonial
FROM dbo.Stg_Evolucao_CISP AS F
INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS D
    ON F.id_cisp = D.id_cisp
WHERE F.ano BETWEEN 2018 AND 2025
GROUP BY D.regiao
ORDER BY Volume_Total_Patrimonial DESC;

-- Evolução anual dos roubos de veículos e variação % (YoY)
WITH total_por_ano AS (
    SELECT
        ano,
        SUM(quantidade_roubo_veiculo) AS total_roubos
    FROM dbo.Stg_Evolucao_CISP
    WHERE ano BETWEEN 2017 AND 2025
    GROUP BY ano
),
dados_comparativos AS (
    SELECT
        ano,
        total_roubos,
        LAG(total_roubos) OVER (ORDER BY ano) AS roubo_ano_anterior
    FROM total_por_ano
)
SELECT 
    ano,
    total_roubos,
    roubo_ano_anterior,
    CAST(
        ((total_roubos - roubo_ano_anterior) * 100.0) / NULLIF(roubo_ano_anterior, 0)
        AS DECIMAL(10,2)
    ) AS variacao_percentual
FROM dados_comparativos
WHERE ano >= 2018
ORDER BY ano ASC;

----------------------------------------------------------------------------------
-- MÓDULO 2: DIAGNÓSTICO OPERACIONAL E HIERARQUIA TERRITORIAL
----------------------------------------------------------------------------------

-- Distribuição proporcional de roubos de veículos por região em 2025
SELECT 
    R.regiao AS Regiao,
    SUM(E.quantidade_roubo_veiculo) AS total_roubos_veiculo_regiao,
    CAST(
        (SUM(E.quantidade_roubo_veiculo) * 100.0) / SUM(SUM(E.quantidade_roubo_veiculo)) OVER() 
        AS DECIMAL(10,2)
    ) AS percentual_sobre_total
FROM dbo.Stg_Evolucao_CISP E
INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP R
    ON E.id_cisp = R.id_cisp
WHERE E.ano = 2025
GROUP BY R.regiao
ORDER BY total_roubos_veiculo_regiao DESC;

-- Top 3 RISPs com maior volume de roubos de carga e CISPs ativas
WITH cisp_agrupada AS (
    SELECT 
        R.id_risp,
        R.regiao,
        E.id_cisp,
        SUM(E.quantidade_roubo_carga) AS roubos_cisp
    FROM dbo.Stg_Evolucao_CISP AS E
    INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS R
        ON E.id_cisp = R.id_cisp
    WHERE E.ano = 2025
    GROUP BY R.id_risp, R.regiao, E.id_cisp
)
SELECT TOP 3
    id_risp,
    regiao,
    SUM(roubos_cisp) AS total_roubo_carga,
    COUNT(id_cisp) AS qtde_cisps_ativas,
    STRING_AGG(id_cisp, ', ') WITHIN GROUP (ORDER BY id_cisp ASC) AS ids_cisps
FROM cisp_agrupada
GROUP BY id_risp, regiao
ORDER BY total_roubo_carga DESC;

----------------------------------------------------------------------------------
-- MÓDULO 3: RANKINGS GEOGRÁFICOS E ANÁLISE DE OUTLIERS
----------------------------------------------------------------------------------

-- Unidades territoriais com maior volume patrimonial acumulado
SELECT 
    D.unidade_territorial AS Unidade_Territorial,
    D.regiao AS Regiao,
    SUM(F.quantidade_furto_veiculos) + SUM(F.quantidade_roubo_veiculo) + SUM(F.quantidade_roubo_carga) AS Volume_Total_Patrimonial
FROM dbo.Stg_Evolucao_CISP AS F
INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS D
    ON F.id_cisp = D.id_cisp
WHERE F.ano BETWEEN 2018 AND 2025
GROUP BY 
    D.unidade_territorial,
    D.regiao
ORDER BY Volume_Total_Patrimonial DESC;

-- Maior CISP em roubos de veículos por região em 2025
WITH ranking_cisp_por_regiao AS (
    SELECT
        R.regiao,
        R.unidade_territorial,
        E.id_cisp,
        SUM(E.quantidade_roubo_veiculo) AS total_roubo_veiculo,
        ROW_NUMBER() OVER(PARTITION BY R.regiao ORDER BY SUM(E.quantidade_roubo_veiculo) DESC
        ) AS posicao
    FROM dbo.Stg_Evolucao_CISP AS E
    INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS R
        ON E.id_cisp = R.id_cisp
    WHERE E.ano = 2025
    GROUP BY
        R.regiao,
        R.unidade_territorial,
        E.id_cisp
)
SELECT
    regiao,
    unidade_territorial,
    id_cisp,
    total_roubo_veiculo
FROM ranking_cisp_por_regiao
WHERE posicao = 1
ORDER BY total_roubo_veiculo DESC;

-- Top 5 unidades territoriais em roubos de carga (2025)
SELECT TOP 5
    R.unidade_territorial,
    R.regiao,
    SUM(E.quantidade_roubo_carga) AS quantidade_total_roubo_carga
FROM dbo.Stg_Evolucao_CISP AS E
INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS R
    ON E.id_cisp = R.id_cisp
WHERE E.ano = 2025
GROUP BY 
    R.unidade_territorial, 
    R.regiao
ORDER BY quantidade_total_roubo_carga DESC;

-- CISPs com furtos de veículos acima da média estadual em 2025
WITH total_furtos_por_cisp AS (
    SELECT
        R.unidade_territorial,
        R.regiao,
        SUM(E.quantidade_furto_veiculos) AS total_furtos
    FROM dbo.Stg_Evolucao_CISP AS E
    INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS R
        ON E.id_cisp = R.id_cisp
    WHERE E.ano = 2025
    GROUP BY
        R.unidade_territorial,
        R.regiao
)
SELECT
    unidade_territorial,
    regiao,
    total_furtos
FROM total_furtos_por_cisp
WHERE total_furtos > (
    SELECT AVG(total_furtos) 
    FROM total_furtos_por_cisp
)
ORDER BY total_furtos DESC;

----------------------------------------------------------------------------------
-- MÓDULO 4: INDICADORES AVANÇADOS DE GRAVIDADE E CONSOLIDAÇÃO OPERACIONAL
----------------------------------------------------------------------------------

-- Índice de gravidade (Proporção Roubo x Furto por AISP)
WITH unidades_unicas AS (
    SELECT DISTINCT 
        id_aisp, 
        unidade_territorial 
    FROM dbo.Stg_Relacao_CISP_AISP_RISP
),
unidades_concatenadas AS (
    SELECT 
        id_aisp,
        STRING_AGG(
            CAST(unidade_territorial AS VARCHAR(MAX)), ' | ' ) WITHIN GROUP (ORDER BY unidade_territorial ASC) AS Unidades_Territoriais_Agrupadas
    FROM unidades_unicas
    GROUP BY id_aisp
)
SELECT
    R.id_aisp AS AISP,
    A.nome_aisp AS Nome_AISP,
    U.Unidades_Territoriais_Agrupadas,
    SUM(E.quantidade_roubo_veiculo) AS Total_Roubos,
    SUM(E.quantidade_furto_veiculos) AS Total_Furtos,
  -- Quantos roubos ocorrem para cada 1 furto
    CAST(
        (SUM(E.quantidade_roubo_veiculo) * 1.0) / NULLIF(SUM(E.quantidade_furto_veiculos), 0)
        AS DECIMAL(10,2)
    ) AS Roubos_por_Cada_Furto,
  -- % de roubos sobre o Total Automotivo
    CAST(
        (SUM(E.quantidade_roubo_veiculo) * 100.0) / NULLIF(SUM(E.quantidade_roubo_veiculo + E.quantidade_furto_veiculos), 0)
        AS DECIMAL(10,2)) AS Gravidade_Percentual
FROM dbo.Stg_Evolucao_CISP AS E
INNER JOIN dbo.Stg_Relacao_CISP_AISP_RISP AS R
    ON E.id_cisp = R.id_cisp
INNER JOIN unidades_concatenadas AS U
    ON R.id_aisp = U.id_aisp
INNER JOIN dbo.Dim_AISP AS A
    ON R.id_aisp = A.id_aisp
WHERE E.ano BETWEEN 2018 AND 2025
GROUP BY 
    R.id_aisp,
    A.nome_aisp,
    U.Unidades_Territoriais_Agrupadas
ORDER BY Gravidade_Percentual DESC;
