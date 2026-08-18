kaboom

**# Kessler-6 - continuous - all participants

	**## Unweighted
	
	use "estimates/k6_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "1 Main"
	gen weighted = 0
	
	save 20260727_maihda_predictions, replace
		
	
	**## Weighted
	
	use "estimates/k6_strata48", clear
	
	foreach var in pred_main random_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "1 Main"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace

		

**********************************************************************
**********************************************************************
**********************************************************************

	
**# Kessler-6 - continuous - excluding mop-up survey // SENS CHECK
	
	**## Unweighted
	
	use "estimates/nomopup/k6_strata48_nomopup", clear

	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "2 No mop-up"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace

	
	**## Weighted
	
	use "estimates/nomopup/k6_strata48_nomopup", clear
	
	foreach var in pred_main random_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "2 No mop-up"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Kessler-6 - partially invariant factor scores 
	
	**## Unweighted
	
	use "estimates/fscores/k6_fscore_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "3 Factor scores"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace

	
	**## Weighted
	
	use "estimates/fscores/k6_fscore_strata48", clear
	
	foreach var in pred_main random_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "3 Factor scores"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Kessler-6 - caseness (13+) - all participants

	**## Unweighted
	
	use "estimates/caseness_strata48", clear

	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "2 Caseness"
	gen type = "1 Main"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
	
	**## Weighted
	
	use "estimates/caseness_strata48", clear
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "2 Caseness"
	gen type = "1 Main"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Kessler-6 - caseness (13+) - excluding mop-up survey // SENS CHECK
	
	**## Unweighted
	
	use "estimates/nomopup/caseness_strata48_nomopup", clear
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "2 Caseness"
	gen type = "2 No mop-up"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
	
	**## Weighted
	
	use "estimates/nomopup/caseness_strata48_nomopup", clear
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "2 Caseness"
	gen type = "2 No mop-up"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************
	
	
**# SWEMWBS - continuous - does not include mop-up survey by design

	**## Unweighted
	
	use "estimates/swemwbs_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "1 Main"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace

	
	**## Weighted
	
	use "estimates/swemwbs_strata48", clear	
	
	foreach var in pred_main random_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "1 Main"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	

