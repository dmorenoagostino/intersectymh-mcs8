kaboom

**# Data management for mode effects in continuous outcomes

use Datasets/20260629_mcs_combined_strata, clear
keep if strata48 != .
	
gen mode_online = mode_23y

tabstat kessler_sr_23y swemwbs_sr_23y, stats(mean sd) by(mode_online) // these go in the expected direction: that more computerised modes would elicit a higher disclosure (worse outcome levels)

* Scenario A: homogeneous mode effect

forvalues i = 1(1)3 {
		gen kessler_sr_23y_sim`i' = kessler_sr_23y
			replace kessler_sr_23y_sim`i' = kessler_sr_23y_sim`i' + `i' if mode_online == 0 & kessler_sr_23y != .
		gen swemwbs_sr_23y_sim`i' = swemwbs_sr_23y
			replace swemwbs_sr_23y_sim`i' = swemwbs_sr_23y_sim`i' - `i' if mode_online == 0 & swemwbs_sr_23y != .
	}


* Scenario B: heterogeneous mode effect

forvalues i = 1(1)3 {
	gen kessler_sr_23y_sim`i'b = kessler_sr_23y_sim`i'
		replace kessler_sr_23y_sim`i'b = kessler_sr_23y_sim`i'b + 0.5*`i' if inrange(sexual_minority_23y,1,2) & mode_online == 0 & kessler_sr_23y != .
		replace kessler_sr_23y_sim`i'b = kessler_sr_23y_sim`i'b + 0.5*`i' if inrange(ethnicity_6cat,2,6) & mode_online == 0 & kessler_sr_23y != .
		replace kessler_sr_23y_sim`i'b = kessler_sr_23y_sim`i'b + 0.5*`i' if poverty_9m_3y == 1 & mode_online == 0 & kessler_sr_23y != .
		
	gen swemwbs_sr_23y_sim`i'b = swemwbs_sr_23y_sim`i'
		replace swemwbs_sr_23y_sim`i'b = swemwbs_sr_23y_sim`i'b - 0.5*`i' if inrange(sexual_minority_23y,1,2) & mode_online == 0 & swemwbs_sr_23y != .
		replace swemwbs_sr_23y_sim`i'b = swemwbs_sr_23y_sim`i'b - 0.5*`i' if inrange(ethnicity_6cat,2,6) & mode_online == 0 & swemwbs_sr_23y != .
		replace swemwbs_sr_23y_sim`i'b = swemwbs_sr_23y_sim`i'b - 0.5*`i' if poverty_9m_3y == 1 & mode_online == 0 & swemwbs_sr_23y != .
	}

sum kessler_sr_23y* swemwbs_sr_23y*
tabstat kessler_sr_23y* swemwbs_sr_23y*, by(mode_online)

recode kessler_sr_23y* (24/max = 24) // capping at max of 24
recode swemwbs_sr_23y* (min/7 = 7) // capping at min of 7

rename ///
	(kessler_sr_23y_sim1b kessler_sr_23y_sim2b kessler_sr_23y_sim3b ///
	 swemwbs_sr_23y_sim1b swemwbs_sr_23y_sim2b swemwbs_sr_23y_sim3b) ///
	(kessler_sr_23y_sim4 kessler_sr_23y_sim5 kessler_sr_23y_sim6 ///
	swemwbs_sr_23y_sim4 swemwbs_sr_23y_sim5 swemwbs_sr_23y_sim6)

save Datasets/20260629_mcs_combined_strata_mode, replace




********************************************************************************
********************************************************************************
********************************************************************************

