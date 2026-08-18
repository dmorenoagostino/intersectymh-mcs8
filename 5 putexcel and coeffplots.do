kaboom

**# Set Excel file

	putexcel set "INTERSECT-YP Study 1 results.xlsx", modify sheet("20260629_maihda")
	
	putexcel A1 = "Outcome"
	putexcel B1 = "Unweighted / weighted"
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

	
**********************************************************************
**********************************************************************
**********************************************************************

**# MAIN MODELS

**## Kessler-6 - all participants

	local rownumber = 2

	use "estimates/k6", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "k6"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/k6_null"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/k6_main"
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
				putexcel H`rownumber' = `r(icc2)'
				putexcel I`rownumber' = matrix(r(ci2))
				
				scalar sigma2_u_main = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
			
	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "k6"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/k6_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])]
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/k6_main_ipw"
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
			
			

**********************************************************************
**********************************************************************
**********************************************************************
		
	
**## Kessler-6 - caseness (13+) - all participants

	local rownumber = 4

	use "estimates/caseness", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "caseness"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/caseness_null"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/caseness_main"
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
				putexcel H`rownumber' = `r(icc2)'
				putexcel I`rownumber' = matrix(r(ci2))
				
				scalar sigma2_u_main = _b[/var(_cons[strata48])] 
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "caseness"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/caseness_null_ipw"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/caseness_main_ipw"
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
			putexcel H`rownumber' = `r(icc2)'
			putexcel I`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])]
			putexcel K`rownumber' = sigma2_u_main
						
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

						
			
**********************************************************************
**********************************************************************
**********************************************************************
			
			
**## SWEMWBS - does not include mop-up survey by design

	local rownumber = 6

	use "estimates/swemwbs", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "swemwbs"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/swemwbs_null"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/swemwbs_main"
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
				
				scalar sigma2_u_main = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "swemwbs"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/swemwbs_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])]
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/swemwbs_main_ipw"
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
			
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************


**## Self-harm (any) - excludes mop-up survey by design

	local rownumber = 8
	
	use "estimates/selfharm", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "selfharm"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/selfharm_null"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/selfharm_main"
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
				putexcel H`rownumber' = `r(icc2)'
				putexcel I`rownumber' = matrix(r(ci2))
				
				scalar sigma2_u_main = _b[/var(_cons[strata48])] 
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "selfharm"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/selfharm_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/selfharm_main_ipw"
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
			putexcel H`rownumber' = `r(icc2)'
			putexcel I`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])]
			putexcel K`rownumber' = sigma2_u_main
						
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************

	
**## Suicide (any) - excludes mop-up survey by design

	local rownumber = 10
	
	use "estimates/suicide", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "suicide"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/suicide_null"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/suicide_main"
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
				putexcel H`rownumber' = `r(icc2)'
				putexcel I`rownumber' = matrix(r(ci2))
				
				scalar sigma2_u_main = _b[/var(_cons[strata48])] 
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
	local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "suicide"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/suicide_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/suicide_main_ipw"
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
			putexcel H`rownumber' = `r(icc2)'
			putexcel I`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])]
			putexcel K`rownumber' = sigma2_u_main
						
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
			
			
			
**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: NO MOP-UP
			
**## Kessler-6 - excluding mop-up survey // SENS CHECK

	local rownumber = 12
		
	use "estimates/nomopup/k6_nomopup", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "k6_nomopup"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/nomopup/k6_null_nomopup"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = exp(_b[lns1_1_1:_cons])^2 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/nomopup/k6_main_nomopup"
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
				
				scalar sigma2_u_main = exp(_b[lns1_1_1:_cons])^2 
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1

		putexcel A`rownumber' = "k6_nomopup"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/nomopup/k6_null_ipw_nomopup"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/nomopup/k6_main_ipw_nomopup"
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
	
	

**********************************************************************
**********************************************************************
**********************************************************************
		
	
**## Kessler-6 - caseness (13+) - excluding mop-up survey // SENS CHECK

	local rownumber = 14

	use "estimates/nomopup/caseness_nomopup", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "caseness_nomopup"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/nomopup/caseness_null_nomopup"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/nomopup/caseness_main_nomopup"
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
				putexcel H`rownumber' = `r(icc2)'
				putexcel I`rownumber' = matrix(r(ci2))
				
				scalar sigma2_u_main = _b[/var(_cons[strata48])] 
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "caseness_nomopup"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/nomopup/caseness_null_ipw_nomopup"
		estimates replay, or baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/nomopup/caseness_main_ipw_nomopup"
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
			putexcel H`rownumber' = `r(icc2)'
			putexcel I`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_main = _b[/var(_cons[strata48])]
			putexcel K`rownumber' = sigma2_u_main
						
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
			
			
**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: SELF-HARM COUNT

