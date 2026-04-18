# PROSPERO Registration — Draft Fields

> Copy these fields into the PROSPERO online form at https://www.crd.york.ac.uk/prospero/

---

## 1. Review Title

Living Interactive Evidence Synthesis for Cardiorenal Pharmacotherapy: A Stratified Meta-Analysis and Health-Economic Evaluation of Finerenone, SGLT2 Inhibitors, and Steroidal MRAs

## 2. Anticipated or Actual Start Date

2024-01-01

## 3. Anticipated Completion Date

2026-12-31 (living review — ongoing updates planned)

## 4. Stage of Review at Registration

Data extraction completed. Analysis completed. Manuscript drafted.

> Note: PROSPERO accepts registration after data extraction is complete. Ideally, register before screening begins. For living reviews, retrospective registration is common and accepted.

## 5. Named Contact

[Your name and institutional email]

## 6. Review Team Members

[List all co-authors with affiliations]

## 7. Funding Sources

None.

## 8. Conflicts of Interest

None declared.

## 9. Collaborators

None.

---

## 10. Review Question

**Structured question (PICO):**

- **Population:** Adults with chronic kidney disease (CKD Stages 2–5), heart failure (HFrEF, HFpEF), diabetic kidney disease (DKD), or type 2 diabetes with established cardiovascular disease
- **Intervention:** Finerenone (non-steroidal MRA), SGLT2 inhibitors (dapagliflozin, empagliflozin, canagliflozin, ertugliflozin, sotagliflozin), or steroidal MRAs (spironolactone, eplerenone)
- **Comparator:** Placebo or standard of care
- **Outcomes:** (1) Composite cardiovascular endpoint (CV death + heart failure hospitalisation), (2) Renal composite endpoint, (3) All-cause mortality
- **Study design:** Phase III or IV randomised controlled trials

**Plain language summary:** This review compares the effectiveness of three classes of kidney/heart medications — finerenone, SGLT2 inhibitors, and older MRAs — in preventing cardiovascular and kidney events in patients with kidney disease or heart failure. It also evaluates cost-effectiveness using a health-economic model.

## 11. Searches

### Databases
- ClinicalTrials.gov (primary source)
- PubMed/MEDLINE
- Cochrane Central Register of Controlled Trials (CENTRAL)

### Search Strategy
ClinicalTrials.gov API v2 query:
```
query.term = Finerenone OR Mineralocorticoid OR Kidney Disease OR SGLT2 OR Heart Failure
filter.overallStatus = COMPLETED
aggFilters = results:with
```

PubMed search terms:
```
("finerenone" OR "SGLT2 inhibitor" OR "dapagliflozin" OR "empagliflozin" OR "canagliflozin"
OR "ertugliflozin" OR "sotagliflozin" OR "spironolactone" OR "eplerenone")
AND ("randomized controlled trial" OR "randomised controlled trial")
AND ("kidney" OR "renal" OR "heart failure" OR "cardiovascular")
```

### Date Range
1999 (RALES) to present (living review — no end date)

### Language
English

## 12. Condition or Domain

Chronic kidney disease, heart failure, diabetic kidney disease, type 2 diabetes with cardiovascular disease

## 13. Participants / Population

Adults (age >= 18) with CKD (Stages 2-5), heart failure (HFrEF or HFpEF), diabetic kidney disease, or type 2 diabetes with established or high-risk cardiovascular disease. No restrictions on sex, ethnicity, or geography.

**Exclusions:** Paediatric populations, acute kidney injury without CKD, Phase I/II dose-finding studies without clinical endpoints.

## 14. Intervention(s), Exposure(s)

- Finerenone (non-steroidal mineralocorticoid receptor antagonist)
- SGLT2 inhibitors: dapagliflozin, empagliflozin, canagliflozin, ertugliflozin
- Dual SGLT1/2 inhibitor: sotagliflozin (grouped with SGLT2i for class-level analysis)
- Steroidal MRAs: spironolactone, eplerenone

## 15. Comparator(s) / Control

Placebo or standard of care (including background RAS inhibition)

## 16. Types of Study to be Included

Phase III or IV randomised controlled trials reporting hazard ratios (or rate ratios) for at least one pre-specified outcome. Both double-blind and open-label designs included. Trials must have ≥500 participants.

## 17. Main Outcome(s)

1. **Composite cardiovascular endpoint:** CV death + heart failure hospitalisation (HR with 95% CI)
2. **Renal composite endpoint:** As defined by each trial (kidney-only or kidney + CV death) (HR with 95% CI)
3. **All-cause mortality** (HR with 95% CI)