putexcel set "INTERSECT-YP Study 1 results.xlsx", modify sheet("20260629_mode")
	
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
		
		use Datasets/20260629_mcs_combined_strata_mode, clear
		
		drop if strata48 == . & kessler_sr_23y == .
		
	
	* Null / intercepts-only model
		
		meglm kessler_sr_23y_sim`i' [pweight = hovwt2] || strata48:
			estimates save "estimates/mode/k6_sim`i'_null_ipw", replace
			estat icc 
			
			predict pred_null_ipw, fitted // m1Am, includes fixed and random parts
			
		* Main effects model

		meglm kessler_sr_23y_sim`i' i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y [pweight = hovwt2] || strata48:, baselevels
			estimates save "estimates/mode/k6_sim`i'_main_ipw", replace
			estat icc 
			
			predict pred_main_ipw, fitted // m1Bm, includes fixed and random parts
			predict random_main_ipw, reffect reses(random_main_se_ipw) // m1Bu and m1Buse
			
			predict fixed_main_ipw, xb // fixed-portion linear prediction
			predict fixed_main_se_ipw, stdp // m1Bxbse, SE for the fixed-portion linear prediction
			
	**## Saving data
		
		compress
		save "estimates/mode/k6_sim`i'", replace
		
		use "estimates/mode/k6_sim`i'", clear
		
		collapse (count) n = kessler_sr_23y_sim`i' ///
			(mean) kessler_sr_23y_sim`i' ///
			pred_null_ipw pred_main_ipw random_main_se_ipw random_main_ipw fixed_main_ipw fixed_main_se_ipw, ///
			by(strata48 birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y)
			
		format %9.2f kessler pred* random* fixed*
		compress
		save "estimates/mode/k6_sim`i'_strata48", replace
		
		
	**## Tabulating results
		
		use "estimates/mode/k6_sim`i'", clear
				
		local rownumber = `i' + 1
	
		putexcel A`rownumber' = "k6"
		putexcel B`rownumber' = "Scenario `i'"
			
		estimates use "estimates/mode/k6_sim`i'_null_ipw"
		estimates replay, baselevels
		
		putexcel C`rownumber' = `e(N)'
			
		estat icc
		putexcel D`rownumber' = `r(icc2)'
		putexcel E`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel G`rownumber' = sigma2_u_null 
		
		
		estimates use "estimates/mode/k6_sim`i'_main_ipw"
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
		
		
	**## Visualising results
		
		use "estimates/mode/k6_sim`i'_strata48", clear
		
		drop if n < 10
		
		gen pred_main_lb = pred_main_ipw - 1.96 * sqrt(fixed_main_se_ipw^2 + random_main_se_ipw^2)
		gen pred_main_ub = pred_main_ipw + 1.96 * sqrt(fixed_main_se_ipw^2 + random_main_se_ipw^2)
		
		gen pred_main_marker = pred_main_ub + 1.5
		
		gen random_main_lb = random_main_ipw - 1.96 * random_main_se_ipw
		gen random_main_ub = random_main_ipw + 1.96 * random_main_se_ipw
		
		gen random_main_marker = random_main_ub + 0.2
			
		egen pred_rank_rest = rank(pred_main_ipw)
		egen random_rank_rest = rank(random_main_ipw)

		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank_rest, lcolor(gs4)) ///
			(scatter pred_main_ipw pred_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 score", size(*1.2)) ///
			ylabel(0(4)20, angle(horizontal) labsize(*1)) ///
			yline(0(4)20, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_sim`i'_ipw_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "estimates/mode/pred_k6_sim`i'_ipw_rest", replace 
		
		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank_rest, lcolor(gs4)) ///
			(scatter random_main_ipw random_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank_rest if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main_ipw random_rank_rest if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 score", size(*1.2)) ///
			ylabel(-2(0.5)2, angle(horizontal) labsize(*1)) ///
			yline(-2(0.5)2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_sim`i'_ipw_rest, replace) ///
			title("Scenario `i'") ///
			xsize(10)
			
		graph save "estimates/mode/random_k6_sim`i'_ipw_rest", replace
		
}


	**## Combined figures
	
	foreach type in pred random {
		
		forvalues i = 1(1)6 {
			graph use "estimates/mode/`type'_k6_sim`i'_ipw_rest"
		}
			
		graph combine `type'_k6_sim1_ipw_rest `type'_k6_sim2_ipw_rest `type'_k6_sim3_ipw_rest `type'_k6_sim4_ipw_rest `type'_k6_sim5_ipw_rest `type'_k6_sim6_ipw_rest, ///
		rows(3) iscale(*0.6) colf xsize(6) ///
		note("Only strata with 10+ observations are shown. Weighted results. In scenarios 1-3, a constant mode effect of 1-3 is added to the Kessler-6 score among in-person participants." ///
		"In scenarios 4-6, the constant mode effect is further amplified among sexual minority participants, ethnic minority groups, and those who experienced childhood poverty by -0.5 x scenario magnitude (1-3)" ///
		, size(*0.5)) ///
		name(comb_`type'_k6_sim_ipw_rest, replace)
		
		graph save "estimates/mode/comb_`type'_k6_sim_ipw_rest", replace
		graph export "estimates/mode/comb_`type'_k6_sim_ipw_rest.png", replace width(1000)
		graph export "estimates/mode/comb_`type'_k6_sim_ipw_rest.pdf", replace 
		graph export "estimates/mode/comb_`type'_k6_sim_ipw_rest.svg", replace 
		
	}
	
	
	

	
	


**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS
	
	forvalues i = 1(1)6 {
		
		use Datasets/20260629_mcs_combined_strata_mode, clear
		
		drop if strata48 == . & swemwbs_sr_23y == .

	
	* Null / intercepts-only model
		
		meglm swemwbs_sr_23y_sim`i' [pweight = hovwt2] || strata48:
			estimates save "estimates/mode/swemwbs_sim`i'_null_ipw", replace
			estat icc 
			
			predict pred_null_ipw, fitted // m1Am, includes fixed and random parts
			
		* Main effects model

		meglm swemwbs_sr_23y_sim`i' i.birthsex i.ethnicity_6cat i.sexual_minority_23y i.poverty_9m_3y [pweight = hovwt2] || strata48:, baselevels
			estimates save "estimates/mode/swemwbs_sim`i'_main_ipw", replace
			estat icc 
			
			predict pred_main_ipw, fitted // m1Bm, includes fixed and random parts
			predict random_main_ipw, reffect reses(random_main_se_ipw) // m1Bu and m1Buse
			
			predict fixed_main_ipw, xb // fixed-portion linear prediction
			predict fixed_main_se_ipw, stdp // m1Bxbse, SE for the fixed-portion linear prediction
			
	**## Saving data
		
		compress
		save "estimates/mode/swemwbs_sim`i'", replace
		
		use "estimates/mode/swemwbs_sim`i'", clear
		
		collapse (count) n = swemwbs_sr_23y_sim`i' ///
			(mean) swemwbs_sr_23y_sim`i' ///
			pred_null_ipw pred_main_ipw random_main_se_ipw random_main_ipw fixed_main_ipw fixed_main_se_ipw, ///
			by(strata48 birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y)
			
		format %9.2f swemwbs pred* random* fixed*
		compress
		save "estimates/mode/swemwbs_sim`i'_strata48", replace
		
		
	**## Tabulating results
		
		use "estimates/mode/swemwbs_sim`i'", clear
				
		local rownumber = `i' + 7
	
		putexcel A`rownumber' = "swemwbs"
		putexcel B`rownumber' = "Scenario `i'"
			
		estimates use "estimates/mode/swemwbs_sim`i'_null_ipw"
		estimates replay, baselevels
		
		putexcel C`rownumber' = `e(N)'
			
		estat icc
		putexcel D`rownumber' = `r(icc2)'
		putexcel E`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel G`rownumber' = sigma2_u_null 
		
		
		estimates use "estimates/mode/swemwbs_sim`i'_main_ipw"
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
		
		
	**## Visualising results
		
		use "estimates/mode/swemwbs_sim`i'_strata48", clear
		
		drop if n < 10
		
		gen pred_main_lb = pred_main_ipw - 1.96 * sqrt(fixed_main_se_ipw^2 + random_main_se_ipw^2)
		gen pred_main_ub = pred_main_ipw + 1.96 * sqrt(fixed_main_se_ipw^2 + random_main_se_ipw^2)
		
		gen pred_main_marker = pred_main_ub + 1
		
		gen random_main_lb = random_main_ipw - 1.96 * random_main_se_ipw
		gen random_main_ub = random_main_ipw + 1.96 * random_main_se_ipw
		
		gen random_main_marker = random_main_ub + 0.2
			
		egen pred_rank_rest = rank(pred_main_ipw)
		egen random_rank_rest = rank(random_main_ipw)

		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank_rest, lcolor(gs4)) ///
			(scatter pred_main_ipw pred_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS score", size(*1.2)) ///
			ylabel(16(2)30, angle(horizontal) labsize(*1)) ///
			yline(16(2)30, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_sim`i'_ipw_rest, replace) ///
			xsize(10) ///
			title("Scenario `i'")
			
		graph save "estimates/mode/pred_swemwbs_sim`i'_ipw_rest", replace 
		
		ta strata
		local maxlab = r(r)
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank_rest, lcolor(gs4)) ///
			(scatter random_main_ipw random_rank_rest, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank_rest if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main_ipw random_rank_rest if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank_rest if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS score", size(*1.2)) ///
			ylabel(-1.5(0.5)2, angle(horizontal) labsize(*1)) ///
			yline(-1.5(0.5)2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)`maxlab', labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_sim`i'_ipw_rest, replace) ///
			xsize(10) ///
			title("Scenario `i'")
			
		graph save "estimates/mode/random_swemwbs_sim`i'_ipw_rest", replace
		
}


	**## Combined figures
	
	foreach type in pred random {
		
		forvalues i = 1(1)6 {
			graph use "estimates/mode/`type'_swemwbs_sim`i'_ipw_rest"
		}
			
		graph combine `type'_swemwbs_sim1_ipw_rest `type'_swemwbs_sim2_ipw_rest `type'_swemwbs_sim3_ipw_rest `type'_swemwbs_sim4_ipw_rest `type'_swemwbs_sim5_ipw_rest `type'_swemwbs_sim6_ipw_rest, ///
		rows(3) iscale(*0.6) colf xsize(6) ///
		note("Only strata with 10+ observations are shown. Weighted results. In scenarios 1-3, a constant mode effect of 1-3 is subtracted to the SWEMWBS score among in-person participants." ///
		"In scenarios 4-6, the constant mode effect is further amplified among sexual minority participants, ethnic minority groups, and those who experienced childhood poverty by -0.5 x scenario magnitude (1-3)" ///
		, size(*0.5)) ///
		name(comb_`type'_swemwbs_sim_ipw_rest, replace)
		
		graph save "estimates/mode/comb_`type'_swemwbs_sim_ipw_rest", replace
		graph export "estimates/mode/comb_`type'_swemwbs_sim_ipw_rest.png", replace width(1000)
		graph export "estimates/mode/comb_`type'_swemwbs_sim_ipw_rest.pdf", replace 
		graph export "estimates/mode/comb_`type'_swemwbs_sim_ipw_rest.svg", replace 

	}