**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS - partially invariant factor scores - does not include mop-up survey by design

	**## Unweighted
	
	use "estimates/fscores/swemwbs_fscore_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "3 Factor scores"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace

	
	**## Weighted
	
	use "estimates/fscores/swemwbs_fscore_strata48", clear
	
	foreach var in pred_main random_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "3 Factor scores"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm (any) - excludes mop-up survey by design

	**## Unweighted
	
	use "estimates/selfharm_strata48", clear
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "4 Self-harm"
	gen type = "1 Main"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
	
	**## Weighted
	
	use "estimates/selfharm_strata48", clear
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "4 Self-harm"
	gen type = "1 Main"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - mepoisson

	**## Unweighted

	use "estimates/selfharm_cont/selfharm_poisson_strata48", clear
	
	* Predicted levels
	
	replace pred_main = exp(pred_main)
	
	gen pred_main_lb = exp(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = exp(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_mean_sim = exp(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_mean = exp(fixed_main)
	replace random_main = pred_main_mean_sim - fixed_main_mean
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)	
	
	gen outcome = "4 Self-harm"
	gen type = "4a Count, Poisson"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
		
	**## Weighted
	
	use "estimates/selfharm_cont/selfharm_poisson_strata48", clear
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = exp(pred_main)
	
	gen pred_main_lb = exp(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = exp(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_mean_sim = exp(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_mean = exp(fixed_main)
	replace random_main = pred_main_mean_sim - fixed_main_mean
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)	
	
	gen outcome = "4 Self-harm"
	gen type = "4a Count, Poisson"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace


**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - negative binomial

	
	**## Unweighted
	
	use "estimates/selfharm_cont/selfharm_nbreg_strata48", clear

	* Predicted levels
	
	replace pred_main = exp(pred_main)
	
	gen pred_main_lb = exp(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = exp(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_mean_sim = exp(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_mean = exp(fixed_main)
	replace random_main = pred_main_mean_sim - fixed_main_mean
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)	
	
	gen outcome = "4 Self-harm"
	gen type = "4b Count, Negative binomial"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
	
		
	**## Weighted
	
	use "estimates/selfharm_cont/selfharm_nbreg_strata48", clear
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = exp(pred_main)
	
	gen pred_main_lb = exp(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = exp(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_mean_sim = exp(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_mean = exp(fixed_main)
	replace random_main = pred_main_mean_sim - fixed_main_mean
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)	
	
	gen outcome = "4 Self-harm"
	gen type = "4b Count, Negative binomial"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace 


**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Suicide (ever) - excludes mop-up survey by design, extend to IPW with/when approach for CIs

	**## Unweighted
	
	use "estimates/suicide_strata48", clear
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "5 Suicide"
	gen type = "1 Main"
	gen weighted = 0
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
	
	**## Weighted
	
	use "estimates/suicide_strata48", clear	
	
	foreach var in fixed_main random_main pred_main fixed_main_se random_main_se {
		replace `var' = `var'_ipw
	}
	
	* Predicted levels
	
	replace pred_main = 100 * invlogit(pred_main)
	
	gen pred_main_lb = 100 * invlogit(fixed_main + random_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	gen pred_main_ub = 100 * invlogit(fixed_main + random_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2))
	
	* Random / intersectional effects
	
	expand 1000
	gen pred_main_se = sqrt(fixed_main_se^2 + random_main_se^2)
	
	set seed 24601
	gen pred_main_prob_sim = 100 * invlogit(fixed_main + random_main + rnormal(0, pred_main_se))
	gen fixed_main_prob = 100 * invlogit(fixed_main)
	replace random_main = pred_main_prob_sim - fixed_main_prob
	
	bysort strata48: egen random_main_lb = pctile(random_main), p(2.5)
	bysort strata48: egen random_main_ub = pctile(random_main), p(97.5)
	
	collapse (mean) birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub, by(strata48)
	
	gen outcome = "5 Suicide"
	gen type = "1 Main"
	gen weighted = 1
	
	append using 20260727_maihda_predictions
	save 20260727_maihda_predictions, replace
		
		
**********************************************************************
**********************************************************************
**********************************************************************

**# Managing full prediction table

	use 20260727_maihda_predictions, clear
	
	* Create ranking variables
	
	foreach type in pred random {
		bysort outcome type weighted: egen `type'_rank_full = rank(`type'_main)
		bysort outcome type weighted: egen `type'_rank = rank(`type'_main) if n >= 10
	}
	

	foreach var in pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub pred_rank_full random_rank_full n {
		replace `var' = . if n < 10
	} 
	
	gsort -weighted +type +outcome +strata48
	save 20260727_maihda_predictions_supptable, replace


**# Creating league tables 

	* ONS compliant (?) with full ranks
	
	use 20260727_maihda_predictions, clear
	
	keep if inrange(pred_rank_full,1,5) | inrange(pred_rank_full,43,47)

	recode pred_rank_full (1 = 47) (2 = 46) (3 = 45) (4 = 44) (5 = 43) (43 = 5) (44 = 4) (45 = 3) (46 = 2) (47 = 1) if outcome == "3 SWEMWBS" 
	keep if type == "1 Main" & weighted
	replace strata48 = . if n < 10
	keep strata48 n pred_main* pred_rank_full outcome 
	encode outcome, gen(outcome_num)
	drop outcome

	reshape wide strata n pred_main pred_main_lb pred_main_ub, i(pred_rank_full) j(outcome_num)
	browse pred_rank strata* 
	
	
	* ONS compliant with reduced ranks
	
	use 20260727_maihda_predictions, clear

	keep if inrange(pred_rank,1,5) | inrange(pred_rank,28,32)
	recode pred_rank (1 = 32) (2 = 31) (3 = 30) (4 = 29) (5 = 28) (28 = 5) (29 = 4) (30 = 3) (31 = 2) (32 = 1) if outcome == "3 SWEMWBS"
	keep if type == "1 Main" & weighted
	keep strata48 pred_main* pred_rank outcome 
	encode outcome, gen(outcome_num)
	drop outcome

	reshape wide strata pred_main pred_main_lb pred_main_ub, i(pred_rank) j(outcome_num)
	browse pred_rank strata* 