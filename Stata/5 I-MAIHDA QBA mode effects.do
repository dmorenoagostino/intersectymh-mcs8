/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 5. I-MAIHDA models, quantitative bias analysis (QBA) for mode effects
	
		This code creates a dataset that simulates multiple scenarios with 
		different types and levels of mode effects, as a quantitative bias
		analysis (QBA). It then runs I-MAIHDA models over those different 
		scenarios, exports the model-wide results, and generates visualisations
		of the stratum-specific predictions under each of the QBA scenarios.
	
		Portions of this code were adapted from: 
		Evans, C.R., G. Leckie, S.V. Subramanian, A. Bell, & J. Merlo. (2024.).
		A Tutorial for Conducting Intersectional Multilevel Analysis of Individual 
		Heterogeneity and Discriminatory Accuracy (MAIHDA). SSM - Population Health.	 
		https://doi.org/10.1016/j.ssmph.2024.101664

*/

**# Setup

	global datasets "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Datasets" // folder including datasets for analyses
	
	global mode "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Estimates/mode" // folder where results from models are saved
	
	global excelfile "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses" // folder where Excel file with results is located

**# Data management for mode effects in continuous outcomes

	use "$datasets/mcs_combined_strata_fscores", clear
	keep if strata48 != .
		
	gen mode_online = mode_23y
	
	tabstat k6_fscore swemwbs_fscore, stats(mean sd) by(mode_online) // these go in the expected direction: that more computerised modes would elicit a higher disclosure (worse outcome levels)

	
	* Scenario A: homogeneous mode effect; the following code adds (for Kessler-6) or subtracts (for SWEMWBS) a fixed deviation or "correction" factor of 0.2SD, 0.4SD, or 0.6SD among participants in a face-to-face mode

	forvalues i = 1(1)3 {
			gen k6_fscore_sim`i' = k6_fscore
				replace k6_fscore_sim`i' = k6_fscore_sim`i' + 0.2*`i' if mode_online == 0 & k6_fscore != .
			gen swemwbs_fscore_sim`i' = swemwbs_fscore
				replace swemwbs_fscore_sim`i' = swemwbs_fscore_sim`i' - 0.2*`i' if mode_online == 0 & swemwbs_fscore != .
		}


	* Scenario B: heterogeneous mode effect; the following code adds (for Kessler-6) or subtracts (for SWEMWBS) a further deviation or "correction" factor of 0.1SD, 0.2SD, or 0.3SD to the values generated in Scenario A, among sexual minority participants, ethnic minority participants, and participants with a history of childhood poverty; multiple deviations/corrections can be made for participants meeting multiple of these criteria

	forvalues i = 1(1)3 {
		gen k6_fscore_sim`i'b = k6_fscore_sim`i'
			replace k6_fscore_sim`i'b = k6_fscore_sim`i'b + 0.1*`i' if sexual_minority_23y == 1 & mode_online == 0 & k6_fscore != .
			replace k6_fscore_sim`i'b = k6_fscore_sim`i'b + 0.1*`i' if inrange(ethnicity_6cat,2,6) & mode_online == 0 & k6_fscore != .
			replace k6_fscore_sim`i'b = k6_fscore_sim`i'b + 0.1*`i' if poverty_9m_3y == 1 & mode_online == 0 & k6_fscore != .
			
		gen swemwbs_fscore_sim`i'b = swemwbs_fscore_sim`i'
			replace swemwbs_fscore_sim`i'b = swemwbs_fscore_sim`i'b - 0.1*`i' if sexual_minority_23y == 1 & mode_online == 0 & swemwbs_fscore != .
			replace swemwbs_fscore_sim`i'b = swemwbs_fscore_sim`i'b - 0.1*`i' if inrange(ethnicity_6cat,2,6) & mode_online == 0 & swemwbs_fscore != .
			replace swemwbs_fscore_sim`i'b = swemwbs_fscore_sim`i'b - 0.1*`i' if poverty_9m_3y == 1 & mode_online == 0 & swemwbs_fscore != .
		}

	sum k6_fscore* swemwbs_fscore*
	tabstat k6_fscore* swemwbs_fscore*, by(mode_online)

	rename ///
		(k6_fscore_sim1b k6_fscore_sim2b k6_fscore_sim3b ///
		 swemwbs_fscore_sim1b swemwbs_fscore_sim2b swemwbs_fscore_sim3b) ///
		(k6_fscore_sim4 k6_fscore_sim5 k6_fscore_sim6 ///
		swemwbs_fscore_sim4 swemwbs_fscore_sim5 swemwbs_fscore_sim6)

	save "$datasets/mcs_combined_strata_mode", replace




