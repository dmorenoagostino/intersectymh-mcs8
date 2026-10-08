/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 4a. I-MAIHDA model-wide tables and coefficient plots
	
		This code uses the results from models ran in the previous script
		(part 3) to export them to a combined results table. 
		
		It then uses that table to produce plots depicting the coefficients for
		the main/additive effects across the different models.
	
		Portions of this code were adapted from: 
		Evans, C.R., G. Leckie, S.V. Subramanian, A. Bell, & J. Merlo. (2024.).
		A Tutorial for Conducting Intersectional Multilevel Analysis of Individual 
		Heterogeneity and Discriminatory Accuracy (MAIHDA). SSM - Population Health.	 
		https://doi.org/10.1016/j.ssmph.2024.101664

*/

**# Setup

	global excelfile "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses" // folder where Excel file with results is located
	
	global estimates "C:\Users\qtnzdmo\OneDrive - University College London\# CLS\# Projects\Intersectional measurement and analysis\WT EC awards\#Studies\Study 1 - A proof of concept\Analyses\Estimates" // folder where results from models are saved
	
	* Create subfolders for coefficient plots
		
		cap mkdir "$estimates/coeffplots"


**# Set Excel file

	putexcel set "$excelfile/MMV MCS23 results.xlsx", modify sheet("maihda")
	
	putexcel A1 = "Outcome"
	putexcel B1 = "N"
	
	putexcel C1 = "VPC null"
	putexcel D1 = "VPC (95% LB) null"
	putexcel E1 = "VPC (95% UB) null"
	putexcel F1 = "Sigma_u null"
	putexcel G1 = "VPC main"
	putexcel H1 = "VPC (95% LB) main"
	putexcel I1 = "VPC (95% UB) main"
	putexcel J1 = "Sigma_u main"
	putexcel K1 = "PCV"
	
	putexcel L1 = 	"coeff_Male"
	putexcel M1 = 	"LB_Male"
	putexcel N1 = 	"UB_Male"
	putexcel O1 = 	"pvalue_Male"

	putexcel P1 = 	"coeff_Mixed"
	putexcel Q1 = 	"LB_Mixed"
	putexcel R1 = 	"UB_Mixed"
	putexcel S1 = 	"pvalue_Mixed"

	putexcel T1 = 	"coeff_Indian"
	putexcel U1 = 	"LB_Indian"
	putexcel V1 = 	"UB_Indian"
	putexcel W1 = 	"pvalue_Indian"

	putexcel X1 = 	"coeff_Pakistani_Bangladeshi"
	putexcel Y1 = 	"LB_Pakistani_Bangladeshi"
	putexcel Z1 = 	"UB_Pakistani_Bangladeshi"
	putexcel AA1 = 	"pvalue_Pakistani_Bangladeshi"

	putexcel AB1 = 	"coeff_Black"
	putexcel AC1 = 	"LB_Black"
	putexcel AD1 = 	"UB_Black"
	putexcel AE1 = 	"pvalue_Black"

	putexcel AF1 = 	"coeff_Other"
	putexcel AG1 = 	"LB_Other"
	putexcel AH1 = 	"UB_Other"
	putexcel AI1 = 	"pvalue_Other"

	putexcel AJ1 = 	"coeff_Sexualminority"
	putexcel AK1 = 	"LB_Sexualminority"
	putexcel AL1 = 	"UB_Sexualminority"
	putexcel AM1 = 	"pvalue_Sexualminority"

	putexcel AN1 = 	"coeff_Childhoodpoverty"
	putexcel AO1 = 	"LB_Childhoodpoverty"
	putexcel AP1 = 	"UB_Childhoodpoverty"
	putexcel AQ1 = 	"pvalue_Childhoodpoverty"

	
**********************************************************************
**********************************************************************
**********************************************************************

**# MAIN MODELS

