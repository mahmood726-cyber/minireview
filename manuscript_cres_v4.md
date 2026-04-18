# CRES: A Living Interactive Evidence Synthesis Platform for Cardiorenal Pharmacotherapy

**Running title:** CRES — CardioRenal Evidence Synthesizer

**Target journal:** European Heart Journal — Digital Health (EHJ:DH)

**Word count:** ~3,500 (excluding references, tables, figures)

---

## Abstract

**Aims.** Living systematic reviews promise continuously updated evidence, yet few tools exist for transparent, reproducible, zero-installation evidence synthesis in cardiorenal pharmacotherapy. We developed CRES (CardioRenal Evidence Synthesizer), a browser-based platform that integrates stratified meta-analysis, cumulative meta-analysis, patient geometry mapping, and health-economic simulation in a single HTML file requiring no server infrastructure.

**Methods and Results.** CRES v4.0 curates 20 randomised controlled trials (N = 135,245 participants) spanning three drug classes — finerenone (non-steroidal MRA), SGLT2 inhibitors, and steroidal MRAs — across CKD, heart failure, and T2DM+CVD populations. The platform implements DerSimonian–Laird random-effects meta-analysis with t-distribution confidence intervals, SVD-based principal component analysis for trial similarity mapping, a 3-state Markov model for cost-effectiveness estimation, and 1,000-iteration probabilistic sensitivity analysis with seeded pseudo-random number generation (xoshiro128**). Cumulative meta-analysis demonstrates how pooled hazard ratios evolve chronologically from RALES (1999) through FINEARTS-HF (2024), enabling users to visualise evidence accrual in real time. For the composite endpoint (CV death + heart failure hospitalisation), pooled HRs were: SGLT2i 0.79 (95% CI 0.73–0.86, 5 trials), Finerenone 0.87 (0.73–1.02, 2 trials), Steroidal MRA 0.63 (0.54–0.74, 1 trial). The deterministic ICER for finerenone versus status quo was $890,844/QALY with P(cost-effective) = 0% at all standard willingness-to-pay thresholds ($50K–$150K/QALY), reflecting the current pricing landscape.

**Conclusion.** CRES demonstrates that transparent, interactive evidence synthesis can be delivered as a single portable file with full methodological reproducibility. The finding that finerenone is not cost-effective at current pricing, surfaced without bias by the platform itself, illustrates the value of neutral evidence synthesis tools. CRES is freely available as an open-access HTML file.

**Keywords:** living evidence synthesis; meta-analysis; cardiorenal; finerenone; SGLT2 inhibitors; cost-effectiveness; digital health tool

---

## 1. Introduction

The cardiorenal pharmacotherapy landscape has expanded rapidly since the landmark RALES trial (1999), with SGLT2 inhibitors, non-steroidal mineralocorticoid receptor antagonists (MRAs), and steroidal MRAs demonstrating varying degrees of efficacy across chronic kidney disease (CKD), heart failure (HF), and type 2 diabetes (T2DM) populations.^1–4^ The ESC 2023 Focused Update gives MRA therapy a Class I recommendation for HFrEF and finerenone a Class I recommendation for DKD with T2DM.^5^ The KDIGO 2024 CKD guideline recommends a layered approach: first-line RASi plus SGLT2i, with finerenone considered when albuminuria persists.^6^

Despite this expanding evidence base, clinicians and health-technology assessment bodies face fragmented data across heterogeneous trial populations, inconsistent composite endpoint definitions, and rapidly evolving trial results. Living systematic reviews — continuously updated syntheses with pre-specified search and analysis protocols — have been proposed to address evidence currency,^7^ but implementation remains challenging: most require server infrastructure, proprietary software, and dedicated analyst teams.

We developed CRES (CardioRenal Evidence Synthesizer), a browser-based living interactive evidence synthesis platform that runs entirely within a single HTML file. CRES integrates stratified meta-analysis, cumulative meta-analysis, principal component analysis for trial similarity, and probabilistic cost-effectiveness analysis, all with no installation, no server dependency, and full source-code transparency.