********************************************************************************
********************************************************************************
********************************************************************************

	putexcel set "$excelfile/MMV MCS23 results.xlsx", modify sheet("mode")
	
	putexcel A1 = "Outcome"
	putexcel B1 = "Mode effect scenario"
	putexcel C1 = "N"
	
	putexcel D1 = "VPC null"
	putexcel E1 = "VPC (95% LB) null"
	putexcel F1 = "VPC (95% UB) null"
	putexcel G1 = "Sigma_u null"
	putexcel H1 = "VPC main"
	putexcel I1 = "VPC (95% LB) main"
	putexcel J1 = "VPC (95% UB) main"
	putexcel K1 = "Sigma_u main"
	putexcel L1 = "PCV" 
	
	putexcel M1 = 	"coeff_Male"
	putexcel N1 = 	"LB_Male"
	putexcel O1 = 	"UB_Male"
	putexcel P1 = 	"pvalue_Male"

	putexcel Q1 = 	"coeff_Mixed"
	putexcel R1 = 	"LB_Mixed"
	putexcel S1 = 	"UB_Mixed"
	putexcel T1 = 	"pvalue_Mixed"

	putexcel U1 = 	"coeff_Indian"
	putexcel V1 = 	"LB_Indian"
	putexcel W1 = 	"UB_Indian"
	putexcel X1 = 	"pvalue_Indian"

	putexcel Y1 = 	"coeff_Pakistani_Bangladeshi"
	putexcel Z1 = 	"LB_Pakistani_Bangladeshi"
	putexcel AA1 = 	"UB_Pakistani_Bangladeshi"
	putexcel AB1 = 	"pvalue_Pakistani_Bangladeshi"

	putexcel AC1 = 	"coeff_Black"
	putexcel AD1 = 	"LB_Black"
	putexcel AE1 = 	"UB_Black"
	putexcel AF1 = 	"pvalue_Black"

	putexcel AG1 = 	"coeff_Other"
	putexcel AH1 = 	"LB_Other"
	putexcel AI1 = 	"UB_Other"
	putexcel AJ1 = 	"pvalue_Other"

	putexcel AK1 = 	"coeff_Sexualminority"
	putexcel AL1 = 	"LB_Sexualminority"
	putexcel AM1 = 	"UB_Sexualminority"
	putexcel AN1 = 	"pvalue_Sexualminority"

	putexcel AO1 = 	"coeff_Childhoodpoverty"
	putexcel AP1 = 	"LB_Childhoodpoverty"
	putexcel AQ1 = 	"UB_Childhoodpoverty"
	putexcel AR1 = 	"pvalue_Childhoodpoverty"

	