**## Self-harm - count - mepoisson

	local rownumber = 16
	
	use "estimates/selfharm_cont/selfharm_poisson", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "selfharm_poisson"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/selfharm_cont/selfharm_poisson_null"
		estimates replay, irr baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
			* Variance components calculation based on Leckie et al 2020
			
			scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation, also level-1 marginal variance
			scalar variance1_null = expectation_null
			scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
			scalar vpc_null = variance2_null/(variance2_null + variance1_null) // level-2 vpc
			putexcel D`rownumber' = vpc_null
			
		estimates use "estimates/selfharm_cont/selfharm_poisson_main"
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
			putexcel K`rownumber' = sigma2_u_main
			
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "selfharm_poisson"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/selfharm_cont/selfharm_poisson_null_ipw"
		estimates replay, irr baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
			* Variance components calculation based on Leckie et al 2020
			
			scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation, also level-1 marginal variance
			scalar variance1_null = expectation_null
			scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
			scalar vpc_null = variance2_null/(variance2_null + variance1_null) // vpc level-2
			putexcel D`rownumber' = vpc_null
			
		estimates use "estimates/selfharm_cont/selfharm_poisson_main_ipw"
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
			putexcel K`rownumber' = sigma2_u_main
			
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
	
	
			
**********************************************************************
**********************************************************************
**********************************************************************


**## Self-harm - count - menbreg

	local rownumber = 18
	
	use "estimates/selfharm_cont/selfharm_nbreg", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "selfharm_nbreg"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/selfharm_cont/selfharm_nbreg_null"
		estimates replay, irr baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
			* Variance components calculation based on Leckie et al 2020
			
			scalar alpha_null = exp(_b[/lnalpha])
			scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation
			scalar variance1_null = expectation_null + expectation_null^2*exp(sigma2_u_null)*alpha_null // level-2 marginal variance
			scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
			scalar vpc_null = variance2_null/(variance2_null + variance1_null) // level-2 vpc
			putexcel D`rownumber' = vpc_null
			
		estimates use "estimates/selfharm_cont/selfharm_nbreg_main"
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
			putexcel K`rownumber' = sigma2_u_main
			
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "selfharm_nbreg"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/selfharm_cont/selfharm_nbreg_null_ipw"
		estimates replay, irr baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])] 
			putexcel G`rownumber' = sigma2_u_null
			
			* Variance components calculation based on Leckie et al 2020
			
			scalar alpha_null = exp(_b[/lnalpha])
			scalar expectation_null = exp(_b[_cons] + sigma2_u_null/2) // marginal expectation
			scalar variance1_null = expectation_null + expectation_null^2*exp(sigma2_u_null)*alpha_null // level-2 marginal variance
			scalar variance2_null = expectation_null^2*(exp(sigma2_u_null) - 1) // level-2 marginal variance 
			scalar vpc_null = variance2_null/(variance2_null + variance1_null) // level-2 vpc
			putexcel D`rownumber' = vpc_null
			
		estimates use "estimates/selfharm_cont/selfharm_nbreg_main_ipw"
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
			putexcel K`rownumber' = sigma2_u_main
			
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)
	
	

**********************************************************************
**********************************************************************
**********************************************************************

**# ADDITIONAL MODELS: FACTOR SCORES
						
**## K6 fscore 

	local rownumber = 20

	use "estimates/fscores/k6_fscore", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "k6_fscore"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/fscores/k6_fscore_null"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/fscores/k6_fscore_main"
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
				
				scalar sigma2_u_main = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "k6_fscore"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/fscores/k6_fscore_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])]
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/fscores/k6_fscore_main_ipw"
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
	
	
	
**********************************************************************
**********************************************************************
**********************************************************************			
	
	
						
**## SWEMWBS fscore - does not include mop-up survey by design

	local rownumber = 22

	use "estimates/fscores/swemwbs_fscore", clear
	
	* Unweighted
	
		putexcel A`rownumber' = "swemwbs_fscore"
	
		putexcel B`rownumber' = "unweighted"
		
		estimates use "estimates/fscores/swemwbs_fscore_null"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2)) 
			
			scalar sigma2_u_null = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/fscores/swemwbs_fscore_main"
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
				
				scalar sigma2_u_main = exp(_b[lns1_1_1:_cons])^2 // between-stratum variance
				putexcel K`rownumber' = sigma2_u_main
							
			scalar pcv = 100*(sigma2_u_null - sigma2_u_main) / sigma2_u_null
			putexcel L`rownumber' = pcv
			
			putexcel M`rownumber' = matrix(coeffs)

	* Weighted
	
		local rownumber = `rownumber' + 1
	
		putexcel A`rownumber' = "swemwbs_fscore"
		putexcel B`rownumber' = "weighted"
		
		estimates use "estimates/fscores/swemwbs_fscore_null_ipw"
		estimates replay, baselevels
		
			putexcel C`rownumber' = `e(N)'
			
			estat icc
			putexcel D`rownumber' = `r(icc2)'
			putexcel E`rownumber' = matrix(r(ci2))
			
			scalar sigma2_u_null = _b[/var(_cons[strata48])]
			putexcel G`rownumber' = sigma2_u_null
			
		estimates use "estimates/fscores/swemwbs_fscore_main_ipw"
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
			