---

## 2. Methods

### 2.1 Trial Registry

CRES v4.0 curates 20 randomised controlled trials identified from ClinicalTrials.gov and published literature (Table 1). Eligible trials were Phase III or IV randomised controlled trials of finerenone, SGLT2 inhibitors, or steroidal MRAs reporting hazard ratios for at least one of three outcomes: composite (CV death + HF hospitalisation), renal composite, or all-cause mortality. Trials reporting rate ratios from recurrent-event models (FINEARTS-HF, SCORED, SOLOIST-WHF) were retained in the registry but excluded from inverse-variance weighted pooling due to incompatible estimands. Trials with 3-point MACE as the sole composite (EMPA-REG OUTCOME, CANVAS Program, VERTIS-CV) had their composite excluded from pooling to avoid endpoint heterogeneity; mortality data were included where available.

Trial-level data (hazard ratios, 95% confidence intervals, sample sizes, population characteristics) were extracted from the primary publication of each trial and verified against ClinicalTrials.gov registry records. NCT identifiers are provided for all trials.

### 2.2 Stratified Meta-Analysis

Drug-class effects were estimated using DerSimonian–Laird random-effects meta-analysis via weighted least squares (WLS) with a one-hot drug-class design matrix.^8^ This approach is equivalent to stratified meta-analysis against a common comparator (placebo/standard of care) and does not involve indirect comparisons between active treatments. Standard errors were derived from published 95% CIs as SE = (ln(upper) − ln(lower)) / 3.92. Confidence intervals use the t-distribution (not z) for finite-sample correction. Prediction intervals follow IntHout, Ioannidis, and Rovers (2016), with per-class degrees of freedom (df = k_j − 2).^9^ Heterogeneity is reported as residual within-class I² and Cochran's Q.

### 2.3 Cumulative Meta-Analysis

For the "living" evidence visualisation, trials within each drug class are ordered chronologically by publication year. At each accumulation step k, the IV-weighted pooled hazard ratio is computed using DerSimonian–Laird random-effects. Confidence intervals use the t-distribution with df = k − 1; at k = 1, the normal quantile is used as the t-distribution with 0 degrees of freedom is degenerate. This allows users to observe how the pooled estimate evolves and stabilises as evidence accrues.

### 2.4 Principal Component Analysis

Trial similarity is assessed via SVD-based eigendecomposition on Z-score standardised features: mean age, proportion male, mean eGFR, and publication year.^10^ Trial-to-profile distance is computed as L2 (Euclidean) distance in the full 4-dimensional PC space, enabling identification of trials most relevant to a given patient profile.

### 2.5 Health-Economic Model

A 3-state competing-risks Markov model (Stable CKD → ESRD → Dead) with quarterly cycles, 10-year horizon, and half-cycle correction (Sonnenberg–Beck) was implemented.^11^ Base mortality: 6%/year (Go et al. 2004, CKD Stage 3 average). ESRD mortality multiplier: 3×. Drug cost: $8,500/year (US Kerendia WAC). ESRD cost: $90,000/year (USRDS 2024). Utilities: stable CKD 0.85 (Sullivan 2011), ESRD 0.58 (Gorodetskaya 2005). Discount rate: 3.5% (NICE TA convention).

### 2.6 Probabilistic Sensitivity Analysis

PSA was conducted with 1,000 Monte Carlo iterations using a seeded pseudo-random number generator (xoshiro128**, seed = 42) for full reproducibility. Parameter distributions: Beta (transition rates, utilities), Gamma (costs), Lognormal (hazard ratios, incorporating between-study τ² from the meta-analysis). Cost-effectiveness acceptability curves (CEACs) were derived via the net monetary benefit criterion (pairwise versus status quo).

### 2.7 Technical Implementation

