# Replication Study: Adequacy of Diabetes Care for Older U.S. Rural Adults

This project replicates the study *"Adequacy of diabetes care for older U.S. rural adults: a cross-sectional population-based study using 2009 BRFSS data"* by Lutfiyya et al. (2011). Using the 2009 Behavioral Risk Factor Surveillance System (BRFSS) dataset, I reproduced the original analysis using STATA and assessed the validity of the published findings.

Additionally, I extended the study by conducting a parallel analysis using the 2019 BRFSS dataset to evaluate how diabetes care patterns have evolved over a 10-year period.

---

### Objectives
- Replicate the original 2009 analysis to verify the reproducibility of published results.
- Compare diabetes care indicators between 2009 and 2019 among older rural adults.
- Identify trends or shifts in healthcare adequacy over time.

---

### Tools Used
- STATA 18
- BRFSS datasets (2009, 2019)

---

### File Structure

- `do-files/`
  - `brfss_analysis_2009.do`: STATA code for replicating the 2009 study
  -  `brfss_analysis_2019.do`: STATA code for additional 2019 analysis
- `output/`
  - `brfss_analysis_2009.txt`: Log file with output from 2009 analysis
  - `brfss_analysis_2019.txt`: Log file with output from 2019 analysis
- `README.md`: Project overview and documentation

---

### Key Findings

- My replication showed that the results from the original 2009 Lutfiyya et al. paper were largely reproducible using the same BRFSS dataset and methods.
- However, when I repeated the analysis using 2019 BRFSS data to examine changes after 10 years, we found that rural U.S. adults continued to experience disparities in diabetes care—and, in some cases, these disparities had worsened.
- Specifically, the odds of rural adults receiving less than adequate diabetes care were higher in 2019 compared to 2009.
- Older adults in rural areas had higher odds of deferring medical care due to cost and of not having a healthcare provider. Notably, the odds of not having a healthcare provider were significantly higher in 2019 than in 2009.

---

### Note on Data

The BRFSS datasets used in this analysis are publicly available from the CDC. Please visit the [CDC BRFSS site](https://www.cdc.gov/brfss/) to download the data directly.

---

### Contact

For questions about this project or access to code files, feel free to reach out via email at eshakothapalli@gmail.com. 