**## Kessler-6 - partially invariant factor scores - all participants

	local rownumber = 2

	use "$estimates/k6", clear
	
	putexcel A`rownumber' = "k6"

	estimates use "$estimates/k6_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] // between-stratum variance
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/k6_main"
	estimates replay, baselevels
	
		mat coeffs = ///
			r(table)[1,2], r(table)[5,2], r(table)[6,2], r(table)[4,2], /// coeffs for birth sex: male
			r(table)[1,4], r(table)[5,4], r(table)[6,4], r(table)[4,4], /// coeffs for ethnicity: Mixed
			r(table)[1,5], r(table)[5,5], r(table)[6,5], r(table)[4,5], /// coeffs for ethnicity: Indian
			r(table)[1,6], r(table)[5,6], r(table)[6,6], r(table)[4,6], /// coeffs for ethnicity: Pakistani/Bangladeshi
			r(table)[1,7], r(table)[5,7], r(table)[6,7], r(table)[4,7], /// coeffs for ethnicity: Black
			r(table)[1,8], r(table)[5,8], r(table)[6,8], r(table)[4,8], /// coeffs for ethnicity: Other
			r(table)[1,10], r(table)[5,10], r(table)[6,10], r(table)[4,10], /// coeffs for sexuality: sexual minority
			r(table)[1,12], r(table)[5,12], r(table)[6,12], r(table)[4,12] // coeffs for childhood poverty
			
		estat icc
			putexcel G`rownumber' = `r(icc2)'
			putexcel H`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])] // between-stratum variance
			putexcel J`rownumber' = sigma2_u_main
						
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			
		

**********************************************************************
**********************************************************************
**********************************************************************
		
	
**## Caseness (Kessler-6 = 13+) - all participants

	local rownumber = `rownumber' + 1

	use "$estimates/caseness", clear
	
	putexcel A`rownumber' = "caseness"

	estimates use "$estimates/caseness_null"
	estimates replay, or baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2)) 
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/caseness_main"
	estimates replay, or baselevels
	
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
			putexcel G`rownumber' = `r(icc2)'
			putexcel H`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])] 
			putexcel J`rownumber' = sigma2_u_main
						
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)

		
**********************************************************************
**********************************************************************
**********************************************************************
			
			
**## SWEMWBS - partially invariant factor scores

	local rownumber = `rownumber' + 1

	use "$estimates/swemwbs", clear
	
	putexcel A`rownumber' = "swemwbs"
	
	estimates use "$estimates/swemwbs_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/swemwbs_main"
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************


**## Self-harm (any) - excludes mop-up survey by design

	local rownumber = `rownumber' + 1
	
	use "$estimates/selfharm", clear
	
	putexcel A`rownumber' = "selfharm"
	
	estimates use "$estimates/selfharm_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2)) 
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/selfharm_main"
	estimates replay, or baselevels
	
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])]
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************

	
**## Lifetime suicide attempts

	local rownumber = `rownumber' + 1
	
	use "$estimates/suicide", clear
	
	putexcel A`rownumber' = "suicide"
	
	estimates use "$estimates/suicide_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2)) 
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/suicide_main"
	estimates replay, or baselevels
	
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])]
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: SUM SCORES
						
**## Kessler-6 - sum scores 

	local rownumber = `rownumber' + 1

	use "$estimates/sumscores/k6_sumscore", clear
	
	putexcel A`rownumber' = "k6_sumscore"
	
	estimates use "$estimates/sumscores/k6_sumscore_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/sumscores/k6_sumscore_main"
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
	
	
	
**********************************************************************
**********************************************************************
**********************************************************************			
	
	
						
**## SWEMWBS - sum scores

	local rownumber = `rownumber' + 1

	use "$estimates/sumscores/swemwbs_sumscore", clear
	
	putexcel A`rownumber' = "swemwbs_sumscore"
	
	estimates use "$estimates/sumscores/swemwbs_sumscore_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])]
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/sumscores/swemwbs_sumscore_main"
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			


**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: NO MOP-UP
			
