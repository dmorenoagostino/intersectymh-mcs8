kaboom // added to prevent running the whole script when using the run command shortcut

**# Setup

	global mplus "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Mplus" // folder with Mplus results
	
	global datasets "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Datasets" // folder including datasets for analyses
	
	global estimates "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Estimates" // folder where results from models are saved
	
	* Create subfolders for sensitivity checks
		
		cap mkdir "$estimates/nomopup"
		cap mkdir "$estimates/sumscores"
		cap mkdir "$estimates/selfharm_cont"
	

**# Import partially invariant factor scores 

	* Kessler-6

		import delimited ///
			"$mplus\datasets/k6_fscores", /// 
			delimiter(space, collapse) numericcols(_all) clear

		keep v8 v11 // columns corresponding to the predicted factor scores and ID
		rename (v8 v11) (k6_fscore MCSIDCNUM_link)
		sort MCSIDCNUM_link

		tempfile k6_fscore
		save `k6_fscore'

	* SWEMWBS
	
		import delimited ///
			"$mplus\datasets/swemwbs_fscores", ///
			delimiter(space, collapse) numericcols(_all) clear

		keep v9 v12
		rename (v9 v12) (swemwbs_fscore MCSIDCNUM_link)
		sort MCSIDCNUM_link

		tempfile swemwbs_fscore
		save `swemwbs_fscore'
		
	* Merge with main dataset
	
		use "$datasets/mcs_combined_strata", clear
		merge 1:1 MCSIDCNUM_link using `k6_fscore', nogen
		merge 1:1 MCSIDCNUM_link using `swemwbs_fscore', nogen
		
		replace k6_fscore = . if kessler_sr_23y == .
		replace swemwbs_fscore = . if swemwbs_sr_23y == .
		
		save "$datasets/mcs_combined_strata_fscores", replace

		
**# Setup for reusable programme
		
	global data 	"$datasets/mcs_combined_strata_fscores" // dataset to use in analyses
	global covars 	"i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y" // variables defining intersectional strata
	global strata 	"strata48" // variable identifying intersectional strata
	global weight	"hovwt2" // variable identifying weights	
	global byvars	"$strata birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y" // variables used to collapse
	
	
**# Reusable programme

capture program drop run_maihda_models
program define run_maihda_models

	syntax, ///
		OUTCOME(name) /// outcome variable
		FAMILY(string) /// link function to use depending on outcome
		STEM(string) /// stem for the generated files
		OUTDIR(string) /// directory to save output
		[SAMPLEIF(string asis)]

	use "$data", clear

    * Base analytic sample
	keep if $strata != . & `outcome' != . // `samplevar' != .

	* Optional sample restriction, e.g. excluding mop-up
	if `"`sampleif'"' != "" {
		keep if `sampleif'
	}

	**## Model family-specific commands

	if "`family'" == "continuous" {

		* Weighted null model
		meglm `outcome' [pweight = $weight] || $strata:
		estimates save "`outdir'/`stem'_null", replace
		predict pred_null, fitted

		* Weighted main-effects model
		meglm `outcome' $covars [pweight = $weight] || $strata:, baselevels
		estimates save "`outdir'/`stem'_main", replace
		predict pred_main, fitted
		predict random_main, reffects reses(random_main_se)
		predict fixed_main, xb
		predict fixed_main_se, stdp

		local collapse_vars ///
			pred_null ///
			pred_main random_main random_main_se fixed_main fixed_main_se
	}

	else if "`family'" == "binary" {

		* Weighted null model
		melogit `outcome' [pweight = $weight] || $strata:, or baselevels
		estimates save "`outdir'/`stem'_null", replace
		predict pred_null, eta
		predict fixed_null, xb

		* Weighted main-effects model
		melogit `outcome' $covars [pweight = $weight] || $strata:, or baselevels
		estimates save "`outdir'/`stem'_main", replace
		predict pred_main, fitted
		predict random_main, reffects reses(random_main_se)
		predict fixed_main, xb
		predict fixed_main_se, stdp

		local collapse_vars ///
			pred_null fixed_null ///
			pred_main random_main random_main_se fixed_main fixed_main_se
	}
	
	else if "`family'" == "poisson" {

		* Weighted null model
		mepoisson `outcome' [pweight = $weight] || $strata:, irr baselevels
		estimates save "`outdir'/`stem'_null", replace
		predict pred_null, eta
		predict fixed_null, xb

		* Weighted main-effects model
		mepoisson `outcome' $covars [pweight = $weight] || $strata:, irr baselevels
		estimates save "`outdir'/`stem'_main", replace
		predict pred_main, fitted
		predict random_main, reffects reses(random_main_se)
		predict fixed_main, xb
		predict fixed_main_se, stdp

		local collapse_vars ///
			pred_null fixed_null ///
			pred_main random_main random_main_se fixed_main fixed_main_se
	}
	
	else if "`family'" == "nbreg" {

		* Weighted null model
		menbreg `outcome' [pweight = $weight] || $strata:, irr baselevels
		estimates save "`outdir'/`stem'_null", replace
		predict pred_null, eta
		predict fixed_null, xb

		* Weighted main-effects model
		menbreg `outcome' $covars [pweight = $weight] || $strata:, irr baselevels
		estimates save "`outdir'/`stem'_main", replace
		predict pred_main, fitted
		predict random_main, reffects reses(random_main_se)
		predict fixed_main, xb
		predict fixed_main_se, stdp

		local collapse_vars ///
			pred_null fixed_null ///
			pred_main random_main random_main_se fixed_main fixed_main_se
	}

	else {
		di as error "family() must be either continuous, binary, poisson, or nbreg"
		exit 198
	}

    **## Save individual-level predictions

	compress
	save "`outdir'/`stem'", replace

	**## Collapse to strata-level file

	collapse ///
		(count) n = `outcome' ///
		(mean)  `outcome' `collapse_vars', ///
		by($byvars)

	format %9.2f `outcome' pred* random* fixed*
	compress
	save "`outdir'/`stem'_$strata", replace

