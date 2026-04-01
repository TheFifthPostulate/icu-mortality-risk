# Interpretable ICU mortality risk modeling and survival analysis using probabilistic modeling

## Project Overview

This project develops interpretable mortality risk models using ICU electronic health record (EHR) data from the MIMIC-IV database. Instead of using black-box models alone, the approach constructs a population-relative probabilistic risk score and decomposes patient risk into physiologic components. Survival analysis is then used to model time-to-event risk. The project demonstrates skills in clinical data extraction, data harmonization, statistical modeling, machine learning, survival analysis using real-world healthcare data, and AI-assisted development and prototyping.  
  
The project combines probabilistic modeling, machine learning, and survival analysis to study how mortality risk evolves after the first 24 hours of ICU admission and compares the approach against established ICU severity scores.  

This project uses the Evidence Geometry probabilistic framework developed here:
[https://github.com/TheFifthPostulate/evidence-geometry](https://github.com/TheFifthPostulate/evidence-geometry)  

## Data Sources

Data source: MIMIC-IV ICU database  
Features: 24-hour aggregated vitals, laboratory measurements, gcs, and demographics  
Outcome: Mortality and time-to-death after 24-hour landmark  
Benchmark models: SOFA, SAPS II, OASIS, APS III, LODS, SIRS  

## Pipeline Overview
   
Analytical pipeline:  
  
1. Extract ICU cohort and clinical measurements using SQL (BigQuery)
2. Perform data harmonization across multiple clinical tables
3. Aggregate vitals, labs, and gcs over first 24 hours
4. Perform data cleaning and feature engineering
5. Split data into Train / Validation / Test sets
6. Fit marginal likelihood models on training data
7. Transform features into log-likelihood ratio (LLR) evidence space
8. Construct population-relative risk metric (d_dist)
9. Train Random Forest model for predictive comparison
10. Perform population-relative risk stratification
11. **Physiologic Interpretation:** Group features according to measurment type and report top contributors to total positive evidence
12. Perform survival analysis (Kaplan–Meier, Cox models)
13. Benchmark against ICU severity scores

Engineered Features:  
Number of measurements, measurement missing indicator, min, max, mean, median, IQR, early mean (before 12h), late mean (after 12h), Number occurrences below safe lower bound for measurement, Number occurrences above safe upper bound for measurement, Number in low/med/high bins, Measurement entropy using counts in low/med/high bins, Fraction of occurrences below safe lower bound, and Fraction of occurrences above safe upper bound  
  
Methods used:

- SQL / BigQuery for cohort extraction and feature construction
- R for statistical modeling and analysis
- Probabilistic modeling
- Machine learning (Random Forest)
- Survival analysis (Kaplan–Meier, Cox proportional hazards)
- Risk stratification and selective classification
- AI/LLM-assisted rapid protyping and documentation

## Key Results

### Risk Score Distribution

#### Density plot of population-relative risk score d_dist
![Density plot of population-relative risk score d_dist](plots/d_dist_dens_val.png)    
  
#### Density plot of Random Forest Probability of mortality
![Density plot of Random Forest Probability of mortality](plots/rf_dens_val.png)  

#### AUROC and AUPRC

![AUROC and AUPRC](plots/auroc_auprc.png)  
  
### d_dist and RF p vs Mortality Rate

![d_dist vs Mortality Rate](plots/d_dist_mort_rate_val.png)   
  
### Primary Risk Stratification (population-relative, Test Set)
Low Risk : d_dist < 0  
Ambiguous Risk : 0 <= d_dist < 2  
High Risk : d_dist >= 2  

![Primary Risk Stratification Table (Test Set)](plots/primary_risk_strat.png)  

### Kaplan-Meier Curves by d_dist Risk Group

![Kaplan-Meier Curves by d_dist Risk Group](plots/d_dist_survminer_km_plot.png)  

  
### Cox Regression Model using evidence geometry

Model : log-Hazard Ratio \~ Spline(d_dist) + Measurement Groups  
  
Measurement Groups were created by adding positive evidence (log-likelihood ratios) of all features within every measurement type such as resp_rate, spo2, etc.  

#### Kaplan-Meier Curves of Cox Regression Model by quantiles of Log-Hazard Ratio (0-25%, 25-50%, 50-75%, 75-100%)  
![Kaplan-Meier Curves of Cox Regression Model by quantiles of Log-Hazard Ratio (0-25%, 25-50%, 50-75%, 75-100%)](plots/cox_spline_survminer_km_plot.png)  
 
#### d_dist vs Log-Hazard Ratio
  
![d_dist vs Log-Hazard Ratio](plots/d_dist_hazard.png)  

#### Survival Curves by d_dist group

![Survival Curves by d_dist group](plots/surv_curves_group.png)  
  
### Comparision with ICU Severity Scores

![Benchmarking evidence geometry against ICU severity scores](plots/survival_analysis_table.png)   

![Concordance Plot](plots/concordance_plot.png)  
  
![TimeROC Plot](plots/timeROC_plot.png)  
  
### Risk Decomposition

#### Example : Survived Patient, Low Risk

#### Survival Curve

![Survival Curve](plots/surv_curve_0.png)
  
#### Total positive evidence and dominant measurement groups 

![Total positive evidence and dominant measurement groups](plots/mort_0_risk_decomp.png)  

#### Hazard Ratio Decomposition 
  
![Hazard Ratio Decomposition](plots/mort_0_hr_decomp.png)  
 
  
#### Example : Deceased Patient, High Risk

#### Survival Curve

![Survival Curve](plots/surv_curve_1.png)
  
#### Total positive evidence and dominant measurement groups 

![Total positive evidence and dominant measurement groups](plots/mort_1_risk_decomp.png)  
  
#### Hazard Ratio Decomposition
  
![Hazard Ratio Decomposition](plots/mort_1_hr_decomp.png)    
 
## Key Takeaways
- Population-relative risk score d_dist strongly stratifies mortality risk
- Survival models based on interpretable risk features perform comparably or better than ICU severity scores
- Risk can be directly decomposed into physiologic drivers and feature-level contributions

## Future Work
  
External validation on eICU subsets.  

## References

- Johnson, A., Bulgarelli, L., Pollard, T., Gow, B., Moody, B., Horng, S., Celi, L. A., & Mark, R. (2024). MIMIC-IV (version 3.1). PhysioNet. RRID:SCR_007345. https://doi.org/10.13026/kpb9-mt58  
  
- Johnson, A.E.W., Bulgarelli, L., Shen, L. et al. MIMIC-IV, a freely accessible electronic health record dataset. Sci Data 10, 1 (2023). https://doi.org/10.1038/s41597-022-01899-x  
  
- Goldberger, A., Amaral, L., Glass, L., Hausdorff, J., Ivanov, P. C., Mark, R., ... & Stanley, H. E. (2000). PhysioBank, PhysioToolkit, and PhysioNet: Components of a new research resource for complex physiologic signals. Circulation [Online]. 101 (23), pp. e215–e220. RRID:SCR_007345.  
  
- [https://zenodo.org/records/15272720](https://zenodo.org/records/15272720)  
  
- Alistair E W Johnson, David J Stone, Leo A Celi, Tom J Pollard, The MIMIC Code Repository: enabling reproducibility in critical care research, Journal of the American Medical Informatics Association, Volume 25, Issue 1, January 2018, Pages 32–39, https://doi.org/10.1093/jamia/ocx084  
  