**## Kessler-6 - partially invariant factor scores - excluding mop-up survey

	local rownumber = `rownumber' + 1
		
	use "$estimates/nomopup/k6_nomopup", clear
	
	putexcel A`rownumber' = "k6_nomopup"
	
	estimates use "$estimates/nomopup/k6_nomopup_null"
	estimates replay, baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2)) 
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/nomopup/k6_nomopup_main"
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])] 
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
	
	

**********************************************************************
**********************************************************************
**********************************************************************
		
	
**## Caseness (Kessler-6 = 13+) - excluding mop-up survey

	local rownumber = `rownumber' + 1

	use "$estimates/nomopup/caseness_nomopup", clear
	
	putexcel A`rownumber' = "caseness_nomopup"
		
	estimates use "$estimates/nomopup/caseness_nomopup_null"
	estimates replay, or baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		estat icc
		putexcel C`rownumber' = `r(icc2)'
		putexcel D`rownumber' = matrix(r(ci2)) 
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
	estimates use "$estimates/nomopup/caseness_nomopup_main"
	estimates replay, or baselevels
	
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
		putexcel G`rownumber' = `r(icc2)'
		putexcel H`rownumber' = matrix(r(ci2))
		
		scalar sigma2_u_main = _b[/var(_cons[strata48])]
		putexcel J`rownumber' = sigma2_u_main
					
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
			
			
**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: SELF-HARM COUNT

**## Self-harm - count - Poisson

	local rownumber = `rownumber' + 1
	
	use "$estimates/selfharm_cont/selfharm_poisson", clear
	
	putexcel A`rownumber' = "selfharm_poisson"
	
	estimates use "$estimates/selfharm_cont/selfharm_poisson_null"
	estimates replay, irr baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
		* Variance components calculation based on Leckie et al 2020
		
		scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation, also level-1 marginal variance
		scalar variance1_null = expectation_null
		scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
		scalar vpc_null = variance2_null/(variance2_null + variance1_null) // vpc level-2
		putexcel C`rownumber' = vpc_null
		
	estimates use "$estimates/selfharm_cont/selfharm_poisson_main"
	estimates replay, irr baselevels
	
		mat coeffs = ///
			r(table)[1,2], r(table)[5,2], r(table)[6,2], r(table)[4,2], /// coeffs for gender: male
			r(table)[1,4], r(table)[5,4], r(table)[6,4], r(table)[4,4], /// coeffs for ethnicity: Mixed
			r(table)[1,5], r(table)[5,5], r(table)[6,5], r(table)[4,5], /// coeffs for ethnicity: Indian
			r(table)[1,6], r(table)[5,6], r(table)[6,6], r(table)[4,6], /// coeffs for ethnicity: Pakistani/Bangladeshi
			r(table)[1,7], r(table)[5,7], r(table)[6,7], r(table)[4,7], /// coeffs for ethnicity: Black
			r(table)[1,8], r(table)[5,8], r(table)[6,8], r(table)[4,8], /// coeffs for ethnicity: Other
			r(table)[1,10], r(table)[5,10], r(table)[6,10], r(table)[4,10], /// coeffs for sexuality: sexual minority
			r(table)[1,12], r(table)[5,12], r(table)[6,12], r(table)[4,12] // coeffs for childhood poverty
	
		scalar sigma2_u_main = _b[/var(_cons[strata48])]
		putexcel J`rownumber' = sigma2_u_main
		
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
	
	
			
**********************************************************************
**********************************************************************
**********************************************************************


