# intersectymh-mcs8

## Overview

This repository contains the code used for the analyses reported in _Intersectional inequalities in youth mental health measurement and outcomes: population-representative evidence from the UK Millennium Cohort Study_, by Darío Moreno-Agostino et al. 

The study was preregistered and deposited as a preprint in the Open Science Framework (OSF):

- Preregistered protocol: https://doi.org/10.17605/OSF.IO/U89GR
- Preprint: to be included

The study investigates social and intersectional inequalities in multiple mental health outcomes among young adults participating in the UK Millennium Cohort Study (MCS) age 23 sweep. Specifically, the analyses:

- Examine whether commonly used measures of psychological distress and wellbeing operate equivalently across social and intersectional groups.
- Quantify inequalities in psychological distress, probable serious psychological distress ("caseness"), wellbeing, self-harm, and suicide attempts.
- Investigate both additive and non-additive (intersectional) patterns of inequality using Intersectional Multilevel Analysis of Individual Heterogeneity and Discriminatory Accuracy (I-MAIHDA).
- Assess the robustness of findings to potential mode and selection effects using quantitative bias analysis (QBA).


## Data availability

The analyses use data from the **Millennium Cohort Study (MCS)**.

MCS data are available, free of charge, to bona fide researchers through the UK Data Service: https://doi.org/10.5255/UKDA-Series-2000031

This repository does **not** contain participant-level data.


## Software requirements

Analyses were conducted using:

- Stata/MP 19.5
- Mplus 9.1

The repository contains both Stata (`.do`) and Mplus (`.inp`) scripts.


# Analytical workflow

Scripts should be run sequentially in the order described below.

## 1. Data management

### Stata 1: Data preparation and variable construction (Stata/1 data management.do)

**Purpose**

Creates the analysis-ready dataset used throughout the project.

**Main tasks**

- Imports and harmonises MCS data across survey sweeps.
- Constructs all study outcomes.
- Creates social identity and social position variables.
- Derives childhood poverty indicators.
- Produces datasets for descriptive analyses.

## 2. Descriptive analyses and preparation for Mplus

### Stata 2a: Descriptive statistics and Mplus dataset creation (Stata/2a descriptives strata and Mplus datasets.do)

**Purpose**

Produces descriptive summaries and prepares datasets for measurement invariance analyses in Mplus.

**Main tasks**

- Generates weighted descriptive statistics.
- Produces descriptive estimates for outcomes and key social variables.
- Creates grouping variables required for invariance testing, including intersectional strata.
- Exports datasets in formats required for Mplus.

### Stata 2b: Descriptive figures (Stata/2b descriptive graphs.do)

**Purpose**

Creates descriptive visualisations used in the manuscript and supplementary material.

**Main tasks**

- Produces outcome distributions.
- Creates descriptive comparisons across social identities and positions.
- Generates supplementary descriptive figures.

## 3. Measurement invariance/equivalence testing

The invariance workflow proceeds from broad tests of comparability to more detailed analyses where evidence of non-invariance is identified.

### Mplus 1: Configural models (Mplus/1 Configural/configural_outcome.inp)

**Purpose**

Establishes the baseline measurement models.

**Main tasks**

- Fits confirmatory factor models for each `outcome` (Kessler-6 and SWEMWBS).
- Evaluates overall model fit.

### Mplus 2: Alignment analyses (Mplus/2 Alignment/outcome_strata.inp)

**Purpose**

Evaluates approximate measurement invariance for each `outcome` and across the different `strata` (social and intersectional groups).

**Main tasks**

- Implements alignment optimisation procedures.
- Estimates the proportion of non-invariant measurement parameters.
- Identifies outcome * strata conditions requiring further investigation.

### Mplus 3: Multiple-group CFA and partial invariance models (Mplus/3 MG-CFA/outcome_strata_models.inp)

**Purpose**

Investigates and accounts for substantial measurement non-invariance for each `outcome`, across the different `strata` under study, and across different `models`. Scripts names include the number before a naming convention for the model showcasing the order in which they were implemented. The workflow would typically include the following steps:

- First, the Mplus shortcut function to test for measurement invariance was used ("conf_metric_scalar").
- Where issues were detected, modification indices at the specific invariance level were explored ("metric_modind" or "scalar_modind").
- If multiple rounds of modification indices were explored, these are noted as "_mi2" and numbered after the first round.
- Once the required measurement parameters were freed, a partial invariant model was estimated ("metric_part", "scalar_part", or "metric_part_scalar_part" if both loadings and intercepts were freed). 

