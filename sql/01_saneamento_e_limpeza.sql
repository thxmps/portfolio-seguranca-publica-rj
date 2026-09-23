----------------------------------------------------------------------------------
-- MÓDULO 0: TRATAMENTO E HIGIENIZAÇÃO DE DADOS (DATA CLEANING)
----------------------------------------------------------------------------------

-- Arrumando bug visual de acentuação e padronização das regiões
UPDATE dbo.Stg_Relacao_CISP_AISP_RISP
SET regiao = CASE 
    WHEN regiao LIKE '%Niter%' THEN 'Grande Niterói'
    WHEN regiao LIKE '%Baixada%' THEN 'Baixada Fluminense'
    WHEN regiao LIKE '%Capital%' THEN 'Capital'
    WHEN regiao LIKE '%Interior%' THEN 'Interior'
    ELSE regiao
END;
