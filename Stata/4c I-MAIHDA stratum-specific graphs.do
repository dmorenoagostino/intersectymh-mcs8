/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 4c. I-MAIHDA stratum-specific graphs
	
		This code uses the results from the predictions table created in the 
		previous script	(part 4b) to produce the graphs depicting the 
		stratum-specific predicted levels and random effects.
		
		Portions of this code were adapted from: 
		Evans, C.R., G. Leckie, S.V. Subramanian, A. Bell, & J. Merlo. (2024.).
		A Tutorial for Conducting Intersectional Multilevel Analysis of Individual 
		Heterogeneity and Discriminatory Accuracy (MAIHDA). SSM - Population Health.	 
		https://doi.org/10.1016/j.ssmph.2024.101664

*/

**# Setup

	global estimates "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Estimates" // folder where results from models are saved

**# Kessler-6 - partially invariant factor scores - all participants

	global miny_pred = -1
	global maxy_pred = 1.75
	global stepy_pred = 0.25
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.3
	global maxy_random = 0.4
	global stepy_random = 0.1
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "1 Main" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6, replace) ///
			xsize(5) 
			
		graph save "$estimates/pred_k6", replace
		graph export "$estimates/pred_k6.png", replace width(1000)
		graph export "$estimates/pred_k6.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6, replace) ///
			xsize(5) 
			
		graph save "$estimates/random_k6", replace
		graph export "$estimates/random_k6.png", replace width(1000)
		graph export "$estimates/random_k6.pdf", replace 
		

**********************************************************************
**********************************************************************
**********************************************************************


**# Kessler-6 - sum scores 
	
	global miny_pred = 0
	global maxy_pred = 20
	global stepy_pred = 4
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -2
	global maxy_random = 2.2
	global stepy_random = 0.5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "2 Sum scores" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 sum score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_sumscore, replace) ///
			xsize(5) 
			
		graph save "$estimates/sumscores/pred_k6_sumscore", replace 
		graph export "$estimates/sumscores/pred_k6_sumscore.png", replace width(1000)
		graph export "$estimates/sumscores/pred_k6_sumscore.pdf", replace 

	
	
	* Random / intersectional effects
		
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 sum score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_sumscore, replace) ///
			xsize(5) 

		graph save "$estimates/sumscores/random_k6_sumscore", replace 
		graph export "$estimates/sumscores/random_k6_sumscore.png", replace width(1000)
		graph export "$estimates/sumscores/random_k6_sumscore.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************

	
**# Kessler-6 - partially invariant factor scores - excluding mop-up survey
	
	global miny_pred = -1
	global maxy_pred = 1.75
	global stepy_pred = 0.25
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.3
	global maxy_random = 0.4
	global stepy_random = 0.1
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20
	
	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "3 No mop-up" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_nomopup, replace) ///
			xsize(5) 
			
		graph save "$estimates/nomopup/pred_k6_nomopup", replace 
		graph export "$estimates/nomopup/pred_k6_nomopup.png", replace width(1000)
		graph export "$estimates/nomopup/pred_k6_nomopup.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 factor score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_nomopup, replace) ///
			xsize(5) 
			
		graph save "$estimates/nomopup/random_k6_nomopup", replace 
		graph export "$estimates/nomopup/random_k6_nomopup.png", replace width(1000)
		graph export "$estimates/nomopup/random_k6_nomopup.pdf", replace 
		
	
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Caseness (Kessler-6 = 13+) - all participants

	global miny_pred = 0
	global maxy_pred = 90
	global stepy_pred = 10
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global stepy_random = 5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	* Predicted levels
	
	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "1 Main" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 sum score ≥ 13)", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness, replace) ///
			xsize(5) 
			
		graph save "$estimates/pred_caseness", replace
		graph export "$estimates/pred_caseness.png", replace width(1000)
		graph export "$estimates/pred_caseness.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 sum score ≥ 13)", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness, replace) ///
			xsize(5) 

		graph save "$estimates/random_caseness", replace 
		graph export "$estimates/random_caseness.png", replace width(1000)
		graph export "$estimates/random_caseness.pdf", replace 
	
	
**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Caseness (Kessler-6 = 13+) - excluding mop-up survey
	
	/* using same as above
	global miny_pred = 0
	global maxy_pred = 90
	global stepy_pred = 10
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global stepy_random = 5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20
	*/

	* Predicted levels
	
	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "3 No mop-up" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 sum score ≥ 13)", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness_nomopup, replace) ///
			xsize(5) 
			
		graph save "$estimates/nomopup/pred_caseness_nomopup", replace 
		graph export "$estimates/nomopup/pred_caseness_nomopup.png", replace width(1000)
		graph export "$estimates/nomopup/pred_caseness_nomopup.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 sum score ≥ 13)", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness_nomopup, replace) ///
			xsize(5) 

		graph save "$estimates/nomopup/random_caseness_nomopup", replace 
		graph export "$estimates/nomopup/random_caseness_nomopup.png", replace width(1000)
		graph export "$estimates/nomopup/random_caseness_nomopup.pdf", replace 
		
	