CRES is implemented as a single HTML file (~2,200 lines) containing all HTML, CSS, and JavaScript. External dependencies (Plotly.js, vis-network, Tailwind CSS, math.js) are loaded via CDN with Subresource Integrity (SRI) hashes. The application includes Content Security Policy headers, input whitelisting, HTML entity escaping, and WCAG 2.5.8-compliant touch targets (≥44px). The source code serves simultaneously as the data repository — all trial-level data are embedded in a structured JavaScript object (TRIAL_REGISTRY) viewable via browser "View Source."

### 2.8 Publication Bias Assessment

Egger's weighted regression of standardised effects on precision (1/SE) was used, with t-distribution p-value (df = n − 2). Limitation: this test uses raw study-level HRs, not class-residualised effects; systematic differences between drug classes may confound the assessment.

---

## 3. Results

### 3.1 Trial Registry

The CRES v4.0 registry contains 20 trials enrolling 135,245 participants across three drug classes: finerenone (2 trials for composite, 2 for renal), SGLT2 inhibitors (5 for composite, 3 for renal, 7 for mortality), and steroidal MRAs (2 for composite, 3 for mortality). Publication years range from 1999 (RALES) to 2024 (FINEARTS-HF). Three trials (FINEARTS-HF, SCORED, SOLOIST-WHF) report rate ratios and are displayed but excluded from IV-weighted pooling. Three CVOT trials (EMPA-REG OUTCOME, CANVAS Program, VERTIS-CV) have 3-point MACE composites excluded from pooling; mortality data are included.

### 3.2 Stratified Meta-Analysis

**Composite endpoint (CV death + HHF):** Pooled HR was 0.79 (95% CI 0.73–0.86) for SGLT2i (5 trials), 0.87 (0.73–1.02) for Finerenone (2 trials, not significant), and 0.63 (0.54–0.74) for Steroidal MRA (1 trial). Within-class heterogeneity: I² = 50.3%, Q p = 0.060.

**Renal endpoint:** Pooled HR was 0.67 (0.62–0.73) for SGLT2i and 0.84 (0.77–0.92) for Finerenone. Notably, SGLT2i trials define the renal composite to include CV death (kidney_cv_death), while finerenone trials use kidney-only endpoints — this definitional asymmetry may inflate the apparent SGLT2i advantage.

**All-cause mortality:** Pooled HR was 0.84 (0.78–0.90) for SGLT2i and 0.78 (0.68–0.89) for Steroidal MRA.

Egger's test for the composite endpoint was non-significant (p = 0.248), though the test has known limitations with heterogeneous drug-class structures.

### 3.3 Cumulative Meta-Analysis

The cumulative meta-analysis for SGLT2i composite endpoints shows progressive narrowing of the confidence interval from 2019 (DECLARE-TIMI 58 alone, 1 trial) through 2022 (DELIVER, 5 trials). The pooled SGLT2i HR stabilised around 0.79 by the fourth trial accumulation, suggesting evidence maturity for this drug class and outcome.

### 3.4 Patient Geometry

PCA on the four features explains 50.6% (PC1) and 21.9% (PC2) of variance. The DKD target profile (age 66, eGFR 44) clusters nearest to FIDELIO-DKD and CREDENCE. The HFpEF profile (age 72, eGFR 55) clusters nearest to EMPEROR-Preserved and DELIVER.

### 3.5 Health-Economic Analysis

**Deterministic analysis:** The ICER for finerenone versus status quo was $890,844/QALY, substantially exceeding standard willingness-to-pay thresholds. The SGLT2i universal strategy yielded an ICER of $130,667/QALY, within the $50K–$150K range.

**PSA (1,000 iterations):** Mean ICER for finerenone was $1,005,607/QALY. P(cost-effective) was 0.0% at all thresholds ($50K, $100K, $150K/QALY). The CEAC was flat at 0% across the entire WTP range, driven by the high drug cost relative to the modest renal HR benefit (0.84) and absence of pooled mortality benefit.

---

## 4. Discussion

### 4.1 Principal Findings