## 18. Additional Outcome(s)

- Cumulative meta-analysis trajectory (chronological pooled HR evolution)
- Cost-effectiveness (ICER, $/QALY) via Markov model
- Probability of cost-effectiveness at WTP thresholds ($50K, $100K, $150K/QALY)
- Trial similarity via PCA-based distance metrics

## 19. Data Extraction

Trial-level aggregate data extracted from primary publications and ClinicalTrials.gov:
- Hazard ratio (or rate ratio), 95% confidence interval
- Sample size (N randomised)
- Population characteristics (mean age, proportion male, mean eGFR, publication year)
- Endpoint definitions (composite components, renal composite definition)
- Estimand type (hazard ratio vs. rate ratio)

Standard errors computed as: SE = (ln(upper) - ln(lower)) / 3.92

Extraction performed by [name]; verified against ClinicalTrials.gov registry records.

## 20. Risk of Bias (Quality) Assessment

Risk of bias was not formally assessed using the Cochrane RoB 2.0 tool for this version. All included trials are Phase III/IV multicentre RCTs published in high-impact peer-reviewed journals (NEJM, Lancet, EHJ). Future updates will incorporate RoB 2.0 assessment.

> Note: This is a limitation acknowledged in the manuscript. Reviewers may request RoB 2.0 assessment.

## 21. Strategy for Data Synthesis

**Meta-analysis method:** DerSimonian-Laird random-effects with weighted least squares, one-hot drug-class design matrix (stratified by drug class, not network meta-analysis). T-distribution confidence intervals. Prediction intervals per IntHout et al. (2016).

**Heterogeneity:** Within-class I² and Cochran's Q. Tau² estimated via DerSimonian-Laird moment estimator.

**Estimand handling:** Trials reporting rate ratios (recurrent-event models) are displayed but excluded from IV-weighted pooling. Trials with 3-point MACE composites (different from CV death + HHF) have their composite excluded.

**Cumulative meta-analysis:** Chronological ordering by publication year, IV-weighted pooled HR at each accumulation step with t-distribution CI.

**Subgroup analysis:** By drug class (primary stratification). By population (CKD, HF, DKD, T2DM+CVD) — exploratory.

**Publication bias:** Egger's weighted regression (1/SE vs. standardised effect). Limitation: test uses raw study-level HRs, not class-residualised effects.

**Health-economic analysis:** 3-state Markov model, 1,000-iteration PSA with seeded PRNG (xoshiro128**, seed=42).

## 22. Analysis of Subgroups or Subsets

- By drug class (finerenone, SGLT2i, steroidal MRA) — primary stratification
- By population (DKD, HFrEF, HFpEF, CKD, T2DM+CVD) — exploratory
- By renal endpoint definition (kidney-only vs. kidney+CV death) — sensitivity analysis
- By estimand type (HR only vs. HR + rate ratio) — sensitivity analysis

## 23. Type and Method of Review

Systematic review with meta-analysis. Living review design (planned periodic updates).

## 24. Language

English

## 25. Country

[Your country]

## 26. Other Registration Details

This review is implemented as an interactive browser-based evidence synthesis tool (CRES v4.0). The tool itself — containing all data, analysis code, and visualisations — is the primary deliverable and is available as supplementary material.

## 27. Reference / URL for Published Protocol

Not applicable (retrospective registration). The analysis protocol is embedded in the tool source code.

## 28. Dissemination Plans

Manuscript submitted to European Heart Journal — Digital Health. Tool freely available as open-access HTML file.

## 29. Keywords

living systematic review; meta-analysis; cardiorenal; finerenone; SGLT2 inhibitors; mineralocorticoid receptor antagonists; cost-effectiveness; digital health

## 30. Details of Any Existing Review of the Same Topic

Several meta-analyses exist for individual drug classes:
- Finerenone: Agarwal et al. (FIDELITY pooled analysis, Eur Heart J 2022)
- SGLT2i: Vaduganathan et al. (Lancet 2022) — pooled SGLT2i across HF spectrum
- Cross-class: No existing living interactive evidence synthesis platform covering all three drug classes simultaneously with integrated health-economic modelling.

---

## Instructions for Submission

1. Go to https://www.crd.york.ac.uk/prospero/
2. Create an account or log in
3. Click "Register a new review"
4. Copy the fields above into the corresponding form sections
5. Review and submit
6. You will receive a PROSPERO ID (e.g., CRD42026XXXXXX)
7. Add this ID to the manuscript Methods section and the CRES Methods tab
