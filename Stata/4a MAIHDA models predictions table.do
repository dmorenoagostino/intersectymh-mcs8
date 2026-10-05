kaboom // added to prevent running the whole script when using the run command shortcut

**# Setup

	global estimates "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Estimates" // folder where results from models are saved

	tempfile maihda_predictions

**# Kessler-6 - partially invariant factor scores - all participants

	use "$estimates/k6_strata48", clear
		
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "1 Main"
	
	save `maihda_predictions'
		

**********************************************************************
**********************************************************************
**********************************************************************


**# Kessler-6 - sum scores 
	
	use "$estimates/sumscores/k6_sumscore_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "2 Sum scores"
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
		

**********************************************************************
**********************************************************************
**********************************************************************

	
**# Kessler-6 - partially invariant factor scores - excluding mop-up survey
	
	use "$estimates/nomopup/k6_nomopup_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "1 Kessler-6"
	gen type = "3 No mop-up"
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
	
	

**********************************************************************
**********************************************************************
**********************************************************************


**# Caseness (Kessler-6 = 13+) - all participants

	use "$estimates/caseness_strata48", clear
	
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
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Caseness (Kessler-6 = 13+) - excluding mop-up survey
	
	use "$estimates/nomopup/caseness_nomopup_strata48", clear
	
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
	gen type = "3 No mop-up"
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************
	
	
**# SWEMWBS - partially invariant factor scores

	use "$estimates/swemwbs_strata48", clear	
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "1 Main"
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
	

**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS - sum scores

	use "$estimates/sumscores/swemwbs_sumscore_strata48", clear
	
	* Predicted levels
	
	gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
	
	* Random / intersectional effects
		
	gen random_main_lb = random_main - 1.96 * random_main_se
	gen random_main_ub = random_main + 1.96 * random_main_se
	
	keep birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y strata48 n pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub 
	
	gen outcome = "3 SWEMWBS"
	gen type = "2 Sum scores"
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm (any) 

	use "$estimates/selfharm_strata48", clear
	
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
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
	
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - Poisson

	use "$estimates/selfharm_cont/selfharm_poisson_strata48", clear
	
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
	
	append using `maihda_predictions'
	save `maihda_predictions', replace


**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - Negative Binomial

	use "$estimates/selfharm_cont/selfharm_nbreg_strata48", clear
	
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
	
	append using `maihda_predictions'
	save `maihda_predictions', replace


**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Lifetime suicide attempts

	use "$estimates/suicide_strata48", clear	
	
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
	
	append using `maihda_predictions'
	save `maihda_predictions', replace
		
		
**********************************************************************
**********************************************************************
**********************************************************************

**# Managing full prediction table

	use `maihda_predictions', clear
	sort outcome type strata48
	
	* Create ranking variables
	
	foreach type in pred random {
		bysort outcome type: egen `type'_rank_full = rank(`type'_main)
		bysort outcome type: egen `type'_rank = rank(`type'_main) if n >= 10
	}
	

	foreach var in pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub pred_rank_full random_rank_full n {
		replace `var' = . if n < 10
	} 
	
	gsort +type +outcome +strata48
	
	format pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub %9.2f
		
	rename ///
		(strata48 birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y pred_main pred_main_lb pred_main_ub random_main random_main_lb random_main_ub pred_rank_full pred_rank random_rank_full random_rank) ///
		(strata birth_sex ethnicity sexual_identity childhood_poverty predicted_estimate predicted_lb predicted_ub random_estimate random_lb random_ub predicted_rank_full predicted_rank_restricted random_rank_full random_rank_restricted)
		
	order ///
		strata birth_sex ethnicity sexual_identity childhood_poverty n ///
		outcome type ///
		predicted_estimate predicted_lb predicted_ub predicted_rank_full predicted_rank_restricted ///
		random_estimate random_lb random_ub random_rank_full random_rank_restricted
		
	save "$estimates/maihda_predictions_supptable", replace
	export excel using "$estimates/maihda_predictions_supptable.xlsx", firstrow(variables) replace