CRES demonstrates that a fully functional, transparent, and reproducible evidence synthesis platform can be delivered as a single portable HTML file. The platform surfaces several clinically relevant findings: (1) SGLT2 inhibitors show the most robust composite endpoint benefit (HR 0.79, 5 trials), (2) finerenone's composite benefit does not reach statistical significance with only 2 trials, and (3) finerenone is not cost-effective at current US pricing — a finding the platform surfaces without bias.

### 4.2 Comparison with Existing Approaches

Traditional meta-analysis software (RevMan, Stata, R metafor) requires installation, programming expertise, and manual data management. Web-based tools (MetaInsight, CINeMA) offer more accessibility but still require server infrastructure. CRES occupies a distinct niche: a self-contained, versionable, auditable evidence synthesis that can be emailed, hosted on any web server, or opened directly from disk.

The cumulative meta-analysis feature aligns with the living systematic review paradigm^7^ but with important caveats: CRES does not implement pre-specified update triggers, stopping rules, or formal evidence stabilisation assessment. It should be understood as a visualisation and analysis tool that facilitates living evidence monitoring, not a substitute for a fully registered living review protocol.

### 4.3 Methodological Considerations

The stratified meta-analysis approach pools within drug classes against a common comparator. This avoids the assumptions of network meta-analysis (transitivity, consistency) but cannot estimate relative effects between active treatments. The one-hot design matrix with shared τ² assumes homogeneous between-study variance across classes — a simplification acknowledged in the limitations.

Rate ratio trials (FINEARTS-HF, SCORED, SOLOIST-WHF) are displayed but excluded from IV-weighted pooling. This is conservative: including rate ratios alongside hazard ratios would violate estimand homogeneity. The cardiorenal scatter plot is currently sparse (2 qualifying trials) but will become more informative as dual-outcome reporting becomes more common.

### 4.4 Implications for Practice

The P(cost-effective) = 0% finding for finerenone should be interpreted in context: it reflects current US Kerendia pricing ($8,500/year) and does not account for potential price reductions, value-based contracts, or non-US health systems with different cost structures. The SGLT2i universal strategy shows more favourable economics (ICER $130,667/QALY), consistent with their lower drug cost and broader evidence base.

### 4.5 Limitations

Key limitations include: (1) composite endpoint definitions vary across trials (CV death+HHF vs. kidney composite ± CV death); (2) renal endpoint definitions differ between drug classes; (3) populations are clinically heterogeneous; (4) the health-economic model uses US-centric parameters; (5) base mortality (6%/year) underestimates HF subgroup mortality; (6) TOPCAT uses the overall ITT result rather than the Americas subgroup; (7) no GRADE certainty assessment was performed; (8) Egger's test may be confounded by drug-class structure; (9) sotagliflozin is a dual SGLT1/2 inhibitor grouped with SGLT2i.

---

## 5. Conclusion

CRES provides a paradigm for transparent, reproducible, zero-installation evidence synthesis in cardiorenal pharmacotherapy. By embedding data, analysis code, and visualisation in a single auditable file, it enables rapid evidence assessment without server infrastructure or programming expertise. The platform's honest surfacing of cost-effectiveness findings — including unfavourable results — demonstrates the value of neutral evidence synthesis tools in the era of living evidence.

---

## Data Availability

All trial-level data are embedded in the CRES source code (TRIAL_REGISTRY JavaScript object). The HTML file, Selenium test suite (153 tests), and this manuscript are available at [repository URL]. No individual patient data were used.

---

## Funding

None declared.

## Conflicts of Interest

None declared.

---

## References

