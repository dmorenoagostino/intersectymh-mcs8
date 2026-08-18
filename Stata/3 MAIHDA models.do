kaboom

**# Setup

	clear all
	set more off

	global DATA		"Datasets/20260629_mcs_combined_strata"
	global COVARS	"i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y"
	global STRATA	"strata48"
	global WT		"hovwt2"
	global BYVARS	"$STRATA birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y"

	cap mkdir "estimates"
	cap mkdir "estimates/nomopup"
	cap mkdir "estimates/fscores"
	cap mkdir "estimates/selfharm_cont"

**# Reusable programme

capture program drop run_maihda_models
program define run_maihda_models

    syntax, OUTCOME(name) SAMPLEVAR(name) FAMILY(string) STEM(string) OUTDIR(string) ///
        [SAMPLEIF(string asis) MERGEUSING(string)]

    use "$DATA", clear

    * Base analytic sample
    keep if $STRATA != . & `samplevar' != .

    * Optional sample restriction, e.g. excluding mop-up
    if `"`sampleif'"' != "" {
        keep if `sampleif'
    }

    * Optional merge, e.g. for Mplus factor scores
    if `"`mergeusing'"' != "" {
        merge 1:1 MCSIDCNUM_link using `"`mergeusing'"', nogen keep(3)
        keep if `outcome' != .
    }

    **## Model family-specific commands

    if "`family'" == "continuous" {

        * Unweighted null model
        mixed `outcome' || $STRATA:
        estimates save "`outdir'/`stem'_null", replace
        predict pred_null, fitted

        * Unweighted main-effects model
        mixed `outcome' $COVARS || $STRATA:, baselevels
        estimates save "`outdir'/`stem'_main", replace
        predict pred_main, fitted
        predict random_main, reffect reses(random_main_se)
        predict fixed_main, xb
        predict fixed_main_se, stdp

        * Weighted null model
        meglm `outcome' [pweight = $WT] || $STRATA:
        estimates save "`outdir'/`stem'_null_ipw", replace
        predict pred_null_ipw, fitted

        * Weighted main-effects model
        meglm `outcome' $COVARS [pweight = $WT] || $STRATA:, baselevels
        estimates save "`outdir'/`stem'_main_ipw", replace
        predict pred_main_ipw, fitted
        predict random_main_ipw, reffect reses(random_main_se_ipw)
        predict fixed_main_ipw, xb
        predict fixed_main_se_ipw, stdp

        local collapse_vars ///
            pred_null ///
            pred_main random_main random_main_se fixed_main fixed_main_se ///
            pred_null_ipw ///
            pred_main_ipw random_main_ipw random_main_se_ipw fixed_main_ipw fixed_main_se_ipw
    }

    else if "`family'" == "binary" {

        * Unweighted null model
        melogit `outcome' || $STRATA:, or baselevels
        estimates save "`outdir'/`stem'_null", replace
        predict pred_null, eta
        predict fixed_null, xb

        * Unweighted main-effects model
        melogit `outcome' $COVARS || $STRATA:, or baselevels
        estimates save "`outdir'/`stem'_main", replace
        predict pred_main, fitted
        predict random_main, reffect reses(random_main_se)
        predict fixed_main, xb
        predict fixed_main_se, stdp

        * Weighted null model
        melogit `outcome' [pweight = $WT] || $STRATA:, or baselevels
        estimates save "`outdir'/`stem'_null_ipw", replace
        predict pred_null_ipw, eta
        predict fixed_null_ipw, xb

        * Weighted main-effects model
        melogit `outcome' $COVARS [pweight = $WT] || $STRATA:, or baselevels
        estimates save "`outdir'/`stem'_main_ipw", replace
        predict pred_main_ipw, fitted
        predict random_main_ipw, reffect reses(random_main_se_ipw)
        predict fixed_main_ipw, xb
        predict fixed_main_se_ipw, stdp

        local collapse_vars ///
            pred_null fixed_null ///
            pred_main random_main random_main_se fixed_main fixed_main_se ///
            pred_null_ipw fixed_null_ipw ///
            pred_main_ipw random_main_ipw random_main_se_ipw fixed_main_ipw fixed_main_se_ipw
    }
	
	else if "`family'" == "poisson" {

        * Unweighted null model
        mepoisson `outcome' || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_null", replace
        predict pred_null, eta
        predict fixed_null, xb

        * Unweighted main-effects model
        mepoisson `outcome' $COVARS || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_main", replace
        predict pred_main, fitted
        predict random_main, reffect reses(random_main_se)
        predict fixed_main, xb
        predict fixed_main_se, stdp

        * Weighted null model
        mepoisson `outcome' [pweight = $WT] || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_null_ipw", replace
        predict pred_null_ipw, eta
        predict fixed_null_ipw, xb

        * Weighted main-effects model
        mepoisson `outcome' $COVARS [pweight = $WT] || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_main_ipw", replace
        predict pred_main_ipw, fitted
        predict random_main_ipw, reffect reses(random_main_se_ipw)
        predict fixed_main_ipw, xb
        predict fixed_main_se_ipw, stdp

        local collapse_vars ///
            pred_null fixed_null ///
            pred_main random_main random_main_se fixed_main fixed_main_se ///
            pred_null_ipw fixed_null_ipw ///
            pred_main_ipw random_main_ipw random_main_se_ipw fixed_main_ipw fixed_main_se_ipw
    }
	
	else if "`family'" == "nbreg" {

        * Unweighted null model
        menbreg `outcome' || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_null", replace
        predict pred_null, eta
        predict fixed_null, xb

        * Unweighted main-effects model
        menbreg `outcome' $COVARS || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_main", replace
        predict pred_main, fitted
        predict random_main, reffect reses(random_main_se)
        predict fixed_main, xb
        predict fixed_main_se, stdp

        * Weighted null model
        menbreg `outcome' [pweight = $WT] || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_null_ipw", replace
        predict pred_null_ipw, eta
        predict fixed_null_ipw, xb

        * Weighted main-effects model
        menbreg `outcome' $COVARS [pweight = $WT] || $STRATA:, irr baselevels
        estimates save "`outdir'/`stem'_poisson_main_ipw", replace
        predict pred_main_ipw, fitted
        predict random_main_ipw, reffect reses(random_main_se_ipw)
        predict fixed_main_ipw, xb
        predict fixed_main_se_ipw, stdp

        local collapse_vars ///
            pred_null fixed_null ///
            pred_main random_main random_main_se fixed_main fixed_main_se ///
            pred_null_ipw fixed_null_ipw ///
            pred_main_ipw random_main_ipw random_main_se_ipw fixed_main_ipw fixed_main_se_ipw
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
        by($BYVARS)

    format %9.2f `outcome' pred* random* fixed*
    compress
    save "`outdir'/`stem'_strata48", replace

end


**# Kessler-6

	**## Main analyses

	run_maihda_models, ///
		outcome(kessler_sr_23y) ///
		samplevar(kessler_sr_23y) ///
		family(continuous) ///
		stem(k6) ///
		outdir("estimates")

	**## Excluding mop-up survey

	run_maihda_models, ///
		outcome(kessler_sr_23y) ///
		samplevar(kessler_sr_23y) ///
		family(continuous) ///
		stem(k6_nomopup) ///
		outdir("estimates/nomopup") ///
		sampleif(!mopup)

	**## Partially invariant factor scores

	import delimited ///
		"Mplus\20260611 MGCFA\20260703_k6_sex_sexid_pov_metric_scalar_part_fscores", ///
		delimiter(space, collapse) numericcols(_all) clear

	keep v8 v11
	rename (v8 v11) (k6_fscore MCSIDCNUM_link)
	sort MCSIDCNUM_link

	tempfile k6_fscore
	save `k6_fscore'

	di "`k6_fscore'"
	confirm file "`k6_fscore'"

	run_maihda_models, ///
		outcome(k6_fscore) ///
		samplevar(kessler_sr_23y) ///
		family(continuous) ///
		stem(k6_fscore) ///
		outdir("estimates/fscores") ///
		mergeusing("`k6_fscore'")

	
**# Caseness

	**## Main analyses

	run_maihda_models, ///
		outcome(caseness) ///
		samplevar(caseness_23y) ///
		family(binary) ///
		stem(caseness) ///
		outdir("estimates")

	**## Excluding mop-up survey

	run_maihda_models, ///
		outcome(caseness) ///
		samplevar(caseness_23y) ///
		family(binary) ///
		stem(caseness_nomopup) ///
		outdir("estimates/nomopup") ///
		sampleif(!mopup)

		
**# SWEMWBS

	**## Main analyses 

	run_maihda_models, ///
		outcome(swemwbs_sr_23y) ///
		samplevar(swemwbs_sr_23y) ///
		family(continuous) ///
		stem(swemwbs) ///
		outdir("estimates")

	**## Partially invariant factor scores

	import delimited ///
		"Mplus\20260611 MGCFA\20260611_swemwbs_sex_sexid_pov_scalar_part_fscores", ///
		delimiter(space, collapse) numericcols(_all) clear

	keep v9 v12
	rename (v9 v12) (swemwbs_fscore MCSIDCNUM_link)
	sort MCSIDCNUM_link

	tempfile swemwbs_fscore
	save `swemwbs_fscore'

	run_maihda_models, ///
		outcome(swemwbs_fscore) ///
		samplevar(swemwbs_sr_23y) ///
		family(continuous) ///
		stem(swemwbs_fscore) ///
		outdir("estimates/fscores") ///
		mergeusing("`swemwbs_fscore'")

		
**# Self-harm (any)

	run_maihda_models, ///
		outcome(selfharm_23y) ///
		samplevar(selfharm_23y) ///
		family(binary) ///
		stem(selfharm) ///
		outdir("estimates")
	
	
**# Self-harm (count)

	**## Poisson models

	run_maihda_models, ///
		outcome(selfharm_23y_cont) ///
		samplevar(selfharm_23y_cont) ///
		family(poisson) ///
		stem(selfharm_poisson) ///
		outdir("estimates/selfharm_cont")

	**## Negative binomial models

	run_maihda_models, ///
		outcome(selfharm_23y_cont) ///
		samplevar(selfharm_23y_cont) ///
		family(nbreg) ///
		stem(selfharm_nbreg) ///
		outdir("estimates/selfharm_cont")

		
**# Suicide attempts (lifetime)

	run_maihda_models, ///
		outcome(suicide_23y) ///
		samplevar(suicide_23y) ///
		family(binary) ///
		stem(suicide) ///
		outdir("estimates")