**# Kessler-6
	
	forvalues i = 1(1)6 {
		
		use "$datasets/mcs_combined_strata_mode", clear
		
		drop if strata48 == . & k6_fscore == .
		
	
		* Null / intercepts-only model
		
		meglm k6_fscore_sim`i' [pweight = hovwt2] || strata48:
			estimates save "$mode/k6_sim`i'_null", replace
			
			predict pred_null, fitted // predicted values, includes fixed and random parts
			
		* Main effects model

		meglm k6_fscore_sim`i' i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y [pweight = hovwt2] || strata48:, baselevels
			estimates save "$mode/k6_sim`i'_main", replace
			
			predict pred_main, fitted // predicted values, includes fixed and random parts
			predict random_main, reffect reses(random_main_se) // random effects and their standard errors
			
			predict fixed_main, xb // fixed-portion linear predictions
			predict fixed_main_se, stdp // standard errors for the fixed-portion linear predictions
			
	**## Saving data
		
		compress
		save "$mode/k6_sim`i'", replace
		
		use "$mode/k6_sim`i'", clear
		
		collapse (count) n = k6_fscore_sim`i' ///
			(mean) k6_fscore_sim`i' ///
			pred_null pred_main random_main_se random_main fixed_main fixed_main_se, ///
			by(strata48 birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y)
			
		format %9.2f k6_fscore_sim`i' pred* random* fixed*
		compress
		save "$mode/k6_sim`i'_strata48", replace
		
		
	**## Exporting model-wide results
		
		use "$mode/k6_sim`i'", clear
				
		local rownumber = `i' + 1
	
		putexcel A`rownumber' = "k6"
		putexcel B`rownumber' = "Scenario `i'"
			
		estimates use "$mode/k6_sim`i'_null"
		estimates replay, baselevels
		
		putexcel C`rownumber' = `e(N)'
			
		estat icc
		putexcel D`rownumber' = `r(icc2)'
		putexcel E`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel G`rownumber' = sigma2_u_null 
		
		
		estimates use "$mode/k6_sim`i'_main"
		estimates replay, baselevels

		mat coeffs = ///
				r(table)[1,2], r(table)[5,2], r(table)[6,2], r(table)[4,2], /// coeffs for gender: male
				r(table)[1,4], r(table)[5,4], r(table)[6,4], r(table)[4,4], /// coeffs for ethnicity: Mixed
				r(table)[1,5], r(table)[5,5], r(table)[6,5], r(table)[4,5], /// coeffs for ethnicity: Indian
				r(table)[1,6], r(table)[5,6], r(table)[6,6], r(table)[4,6], /// coeffs for ethnicity: Pakistani/Bangladeshi
				r(table)[1,7], r(table)[5,7], r(table)[6,7], r(table)[4,7], /// coeffs for ethnicity: Black
				r(table)[1,8], r(table)[5,8], r(table)[6,8], r(table)[4,8], /// coeffs for ethnicity: Other
				r(table)[1,10], r(table)[5,10], r(table)[6,10], r(table)[4,10], /// coeffs for sexuality: sexual minority
				r(table)[1,12], r(table)[5,12], r(table)[6,12], r(table)[4,12] // coeffs for childhood poverty
		
		estat icc
		putexcel H`rownumber' = `r(icc2)'
		putexcel I`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel K`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel L`rownumber' = pcv
		
		putexcel M`rownumber' = matrix(coeffs)
		
		
	**## Visualising stratum-specific predictions
		
		use "$mode/k6_sim`i'_strata48", clear
		
		global miny_pred = -1
		global maxy_pred = 2.1
		global stepy_pred = 0.25
		global rangey_pred = $maxy_pred - $miny_pred
		global markeradd_pred = $rangey_pred / 15
		
		global miny_random = -0.3
		global maxy_random = 0.4
		global stepy_random = 0.1
		global rangey_random = $maxy_random - $miny_random
		global markeradd_random = $rangey_random / 15
		
		drop if n < 10
		
		gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
		gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
		
		gen pred_main_marker = pred_main_ub + $markeradd_pred

		gen random_main_lb = random_main - 1.96 * random_main_se
		gen random_main_ub = random_main + 1.96 * random_main_se
		
		gen random_main_marker = random_main_ub + $markeradd_random
			
		egen pred_rank_rest = rank(pred_main)
		egen random_rank_rest = rank(random_main)

		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank_rest, lcolor(gs4)) ///
			(scatter pred_main pred_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_sim`i'_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "$mode/pred_k6_sim`i'_rest", replace 
		
		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank_rest, lcolor(gs4)) ///
			(scatter random_main random_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank_rest if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank_rest if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_sim`i'_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "$mode/random_k6_sim`i'_rest", replace
		
}


	**## Combined figures
	
	foreach type in pred random {
		
		graph combine ///
			"$mode/`type'_k6_sim1_rest" ///
			"$mode/`type'_k6_sim2_rest" ///
			"$mode/`type'_k6_sim3_rest" ///
			"$mode/`type'_k6_sim4_rest" ///
			"$mode/`type'_k6_sim5_rest" ///
			"$mode/`type'_k6_sim6_rest" ///
			, ///
		rows(3) iscale(*0.6) colf xsize(6) ///
		note("Only strata with 10+ observations are shown. Weighted results. In scenarios 1-3, a constant mode effect of 0.2 SD, 0.4 SD, or 0.6 SD is added to the Kessler-6 score among in-person participants." ///
		"In scenarios 4-6, the constant mode effect is further amplified among sexual minority participants, ethnic minority groups, and those who experienced childhood poverty by 0.1 SD x scenario magnitude (1-3)" ///
		, size(*0.5)) ///
		name(comb_`type'_k6_sim_rest, replace)
		
		graph save "$mode/comb_`type'_k6_sim_rest", replace
		graph export "$mode/comb_`type'_k6_sim_rest.png", replace width(1000)
		graph export "$mode/comb_`type'_k6_sim_rest.pdf", replace 
		graph export "$mode/comb_`type'_k6_sim_rest.svg", replace 
		
	}
	
	
	

	
	


**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS
	
	forvalues i = 1(1)6 {
		
		use "$datasets/mcs_combined_strata_mode", clear
		
		drop if strata48 == . & swemwbs_fscore == .
		
	
		* Null / intercepts-only model
		
		meglm swemwbs_fscore_sim`i' [pweight = hovwt2] || strata48:
			estimates save "$mode/swemwbs_sim`i'_null", replace
			
			predict pred_null, fitted // predicted values, includes fixed and random parts

			
		* Main effects model

		meglm swemwbs_fscore_sim`i' i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y [pweight = hovwt2] || strata48:, baselevels
			estimates save "$mode/swemwbs_sim`i'_main", replace
			
			predict pred_main, fitted // predicted values, includes fixed and random parts
			predict random_main, reffect reses(random_main_se) // random effects and their standard errors
			
			predict fixed_main, xb // fixed-portion linear predictions
			predict fixed_main_se, stdp // standard errors for the fixed-portion linear predictions
			
	**## Saving data
		
		compress
		save "$mode/swemwbs_sim`i'", replace
		
		use "$mode/swemwbs_sim`i'", clear
		
		collapse (count) n = swemwbs_fscore_sim`i' ///
			(mean) swemwbs_fscore_sim`i' ///
			pred_null pred_main random_main_se random_main fixed_main fixed_main_se, ///
			by(strata48 birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y)
			
		format %9.2f swemwbs_fscore_sim`i' pred* random* fixed*
		compress
		save "$mode/swemwbs_sim`i'_strata48", replace
		
		
	**## Exporting model-wide results
		
		use "$mode/swemwbs_sim`i'", clear
				
		local rownumber = `i' + 7 // so that this is added after the Kessler-6 rows
	
		putexcel A`rownumber' = "swemwbs"
		putexcel B`rownumber' = "Scenario `i'"
			
		estimates use "$mode/swemwbs_sim`i'_null"
		estimates replay, baselevels
		
		putexcel C`rownumber' = `e(N)'
			
		estat icc
		putexcel D`rownumber' = `r(icc2)'
		putexcel E`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel G`rownumber' = sigma2_u_null 
		
		
		estimates use "$mode/swemwbs_sim`i'_main"
		estimates replay, baselevels

		mat coeffs = ///
				r(table)[1,2], r(table)[5,2], r(table)[6,2], r(table)[4,2], /// coeffs for gender: male
				r(table)[1,4], r(table)[5,4], r(table)[6,4], r(table)[4,4], /// coeffs for ethnicity: Mixed
				r(table)[1,5], r(table)[5,5], r(table)[6,5], r(table)[4,5], /// coeffs for ethnicity: Indian
				r(table)[1,6], r(table)[5,6], r(table)[6,6], r(table)[4,6], /// coeffs for ethnicity: Pakistani/Bangladeshi
				r(table)[1,7], r(table)[5,7], r(table)[6,7], r(table)[4,7], /// coeffs for ethnicity: Black
				r(table)[1,8], r(table)[5,8], r(table)[6,8], r(table)[4,8], /// coeffs for ethnicity: Other
				r(table)[1,10], r(table)[5,10], r(table)[6,10], r(table)[4,10], /// coeffs for sexuality: sexual minority
				r(table)[1,12], r(table)[5,12], r(table)[6,12], r(table)[4,12] // coeffs for childhood poverty
		
		estat icc
		putexcel H`rownumber' = `r(icc2)'
		putexcel I`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel K`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel L`rownumber' = pcv
		
		putexcel M`rownumber' = matrix(coeffs)
		
		
	**## Visualising stratum-specific predictions
		
		use "$mode/swemwbs_sim`i'_strata48", clear
		
		global miny_pred = -1
		global maxy_pred = 1
		global stepy_pred = 0.25
		global rangey_pred = $maxy_pred - $miny_pred
		global markeradd_pred = $rangey_pred / 15
		
		global miny_random = -0.3
		global maxy_random = 0.4
		global stepy_random = 0.1
		global rangey_random = $maxy_random - $miny_random
		global markeradd_random = $rangey_random / 15
		
		drop if n < 10
		
		gen pred_main_lb = pred_main - 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
		gen pred_main_ub = pred_main + 1.96 * sqrt(fixed_main_se^2 + random_main_se^2)
		
		gen pred_main_marker = pred_main_ub + $markeradd_pred

		gen random_main_lb = random_main - 1.96 * random_main_se
		gen random_main_ub = random_main + 1.96 * random_main_se
		
		gen random_main_marker = random_main_ub + $markeradd_random
			
		egen pred_rank_rest = rank(pred_main)
		egen random_rank_rest = rank(random_main)

		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank_rest, lcolor(gs4)) ///
			(scatter pred_main pred_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS factor score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_sim`i'_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "$mode/pred_swemwbs_sim`i'_rest", replace 
		
		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank_rest, lcolor(gs4)) ///
			(scatter random_main random_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank_rest if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank_rest if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS factor score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_sim`i'_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "$mode/random_swemwbs_sim`i'_rest", replace
		
}


	**## Combined figures
	
	foreach type in pred random {
		
		graph combine ///
			"$mode/`type'_swemwbs_sim1_rest" ///
			"$mode/`type'_swemwbs_sim2_rest" ///
			"$mode/`type'_swemwbs_sim3_rest" ///
			"$mode/`type'_swemwbs_sim4_rest" ///
			"$mode/`type'_swemwbs_sim5_rest" ///
			"$mode/`type'_swemwbs_sim6_rest" ///
			, ///
		rows(3) iscale(*0.6) colf xsize(6) ///
		note("Only strata with 10+ observations are shown. Weighted results. In scenarios 1-3, a constant mode effect of 0.2 SD, 0.4 SD, or 0.6 SD is subtracted to the SWEMWBS score among in-person participants." ///
		"In scenarios 4-6, the constant mode effect is further amplified among sexual minority participants, ethnic minority groups, and those who experienced childhood poverty by -0.1 SD x scenario magnitude (1-3)" ///
		, size(*0.5)) ///
		name(comb_`type'_swemwbs_sim_rest, replace)
		
		graph save "$mode/comb_`type'_swemwbs_sim_rest", replace
		graph export "$mode/comb_`type'_swemwbs_sim_rest.png", replace width(1000)
		graph export "$mode/comb_`type'_swemwbs_sim_rest.pdf", replace 
		graph export "$mode/comb_`type'_swemwbs_sim_rest.svg", replace 

	}