**********************************************************************
**********************************************************************
**********************************************************************
	
	
**# SWEMWBS - partially invariant factor scores

	global miny_pred = -1
	global maxy_pred = 1
	global stepy_pred = 0.25
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.3
	global maxy_random = 0.4
	global stepy_random = 0.1
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "1 Main" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS factor score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs, replace) ///
			xsize(5) 
			
		graph save "$estimates/pred_swemwbs", replace 
		graph export "$estimates/pred_swemwbs.png", replace width(1000)
		graph export "$estimates/pred_swemwbs.pdf", replace 
	
	* Random / intersectional effects
		
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS factor score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs, replace) ///
			xsize(5) 

		graph save "$estimates/random_swemwbs", replace 
		graph export "$estimates/random_swemwbs.png", replace width(1000)
		graph export "$estimates/random_swemwbs.pdf", replace 
	

**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS - sum scores

	global miny_pred = 16
	global maxy_pred = 30
	global stepy_pred = 2
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -1.5
	global maxy_random = 1.5
	global stepy_random = 0.5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "2 Sum scores" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS sum score", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_sumscore, replace) ///
			xsize(5) 
			
		graph save "$estimates/sumscores/pred_swemwbs_sumscore", replace 
		graph export "$estimates/sumscores/pred_swemwbs_sumscore.png", replace width(1000)
		graph export "$estimates/sumscores/pred_swemwbs_sumscore.pdf", replace 
	
	* Random / intersectional effects
		
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS sum score", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_sumscore, replace) ///
			xsize(5) 

		graph save "$estimates/sumscores/random_swemwbs_sumscore", replace 
		graph export "$estimates/sumscores/random_swemwbs_sumscore.png", replace width(1000)
		graph export "$estimates/sumscores/random_swemwbs_sumscore.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm (any) 

	global miny_pred = 0
	global maxy_pred = 80
	global stepy_pred = 10
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global stepy_random = 5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "1 Main" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm, replace) ///
			xsize(5) 	
		
		graph save "$estimates/pred_selfharm", replace 
		graph export "$estimates/pred_selfharm.png", replace width(1000)
		graph export "$estimates/pred_selfharm.pdf", replace 
	
	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm, replace) ///
			xsize(5) 
			
		graph save "$estimates/random_selfharm", replace 
		graph export "$estimates/random_selfharm.png", replace width(1000)
		graph export "$estimates/random_selfharm.pdf", replace 
	
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - Poisson

	global miny_pred = 0
	global maxy_pred = 3.25
	global stepy_pred = 0.5
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.75
	global maxy_random = 1.6
	global stepy_random = 0.25
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4a Count, Poisson" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_poisson, replace) ///
			xsize(5) 
	
		graph save "$estimates/selfharm_cont/pred_selfharm_poisson", replace 
		graph export "$estimates/selfharm_cont/pred_selfharm_poisson.png", replace width(1000)
		graph export "$estimates/selfharm_cont/pred_selfharm_poisson.pdf", replace 
			
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_poisson, replace) ///
			xsize(5) 

		graph save "$estimates/selfharm_cont/random_selfharm_poisson", replace 
		graph export "$estimates/selfharm_cont/random_selfharm_poisson.png", replace width(1000)
		graph export "$estimates/selfharm_cont/random_selfharm_poisson.pdf", replace 


**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - Negative Binomial

	/* using same as above
	global miny_pred = 0
	global maxy_pred = 3.25
	global stepy_pred = 0.5
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.5
	global maxy_random = 1.6
	global stepy_random = 0.25
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20
	*/
	
	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4b Count, Negative binomial" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_nbreg, replace) ///
			xsize(5) 
	
		graph save "$estimates/selfharm_cont/pred_selfharm_nbreg", replace 
		graph export "$estimates/selfharm_cont/pred_selfharm_nbreg.png", replace width(1000)
		graph export "$estimates/selfharm_cont/pred_selfharm_nbreg.pdf", replace 
			
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_nbreg, replace) ///
			xsize(5) 

		graph save "$estimates/selfharm_cont/random_selfharm_nbreg", replace 
		graph export "$estimates/selfharm_cont/random_selfharm_nbreg.png", replace width(1000)
		graph export "$estimates/selfharm_cont/random_selfharm_nbreg.pdf", replace 


