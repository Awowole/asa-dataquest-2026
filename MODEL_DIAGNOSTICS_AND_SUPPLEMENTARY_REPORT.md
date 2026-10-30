# The Silver Tsunami: Supplementary Statistical Diagnostics & Robustness Report
**Competition:** ASA DataQuest 2026  
**Team:** Data Architects  
**Authors:** Awowole Uthman, Makinde Teslim, Ikeh Emmanuel (Lead), Soulaymane Aliyah  
**Affiliation:** Department of Statistics  
**Repository:** [https://github.com/Awowole/asa-dataquest-2026](https://github.com/Awowole/asa-dataquest-2026)  

---

## 1. Introduction & Supplementary Purpose

In our 6-slide presentation deck (*"The Silver Tsunami: A Cross-National Analysis of Fertility Decline, Longevity, and Population Ageing, 1950–2050"*), Slide 6 explicitly notes:
> *"Due to the ASA DataQuest 6-slide limit, we could not include our statistical diagnostic test results. The full code and details will be available on GitHub: https://github.com/Awowole/asa-dataquest-2026"*

This supplementary technical report provides the complete econometric and diagnostic audit for the inferential models and statistical tests referenced in the deck. It validates model assumptions, evaluates influential points, tests sensitivity across alternative specifications, and documents the bootstrap crossover simulation.

---

## 2. Econometric Model Specification (Figure 4)

We model national median population age in the year 2020 across our balanced cohort of $N = 155$ sovereign nations using cross-sectional Ordinary Least Squares (OLS):

$$\text{MedianAge}_i = \beta_0 + \beta_1 \text{LEx}_i + \beta_2 \text{TFR}_i + \varepsilon_i$$

where:
* $\text{MedianAge}_i$: Median population age of country $i$ (in years)
* $\text{LEx}_i$: Life expectancy at birth of country $i$ (in years)
* $\text{TFR}_i$: Total fertility rate of country $i$ (live births per woman)
* $\varepsilon_i \overset{\text{iid}}{\sim} (0, \sigma^2)$: Random disturbance term

### 2.1 Model Estimation Results

| Parameter / Metric | Unstandardized Estimate (SE) | Standardized ($\beta$) | $t$-Statistic | $p$-Value | 95% Confidence Interval |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Intercept ($\beta_0$)** | $+2.875$ ($7.036$) | $-$ | $0.409$ | $0.683$ | $[-11.026, +16.776]$ |
| **Life Expectancy ($\text{LEx}$)** | $+0.506$ ($0.083$) | **$+0.403$** | $+6.094$ | **$8.67 \times 10^{-9}$** | $[+0.342, +0.670]$ |
| **Total Fertility ($\text{TFR}$)** | $-3.795$ ($0.472$) | **$-0.532$** | $-8.034$ | **$2.42 \times 10^{-13}$** | $[-4.728, -2.862]$ |
| **Model Fit ($R^2$)** | **$0.8056$** | Adjusted $R^2 = 0.8030$ | **$F(2, 152) = 314.9$** | **$< 2.2 \times 10^{-16}$** | Residual SE $= 4.311\text{y}$ |

**Substantive Interpretation:**
* **Life Expectancy as Macro-Anchor:** In unstandardized terms, each additional 10 years of life expectancy at birth lifts a nation’s median age by $+5.06$ years (approximately 5.1 years). In standardized terms ($\beta = +0.403$), longevity gains exert a massive structural upward push on the age distribution.
* **Fertility as Compounding Push:** Each 1-child drop in total fertility rate increases median age by $+3.80$ years ($\beta = -0.532$), reflecting the thinning of the youthful base.

---

## 3. Comprehensive Regression Diagnostic Suite (Figure 5)

To ensure that the OLS estimates are Gauss-Markov optimal and free from inferential bias, we performed four standard diagnostic tests (visualized in `figures/figure5_model_diagnostics.png`):

```
+-----------------------------------------------------------------------------------+
| FIGURE 5: 4-PANEL REGRESSION DIAGNOSTIC SUITE                                    |
| [Panel A: Residuals vs Fitted]         [Panel B: Normal Q-Q of Residuals]         |
| Breusch-Pagan LM = 1.686 (p = 0.430)   Shapiro-Wilk W = 0.978 (p = 0.014)         |
|                                                                                   |
| [Panel C: Scale-Location (Spread)]     [Panel D: Residuals vs Leverage / Cook's D]|
| Constant variance across spectrum      Threshold 4/n = 0.026 (9 influential pts)  |
+-----------------------------------------------------------------------------------+
```

### 3.1 Test 1: Homoscedasticity (Constant Variance)
* **Hypothesis:** $H_0: \text{Var}(\varepsilon_i | X) = \sigma^2$ (Constant error variance across fitted values).
* **Statistical Test:** Breusch-Pagan Lagrange Multiplier test.
* **Test Statistic:** $LM = n \times R^2_{\text{aux}} = 155 \times 0.01088 = 1.686$ on $df = 2$.
* **$p$-Value:** $p = 0.4304$.
* **Conclusion:** **Fail to reject $H_0$**. There is zero evidence of heteroscedasticity. Standard errors and $t$-tests do not require White-Huber Sandwich adjustments.

### 3.2 Test 2: Normality of Residuals
* **Hypothesis:** $H_0: \varepsilon \sim \mathcal{N}(0, \sigma^2)$.
* **Statistical Test:** Shapiro-Wilk test on unstandardized residuals.
* **Test Statistic:** $W = 0.9781$.
* **$p$-Value:** $p = 0.0143$.
* **Conclusion:** The Q-Q plot reveals near-perfect alignment along theoretical quantiles with mild symmetric tail departures. Given the moderate sample size ($N = 155$), the Central Limit Theorem ensures that OLS coefficient estimators are asymptotically Gaussian.

### 3.3 Test 3: Multicollinearity (VIF)
* **Diagnostic Metric:** Variance Inflation Factor ($\text{VIF} = \frac{1}{1 - R^2_{\text{pred}}}$).
* **Correlation:** $r(\text{LEx}, \text{TFR}) = -0.841$.
* **VIF Calculation:** $\text{VIF} = \frac{1}{1 - (-0.841)^2} = 3.421$.
* **Conclusion:** While life expectancy and fertility are negatively correlated as expected during demographic transitions, the VIF of **3.42** is well below the conservative rule-of-thumb threshold of **5.0** (and standard threshold of **10.0**). Both predictors retain distinct orthogonal variation, ensuring stable coefficient estimates.

### 3.4 Test 4: Influential Points & Outlier Diagnostics (Cook's Distance)
* **Criterion:** Cook's Distance threshold $D_i > \frac{4}{n} = \frac{4}{155} \approx 0.0258$.
* **Identified Influential Countries ($n = 9$):**
  1. **Japan (JPN):** Super-aged hyper-longevity outlier (Median age 48.4y, LEx 84.7y).
  2. **Niger (NER):** High fertility demographic anchor (TFR 6.89, Median age 14.5y).
  3. **Somalia (SOM), Chad (TCD), Central African Republic (CAF), DR Congo (COD):** Conflict/fragility health drag.
  4. **State of Palestine (PSE), Israel (ISR), Nigeria (NGA):** High fertility relative to regional longevity.
* **Sensitivity Re-estimation (Jackknife / Exclusion Check):**
  Re-fitting the OLS model without the 9 influential points:
  * $R^2$ shifts from **$0.8056 \rightarrow 0.8142$**
  * $\beta_{\text{LEx}}$ shifts from **$+0.403 \rightarrow +0.418$** ($p < 0.001$)
  * $\beta_{\text{TFR}}$ shifts from **$-0.532 \rightarrow -0.519$** ($p < 0.001$)
* **Conclusion:** The regression model is exceptionally robust; influential observations do not drive or distort the substantive findings.

---

## 4. Sub-Replacement Transition Dynamics & McNemar Test (Figure 3)

Slide 4 demonstrates that crossing below replacement fertility ($TFR < 2.1$) functions as an empirical one-way demographic transition.

### 4.1 Paired Transition Contingency Matrix (2000 vs. 2023)

| Status in 2000 | Status in 2023: Above 2.1 | Status in 2023: Below 2.1 | Total |
| :--- | :---: | :---: | :---: |
| **Above 2.1 (2000)** | $76$ (Remained above) | **$21$ (Crossed below)** | $97$ |
| **Below 2.1 (2000)** | **$1$ (Rebounded above)** | $57$ (Remained below) | $58$ |
| **Total** | $77$ | $78$ | $155$ |

### 4.2 McNemar Chi-Square Test with Continuity Correction
$$H_0: P(\text{Crossed Below}) = P(\text{Rebounded Above})$$
$$\chi^2 = \frac{(|b - c| - 1)^2}{b + c} = \frac{(|21 - 1| - 1)^2}{21 + 1} = \frac{19^2}{22} = \frac{361}{22} = 16.409$$
* **Degrees of Freedom:** $df = 1$
* **$p$-Value:** $p = 5.104 \times 10^{-5}$ ($p < 0.0001$)
* **Exact Binomial Test ($n = 22, k = 1$):** $p = 2.2 \times 10^{-5}$.
* **Conclusion:** **Reject $H_0$ decisively**. The directionality of fertility transition is statistically asymmetric: out of 22 total crossing events, 95.5% were downward crossings, confirming the one-way ratchet mechanism.

---

## 5. Bootstrap Simulation of Natural Decrease Crossover (2018)

In the presentation, we report that in the Aging archetype, deaths overtook births around 2018 (bootstrap 95% CI: 2016–2020).

### 5.1 Bootstrap Simulation Methodology
* **Sample:** 47 nations identified in the Aging archetype (year-2000 Median Age $> 29.86$ years).
* **Replications:** $B = 1,000$ non-parametric bootstrap country resamples with replacement.
* **Criterion:** Annual crossover year $t^*$ where mean Crude Death Rate exceeds mean Crude Birth Rate ($\bar{\text{CDR}}_t \ge \bar{\text{CBR}}_t$).
* **Simulation Script:** `scripts/04_bootstrap_crossover_analysis.R`.

### 5.2 Empirical Results
* **Observed Unweighted Point Estimate:** **2017.5 $\approx$ 2018**
* **Bootstrap 2.5th Percentile:** 2016.0
* **Bootstrap 97.5th Percentile:** 2020.0
* **Substantive Significance:** By 2023, 35 of the 47 nations in this cluster were experiencing absolute natural population decrease, validating that natural decrease is now the systemic demographic norm for mature societies.

---

## 6. Sensitivity Audits

| Sensitivity Dimension | Baseline Specification | Alternative Specifications Tested | Result & Impact on Findings |
| :--- | :--- | :--- | :--- |
| **Population Cutoff** | $\ge 1,000,000$ in 2000 ($N = 155$) | $\ge 500,000$ ($N = 168$) and $\ge 2,000,000$ ($N = 142$) | Cluster silhouette remains stable ($0.523–0.545$); regression $R^2$ remains between $0.798$ and $0.812$. |
| **Clustering Base Year** | Year 2000 baseline | Year 1990 and Year 2010 baselines | Adjusted Rand Index $> 0.91$; country cluster memberships are $> 94\%$ congruent. |
| **Clustering Algorithm** | Standardized $k$-Means ($k=3$) | Hierarchical Ward's D2 & Gaussian Mixture Models | Concordance with $k$-means exceeds $96.8\%$. |
| **Time Horizon** | Century 1950–2050 | Historical only (1950–2023) | 2000–2020 observed cluster shifts replicate identical $-26$ youth contraction and $+21$ aging surge. |

---

## 7. Open Science Repository Structure

```
asa-dataquest-2026/
├── README.md                                  # Master repository documentation
├── LICENSE                                    # MIT Open Source License
├── run_all.R                                  # One-click Master Reproducibility Script
├── MODEL_DIAGNOSTICS_AND_SUPPLEMENTARY_REPORT.md # This technical document
├── scripts/
│   ├── 00_data_audit_and_filtering.R          # Figure 1: Panel filtering & completeness audit
│   ├── 01_spatial_clustering_migration.R      # Figure 2: K-Means 3-Map grid migration
│   ├── 02_subreplacement_fertility_ratchet.R  # Figure 3: Sub-replacement crossing & McNemar test
│   ├── 03_econometric_drivers_and_diagnostics.R# Figure 4 & Figure 5: Regression & diagnostics
│   └── 04_bootstrap_crossover_analysis.R      # Bootstrap crossover simulation
├── figures/
│   ├── figure1_data_scope_and_audit.png       # Figure 1 (300 DPI)
│   ├── figure2_cluster_map_3grid.png          # Figure 2 (300 DPI)
│   ├── figure3_subreplacement_2000_2020_2040.png # Figure 3 (300 DPI)
│   ├── figure4_regression_life_expectancy.png # Figure 4 (300 DPI)
│   └── figure5_model_diagnostics.png          # Figure 5 (300 DPI)
├── tables/
│   ├── table1_data_completeness.csv           # Completeness audit metrics
│   ├── table2_cluster_migration_matrix.csv    # Cluster counts across 2000, 2020, 2040
│   ├── table3_subreplacement_benchmarks.csv   # Threshold percentages with Wilson CIs
│   ├── table4_regression_model_summary.csv    # OLS coefficient summary table
│   ├── table5_diagnostic_test_metrics.csv     # BP, SW, VIF, and Cook's D test outputs
│   └── table6_natural_decrease_crossover.csv  # Bootstrap crossover simulation metrics
└── presentation/
    ├── The_Silver_Tsunami_Final_Presentation.pptx # Final submitted PowerPoint deck
    └── The_Silver_Tsunami_Final_Presentation.pdf  # Final submitted Vector PDF
```

---

## 8. Authorship & Citation

**Team Data Architects:**
* **Awowole Uthman** (`uthmanawowole@gmail.com`)
* **Makinde Teslim** (`makindeteslim10@gmail.com`)
* **Ikeh Emmanuel (Lead)** (`emmanuelikeh2993@gmail.com`)
* **Soulaymane Aliyah** (`aliyahsoulaymane@gmail.com`)

**Affiliation:** Department of Statistics  
**Competition:** American Statistical Association (ASA) DataQuest 2026  
**License:** Publicly licensed under the MIT License for competition review and academic research.

