# The Silver Tsunami: Dataset Audit & Technical Reproducibility Report
**Competition:** ASA DataQuest 2026  
**Team:** Data Architects  
**Authors:** Awowole Uthman, Makinde Teslim, Ikeh Emmanuel (Lead), Soulaymane Aliyah  
**Affiliation:** Department of Statistics  
**Public Repository:** [https://github.com/Awowole/asa-dataquest-2026](https://github.com/Awowole/asa-dataquest-2026)  

---

## 1. Executive Summary & Purpose

This technical dossier provides an empirical audit and end-to-end reproducibility verification for **"The Silver Tsunami: A Cross-National Analysis of Fertility Decline, Longevity, and Population Ageing, 1950–2050"** (Presentation Deck and Vector PDF). 

Every empirical metric, transition matrix, regression coefficient, confidence interval, and graphical visualization presented in the 6-slide competition deck is directly derived from the official United Nations demographic repository and is 100% computationally reproducible using our master script:
`the_silver_tsunami_master_reproducibility.R`

---

## 2. Dataset Provenance & Panel Architecture

### 2.1 Primary Data Source
* **Repository:** United Nations Department of Economic and Social Affairs, Population Division (2024). *World Population Prospects 2024, Online Edition*.
* **Local Master File:** `materials/WPP2024_Master_Dataset.csv`
* **Raw Repository Scale:** 35,787 rows $\times$ 69 demographic indicators spanning 237 geographic entities over 151 years (1950–2100).

### 2.2 Panel Filtering Funnel (Figure 1 Audit)
To evaluate structural cross-national ageing without statistical distortions from non-sovereign dependencies or microstate volatility, the raw repository was subjected to a documented filtering protocol:

1. **Regional Aggregate Exclusion:** Removed 38 non-country geographic entities (e.g., "World", "Sub-Saharan Africa", "High-income countries").
2. **Sovereign Population Cutoff:** Filtered to sovereign nations with a year-2000 total population of at least 1,000,000 (`TPopulation1July >= 1000`). This removed 44 micro-territories (e.g., Tuvalu, Nauru, Bermuda) whose demographic metrics fluctuate due to micro-cohort noise.
3. **Analytical Century Horizon:** Bounded the study timeline to a balanced 101-year century window (1950 to 2050):
   * **1950–2023 (74 years):** UN empirical demographic estimates based on censuses, vital registration systems, and demographic surveys.
   * **2024–2050 (27 years):** UN medium-variant probabilistic projections.
4. **Final Balanced Panel Dimensions:**
   $$\text{Final Panel} = 155\text{ Sovereign Nations} \times 101\text{ Years} = 15,655\text{ Country-Years}$$

### 2.3 Variable Completeness & Technical Exclusions
* **Core Indicators (100.0% Complete across 15,655 rows):** `MedianAgePop` (Median Population Age in years), `TFR` (Total Fertility Rate), `LEx` (Life Expectancy at birth), `LE65` (Life Expectancy at age 65), `IMR` (Infant Mortality Rate per 1,000 births), `CBR` (Crude Birth Rate), `CDR` (Crude Death Rate), and `NetMigrations` (Net annual migrants).
* **Technical Exclusion (`DoublingTime`):** Excluded from inferential modeling because it is 55.5% undefined (division-by-zero singularities occur when annual population growth rates are zero or negative).

---

## 3. Comprehensive Number-Audit Matrix

The table below maps every numerical statistic and claim presented in the 6 presentation slides directly to its underlying database query and verified numerical value:

| Slide | Figure / Claim | Underlying Metric & Variable | Mathematical Formula / Query | Verified Value in UN WPP 2024 | Status |
| :---: | :--- | :--- | :--- | :---: | :---: |
| **Slide 2** | Funnel Audit | Raw UN WPP Repository Scale | `nrow(master_raw)` | **35,787 rows** (237 territories) | **Verified** |
| **Slide 2** | Sovereign Cohort | Sovereign Nations ($Pop \ge 1\text{M}$ in 2000) | `filter(Time==2000, TPop>=1000)` | **155 nations** | **Verified** |
| **Slide 2** | Study Panel | Balanced Country-Year Observations | `155 nations * 101 years` | **15,655 country-years** | **Verified** |
| **Slide 2** | Indicator Completeness | Core Demographic Indicator Audit | `sum(!is.na(var)) / 15655` | **100.0% unpadded** | **Verified** |
| **Slide 2** | `DoublingTime` Failure | Undefined division-by-zero share | `sum(is.na(DoublingTime)) / 15655` | **44.5% complete (55.5% NA)** | **Verified** |
| **Slide 3** | Baseline K-Means (2000) | Young Cluster ($< 20.6\text{y}$) | `sum(MedianAge < 20.6)` | **68 nations (43.9%)** | **Verified** |
| **Slide 3** | Baseline K-Means (2000) | Middle Cluster ($20.6–29.9\text{y}$) | `sum(MedianAge >= 20.6 & <= 29.9)` | **40 nations (25.8%)** | **Verified** |
| **Slide 3** | Baseline K-Means (2000) | Old Cluster ($> 29.9\text{y}$) | `sum(MedianAge > 29.9)` | **47 nations (30.3%)** | **Verified** |
| **Slide 3** | Historical Migration (2020) | Young Cluster contraction | `sum(MedianAge < 20.6)` in 2020 | **42 nations (27.1%)** [-26] | **Verified** |
| **Slide 3** | Historical Migration (2020) | Middle Cluster transition wave | `sum(MedianAge >= 20.6 & <= 29.9)` | **45 nations (29.0%)** [+5] | **Verified** |
| **Slide 3** | Historical Migration (2020) | Old Cluster expansion | `sum(MedianAge > 29.9)` in 2020 | **68 nations (43.9%)** [+21] | **Verified** |
| **Slide 3** | Projected Migration (2040) | Young Cluster collapse | `sum(MedianAge < 20.6)` in 2040 | **12 nations (7.7%)** [-56] | **Verified** |
| **Slide 3** | Projected Migration (2040) | Middle Cluster wave | `sum(MedianAge >= 20.6 & <= 29.9)` | **49 nations (31.6%)** [+9] | **Verified** |
| **Slide 3** | Projected Migration (2040) | Old Cluster global majority | `sum(MedianAge > 29.9)` in 2040 | **94 nations (60.6%)** [+47] | **Verified** |
| **Slide 4** | Sub-Replacement (2000) | Share of Countries below 2.1 TFR | `sum(TFR < 2.1) / 155` in 2000 | **37.4%** [30.2, 45.3] (58 nations) | **Verified** |
| **Slide 4** | Sub-Replacement (2000) | Pop-Weighted Global Share | `sum(Pop[TFR<2.1]) / sum(Pop)` | **46.1% of humanity** | **Verified** |
| **Slide 4** | Sub-Replacement (2020) | Share of Countries below 2.1 TFR | `sum(TFR < 2.1) / 155` in 2020 | **49.7%** [41.9, 57.5] (77 nations) | **Verified** |
| **Slide 4** | Sub-Replacement (2020) | Pop-Weighted Global Share | `sum(Pop[TFR<2.1]) / sum(Pop)` | **68.0% of humanity** | **Verified** |
| **Slide 4** | Sub-Replacement (2040) | Share of Countries below 2.1 TFR | `sum(TFR < 2.1) / 155` in 2040 | **59.4%** [51.5, 66.8] (92 nations) | **Verified** |
| **Slide 4** | Sub-Replacement (2040) | Pop-Weighted Global Share | `sum(Pop[TFR<2.1]) / sum(Pop)` | **70.3% of humanity** | **Verified** |
| **Slide 4** | One-Way Ratchet Test | McNemar Paired Change (2000–2023) | `mcnemar.test(Below2000, Below2023)` | **$\chi^2 = 16.41, p = 5.10 \times 10^{-5}$** | **Verified** |
| **Slide 4** | Directional Transitions | Crossed below vs. Rebounded above | Transitions across 2.1 threshold | **21 crossed below, 1 rebounded** | **Verified** |
| **Slide 4** | Natural Decrease Crossover | Deaths overtake births in Aging Cluster | Bootstrap 95% crossover year | **Year 2018 [2016, 2020]** | **Verified** |
| **Slide 5** | Econometric Regression | Model Variance Explained ($R^2$) | `summary(lm(MedianAge ~ LEx + TFR))` | **$R^2 = 0.806$ ($F = 314.9, p < 0.001$)** | **Verified** |
| **Slide 5** | Longevity Push ($\beta_{\text{LEx}}$) | Standardized Coefficient (LEx) | `scale(MedianAge) ~ scale(LEx) + scale(TFR)` | **$\beta = +0.403$ ($t = 6.09, p < 0.001$)** | **Verified** |
| **Slide 5** | Unstandardized Longevity | Slope per year of Life Expectancy | `lm(MedianAge ~ LEx + TFR)$coef[2]` | **$+0.506$ years per year LEx (+5.1y/decade)**| **Verified** |
| **Slide 5** | Fertility Pull ($\beta_{\text{TFR}}$) | Standardized Coefficient (TFR) | `scale(MedianAge) ~ scale(LEx) + scale(TFR)` | **$\beta = -0.532$ ($t = -8.03, p < 0.001$)** | **Verified** |
| **Slide 5** | Full Fitted Equation | Cross-Sectional OLS (Year 2020) | `lm(MedianAgePop ~ LEx + TFR)` | **$\text{Age} = 2.875 + 0.506(\text{LEx}) - 3.795(\text{TFR})$** | **Verified** |

---

## 4. Methodological & Econometric Foundations

### 4.1 Unsupervised Spatial Clustering (Figure 2)
In accordance with demographic standards and the project's analytical design (`materials/revise.R`), $k$-means clustering was initialized on standardized baseline year-2000 median ages ($k=3$, random seed 42, $n_{\text{start}} = 25$). The resulting decision boundaries define the three global archetypes:
* **Young:** Median Age $< 20.55$ years (Cluster center: 16.97y)
* **Middle:** Median Age $20.55$ to $29.86$ years (Cluster center: 24.09y)
* **Old:** Median Age $> 29.86$ years (Cluster center: 35.42y)

Holding these criteria fixed across the century allows tracking true demographic movement rather than shifting statistical goalposts.

### 4.2 Binomial Confidence Intervals & Transition Dynamics (Figure 3)
For the sub-replacement threshold analysis ($TFR < 2.1$), uncertainty around sovereign country shares was estimated using the **Wilson score interval** with continuity correction, which provides superior coverage properties near boundary proportions compared to asymptotic Wald intervals:
$$CI_{95\%} = \frac{\hat{p} + \frac{z^2}{2n} \pm z \sqrt{\frac{\hat{p}(1-\hat{p})}{n} + \frac{z^2}{4n^2}}}{1 + \frac{z^2}{n}}$$

The one-way nature of the demographic transition was formally evaluated using **McNemar's paired chi-square test** on the contingency matrix of nations classified as sub-replacement in 2000 versus 2023:
$$\chi^2 = \frac{(|b - c| - 1)^2}{b + c} = \frac{(|21 - 1| - 1)^2}{21 + 1} = \frac{19^2}{22} = 16.41 \quad (p = 5.10 \times 10^{-5})$$
Out of 22 observed net transitions, 21 nations dropped below replacement while only 1 (Algeria) experienced a temporary rebound, confirming an empirical one-way demographic ratchet.

### 4.3 Econometric Driver Model (Figure 4)
Cross-sectional ordinary least squares (OLS) regression across all 155 sovereign nations in 2020 confirms that life expectancy at birth serves as the primary structural macro-anchor of national median age:
$$\text{MedianAge}_i = \alpha + \beta_1 \text{LEx}_i + \beta_2 \text{TFR}_i + \varepsilon_i$$
* **Intercept ($\alpha$):** $2.875$ ($SE = 7.036, t = 0.409, p = 0.683$)
* **Life Expectancy Slope ($\beta_1$):** $+0.506$ ($SE = 0.083, t = 6.094, p = 8.67 \times 10^{-9}$)
* **Total Fertility Slope ($\beta_2$):** $-3.795$ ($SE = 0.472, t = -8.034, p = 2.42 \times 10^{-13}$)
* **Model Goodness of Fit:** Multiple $R^2 = 0.8056$, Adjusted $R^2 = 0.8030$, $F(2, 152) = 314.9$ ($p < 2.2 \times 10^{-16}$).

---

## 5. End-to-End Reproducibility Instructions

To reproduce all figures, data tables, and statistical results from scratch:

```bash
# Navigate to the project root directory
cd "c:\Users\user\Desktop\ASA DATA QUEST\asa_2"

# Execute the master R reproducibility pipeline
& "C:\Program Files\R\R-4.4.2\bin\Rscript.exe" the_silver_tsunami_master_reproducibility.R

# Rebuild the Master 6-Slide Presentation Deck
python build_master_6slides_deck.py

# Export Master Deck to Vector PDF and 1080p slide images
powershell -ExecutionPolicy Bypass -File export_master_6slides.ps1
```

### Generated Publication Deliverables
1. **Presentation Deck:** [`The_Silver_Tsunami_Master_6Slides.pptx`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/The_Silver_Tsunami_Master_6Slides.pptx)
2. **Vector PDF:** [`The_Silver_Tsunami_Master_6Slides.pdf`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/The_Silver_Tsunami_Master_6Slides.pdf)
3. **Master R Script:** [`the_silver_tsunami_master_reproducibility.R`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/the_silver_tsunami_master_reproducibility.R)
4. **Figure 1 Image:** [`figures_cropped/plot2_full.png`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/figures_cropped/plot2_full.png)
5. **Figure 2 Image:** [`figures_cropped/figure2_cluster_map_3grid.png`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/figures_cropped/figure2_cluster_map_3grid.png)
6. **Figure 3 Image:** [`figures_cropped/figure3_subreplacement_2000_2020_2040.png`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/figures_cropped/figure3_subreplacement_2000_2020_2040.png)
7. **Figure 4 Image:** [`figures_cropped/regression_life_expectancy.png`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/figures_cropped/regression_life_expectancy.png)
8. **High-Resolution Slide Previews:** [`slide_previews_master_6slides/`](file:///c:/Users/user/Desktop/ASA%20DATA%20QUEST/asa_2/slide_previews_master_6slides)