**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Lifetime suicide attempts

	global miny_pred = 0
	global maxy_pred = 60
	global stepy_pred = 10
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -10
	global maxy_random = 17
	global stepy_random = 5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	use "$estimates/maihda_predictions_supptable", clear
	keep if outcome == "5 Suicide" & type == "1 Main" & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen predicted_estimate_marker = predicted_ub + $markeradd_pred
	
		twoway ///
			(rspike predicted_ub predicted_lb predicted_rank_restricted, lcolor(gs4)) ///
			(scatter predicted_estimate predicted_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter predicted_estimate_marker predicted_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel($miny_pred($stepy_pred)$maxy_pred, angle(horizontal) labsize(*1)) ///
			yline($miny_pred($stepy_pred)$maxy_pred, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_suicide, replace) ///
			xsize(5) 
			
		graph save "$estimates/pred_suicide", replace 
		graph export "$estimates/pred_suicide.png", replace width(1000)
		graph export "$estimates/pred_suicide.pdf", replace 

	* Random / intersectional effects
	
	gen random_estimate_marker = random_ub + $markeradd_random
		
		twoway ///
			(rspike random_ub random_lb random_rank_restricted, lcolor(gs4)) ///
			(scatter random_estimate random_rank_restricted, mcolor(black) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_ub random_lb random_rank_restricted if random_ub < 0 | random_lb > 0, lcolor(red)) ///
			(scatter random_estimate random_rank_restricted if random_ub < 0 | random_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_estimate_marker random_rank_restricted if random_ub < 0 | random_lb > 0, msymbol(i) mlabel(strata) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel($miny_random($stepy_random)$maxy_random, angle(horizontal) labsize(*1)) ///
			yline($miny_random($stepy_random)$maxy_random, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_suicide, replace) ///
			xsize(5) 
			
		graph save "$estimates/random_suicide", replace 
		graph export "$estimates/random_suicide.png", replace width(1000)
		graph export "$estimates/random_suicide.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************

		
**# Graphs for manuscript

	* Main models
	
	foreach type in pred random {
		
		graph combine ///
			"$estimates/`type'_k6" "$estimates/`type'_caseness" "$estimates/`type'_swemwbs" "$estimates/`type'_selfharm" "$estimates/`type'_suicide" ///
			, row(2) holes(3) iscale(*0.80) name(comb_`type', replace)
			
		graph save "$estimates/`type'_comb", replace
		graph export "$estimates/`type'_comb.png", replace
		graph export "$estimates/`type'_comb.pdf", replace
		graph export "$estimates/`type'_comb.svg", replace
		
	}
		
		
	* Sum scores
		
	foreach outcome in k6 swemwbs {
		
		graph combine "$estimates/sumscores/pred_`outcome'_sumscore" "$estimates/sumscores/random_`outcome'_sumscore", rows(2) xsize(4) iscale(*0.85) name(comb_`outcome'_sumscore, replace)
		
	}
		
		graph combine ///
			comb_k6_sumscore comb_swemwbs_sumscore ///
			, name(comb_sumscore, replace)
			
		graph save "$estimates/sumscores/comb_sumscore", replace
		graph export "$estimates/sumscores/comb_sumscore.png", replace
		graph export "$estimates/sumscores/comb_sumscore.pdf", replace
		graph export "$estimates/sumscores/comb_sumscore.svg", replace
		
		
	* No mop-up
	
	foreach outcome in k6 caseness {
	
		graph combine "$estimates/nomopup/pred_`outcome'_nomopup" "$estimates/nomopup/random_`outcome'_nomopup", rows(2) xsize(4) iscale(*0.85) name(comb_`outcome'_nomopup, replace)
		
	}
		
		graph combine ///
			comb_k6_nomopup comb_caseness_nomopup ///
			, name(comb_nomopup, replace)
			
		graph save "$estimates/nomopup/comb_nomopup", replace
		graph export "$estimates/nomopup/comb_nomopup.png", replace
		graph export "$estimates/nomopup/comb_nomopup.pdf", replace
		graph export "$estimates/nomopup/comb_nomopup.svg", replace
		
		
		
	* Self-harm cont 
		
		graph combine ///
			"$estimates/selfharm_cont/pred_selfharm_poisson" ///
			"$estimates/selfharm_cont/random_selfharm_poisson" ///
			, title("Poisson", size(*0.75)) rows(2) xsize(4) iscale(*0.85) name(comb_selfharm_poisson, replace)

		graph combine ///
			"$estimates/selfharm_cont/pred_selfharm_nbreg" ///
			"$estimates/selfharm_cont/random_selfharm_nbreg" ///
			, title("Negative binomial", size(*0.75)) rows(2) xsize(4) iscale(*0.85) name(comb_selfharm_nbreg, replace)

		graph combine comb_selfharm_nbreg comb_selfharm_poisson, rows(1) ysize(5) name(comb_selfharm_cont, replace)
		
		graph save "$estimates/selfharm_cont/comb_selfharm_cont", replace
		graph export "$estimates/selfharm_cont/comb_selfharm_cont.png", replace
		graph export "$estimates/selfharm_cont/comb_selfharm_cont.pdf", replace
		graph export "$estimates/selfharm_cont/comb_selfharm_cont.svg", replace