# 🛡️ Dashboard de Segurança Pública | Rio de Janeiro
> **Tratamento de Dados, Modelagem e Análise de Crimes Patrimoniais (2015 – 2025)**

---

## 📌 Motivação do Projeto
Desenvolvi este projeto por curiosidade analítica em relação à dinâmica da criminalidade patrimonial do estado. O objetivo principal foi explorar dados brutos oficiais e construir uma estrutura de dados consistente para extrair diagnósticos operacionais.

**Escopo de Estudo:**
* 🚗 Roubo de Veículos
* 📦 Roubo de Carga
* 🔑 Furto de Veículos

> [!NOTE]
> **Foco do Projeto:** Transformar grandes volumes de ocorrências históricas brutas em indicadores operacionais claros para apoio à tomada de decisão e análise espacial.

---

## 🗂️ Fontes de Dados
Dados abertos extraídos do portal do Instituto de Segurança Pública (ISP-RJ) em formato CSV:
1. `br_rj_isp_estatisticas_seguranca_evolucao_mensal_cisp`: Histórico mensal de ocorrências por CISP.
2. `br_rj_isp_estatisticas_seguranca_relacao_cisp_aisp_risp`: Mapeamento e hierarquia geográfica (CISP, AISP, RISP).

---

## 🛠️ Tecnologias e Ferramentas

![Microsoft SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)

* **SQL Server:** Importação, higienização de texto, criação de tabelas dimensionais e validação de lógicas analíticas com CTEs, Funções de Janela e Agregações.
* **Power BI:** Modelagem dimensional (Star Schema), fórmulas em DAX, personalização de visuais e construção do relatório interativo.

---

## ⚙️ Passo a Passo do Desenvolvimento

| Etapa | Foco Técnico | Descrição & Principais Ações |
| :--- | :--- | :--- |
| **1. Saneamento & Estruturação**<br>*(SQL Server)* | `Tratamento` <br> `Modelagem` | • **Higienização de Texto:** Correção de caracteres e acentuação no campo `regiao`.<br>• **Dimensão AISP (`Dim_AISP`):** Mapeamento manual associando o código do Batalhão (BPM) ao seu nome e área de atuação. |
| **2. Validação & Regras de Negócio**<br>*(SQL Server)* | `Window Functions` <br> `CTEs & Rankings` | • **Inteligência Temporal:** Variação percentual ano a ano (YoY) via `LAG()`.<br>• **Agrupamento Geográfico:** Mapeamento de CISPs ativas via `STRING_AGG()`.<br>• **Rankings e Outliers:** Identificação de áreas críticas com `ROW_NUMBER() OVER(PARTITION BY...)`.<br>• **Índices de Gravidade:** Proporção entre roubos e furtos por região. |
| **3. Visualização & UX**<br>*(Power BI & DAX)* | `Star Schema` <br> `DAX Dinâmico` | • **Modelagem Star Schema:** Organização entre tabela fato, dimensões e repositório centralizado (`_Medidas`).<br>• **Medidas em DAX:** Criação de métricas de `Total Volume Patrimonial`, `Gravidade %`, `Roubos por Cada Furto`, `Média Furtos por CISP` e outros.<br>• **Análise Decenal (2015–2025):** Expansão do escopo para 10 anos de dados com interatividade fluida por filtros dinâmicos. |

---

## 👤 Autor

**Thompson M Lima**
