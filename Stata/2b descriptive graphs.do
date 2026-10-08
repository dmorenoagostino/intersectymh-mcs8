/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 2b. Descriptive graphs
	
		This code produces descriptive visualisations across social identities 
		and positions under study, both before and after recoding for subsequent 
		analyses.
		
*/

**# Setup

	global datasets "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Datasets" // folder including working datasets
	
	global descriptivegraphs "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Descriptives" // folder to save descriptive graphs
	
**# Preparation of dataset for visualisation

	clear all 

	use "$datasets/mcs_combined_clean", clear

	recode sexuality_23y ///
		(1 = 1 "1 Heterosexual") ///
		(2 = 2 "2 Gay or lesbian") ///
		(3 = 3 "3 Bisexual") ///
		(4 = 4 "4 Other") ///
		(6 = 5 "5 Pansexual") ///
		(7 = 6 "6 Asexual") ///
		(8 = 7 "7 Queer") ///
		(-8 -1 5 . = 999 "999 DK/RF/NA") ///
		, gen(sexuality_23y_cat)

	* Recode missing on grouping variables to 999 for descriptives and add missing labels
	foreach g in birthsex ethnicity ethnicity_6cat poverty_9m_3y {
		recode `g' (. = 999)
	}

	foreach label in birthsex ethnicity ethnicity_6cat {
		label define `label' ///
		999 "Missing", modify
	}

	label define poverty ///
		0 "0 No childhood poverty" ///
		1 "1 Childhood poverty" ///
		999 "Missing", replace
		
	label values poverty_9m_3y poverty

	label define sexualmin ///
		0 "0 Heterosexual" ///
		1 "1 Sexual minority" ///
		999 "Missing", replace
		
	label values sexual_minority_23y_augm sexualmin


	* Create temporary file

	tempfile weighted_estimates

	postfile results ///
		str30 domain ///
		double category ///
		str80 category_label ///
		str40 outcome ///
		str20 statistic ///
		double estimate ///
		double lb ///
		double ub ///
		double n_obs ///
		using `weighted_estimates', replace


	* Loop over social identity/position variables and outcomes

	foreach group in birthsex ethnicity ethnicity_6cat sexuality_23y_cat sexual_minority_23y_augm poverty_9m_3y {

		levelsof `group', local(levels)

		foreach y in kessler_sr_23y caseness_23y swemwbs_sr_23y selfharm_23y selfharm_23y_cont suicide_23y {

			* Outcome labels and statistic labels
			local outlab "`y'"
			local stat "M"
			local binary = 0

			if "`y'" == "kessler_sr_23y" {
				local outlab "Kessler-6"
				local stat "M"
			}

			if "`y'" == "caseness_23y" {
				local outlab "Caseness"
				local stat "% yes"
				local binary = 1
			}

			if "`y'" == "swemwbs_sr_23y" {
				local outlab "SWEMWBS"
				local stat "M"
			}

			if "`y'" == "selfharm_23y" {
				local outlab "Self-harm (any)"
				local stat "% yes"
				local binary = 1
			}

			if "`y'" == "selfharm_23y_cont" {
				local outlab "Self-harm (number)"
				local stat "M"
			}

			if "`y'" == "suicide_23y" {
				local outlab "Attempted suicide (ever)"
				local stat "% yes"
				local binary = 1
			}

			*----------------------------------------------------
			* Continuous outcomes: use mean
			*----------------------------------------------------

			if `binary' == 0 {

				quietly mean `y' [pweight = hovwt2], over(`group')

				* r(table) rows:
				* 1 = estimate
				* 5 = lower bound
				* 6 = upper bound
				mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]')
			}

			*----------------------------------------------------
			* Binary outcomes: use proportion
			*----------------------------------------------------

			if `binary' == 1 {

				quietly proportion `y' [pweight = hovwt2], over(`group')

				/*
				For binary 0/1 outcomes with over(`g'), r(table) contains
				proportions for outcome==0 and outcome==1.

				Assuming both 0 and 1 are present, the outcome==1 estimates
				are in the second half of the columns.
				*/

				matrix RT = r(table)

				local first_yes = colsof(RT) / 2 + 1
				local last_yes  = colsof(RT)

				matrix a = ///
				(RT[1, `first_yes'..`last_yes'] \ ///
				 RT[5, `first_yes'..`last_yes'] \ ///
				 RT[6, `first_yes'..`last_yes'])'
			}

			*----------------------------------------------------
			* Post results
			*----------------------------------------------------

			local i = 1

			foreach lev of local levels {

				quietly count if `group' == `lev' & !missing(`y') & !missing(hovwt2)
				local n = r(N)

				local vl : value label `group'

				if "`vl'" != "" {
					local catlab : label `vl' `lev'
				}
				
				else {
					local catlab "`lev'"
				}

				post results ///
					("`group'") ///
					(`lev') ///
					("`catlab'") ///
					("`outlab'") ///
					("`stat'") ///
					(a[`i',1]) ///
					(a[`i',2]) ///
					(a[`i',3]) ///
					(`n')

				local ++i
			}
		}
	}

	postclose results

	use `weighted_estimates', clear

	foreach var in estimate lb ub {
		replace `var' = . if n_obs < 10
	}

	order domain category category_label outcome statistic estimate lb ub n_obs

	save "$datasets/weighted_descriptive_estimates.dta", replace



**# Visualisation

	use "$datasets/weighted_descriptive_estimates.dta", clear


	* Create ordered outcome variable

	gen outcome_order = .

	replace outcome_order = 1 if outcome == "Kessler-6"
	replace outcome_order = 2 if outcome == "Caseness"
	replace outcome_order = 3 if outcome == "SWEMWBS"
	replace outcome_order = 4 if outcome == "Self-harm (any)"
	replace outcome_order = 5 if outcome == "Attempted suicide (ever)"
	replace outcome_order = 6 if outcome == "Self-harm (number)"

	label define outcome_order_lbl ///
		1 "Kessler-6" ///
		2 "Caseness (%)" ///
		3 "SWEMWBS" ///
		4 "Self-harm any (%)" ///
		5 "Attempted suicide (%)" ///
		6 "Number of self-harm behaviours", replace

	label values outcome_order outcome_order_lbl


	* Convert binary outcomes from proportions to percentages

	foreach var in estimate lb ub {
		replace `var' = `var' * 100 if inlist(outcome_order,2,4,5)
	}

	* Capping at 0 estimates for mean Number of" "self-harm behaviours

	sum estimate lb ub if outcome == "Self-harm (number)"
	recode lb (min/0 = 0) if outcome == "Self-harm (number)"

	* Exclude missing categories from figures

	drop if category == 999

	* Set min, max, and step for each outcome

	tabstat lb ub, statistics(min max) by(outcome)

	global min_1 = 4 // range of 0-24 for K6
	global max_1 = 16
	global step_1 = 2

	global min_3 = 15 // range of 7-35 for SWEMWBS
	global max_3 = 27
	global step_3 = 2

	foreach o in 2 4 { // range of 0-100 for binary outcomes (probability)
		global min_`o' = 0
		global max_`o' = 100
		global step_`o' = 20
	}

	foreach o in 5 { // 
		global min_`o' = 0
		global max_`o' = 70
		global step_`o' = 10
	}


	global min_6 = 0 // range of 0-3 for Number of" "self-harm behaviours 
	global max_6 = 3
	global step_6 = .5

	* Create legend helper for combined graphs

	gen legend_estimate = 1
	* bysort domain category (outcome_order): replace legend_estimate = 1 if _n == 1


			
	**## By ethnicity (full, before recoding)

		sum category if domain == "ethnicity"
		global ylabmin = r(min)
		global ylabmax = r(max)
		

		* Labels only

			preserve

			keep if outcome == "Kessler-6"
			keep if domain == "ethnicity"
			
			twoway ///
				(scatter category legend_estimate if category == 1, mcolor(stc1%50) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 1, mcolor(stc1%50) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 2, mcolor(stc2%80) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 3, mcolor(stc2%60) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 4, mcolor(stc2%40) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 5, mcolor(stc2%20) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 6, mcolor(stc3%60) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 7, mcolor(stc4%80) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 8, mcolor(stc4%40) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 9, mcolor(stc5%80) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 10, mcolor(stc6%80) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 11, mcolor(stc6%60) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 12, mcolor(stc6%40) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 13, mcolor(stc5%60) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 14, mcolor(stc5%40) msymbol(square) msize(large)) ///
				, ///
				title(" " " ", size(*.7)) /// 
				xtitle(" ", size(*.8)) /// 
				xlabel(1 " ", angle(horizontal) labsize(*.8) nogrid) ///
				ytitle("") ///
				ylabel( ///
					1 "White" ///
					2 "Mixed White & Black Caribbean" ///
					3 "Mixed White & Black African" ///
					4 "Mixed White & Asian" ///
					5 "Other Mixed" ///
					6 "Indian" ///
					7 "Pakistani" ///
					8 "Bangladeshi" ///
					9 "Other Asian" ///
					10 "Black African" ///
					11 "Black Caribbean" ///
					12 "Other Black" ///
					13 "Arab" ///
					14 "Other" ///
					, angle(horizontal) labsize(*0.8) notick) ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_label", replace)
				
				graph save "$descriptivegraphs/ethnicity_label", replace 
				
			restore
				
		* Kessler-6

			preserve

			keep if outcome == "Kessler-6"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Psychological distress" "(Kessler-6)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_1($step_1)$max_1, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_k6", replace)
				
				graph save "$descriptivegraphs/ethnicity_k6", replace 
				
			restore
		
		* Caseness

			preserve

			keep if outcome == "Caseness"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Caseness" "(Kessler-6 = 13+) ", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_2($step_2)$max_2, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_caseness", replace)
				
				graph save "$descriptivegraphs/ethnicity_caseness", replace 
				
			restore
			
			
		* SWEMWBS

			preserve

			keep if outcome == "SWEMWBS"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Psychological wellbeing" "(SWEMWBS)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_3($step_3)$max_3, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_swemwbs", replace)
				
				graph save "$descriptivegraphs/ethnicity_swemwbs", replace 
				
			restore
			
			
		* Self-harm (any)

			preserve

			keep if outcome == "Self-harm (any)"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Any self-harm" "in last 12 months", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_4($step_4)$max_4, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_selfharm", replace)
				
				graph save "$descriptivegraphs/ethnicity_selfharm", replace 
				
			restore
			
		* Suicide attempts

			preserve

			keep if outcome == "Attempted suicide (ever)"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Lifetime" "suicide attempts", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_5($step_5)$max_5, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_suicide", replace)
				
				graph save "$descriptivegraphs/ethnicity_suicide", replace 
				
			restore
			
			
		* Self-harm (number)

			preserve

			keep if outcome == "Self-harm (number)"
			keep if domain == "ethnicity"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%20) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc4%80) lwidth(*4)) ///
				(rspike lb ub category if category == 8, horizontal lcolor(stc4%40) lwidth(*4)) ///
				(rspike lb ub category if category == 9, horizontal lcolor(stc5%80) lwidth(*4)) ///
				(rspike lb ub category if category == 10, horizontal lcolor(stc6%80) lwidth(*4)) ///
				(rspike lb ub category if category == 11, horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category if category == 12, horizontal lcolor(stc6%40) lwidth(*4)) ///
				(rspike lb ub category if category == 13, horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category if category == 14, horizontal lcolor(stc5%40) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Number of" "self-harm behaviours", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_6($step_6)$max_6, labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("ethnicity_selfharm_cont", replace)
				
				graph save "$descriptivegraphs/ethnicity_selfharm_cont", replace 
				
			restore


	**## By sexuality (full, before recoding)

		sum category if domain == "sexuality_23y_cat"
		global ylabmin = r(min)
		global ylabmax = r(max)

		* Labels only

			preserve

			keep if outcome == "Kessler-6"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(scatter category legend_estimate if category == 1, mcolor(stc1%50) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 2, mcolor(stc2%80) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 3, mcolor(stc2%70) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 4, mcolor(stc2%60) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 5, mcolor(stc2%50) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 6, mcolor(stc2%40) msymbol(square) msize(large)) ///
				(scatter category legend_estimate if category == 7, mcolor(stc2%30) msymbol(square) msize(large)) ///
				, ///
				title(" " " ", size(*.7)) /// 
				xtitle(" ", size(*.8)) /// 
				xlabel(1 " ", angle(horizontal) labsize(*.8) nogrid) ///
				ytitle("") ///
				ylabel( ///
					1 "Heterosexual" ///
					2 "Gay or Lesbian" ///
					3 "Bisexual" ///
					4 "Other" ///
					5 "Pansexual" ///
					6 "Asexual" ///
					7 "Queer" ///
					, angle(horizontal) labsize(*0.8) notick) ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_label", replace)
				
				graph save "$descriptivegraphs/sexuality_label", replace  
				
			restore
				
				
		* Kessler-6

			preserve

			keep if outcome == "Kessler-6"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Psychological distress" "(Kessler-6)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_1($step_1)$max_1, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_k6", replace)
				
				graph save "$descriptivegraphs/sexuality_k6", replace 
				
			restore
		
		* Caseness

			preserve

			keep if outcome == "Caseness"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Caseness" "(Kessler-6 = 13+) ", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_2($step_2)$max_2, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_caseness", replace)
				
				graph save "$descriptivegraphs/sexuality_caseness", replace 
				
			restore
			
			
		* SWEMWBS

			preserve

			keep if outcome == "SWEMWBS"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Psychological wellbeing" "(SWEMWBS)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_3($step_3)$max_3, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_swemwbs", replace)
				
				graph save "$descriptivegraphs/sexuality_swemwbs", replace 
				
			restore
			
			
		* Self-harm (any)

			preserve

			keep if outcome == "Self-harm (any)"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Any self-harm" "in last 12 months", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_4($step_4)$max_4, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_selfharm", replace)
				
				graph save "$descriptivegraphs/sexuality_selfharm", replace 
				
			restore
			
		* Suicide attempts

			preserve

			keep if outcome == "Attempted suicide (ever)"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Lifetime" "suicide attempts", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_5($step_5)$max_5, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_suicide", replace)
				
				graph save "$descriptivegraphs/sexuality_suicide", replace 
				
			restore
			
			
		* Self-harm (number)

			preserve

			keep if outcome == "Self-harm (number)"
			keep if domain == "sexuality_23y_cat"
			
			twoway ///
				(rspike lb ub category if category == 1, horizontal lcolor(stc1%50) lwidth(*4)) ///
				(rspike lb ub category if category == 2, horizontal lcolor(stc2%80) lwidth(*4)) ///
				(rspike lb ub category if category == 3, horizontal lcolor(stc2%70) lwidth(*4)) ///
				(rspike lb ub category if category == 4, horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category if category == 5, horizontal lcolor(stc2%50) lwidth(*4)) ///
				(rspike lb ub category if category == 6, horizontal lcolor(stc2%40) lwidth(*4)) ///
				(rspike lb ub category if category == 7, horizontal lcolor(stc2%30) lwidth(*4)) ///
				(scatter category estimate, mcolor(black) msymbol(smcircle)) ///
				, ///
				title("Number of" "self-harm behaviours", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_6($step_6)$max_6, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("sexuality_selfharm_cont", replace)
				
				graph save "$descriptivegraphs/sexuality_selfharm_cont", replace 
				
			restore
			
			
	**## Across variables used in analyses

		keep if inlist(domain,"birthsex","ethnicity_6cat","sexual_minority_23y_augm","poverty_9m_3y")
		
		gen category_comb = category
			replace category_comb = category_comb + 1 if inlist(domain,"sexual_minority_23y_augm","poverty_9m_3y")
			replace category_comb = category_comb + 2 if domain == "ethnicity_6cat"
			replace category_comb = category_comb + 8 if domain == "sexual_minority_23y_augm"
			replace category_comb = category_comb + 10 if domain == "poverty_9m_3y"
			
		sum category_comb
		global ylabmin = r(min)
		global ylabmax = r(max)
		
		* Labels only

			preserve

			keep if outcome == "Kessler-6"
			
			twoway ///
				(scatter category_comb legend_estimate if category_comb == 1,	mcolor(stc1%60) msymbol(O) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 2,	mcolor(stc2%60) msymbol(O) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 3,	mcolor(stc1%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 4,	mcolor(stc2%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 5,	mcolor(stc3%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 6,	mcolor(stc4%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 7,	mcolor(stc6%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 8,	mcolor(stc5%60) msymbol(S) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 9,	mcolor(stc1%60) msymbol(D) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 10,	mcolor(stc2%60) msymbol(D) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 11,	mcolor(stc1%60) msymbol(T) msize(large)) ///
				(scatter category_comb legend_estimate if category_comb == 12,	mcolor(stc2%60) msymbol(T) msize(large)) ///
				, ///
				title(" " " ", size(*.7)) /// 
				xtitle(" ", size(*.8)) /// 
				xlabel(1 " ", angle(horizontal) labsize(*.8) nogrid) ///
				ytitle("") ///
				ylabel( ///female
					1 "Sex assigned at birth: female" ///
					2 "Sex assigned at birth: male" ///
					3 "Ethnicity: White" ///
					4 "Ethnicity: Mixed" ///
					5 "Ethnicity: Indian" ///
					6 "Ethnicity: Pakistani & Bangladeshi" ///
					7 "Ethnicity: Black" ///
					8 "Ethnicity: Other" ///
					9 "Sexual identity: heterosexual" ///
					10 "Sexual identity: sexual minority" ///
					11 "Childhood poverty: no" ///
					12 "Childhood poverty: yes" ///
					, angle(horizontal) labsize(*0.8) notick) ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_label", replace)
				
				graph save "$descriptivegraphs/analysis_label", replace  
				
			restore
				
				
			* Kessler-6

			preserve

			keep if outcome == "Kessler-6"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Psychological distress" "(Kessler-6)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_1($step_1)$max_1, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_k6", replace)
				
				graph save "$descriptivegraphs/analysis_k6", replace 
				
			restore
		
		* Caseness

			preserve

			keep if outcome == "Caseness"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Caseness" "(Kessler-6 = 13+) ", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_2($step_2)$max_2, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_caseness", replace)
				
				graph save "$descriptivegraphs/analysis_caseness", replace 
				
			restore
			
			
		* SWEMWBS

			preserve

			keep if outcome == "SWEMWBS"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Psychological wellbeing" "(SWEMWBS)", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_3($step_3)$max_3, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_swemwbs", replace)
				
				graph save "$descriptivegraphs/analysis_swemwbs", replace 
				
			restore
			
			
		* Self-harm (any)

			preserve

			keep if outcome == "Self-harm (any)"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Any self-harm" "in last 12 months", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_4($step_4)$max_4, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_selfharm", replace)
				
				graph save "$descriptivegraphs/analysis_selfharm", replace 
				
			restore
			
		* Suicide attempts

			preserve

			keep if outcome == "Attempted suicide (ever)"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Lifetime" "suicide attempts", size(*.7)) /// 
				xtitle("Weighted probability and 95% CI", size(*.8)) /// 
				xlabel($min_5($step_5)$max_5, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_suicide", replace)
				
				graph save "$descriptivegraphs/analysis_suicide", replace 
				
			restore
			
			
		* Self-harm (number)

			preserve

			keep if outcome == "Self-harm (number)"
			
			twoway ///
				(rspike lb ub category_comb if category_comb == 1,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 2,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 3,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 4,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 5,	horizontal lcolor(stc3%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 6,	horizontal lcolor(stc4%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 7,	horizontal lcolor(stc6%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 8,	horizontal lcolor(stc5%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 9,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 10,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 11,	horizontal lcolor(stc1%60) lwidth(*4)) ///
				(rspike lb ub category_comb if category_comb == 12,	horizontal lcolor(stc2%60) lwidth(*4)) ///
				///
				(scatter category_comb estimate if category_comb == 1,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 2,	mcolor(black) msymbol(O)) ///
				(scatter category_comb estimate if category_comb == 3,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 4,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 5,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 6,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 7,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 8,	mcolor(black) msymbol(S)) ///
				(scatter category_comb estimate if category_comb == 9,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 10,	mcolor(black) msymbol(D)) ///
				(scatter category_comb estimate if category_comb == 11,	mcolor(black) msymbol(T)) ///
				(scatter category_comb estimate if category_comb == 12,	mcolor(black) msymbol(T)) ///
				, ///
				title("Number of" "self-harm behaviours", size(*.7)) /// 
				xtitle("Weighted mean and 95% CI", size(*.8)) /// 
				xlabel($min_6($step_6)$max_6, angle(horizontal) labsize(*.8)) ///
				ylab( $ylabmin (1) $ylabmax , nolab) ///
				ytitle("") ///
				yscale(reverse) ///
				legend(off) ///
				name("analysis_selfharm_cont", replace)
				
				graph save "$descriptivegraphs/analysis_selfharm_cont", replace 
				
			restore		
			
		
	**## Combined graphs

		foreach var in ethnicity sexuality analysis {
			graph combine ///
				"$descriptivegraphs/`var'_label" ///
				"$descriptivegraphs/`var'_label" ///
				"$descriptivegraphs/`var'_k6" ///
				"$descriptivegraphs/`var'_caseness" ///
				"$descriptivegraphs/`var'_selfharm" ///
				"$descriptivegraphs/`var'_selfharm_cont" ///
				"$descriptivegraphs/`var'_swemwbs" ///
				"$descriptivegraphs/`var'_suicide" ///
				, colf rows(2) name(`var'_comb, replace)
				
			graph save "$descriptivegraphs/`var'_comb", replace
			graph export "$descriptivegraphs/`var'_comb.pdf", replace
			graph export "$descriptivegraphs/`var'_comb.svg", replace
			graph export "$descriptivegraphs/`var'_comb.png", replace width(1000)
		}