**Main tasks**

- Fits multiple-group confirmatory factor analysis (MG-CFA) models.
- Examines increasingly granular combinations of social and intersectional groups.
- Identifies non-invariant loadings and intercepts.
- Estimates partial measurement invariance models.
- In the models using the most granular combinations tested, generates partially invariant factor scores for use in the main analyses.

## 4. Main I-MAIHDA analyses

### Stata 3: I-MAIHDA models (Stata/3 I-MAIHDA models.do)

**Purpose**

Runs the primary models reported in the manuscript. The results from these models are saved and used in the next scripts to obtain model-wide and stratum-specific estimates.

**Main tasks**

- Fits intercept-only (null) I-MAIHDA models.
- Fits main-effects I-MAIHDA models.

## 5. Post-estimation

### Stata 4a: Model-wide tables and coefficients (Stata/4a I-MAIHDA model-wide tables and coeffplots.do)

**Purpose**

Generates model-wide outputs reported in the manuscript and appendices.

**Main tasks**

- Produces coefficient tables.
- Extracts main/additive effects.
- Obtains and tabulates VPC and PCV estimates.

### Stata 4b: Stratum-specific prediction tables (4b I-MAIHDA stratum-specific predictions table.do)

**Purpose**

Produces detailed results for individual intersectional strata.

**Main tasks**

- Generates predicted means and probabilities at each intersectional strata.
- Produces ranked stratum-level outputs.
- Applies disclosure-control suppression where required.

### Stata 4c: Stratum-specific figures (4c I-MAIHDA stratum-specific graphs.do)

**Purpose**

Creates visualisations of intersectional inequalities.

**Main tasks**

- Produces caterpillar plots of predicted outcome levels.
- Produces caterpillar plots of random (non-additive) effects.
- Generates combined figures reported in the manuscript and supplementary material.

## 6. Quantitative bias analysis (QBA)

### Stata 5: QBA mode-effect analyses (5 I-MAIHDA QBA mode effects.do)

**Purpose**

Evaluates the robustness of findings to potential survey mode differences and selection effects.

**Main tasks**

- Implements quantitative bias analysis (QBA) scenarios.
- Simulates potential mode effects between online and face-to-face respondents.
- Re-estimates I-MAIHDA models under alternative assumptions.
- Produces combined visualisations with results from across scenarios.

# Repository structure

```text
intersectymh-mcs8/
│
├── Stata/
│   ├── 1 data management
│   ├── 2a descriptives strata and Mplus datasets
│   ├── 2b descriptive graphs
│   ├── 3 I-MAIHDA models
│   ├── 4a I-MAIHDA model-wide tables and coeffplots
│   ├── 4b I-MAIHDA stratum-specific predictions table
│   ├── 4c I-MAIHDA stratum-specific graphs
│   └── 5 I-MAIHDA QBA mode effects
│
├── Mplus/
│   ├── 1 Configural
│   ├── 2 Alignment
│   └── 3 MG-CFA
│
└── README.md
```

## Reproducibility notes

The scripts were developed using MCS data held under a UK Data Service licence. Users will need to:

1. Obtain access to the required MCS datasets.
2. Update local file paths within the scripts.
3. Run scripts in the order described above.
4. Ensure that both Stata and Mplus are installed and accessible from their computing environment.

## Acknowledgements

Parts of the Stata code used for the I-MAIHDA analyses were adapted from Evans, C.R., Leckie, G., Subramanian, S.V., Bell, A., & Merlo, J. (2024). *A Tutorial for Conducting Intersectional Multilevel Analysis of Individual Heterogeneity and Discriminatory Accuracy (MAIHDA).* SSM - Population Health. https://doi.org/10.1016/j.ssmph.2024.101664

The original code was modified and extended for the purposes of this study, including adaptations for survey weighting, measurement invariance workflows, stratum-specific prediction procedures, analyses with count variables, figure generation, and quantitative bias analyses.

## Citation

If you use this repository, please cite the associated manuscript.

## License

This repository is licensed under the GNU General Public License v3.0 (GPL-3.0).

You are free to use, modify, and redistribute this code under the terms of the GPL-3.0 licence. Any derivative works must also be distributed under the GPL-3.0 licence and accompanied by source code.

See the [LICENSE](LICENSE) file for the full licence text.