end


**# Kessler-6

	**## Main analyses, partially invariant factor scores 

	run_maihda_models, ///
		outcome(k6_fscore) ///
		family(continuous) ///
		stem(k6) ///
		outdir("$estimates")

	**## Excluding mop-up survey, partially invariant factor scores 

	run_maihda_models, ///
		outcome(k6_fscore) ///
		family(continuous) ///
		stem(k6_nomopup) ///
		outdir("$estimates/nomopup") ///
		sampleif(!mopup)

	**## Sum scores

	run_maihda_models, ///
		outcome(kessler_sr_23y) ///
		family(continuous) ///
		stem(k6_sumscore) ///
		outdir("$estimates/sumscores")
	
**# Caseness

	**## Main analyses

	run_maihda_models, ///
		outcome(caseness) ///
		family(binary) ///
		stem(caseness) ///
		outdir("$estimates")

	**## Excluding mop-up survey

	run_maihda_models, ///
		outcome(caseness) ///
		family(binary) ///
		stem(caseness_nomopup) ///
		outdir("$estimates/nomopup") ///
		sampleif(!mopup)
		
**# SWEMWBS

	**## Main analyses, partially invariant factor scores 

	run_maihda_models, ///
		outcome(swemwbs_fscore) ///
		family(continuous) ///
		stem(swemwbs) ///
		outdir("$estimates")

	**## Sum scores

	run_maihda_models, ///
		outcome(swemwbs_sr_23y) ///
		family(continuous) ///
		stem(swemwbs_sumscore) ///
		outdir("$estimates/sumscores")

		
**# Self-harm (any)

	run_maihda_models, ///
		outcome(selfharm_23y) ///
		family(binary) ///
		stem(selfharm) ///
		outdir("$estimates")
	
	
**# Self-harm (count)

	**## Poisson models

	run_maihda_models, ///
		outcome(selfharm_23y_cont) ///
		family(poisson) ///
		stem(selfharm_poisson) ///
		outdir("$estimates/selfharm_cont")

	**## Negative binomial models

	run_maihda_models, ///
		outcome(selfharm_23y_cont) ///
		family(nbreg) ///
		stem(selfharm_nbreg) ///
		outdir("$estimates/selfharm_cont")

		
**# Suicide attempts (lifetime)

	run_maihda_models, ///
		outcome(suicide_23y) ///
		family(binary) ///
		stem(suicide) ///
		outdir("$estimates")