1. Bakris GL, Agarwal R, Anker SD, et al. Effect of finerenone on chronic kidney disease outcomes in type 2 diabetes. *N Engl J Med*. 2020;383:2219-2229. (FIDELIO-DKD)
2. Pitt B, Filippatos G, Agarwal R, et al. Cardiovascular events with finerenone in kidney disease and type 2 diabetes. *N Engl J Med*. 2021;385:2252-2263. (FIGARO-DKD)
3. McMurray JJV, Solomon SD, Inzucchi SE, et al. Dapagliflozin in patients with heart failure and reduced ejection fraction. *N Engl J Med*. 2019;381:1995-2008. (DAPA-HF)
4. Heerspink HJL, Stefánsson BV, Correa-Rotter R, et al. Dapagliflozin in patients with chronic kidney disease. *N Engl J Med*. 2020;383:1436-1446. (DAPA-CKD)
5. McDonagh TA, Metra M, Adamo M, et al. 2023 Focused Update of the 2021 ESC Guidelines for the diagnosis and treatment of acute and chronic heart failure. *Eur Heart J*. 2023;44:3627-3639.
6. Kidney Disease: Improving Global Outcomes (KDIGO) CKD Work Group. KDIGO 2024 Clinical Practice Guideline for the Evaluation and Management of Chronic Kidney Disease. *Kidney Int*. 2024;105(4S):S117-S314.
7. Thomas J, Noel-Storr A, Marshall I, et al. Living systematic reviews: 2. Combining human and machine effort. *J Clin Epidemiol*. 2017;91:31-37.
8. DerSimonian R, Laird N. Meta-analysis in clinical trials. *Control Clin Trials*. 1986;7:177-188.
9. IntHout J, Ioannidis JP, Rovers MM, Goeman JJ. Plea for routinely presenting prediction intervals in meta-analysis. *BMJ Open*. 2016;6:e010247.
10. Jolliffe IT, Cadima J. Principal component analysis: a review and recent developments. *Philos Trans A Math Phys Eng Sci*. 2016;374:20150202.
11. Sonnenberg FA, Beck JR. Markov models in medical decision making. *Med Decis Making*. 1993;13:322-338.
12. Wiviott SD, Raz I, Bonaca MP, et al. Dapagliflozin and cardiovascular outcomes in type 2 diabetes. *N Engl J Med*. 2019;380:347-357. (DECLARE-TIMI 58)
13. Neal B, Perkovic V, Mahaffey KW, et al. Canagliflozin and cardiovascular and renal events in type 2 diabetes. *N Engl J Med*. 2017;377:644-657. (CANVAS Program)
14. Cannon CP, Pratley R, Dagogo-Jack S, et al. Cardiovascular outcomes with ertugliflozin in type 2 diabetes. *N Engl J Med*. 2020;383:1425-1435. (VERTIS-CV)
15. Pitt B, Zannad F, Remme WJ, et al. The effect of spironolactone on morbidity and mortality in patients with severe heart failure. *N Engl J Med*. 1999;341:709-717. (RALES)
16. Solomon SD, McMurray JJV, Vaduganathan M, et al. Finerenone in heart failure with mildly reduced or preserved ejection fraction. *N Engl J Med*. 2024;391:1475-1485. (FINEARTS-HF)

---

## Tables

**Table 1.** Trial registry characteristics (20 trials, N = 135,245). [To be formatted as journal table with columns: Trial Name, NCT ID, Drug Class, Population, N, Year, Composite HR (95% CI), Renal HR (95% CI), Mortality HR (95% CI), Estimand, Notes]

---

## Figures

**Figure 1.** PRISMA 2020 flow diagram showing trial identification and selection.

**Figure 2.** Forest plot of pooled hazard ratios by drug class for the composite endpoint (CV death + HHF).

**Figure 3.** Cumulative meta-analysis showing chronological evidence accrual for SGLT2i composite endpoint.

**Figure 4.** PCA-based trial similarity map with target patient profile overlay.

**Figure 5.** Cost-effectiveness acceptability curves from 1,000-iteration PSA.

**Figure 6.** Screenshot of the CRES v4.0 interface showing the four analysis tabs.

---

## Supplementary Material

**Supplementary File 1.** CRES v4.0 HTML file (fin.html) — the complete, executable evidence synthesis platform.

**Supplementary File 2.** Selenium test suite (test_fin_selenium.py) — 153 automated end-to-end tests.