**********************************************************************
**********************************************************************
**********************************************************************



**# COEFFICIENT PLOTS USING EXCEL FILE

clear all

import excel "INTERSECT-YP Study 1 results.xlsx", sheet("20260629_maihda") firstrow clear

keep if Unweightedweighted == "weighted"
keep Outcome coeff* LB* UB* p*

reshape long coeff_ LB_ UB_ pvalue_, i(Outcome) j(variable) string

gen scale = 0
local i = 1
foreach var in Mixed Indian Pakistani_Bangladeshi Black Other Sexualminority Childhoodpoverty {
	replace scale = scale + `i' if variable == "`var'"
	local i = `i'+1
}

sort scale

	**## Individual graphs with labels

	foreach var in k6_nomopup { // for linear outcomes with headers
		
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
			
			graph save "estimates/coeffplots/coeffplot_`var'", replace
			
			restore
	}


	foreach var in k6_fscore swemwbs_fscore { // for linear standardised outcomes with headers
		
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
			xlabel(-.4(.1).7, angle(horizontal) labsize(*.8)) ///
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
			
			graph save "estimates/coeffplots/coeffplot_`var'", replace
			
			restore
	}

		
	foreach var in caseness_nomopup { // for binary outcomes  with headers
		
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
			xtitle("Odds ratio (OR) and 95% CI", size(*.8)) ///
			xlabel(0.33 0.5 0.66 1 1.5 2 2.5 3 4 5 6, angle(horizontal) labsize(*.8)) ///
			xscale(log) ///
			xline(1, lcolor(red)) ///
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
			
			graph save "estimates/coeffplots/coeffplot_`var'", replace

			restore
	}


	foreach var in selfharm_nbreg selfharm_poisson { // for count outcomes  with headers
		
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
			xtitle("Incidence risk ratio (IRR) and 95% CI", size(*.8)) ///
			xlabel(0.33 0.5 0.66 1 1.5 2 2.5 3 4 5 6, angle(horizontal) labsize(*.8)) ///
			xscale(log) ///
			xline(1, lcolor(red)) ///
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
			
			graph save "estimates/coeffplots/coeffplot_`var'", replace

			restore
	}		


	**## Individual graphs with no labels

	foreach var in k6 swemwbs { // for linear outcomes with no headers
	
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
		ylabel(none) ///
		yscale(reverse) ///
		legend(off) ///
		name(coeffplot_nolab_`var', replace) //
		
		graph save "estimates/coeffplots/coeffplot_nolab_`var'", replace
		
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
		
		graph save "estimates/coeffplots/coeffplot_nolab_`var'", replace

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
		
		graph save "estimates/coeffplots/coeffplot_nolab_`var'", replace 

		restore
}




	**## Header only
	
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
		
		graph save "estimates/coeffplots/coeffplot_labs", replace 



	**## Combined graphs
	
		**### Main analyses
		
		foreach var in k6 caseness swemwbs selfharm suicide {
			graph use "estimates/coeffplots/coeffplot_nolab_`var'"
		}
		
		graph use "estimates/coeffplots/coeffplot_labs"
			
		graph combine ///
			coeffplot_labs coeffplot_nolab_k6 coeffplot_nolab_caseness ///
			coeffplot_labs coeffplot_nolab_swemwbs coeffplot_nolab_selfharm coeffplot_nolab_suicide, ///
			rows(2) cols(4) holes(4) imargin(2 2 2 2) ///
			name(coeffplot_comb, replace)
			
			* Edit graph to rename titles, remove xlabel line, save as coeffplot_comb_edited
			
		graph use "estimates/coeffplots/coeffplot_comb_edited"
			
		graph export "estimates/coeffplots/coeffplot_comb_edited.png", replace width(1000)
		graph export "estimates/coeffplots/coeffplot_comb_edited.pdf", replace  
		graph export "estimates/coeffplots/coeffplot_comb_edited.svg", replace  

	
		**### No mop-up
		
		graph use "estimates/coeffplots/coeffplot_k6_nomopup"
		graph use "estimates/coeffplots/coeffplot_caseness_nomopup"
		
		graph combine ///
			coeffplot_k6_nomopup coeffplot_caseness_nomopup ///
			, rows(2) xsize(4) name(coeffplot_comb_nomopup, replace)
			
			* Edit graph to rename titles, save as coeffplot_comb_nomopup_edited
			
		graph use "estimates/coeffplots/coeffplot_comb_nomopup_edited"
		
		graph export "estimates/coeffplots/coeffplot_comb_nomopup_edited.png", replace width(1000)
		graph export "estimates/coeffplots/coeffplot_comb_nomopup_edited.pdf", replace  
		graph export "estimates/coeffplots/coeffplot_comb_nomopup_edited.svg", replace  
	
	
		**### Factor scores
		
		graph use "estimates/coeffplots/coeffplot_k6_fscore"
		graph use "estimates/coeffplots/coeffplot_swemwbs_fscore"
		
		graph combine ///
			coeffplot_k6_fscore coeffplot_swemwbs_fscore ///
			, rows(2) xsize(4) name(coeffplot_comb_fscore, replace)
			
			* Edit graph to rename titles, save as coeffplot_comb_fscore_edited
			
		graph use "estimates/coeffplots/coeffplot_comb_fscore_edited"
		
		graph export "estimates/coeffplots/coeffplot_comb_fscore_edited.png", replace width(1000)
		graph export "estimates/coeffplots/coeffplot_comb_fscore_edited.pdf", replace  
		graph export "estimates/coeffplots/coeffplot_comb_fscore_edited.svg", replace  

		
		**### Self-harm count
		
		graph use "estimates/coeffplots/coeffplot_selfharm_nbreg"
		graph use "estimates/coeffplots/coeffplot_selfharm_poisson"
		
		graph combine ///
			coeffplot_selfharm_nbreg coeffplot_selfharm_poisson ///
			, rows(2) xsize(4) name(coeffplot_selfharm_comb, replace)
			
			* Edit graph to rename titles, save as coeffplot_selfharm_comb_edited
			
		graph use "estimates/coeffplots/coeffplot_selfharm_comb_edited"
		
		graph export "estimates/coeffplots/coeffplot_selfharm_comb_edited.png", replace width(1000)
		graph export "estimates/coeffplots/coeffplot_selfharm_comb_edited.pdf", replace  
		graph export "estimates/coeffplots/coeffplot_selfharm_comb_edited.svg", replace  