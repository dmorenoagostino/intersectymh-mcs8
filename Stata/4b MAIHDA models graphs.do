kaboom

**# Kessler-6 - continuous - all participants

	global miny_pred = 0
	global maxy_pred = 20
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -2
	global maxy_random = 2.2
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "1 Main" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 score", size(*1.2)) ///
			ylabel(0(4)20, angle(horizontal) labsize(*1)) ///
			yline(0(4)20, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6, replace) ///
			xsize(5) 
			
	graph save "estimates/pred_k6", replace 
	graph export "estimates/pred_k6.png", replace width(1000)
	graph export "estimates/pred_k6.pdf", replace 
	
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 score", size(*1.2)) ///
			ylabel(-2(0.5)2.2, angle(horizontal) labsize(*1)) ///
			yline(-2(0.5)2.2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6, replace) ///
			xsize(5) 
			
		graph save "estimates/random_k6", replace 
		graph export "estimates/random_k6.png", replace width(1000)
		graph export "estimates/random_k6.pdf", replace 
	
	
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	global miny = 0
	global maxy = 20
	global rangey = $maxy - $miny
	global markeradd = $rangey / 20
	
	gen pred_main_marker = pred_main_ub + $markeradd
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 score", size(*1.2)) ///
			ylabel(0(4)20, angle(horizontal) labsize(*1)) ///
			yline(0(4)20, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/pred_k6_ipw", replace
		graph export "estimates/pred_k6_ipw.png", replace width(1000)
		graph export "estimates/pred_k6_ipw.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 score", size(*1.2)) ///
			ylabel(-2(0.5)2.2, angle(horizontal) labsize(*1)) ///
			yline(-2(0.5)2.2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/random_k6_ipw", replace
		graph export "estimates/random_k6_ipw.png", replace width(1000)
		graph export "estimates/random_k6_ipw.pdf", replace 
		

**********************************************************************
**********************************************************************
**********************************************************************

	
**# Kessler-6 - continuous - excluding mop-up survey // SENS CHECK
	
	global miny_pred = 0
	global maxy_pred = 20
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -2
	global maxy_random = 2.2
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "2 No mop-up" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 score", size(*1.2)) ///
			ylabel(0(4)20, angle(horizontal) labsize(*1)) ///
			yline(0(4)20, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_nomopup, replace) ///
			xsize(5) 
			
		graph save "estimates/nomopup/pred_k6_nomopup", replace 
		graph export "estimates/nomopup/pred_k6_nomopup.png", replace width(1000)
		graph export "estimates/nomopup/pred_k6_nomopup.pdf", replace 
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 score", size(*1.2)) ///
			ylabel(-2(0.5)2.2, angle(horizontal) labsize(*1)) ///
			yline(-2(0.5)2.2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_nomopup, replace) ///
			xsize(5) 
			
		graph save "estimates/nomopup/random_k6_nomopup", replace 
		graph export "estimates/nomopup/random_k6_nomopup.png", replace width(1000)
		graph export "estimates/nomopup/random_k6_nomopup.pdf", replace 
	
	
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "2 No mop-up" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 score", size(*1.2)) ///
			ylabel(0(4)20, angle(horizontal) labsize(*1)) ///
			yline(0(4)20, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_nomopup_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/nomopup/pred_k6_nomopup_ipw", replace 
		graph export "estimates/nomopup/pred_k6_nomopup_ipw.png", replace width(1000)
		graph export "estimates/nomopup/pred_k6_nomopup_ipw.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 score", size(*1.2)) ///
			ylabel(-2(0.5)2.2, angle(horizontal) labsize(*1)) ///
			yline(-2(0.5)2.2, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_nomopup_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/nomopup/random_k6_nomopup_ipw", replace 
		graph export "estimates/nomopup/random_k6_nomopup_ipw.png", replace width(1000)
		graph export "estimates/nomopup/random_k6_nomopup_ipw.pdf", replace 
		
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Kessler-6 - partially invariant factor scores 
	
	global miny_pred = -1
	global maxy_pred = 1.6
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.3
	global maxy_random = 0.4
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "3 Factor scores" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 factor score", size(*1.2)) ///
			ylabel(-1(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-1(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_fscore, replace) ///
			xsize(5) 
		
		graph save "estimates/fscores/pred_k6_fscore", replace 
		graph export "estimates/fscores/pred_k6_fscore.png", replace width(1000)
		graph export "estimates/fscores/pred_k6_fscore.pdf", replace 
	
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 factor score", size(*1.2)) ///
			ylabel(-0.3(0.1)0.4, angle(horizontal) labsize(*1)) ///
			yline(-0.3(0.1)0.4, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_fscore, replace) ///
			xsize(5) 
			
		graph save "estimates/fscores/random_k6_fscore", replace
		graph export "estimates/fscores/random_k6_fscore.png", replace width(1000)
		graph export "estimates/fscores/random_k6_fscore.pdf", replace 
		
		
		
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "1 Kessler-6" & type == "3 Factor scores" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "Kessler-6 factor score", size(*1.2)) ///
			ylabel(-1(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-1(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_k6_fscore_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/fscores/pred_k6_fscore_ipw", replace 
		graph export "estimates/fscores/pred_k6_fscore_ipw.png", replace width(1000)
		graph export "estimates/fscores/pred_k6_fscore_ipw.pdf", replace 

	
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "Kessler-6 factor score", size(*1.2)) ///
			ylabel(-0.3(0.1)0.4, angle(horizontal) labsize(*1)) ///
			yline(-0.3(0.1)0.4, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_k6_fscore_ipw, replace) ///
			xsize(5) 

		graph save "estimates/fscores/random_k6_fscore_ipw", replace 
		graph export "estimates/fscores/random_k6_fscore_ipw.png", replace width(1000)
		graph export "estimates/fscores/random_k6_fscore_ipw.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Caseness (Kessler-6 = 13+) - all participants

	global miny_pred = 0
	global maxy_pred = 90
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "1 Main" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(0(10)90, angle(horizontal) labsize(*1)) ///
			yline(0(10)90, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness, replace) ///
			xsize(5) 

		graph save "estimates/pred_caseness", replace 
		graph export "estimates/pred_caseness.png", replace width(1000)
		graph export "estimates/pred_caseness.pdf", replace 
		
		
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness, replace) ///
			xsize(5) 

		graph save "estimates/random_caseness", replace 
		graph export "estimates/random_caseness.png", replace width(1000)
		graph export "estimates/random_caseness.pdf", replace 
	
	
	**## Weighted
	
	* Predicted levels
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(0(10)90, angle(horizontal) labsize(*1)) ///
			yline(0(10)90, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/pred_caseness_ipw", replace
		graph export "estimates/pred_caseness_ipw.png", replace width(1000)
		graph export "estimates/pred_caseness_ipw.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness_ipw, replace) ///
			xsize(5) 

		graph save "estimates/random_caseness_ipw", replace 
		graph export "estimates/random_caseness_ipw.png", replace width(1000)
		graph export "estimates/random_caseness_ipw.pdf", replace 
	
	
**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Caseness (Kessler-6 = 13+) - excluding mop-up survey // SENS CHECK
	
	global miny_pred = 0
	global maxy_pred = 90
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "2 No mop-up" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(0(10)90, angle(horizontal) labsize(*1)) ///
			yline(0(10)90, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness_nomopup, replace) ///
			xsize(5) 
		
		graph save "estimates/nomopup/pred_caseness_nomopup", replace 
		graph export "estimates/nomopup/pred_caseness_nomopup.png", replace width(1000)
		graph export "estimates/nomopup/pred_caseness_nomopup.pdf", replace 
		
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness_nomopup, replace) ///
			xsize(5) 

		graph save "estimates/nomopup/random_caseness_nomopup", replace 
		graph export "estimates/nomopup/random_caseness_nomopup.png", replace width(1000)
		graph export "estimates/nomopup/random_caseness_nomopup.pdf", replace 
	
	
	
	**## Weighted
	
	* Predicted levels
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "2 Caseness" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(0(10)90, angle(horizontal) labsize(*1)) ///
			yline(0(10)90, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_caseness_nomopup_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/nomopup/pred_caseness_nomopup_ipw", replace 
		graph export "estimates/nomopup/pred_caseness_nomopup_ipw.png", replace width(1000)
		graph export "estimates/nomopup/pred_caseness_nomopup_ipw.pdf", replace 
	
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "caseness (Kessler-6 score > 12)", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_caseness_nomopup_ipw, replace) ///
			xsize(5) 

		graph save "estimates/nomopup/random_caseness_nomopup_ipw", replace 
		graph export "estimates/nomopup/random_caseness_nomopup_ipw.png", replace width(1000)
		graph export "estimates/nomopup/random_caseness_nomopup_ipw.pdf", replace 
		
	
**********************************************************************
**********************************************************************
**********************************************************************
	
	
**# SWEMWBS - continuous - does not include mop-up survey by design

	global miny_pred = 16
	global maxy_pred = 30
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -1.5
	global maxy_random = 1.5
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "1 Main" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS score", size(*1.2)) ///
			ylabel(16(2)30, angle(horizontal) labsize(*1)) ///
			yline(16(2)30, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs, replace) ///
			xsize(5) 
			
		graph save "estimates/pred_swemwbs", replace 
		graph export "estimates/pred_swemwbs.png", replace width(1000)
		graph export "estimates/pred_swemwbs.pdf", replace 

	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS score", size(*1.2)) ///
			ylabel(-1.5(0.5)1.5, angle(horizontal) labsize(*1)) ///
			yline(-1.5(0.5)1.5, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs, replace) ///
			xsize(5) 
	
		graph save "estimates/random_swemwbs", replace 
		graph export "estimates/random_swemwbs.png", replace width(1000)
		graph export "estimates/random_swemwbs.pdf", replace 
		
		
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS score", size(*1.2)) ///
			ylabel(16(2)30, angle(horizontal) labsize(*1)) ///
			yline(16(2)30, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/pred_swemwbs_ipw", replace 
		graph export "estimates/pred_swemwbs_ipw.png", replace width(1000)
		graph export "estimates/pred_swemwbs_ipw.pdf", replace 
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS score", size(*1.2)) ///
			ylabel(-1.5(0.5)1.5, angle(horizontal) labsize(*1)) ///
			yline(-1.5(0.5)1.5, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_ipw, replace) ///
			xsize(5) 

		graph save "estimates/random_swemwbs_ipw", replace 
		graph export "estimates/random_swemwbs_ipw.png", replace width(1000)
		graph export "estimates/random_swemwbs_ipw.pdf", replace 
	

**********************************************************************
**********************************************************************
**********************************************************************


**# SWEMWBS - partially invariant factor scores - does not include mop-up survey by design

	global miny_pred = -1
	global maxy_pred = 1
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.3
	global maxy_random = 0.4
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "3 Factor scores" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS factor score", size(*1.2)) ///
			ylabel(-1(0.25)1, angle(horizontal) labsize(*1)) ///
			yline(-1(0.25)1, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_fscore, replace) ///
			xsize(5) 
		
		graph export "estimates/fscores/pred_swemwbs_fscore.pdf", replace 
		graph export "estimates/fscores/pred_swemwbs_fscore.png", replace width(1000)
		graph export "estimates/fscores/pred_swemwbs_fscore.pdf", replace 
	
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS factor score", size(*1.2)) ///
			ylabel(-0.3(0.1)0.3, angle(horizontal) labsize(*1)) ///
			yline(-0.3(0.1)0.3, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_fscore, replace) ///
			xsize(5) 
	
		graph save "estimates/fscores/random_swemwbs_fscore", replace 
		graph export "estimates/fscores/random_swemwbs_fscore.png", replace width(1000)
		graph export "estimates/fscores/random_swemwbs_fscore.pdf", replace 
		
		
		
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "3 SWEMWBS" & type == "3 Factor scores" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted levels" "SWEMWBS factor score", size(*1.2)) ///
			ylabel(-1(0.25)1, angle(horizontal) labsize(*1)) ///
			yline(-1(0.25)1, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_swemwbs_fscore_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/fscores/pred_swemwbs_fscore_ipw", replace 
		graph export "estimates/fscores/pred_swemwbs_fscore_ipw.png", replace width(1000)
		graph export "estimates/fscores/pred_swemwbs_fscore_ipw.pdf", replace 
	
	* Random / intersectional effects
		
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific random effects" "SWEMWBS factor score", size(*1.2)) ///
			ylabel(-0.3(0.1)0.3, angle(horizontal) labsize(*1)) ///
			yline(-0.3(0.1)0.3, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_swemwbs_fscore_ipw, replace) ///
			xsize(5) 

		graph save "estimates/fscores/random_swemwbs_fscore_ipw", replace 
		graph export "estimates/fscores/random_swemwbs_fscore_ipw.png", replace width(1000)
		graph export "estimates/fscores/random_swemwbs_fscore_ipw.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm (any) - excludes mop-up survey by design

	global miny_pred = 0
	global maxy_pred = 80
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -20
	global maxy_random = 20
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "1 Main" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel(0(10)80, angle(horizontal) labsize(*1)) ///
			yline(0(10)80, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm, replace) ///
			xsize(5) 
		
		graph save "estimates/pred_selfharm", replace 
		graph export "estimates/pred_selfharm.png", replace width(1000)
		graph export "estimates/pred_selfharm.pdf", replace 
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm, replace) ///
			xsize(5) 
	
		graph save "estimates/random_selfharm", replace 
		graph export "estimates/random_selfharm.png", replace width(1000)
		graph export "estimates/random_selfharm.pdf", replace 
	
	
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel(0(10)80, angle(horizontal) labsize(*1)) ///
			yline(0(10)80, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_ipw, replace) ///
			xsize(5) 	
		
		graph save "estimates/pred_selfharm_ipw", replace 
		graph export "estimates/pred_selfharm_ipw.png", replace width(1000)
		graph export "estimates/pred_selfharm_ipw.pdf", replace 
	
	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "self-harmed in any way", size(*1.2)) ///
			ylabel(-20(5)20, angle(horizontal) labsize(*1)) ///
			yline(-20(5)20, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/random_selfharm_ipw", replace 
		graph export "estimates/random_selfharm_ipw.png", replace width(1000)
		graph export "estimates/random_selfharm_ipw.pdf", replace 
	
	
**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - mepoisson

	global miny_pred = 0
	global maxy_pred = 3.25
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.5
	global maxy_random = 1.6
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4a Count, Poisson" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(0(0.5)3.25, angle(horizontal) labsize(*1)) ///
			yline(0(0.5)3.25, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_poisson, replace) ///
			xsize(5) 
			
		graph save "estimates/selfharm_cont/pred_selfharm_poisson", replace 
		graph export "estimates/selfharm_cont/pred_selfharm_poisson.png", replace width(1000)
		graph export "estimates/selfharm_cont/pred_selfharm_poisson.pdf", replace 
			
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(-0.5(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-0.5(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_poisson, replace) ///
			xsize(5) 
			
		graph save "estimates/selfharm_cont/random_selfharm_poisson", replace 
		graph export "estimates/selfharm_cont/random_selfharm_poisson.png", replace width(1000)
		graph export "estimates/selfharm_cont/random_selfharm_poisson.pdf", replace 

		
	**## Weighted
	
	* Predicted levels
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4a Count, Poisson" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(0(0.5)3.25, angle(horizontal) labsize(*1)) ///
			yline(0(0.5)3.25, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_poisson_ipw, replace) ///
			xsize(5) 
	
		graph save "estimates/selfharm_cont/pred_selfharm_poisson_ipw", replace 
		graph export "estimates/selfharm_cont/pred_selfharm_poisson_ipw.png", replace width(1000)
		graph export "estimates/selfharm_cont/pred_selfharm_poisson_ipw.pdf", replace 
			
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(-0.5(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-0.5(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_poisson_ipw, replace) ///
			xsize(5) 

		graph save "estimates/selfharm_cont/random_selfharm_poisson_ipw", replace 
		graph export "estimates/selfharm_cont/random_selfharm_poisson_ipw.png", replace width(1000)
		graph export "estimates/selfharm_cont/random_selfharm_poisson_ipw.pdf", replace 


**********************************************************************
**********************************************************************
**********************************************************************


**# Self-harm - count - negative binomial

	
	**## Unweighted
	
	* Predicted levels
	
	global miny_pred = 0
	global maxy_pred = 3.25
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -0.5
	global maxy_random = 1.6
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4b Count, Negative binomial" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(0(0.5)3.25, angle(horizontal) labsize(*1)) ///
			yline(0(0.5)3.25, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_nbreg, replace) ///
			xsize(5) 
	
		graph save "estimates/selfharm_cont/pred_selfharm_nbreg", replace 
		graph export "estimates/selfharm_cont/pred_selfharm_nbreg.png", replace width(1000)
		graph export "estimates/selfharm_cont/pred_selfharm_nbreg.pdf", replace 
			
	
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(-0.5(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-0.5(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_nbreg, replace) ///
			xsize(5) 
			
		graph save "estimates/selfharm_cont/random_selfharm_nbreg", replace 
		graph export "estimates/selfharm_cont/random_selfharm_nbreg.png", replace width(1000)
		graph export "estimates/selfharm_cont/random_selfharm_nbreg.pdf", replace 

		
	**## Weighted
	
	* Predicted levels
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "4 Self-harm" & type == "4b Count, Negative binomial" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(0(0.5)3.25, angle(horizontal) labsize(*1)) ///
			yline(0(0.5)3.25, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_selfharm_nbreg_ipw, replace) ///
			xsize(5) 
	
		graph save "estimates/selfharm_cont/pred_selfharm_nbreg_ipw", replace 
		graph export "estimates/selfharm_cont/pred_selfharm_nbreg_ipw.png", replace width(1000)
		graph export "estimates/selfharm_cont/pred_selfharm_nbreg_ipw.pdf", replace 
			
	* Random / intersectional effects // using similar approach as Evans et al 2024 for binary outcomes
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted" "number of different self-harm behaviours", size(*1.2)) ///
			ylabel(-0.5(0.25)1.6, angle(horizontal) labsize(*1)) ///
			yline(-0.5(0.25)1.6, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_selfharm_nbreg_ipw, replace) ///
			xsize(5) 

		graph save "estimates/selfharm_cont/random_selfharm_nbreg_ipw", replace 
		graph export "estimates/selfharm_cont/random_selfharm_nbreg_ipw.png", replace width(1000)
		graph export "estimates/selfharm_cont/random_selfharm_nbreg_ipw.pdf", replace 


**********************************************************************
**********************************************************************
**********************************************************************
		
	
**# Suicide (ever) - excludes mop-up survey by design, extend to IPW with/when approach for CIs

	global miny_pred = 0
	global maxy_pred = 60
	global rangey_pred = $maxy_pred - $miny_pred
	global markeradd_pred = $rangey_pred / 20
	
	global miny_random = -10
	global maxy_random = 17
	global rangey_random = $maxy_random - $miny_random
	global markeradd_random = $rangey_random / 20

	**## Unweighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "5 Suicide" & type == "1 Main" & weighted == 0 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel(0(10)60, angle(horizontal) labsize(*1)) ///
			yline(0(10)60, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_suicide, replace) ///
			xsize(5) 
				
		graph save "estimates/pred_suicide", replace 
		graph export "estimates/pred_suicide.png", replace width(1000)
		graph export "estimates/pred_suicide.pdf", replace 

	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel(-10(5)17, angle(horizontal) labsize(*1)) ///
			yline(-10(5)17, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_suicide, replace) ///
			xsize(5) 
			
		graph save "estimates/random_suicide", replace 
		graph export "estimates/random_suicide.png", replace width(1000)
		graph export "estimates/random_suicide.pdf", replace 
		
		
	**## Weighted
	
	use "20260727_maihda_predictions_supptable", clear
	keep if outcome == "5 Suicide" & type == "1 Main" & weighted == 1 & n != .
	ta strata
		global maxlab = r(r)
	
	* Predicted levels
	
	gen pred_main_marker = pred_main_ub + $markeradd_pred
	
		twoway ///
			(rspike pred_main_ub pred_main_lb pred_rank, lcolor(gs4)) ///
			(scatter pred_main pred_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter pred_main_marker pred_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))), ///
			ytitle("Stratum-specific predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel(0(10)60, angle(horizontal) labsize(*1)) ///
			yline(0(10)60, lwidth(vthin) lcolor(gray)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(pred_suicide_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/pred_suicide_ipw", replace 
		graph export "estimates/pred_suicide_ipw.png", replace width(1000)
		graph export "estimates/pred_suicide_ipw.pdf", replace 

	* Random / intersectional effects
	
	gen random_main_marker = random_main_ub + $markeradd_random
		
		twoway ///
			(rspike random_main_ub random_main_lb random_rank, lcolor(gs4)) ///
			(scatter random_main random_rank, mcolor(black) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(black))) ///
			(rspike random_main_ub random_main_lb random_rank if random_main_ub < 0 | random_main_lb > 0, lcolor(red)) ///
			(scatter random_main random_rank if random_main_ub < 0 | random_main_lb > 0, mcolor(red) msymbol(smcircle)) ///
			(scatter random_main_marker random_rank if random_main_ub < 0 | random_main_lb > 0, msymbol(i) mlabel(strata48) mlabangle(90) mlabposition(0) mlabtextstyle(color(red))), ///
			ytitle("Stratum-specific difference in predicted %" "ever attempted suicide", size(*1.2)) ///
			ylabel(-10(5)17, angle(horizontal) labsize(*1)) ///
			yline(-10(5)17, lwidth(vthin) lcolor(gray)) ///
			yline(0, lcolor(red)) ///
			xtitle("Stratum rank", size(*1.2)) ///
			xlabel(1 10(10)$maxlab, labsize(*1)) ///
			legend(off) ///
			scheme(s1mono) ///
			name(random_suicide_ipw, replace) ///
			xsize(5) 
			
		graph save "estimates/random_suicide_ipw", replace 
		graph export "estimates/random_suicide_ipw.png", replace width(1000)
		graph export "estimates/random_suicide_ipw.pdf", replace 
		
		
**********************************************************************
**********************************************************************
**********************************************************************


**# Graph combinations

foreach outcome in k6 caseness swemwbs selfharm suicide {
	graph combine "estimates/pred_`outcome'_ipw" "estimates/random_`outcome'_ipw", rows(2) xsize(4) iscale(*0.85) name(comb_`outcome', replace)
	graph save "estimates/comb_`outcome'_ipw", replace
		graph export "estimates/comb_`outcome'_ipw.png", replace
		graph export "estimates/comb_`outcome'_ipw.pdf", replace
		graph export "estimates/comb_`outcome'_ipw.svg", replace

}


foreach outcome in k6 caseness {
	graph combine "estimates/nomopup/pred_`outcome'_nomopup_ipw" "estimates/nomopup/random_`outcome'_nomopup_ipw", rows(2) xsize(4) iscale(*0.85) name(comb_`outcome', replace)
	graph save "estimates/nomopup/comb_`outcome'_nomopup_ipw", replace
		graph export "estimates/nomopup/comb_`outcome'_nomopup_ipw.png", replace
		graph export "estimates/nomopup/comb_`outcome'_nomopup_ipw.pdf", replace
		graph export "estimates/nomopup/comb_`outcome'_nomopup_ipw.svg", replace
}

foreach outcome in k6 swemwbs {
	graph combine "estimates/fscores/pred_`outcome'_fscore_ipw" "estimates/fscores/random_`outcome'_fscore_ipw", rows(2) xsize(4) iscale(*0.85) name(comb_`outcome', replace)
	graph save "estimates/fscores/comb_`outcome'_fscore_ipw", replace
		graph export "estimates/fscores/comb_`outcome'_fscore_ipw.png", replace
		graph export "estimates/fscores/comb_`outcome'_fscore_ipw.pdf", replace
		graph export "estimates/fscores/comb_`outcome'_fscore_ipw.svg", replace
}


	**## Self-harm_cont graphs

		graph combine ///
			"estimates/selfharm_cont/pred_selfharm_poisson_ipw" ///
			"estimates/selfharm_cont/random_selfharm_poisson_ipw" ///
			, title("Poisson", size(*0.75)) rows(2) xsize(4) iscale(*0.85) name(comb_selfharm_poisson_ipw, replace)

		graph combine ///
			"estimates/selfharm_cont/pred_selfharm_nbreg_ipw" ///
			"estimates/selfharm_cont/random_selfharm_nbreg_ipw" ///
			, title("Negative binomial", size(*0.75)) rows(2) xsize(4) iscale(*0.85) name(comb_selfharm_nbreg_ipw, replace)

		graph combine comb_selfharm_nbreg_ipw comb_selfharm_poisson_ipw, rows(1) ysize(5) name(comb_selfharm_cont_ipw, replace)
		
		graph save "estimates/selfharm_cont/comb_selfharm_cont_ipw", replace
		graph export "estimates/selfharm_cont/comb_selfharm_cont_ipw.png", replace
		graph export "estimates/selfharm_cont/comb_selfharm_cont_ipw.pdf", replace
		graph export "estimates/selfharm_cont/comb_selfharm_cont_ipw.svg", replace