**## Self-harm - count - Negative Binomial

	local rownumber = `rownumber' + 1
	
	use "$estimates/selfharm_cont/selfharm_nbreg", clear
		
	putexcel A`rownumber' = "selfharm_nbreg"
	
	estimates use "$estimates/selfharm_cont/selfharm_nbreg_null"
	estimates replay, irr baselevels
	
		putexcel B`rownumber' = `e(N)'
		
		scalar sigma2_u_null = _b[/var(_cons[strata48])] 
		putexcel F`rownumber' = sigma2_u_null
		
		* Variance components calculation based on Leckie et al 2020
		
		scalar alpha_null = exp(_b[/lnalpha])
		scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation
		scalar variance1_null = expectation_null + expectation_null^2*exp(sigma2_u_null)*alpha_null // level-2 marginal variance
		scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
		scalar vpc_null = variance2_null/(variance2_null + variance1_null) // level-2 vpc
		putexcel C`rownumber' = vpc_null
		
	estimates use "$estimates/selfharm_cont/selfharm_nbreg_main"
	estimates replay, irr baselevels
	
		mat coeffs = ///
			r(table)[1,2], r(table)[5,2], r(table)[6,2], r(table)[4,2], /// coeffs for gender: male
			r(table)[1,4], r(table)[5,4], r(table)[6,4], r(table)[4,4], /// coeffs for ethnicity: Mixed
			r(table)[1,5], r(table)[5,5], r(table)[6,5], r(table)[4,5], /// coeffs for ethnicity: Indian
			r(table)[1,6], r(table)[5,6], r(table)[6,6], r(table)[4,6], /// coeffs for ethnicity: Pakistani/Bangladeshi
			r(table)[1,7], r(table)[5,7], r(table)[6,7], r(table)[4,7], /// coeffs for ethnicity: Black
			r(table)[1,8], r(table)[5,8], r(table)[6,8], r(table)[4,8], /// coeffs for ethnicity: Other
			r(table)[1,10], r(table)[5,10], r(table)[6,10], r(table)[4,10], /// coeffs for sexuality: sexual minority
			r(table)[1,12], r(table)[5,12], r(table)[6,12], r(table)[4,12] // coeffs for childhood poverty
	
		scalar sigma2_u_main = _b[/var(_cons[strata48])]
		putexcel J`rownumber' = sigma2_u_main
		
		scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
		putexcel K`rownumber' = pcv
		
		putexcel L`rownumber' = matrix(coeffs)
	
	

**********************************************************************
**********************************************************************
**********************************************************************



**# COEFFICIENT PLOTS USING EXCEL FILE

clear all

import excel "$excelfile/MMV MCS23 results.xlsx", sheet("maihda") firstrow clear

keep Outcome coeff* LB* UB* p*

reshape long coeff_ LB_ UB_ pvalue_, i(Outcome) j(variable) string

gen scale = 0
local i = 1
foreach var in Mixed Indian Pakistani_Bangladeshi Black Other Sexualminority Childhoodpoverty {
	replace scale = scale + `i' if variable == "`var'"
	local i = `i'+1
}

sort scale

	**## Combined coefficient plot for manuscript
	
	**### Individual graphs with no labels

	foreach var in k6 swemwbs { // for linear standardised outcomes with no headers
	
		preserve
		keep if Outcome == "`var'"
		
		twoway ///
			(rspike LB UB scale if scale == 0, horizontal lcolor(#4EB3D3%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 1, horizontal lcolor(#5A4A99%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 2, horizontal lcolor(#6F67AB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 3, horizontal lcolor(#857DBA%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 4, horizontal lcolor(#9C95C9%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 5, horizontal lcolor(#B4AED7%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 6, horizontal lcolor(#7FCDBB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 7, horizontal lcolor(#F4A582%80) lwidth(*4)) ///
			(scatter scale coeff, mcolor(black) msymbol(smcircle)) ///
			, ///
			title(`var', size(*.7)) ///
			xtitle("Difference in outcome, SD units (95% CI)", size(*.8)) ///
			xlabel(-.4(.1).8, angle(horizontal) labsize(*.8)) ///
			xline(0, lcolor(red)) ///
			ytitle("") ///
			ylabel(none) ///
			yscale(reverse) ///
			legend(off) ///
			name(coeffplot_nolab_`var', replace) //
			
			graph save "$estimates/coeffplots/coeffplot_nolab_`var'", replace
			
			restore
	}

	
	foreach var in caseness selfharm { // for binary outcomes with no headers
		
		preserve
		keep if Outcome == "`var'"
		
		insobs 1
		replace Outcome = "var" if Outcome == ""
		replace coeff = 0.33 if coeff == .
		replace LB = 0.33 if LB == .
		replace UB = 0.33 if UB == .
		gen scale_anchor = 1 if scale == .
		
		twoway ///
			(rspike LB UB scale if scale == 0, horizontal lcolor(#4EB3D3%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 1, horizontal lcolor(#5A4A99%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 2, horizontal lcolor(#6F67AB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 3, horizontal lcolor(#857DBA%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 4, horizontal lcolor(#9C95C9%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 5, horizontal lcolor(#B4AED7%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 6, horizontal lcolor(#7FCDBB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 7, horizontal lcolor(#F4A582%80) lwidth(*4)) ///
			(rspike LB UB scale if scale_anchor == 1, lcolor(gs1) lwidth(*4)) /// this is to force all graphs to show the same Y-axis values in log scale
			(scatter scale coeff, mcolor(black) msymbol(smcircle)) ///
			, ///
			title(`var', size(*.7)) ///
			xtitle("Exponentiated coefficient and 95% CI", size(*.8)) ///
			xlabel(0.33 0.5 0.66 1 1.5 2 2.5 3 4 5 6, angle(horizontal) labsize(*.8)) ///
			xscale(log) ///
			xline(1, lcolor(red)) ///
			ytitle("") ///
			ylabel(none) ///
			yscale(reverse) ///
			legend(off) ///
			name(coeffplot_nolab_`var', replace) //
			
			graph save "$estimates/coeffplots/coeffplot_nolab_`var'", replace

			restore
	}

		
	foreach var in suicide { // for binary outcome with no headers, larger X axis
		
		preserve
		keep if Outcome == "`var'"
		
		insobs 1
		replace Outcome = "var" if Outcome == ""
		replace coeff = 0.2 if coeff == .
		replace LB = 0.2 if LB == .
		replace UB = 0.2 if UB == .
		gen scale_anchor = 1 if scale == .
		
		twoway ///
			(rspike LB UB scale if scale == 0, horizontal lcolor(#4EB3D3%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 1, horizontal lcolor(#5A4A99%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 2, horizontal lcolor(#6F67AB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 3, horizontal lcolor(#857DBA%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 4, horizontal lcolor(#9C95C9%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 5, horizontal lcolor(#B4AED7%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 6, horizontal lcolor(#7FCDBB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 7, horizontal lcolor(#F4A582%80) lwidth(*4)) ///
			(rspike LB UB scale if scale_anchor == 1, lcolor(gs1) lwidth(*4)) /// this is to force all graphs to show the same Y-axis values in log scale
			(scatter scale coeff, mcolor(black) msymbol(smcircle)) ///
			, ///
			title(`var', size(*.7)) ///
			xtitle("Exponentiated coefficient and 95% CI", size(*.8)) ///
			xlabel(0.2 0.33 0.5 0.66 1 1.5 2 2.5 3 4, angle(horizontal) labsize(*.8)) ///
			xscale(log) ///
			xline(1, lcolor(red)) ///
			ytitle("") ///
			ylabel(none) ///
			yscale(reverse) ///
			legend(off) ///
			name(coeffplot_nolab_`var', replace) //
			
			graph save "$estimates/coeffplots/coeffplot_nolab_`var'", replace 

			restore
	}



	**### Header only
	
	twoway ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#4EB3D3%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#5A4A99%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#6F67AB%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#857DBA%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#9C95C9%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#B4AED7%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#7FCDBB%80) lwidth(*4)) ///
		(rspike LB UB scale if scale == ., horizontal lcolor(#F4A582%80) lwidth(*4)) ///
		, ///
		title(" ", size(*.7)) ///
		xtitle(" ") ///
		xlabel(0 " ", angle(horizontal) labsize(*.8)) ///
		ytitle("") ///
		ylabel( ///
			0 "Sex assigned at birth: Male" ///
			1 "Ethnicity: Mixed" ///
			2 "Ethnicity: Indian" ///
			3 "Ethnicity: Pakistani/Bangladeshi" ///
			4 "Ethnicity: Black" ///
			5 "Ethnicity: Other" ///
			6 "Sexuality: Sexual minority" ///
			7 "Childhood poverty: Yes" ///
			, angle(horizontal) labsize(*0.8) notick nogrid) ///
		yscale(reverse) ///
		legend(off) ///
		name(coeffplot_labs, replace) //
		
		graph save "$estimates/coeffplots/coeffplot_labs", replace 



	**### Combined plot
	
		graph combine ///
			"$estimates/coeffplots/coeffplot_labs" "$estimates/coeffplots/coeffplot_nolab_k6" "$estimates/coeffplots/coeffplot_nolab_caseness" ///
			"$estimates/coeffplots/coeffplot_labs" "$estimates/coeffplots/coeffplot_nolab_swemwbs" "$estimates/coeffplots/coeffplot_nolab_selfharm" "$estimates/coeffplots/coeffplot_nolab_suicide", ///
			rows(2) cols(4) holes(4) imargin(2 2 2 2) ///
			name(coeffplot_comb, replace)
			
			* Edit graph to rename titles, remove xlabel line, save as coeffplot_comb_edited
			
		graph use "$estimates/coeffplots/coeffplot_comb_edited"
			
		graph export "$estimates/coeffplots/coeffplot_comb_edited.png", replace width(1000)
		graph export "$estimates/coeffplots/coeffplot_comb_edited.pdf", replace  
		graph export "$estimates/coeffplots/coeffplot_comb_edited.svg", replace  
	
	
	
	**## Combined coefficient plot for sum scores
	
	foreach var in k6_sumscore swemwbs_sumscore { // for linear outcomes with headers
		
		preserve
		keep if Outcome == "`var'"
		
		twoway ///
			(rspike LB UB scale if scale == 0, horizontal lcolor(#4EB3D3%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 1, horizontal lcolor(#5A4A99%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 2, horizontal lcolor(#6F67AB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 3, horizontal lcolor(#857DBA%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 4, horizontal lcolor(#9C95C9%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 5, horizontal lcolor(#B4AED7%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 6, horizontal lcolor(#7FCDBB%80) lwidth(*4)) ///
			(rspike LB UB scale if scale == 7, horizontal lcolor(#F4A582%80) lwidth(*4)) ///
			(scatter scale coeff, mcolor(black) msymbol(smcircle)) ///
			, ///
			title(`var', size(*.7)) ///
			xtitle("Coefficient and 95% CI", size(*.8)) ///
			xlabel(-2.5(.5)4.5, angle(horizontal) labsize(*.8)) ///
			xline(0, lcolor(red)) ///
			ytitle("") ///
			ylabel( ///
				0 "Sex assigned at birth: Male" ///
				1 "Ethnicity: Mixed" ///
				2 "Ethnicity: Indian" ///
				3 "Ethnicity: Pakistani/Bangladeshi" ///
				4 "Ethnicity: Black" ///
				5 "Ethnicity: Other" ///
				6 "Sexuality: Sexual minority" ///
				7 "Childhood poverty: Yes" ///
				, angle(horizontal) labsize(*0.8) notick nogrid) ///
			yscale(reverse) ///
			legend(off) ///
			name(coeffplot_`var', replace) //
			
			graph save "$estimates/coeffplots/coeffplot_`var'", replace
			
			restore
	}
		
		graph combine ///
			coeffplot_k6_sumscore coeffplot_swemwbs_sumscore ///
			, rows(2) xsize(4) name(coeffplot_comb_sumscore, replace)
			
			* Edit graph to rename titles, save as coeffplot_comb_sumscore_edited
			
		graph use "$estimates/coeffplots/coeffplot_comb_sumscore_edited"
		
		graph export "$estimates/coeffplots/coeffplot_comb_sumscore_edited.png", replace width(1000)
		graph export "$estimates/coeffplots/coeffplot_comb_sumscore_edited.pdf", replace  
		graph export "$estimates/coeffplots/coeffplot_comb_sumscore_edited.svg", replace  
