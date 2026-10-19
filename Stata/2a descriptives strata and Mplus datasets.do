/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 2a. Descriptive tables, and intersectional strata and Mplus datasets creation
	
		This code produces a table with descriptive statistics across social 
		identities and positions under study, both before and after recoding for
		subsequent analyses.
		
		It also creates the multiple-way intersectional strata and Mplus datasets
		that will be used for measurement invariance/equivalence testing.
	
*/

**# Setup

	global datasets "specify_working_directory\Analyses\Datasets" // folder including working datasets
	
	global excelfile "specify_working_directory\Analyses" // folder where Excel file with results is / will be located
	
	global mplus "specify_working_directory\Analyses\Mplus" // folder with files for Mplus

	
**# eTable 8.1: Descriptive statistics by full single axis variables

	use "$datasets/mcs_combined_clean", clear

	putexcel set "$excelfile/MMV MCS23 results.xlsx", modify sheet("descriptives_before_recoding")
	
	putexcel B1 = "Unweighted"
	
		putexcel B3 = "N"
		putexcel C3 = "%"
		
		putexcel D2 = "Kessler-6"
			putexcel D3 = "N obs"
			putexcel E3 = "M"
			putexcel F3 = "SD"
		
		putexcel G2 = "Caseness"
			putexcel G3 = "N obs"
			putexcel H3 = "% yes"
		
		putexcel I2 = "SWEMWBS"
			putexcel I3 = "N obs"
			putexcel J3 = "M"
			putexcel K3 = "SD"
		
		putexcel L2 = "Self-harm (any)"
			putexcel L3 = "N obs"
			putexcel M3 = "% yes"
		
		putexcel N2 = "Self-harm (number)"
			putexcel N3 = "N obs"
			putexcel O3 = "M"
			putexcel P3 = "SD"
			
		putexcel Q2 = "Attempted suicide (ever)"
			putexcel Q3 = "N obs"
			putexcel R3 = "% yes"
	
	putexcel S1 = "Weighted"
	
		putexcel S3 = "%"
	
		putexcel T2 = "Kessler-6"
			putexcel T3 = "M"
			putexcel U3 = "LB"
			putexcel V3 = "UB"

		putexcel W2 = "Caseness"
			putexcel W3 = "% yes"
			putexcel X3 = "LB"
			putexcel Y3 = "UB"

		putexcel Z2 = "SWEMWBS"
			putexcel Z3 = "M"
			putexcel AA3 = "LB"
			putexcel AB3 = "UB"

		putexcel AC2 = "Self-harm (any)"
			putexcel AC3 = "% yes"
			putexcel AD3 = "LB"
			putexcel AE3 = "UB"

		putexcel AF2 = "Self-harm (number)"
			putexcel AF3 = "M"
			putexcel AG3 = "LB"
			putexcel AH3 = "UB"

		putexcel AI2 = "Attempted suicide (ever)"
			putexcel AI3 = "% yes"
			putexcel AJ3 = "LB"
			putexcel AK3 = "UB"

	
	* Overall / sample-wide descriptive statistics
	
	putexcel A4 = "Overall"
	sum MCSIDCNUM_link
	local totaln = r(N)
	putexcel B4 = `totaln'
	
		* Unweighted
		
		sum kessler_sr_23y
			putexcel D4 = `r(N)'
			putexcel E4 = `r(mean)', nformat(0.00)
			putexcel F4 = `r(sd)', nformat(0.00)
			
		sum caseness_23y
			putexcel G4 = `r(N)'
			putexcel H4 = `r(mean)', nformat(0.00)
		
		sum swemwbs_sr_23y
			putexcel I4 = `r(N)'
			putexcel J4 = `r(mean)', nformat(0.00)
			putexcel K4 = `r(sd)', nformat(0.00)
			
		sum selfharm_23y
			putexcel L4 = `r(N)'
			putexcel M4 = `r(mean)', nformat(0.00)
		
		sum selfharm_23y_cont
			putexcel N4 = `r(N)'
			putexcel O4 = `r(mean)', nformat(0.00)
			putexcel P4 = `r(sd)', nformat(0.00)
			
		sum suicide_23y
			putexcel Q4 = `r(N)'
			putexcel R4 = `r(mean)', nformat(0.00)
		
		* Weighted
		
		mean kessler_sr_23y [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel T4 = matrix(weighted), nformat(0.00)
			
		prop caseness_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel W4 = matrix(weighted), nformat(0.00)
			
		mean swemwbs_sr_23y [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel Z4 = matrix(weighted), nformat(0.00)
			
		prop selfharm_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel AC4 = matrix(weighted), nformat(0.00)
			
		mean selfharm_23y_cont [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel AF4 = matrix(weighted), nformat(0.00)
			
		prop suicide_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel AI4 = matrix(weighted), nformat(0.00)
	
	
	* By single social identities/positions
	
	tab1 birthsex ethnicity sexuality_23y poverty_9m_3y, miss
		recode sexuality_23y ///
			(1 = 1 "1 Heterosexual") ///
			(2 = 2 "2 Gay or lesbian") ///
			(3 = 3 "3 Bisexual") ///
			(4 = 4 "4 Other") ///
			(6 = 6 "6 Pansexual") ///
			(7 = 7 "7 Asexual") ///
			(8 = 8 "8 Queer") ///
			(-8 -1 5 = 999 "999 DK/RF/NA") ///
			, gen(sexuality_23y_cat) // for descriptive purposes
	tab1 birthsex ethnicity sexuality_23y_cat poverty_9m_3y, miss
	
	local rownumber = 5 // row number after adding overall descriptives above
	
	foreach var in birthsex ethnicity sexuality_23y_cat poverty_9m_3y {
		
		* Variable heading
		putexcel A`rownumber' = "`var'"
		local rownumber = `rownumber' + 1
		
		* Unweighted frequencies and proportions
		recode `var' (. = 999) // to provide descriptives on cases with missing data on the variables defining social identities/positions
		
		tab `var', matcell(freq) matrow(names)
		putexcel A`rownumber' = matrix(names)
		putexcel B`rownumber' = matrix(freq)
		putexcel C`rownumber' = matrix(freq/r(N)), nformat(0.00)
		
		* Weighted proportions
		prop `var' [pweight=hovwt2]
		matrix a = e(b)'
		putexcel S`rownumber' = matrix(a), nformat(0.00)
		
		
		* Unweighted outcome descriptives
		tab `var' if kessler_sr_23y != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel D`rownumber' = matrix(freqnm)
		mean kessler_sr_23y, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel E`rownumber' = matrix(a), nformat(0.00)
		putexcel F`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if caseness_23y != ., matcell(freqnm)
			putexcel G`rownumber' = matrix(freqnm)
		proportion caseness_23y, over(`var')
			local half = colsof(e(b))/2+1 // only need to do this once
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel H`rownumber' = matrix(a), nformat(0.00)
		
		tab `var' if swemwbs_sr_23y != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel I`rownumber' = matrix(freqnm)
		mean swemwbs_sr_23y, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel J`rownumber' = matrix(a), nformat(0.00)
		putexcel K`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if selfharm_23y != ., matcell(freqnm)
			putexcel L`rownumber' = matrix(freqnm)
		proportion selfharm_23y, over(`var')
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel M`rownumber' = matrix(a), nformat(0.00)
		
		tab `var' if selfharm_23y_cont != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel N`rownumber' = matrix(freqnm)
		mean selfharm_23y_cont, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel O`rownumber' = matrix(a), nformat(0.00)
		putexcel P`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if suicide_23y != ., matcell(freqnm)
			putexcel Q`rownumber' = matrix(freqnm)
		proportion suicide_23y, over(`var')
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel R`rownumber' = matrix(a), nformat(0.00)
		
		
		* Weighted outcome descriptives
		
		mean kessler_sr_23y [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel T`rownumber' = matrix(a), nformat(0.00)
			
		proportion caseness_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel W`rownumber' = matrix(a), nformat(0.00)
		
		mean swemwbs_sr_23y [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel Z`rownumber' = matrix(a), nformat(0.00)
			
		proportion selfharm_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel AC`rownumber' = matrix(a), nformat(0.00)
			
		mean selfharm_23y_cont [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel AF`rownumber' = matrix(a), nformat(0.00)	
			
		proportion suicide_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel AI`rownumber' = matrix(a), nformat(0.00)
			
		quietly tab `var', miss
		local rownumber = `rownumber' + `r(r)' // local rownumber = `rownumber' + rowsof(a)
		
		recode `var' (999 = .)
		
	}
	


********************************************************************************
********************************************************************************
********************************************************************************
	
		
	
**# Table 1
	
	use "$datasets/mcs_combined_clean", clear

	putexcel set "$excelfile/MMV MCS23 results.xlsx", modify sheet("table_1")
	
	putexcel B1 = "Unweighted"
	
		putexcel B3 = "N"
		putexcel C3 = "%"
		
		putexcel D2 = "Kessler-6"
			putexcel D3 = "N obs"
			putexcel E3 = "M"
			putexcel F3 = "SD"
		
		putexcel G2 = "Caseness"
			putexcel G3 = "N obs"
			putexcel H3 = "% yes"
		
		putexcel I2 = "SWEMWBS"
			putexcel I3 = "N obs"
			putexcel J3 = "M"
			putexcel K3 = "SD"
		
		putexcel L2 = "Self-harm (any)"
			putexcel L3 = "N obs"
			putexcel M3 = "% yes"
		
		putexcel N2 = "Self-harm (number)"
			putexcel N3 = "N obs"
			putexcel O3 = "M"
			putexcel P3 = "SD"
			
		putexcel Q2 = "Attempted suicide (ever)"
			putexcel Q3 = "N obs"
			putexcel R3 = "% yes"
	
	putexcel S1 = "Weighted"
	
		putexcel S3 = "%"
	
		putexcel T2 = "Kessler-6"
			putexcel T3 = "M"
			putexcel U3 = "LB"
			putexcel V3 = "UB"

		putexcel W2 = "Caseness"
			putexcel W3 = "% yes"
			putexcel X3 = "LB"
			putexcel Y3 = "UB"

		putexcel Z2 = "SWEMWBS"
			putexcel Z3 = "M"
			putexcel AA3 = "LB"
			putexcel AB3 = "UB"

		putexcel AC2 = "Self-harm (any)"
			putexcel AC3 = "% yes"
			putexcel AD3 = "LB"
			putexcel AE3 = "UB"

		putexcel AF2 = "Self-harm (number)"
			putexcel AF3 = "M"
			putexcel AG3 = "LB"
			putexcel AH3 = "UB"

		putexcel AI2 = "Attempted suicide (ever)"
			putexcel AI3 = "% yes"
			putexcel AJ3 = "LB"
			putexcel AK3 = "UB"

	
	* Overall / sample-wide descriptive statistics
	
	putexcel A4 = "Overall"
	sum MCSIDCNUM_link
	local totaln = r(N)
	putexcel B4 = `totaln'
	
		* Unweighted
		
		sum kessler_sr_23y
			putexcel D4 = `r(N)'
			putexcel E4 = `r(mean)', nformat(0.00)
			putexcel F4 = `r(sd)', nformat(0.00)
			
		sum caseness_23y
			putexcel G4 = `r(N)'
			putexcel H4 = `r(mean)', nformat(0.00)
		
		sum swemwbs_sr_23y
			putexcel I4 = `r(N)'
			putexcel J4 = `r(mean)', nformat(0.00)
			putexcel K4 = `r(sd)', nformat(0.00)
			
		sum selfharm_23y
			putexcel L4 = `r(N)'
			putexcel M4 = `r(mean)', nformat(0.00)
		
		sum selfharm_23y_cont
			putexcel N4 = `r(N)'
			putexcel O4 = `r(mean)', nformat(0.00)
			putexcel P4 = `r(sd)', nformat(0.00)
			
		sum suicide_23y
			putexcel Q4 = `r(N)'
			putexcel R4 = `r(mean)', nformat(0.00)
		
		* Weighted
		
		mean kessler_sr_23y [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel T4 = matrix(weighted), nformat(0.00)
			
		prop caseness_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel W4 = matrix(weighted), nformat(0.00)
			
		mean swemwbs_sr_23y [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel Z4 = matrix(weighted), nformat(0.00)
			
		prop selfharm_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel AC4 = matrix(weighted), nformat(0.00)
			
		mean selfharm_23y_cont [pweight = hovwt2]
			mat weighted = r(table)[1,1], r(table)[5,1], r(table)[6,1]
			putexcel AF4 = matrix(weighted), nformat(0.00)
			
		prop suicide_23y [pweight = hovwt2]
			mat weighted = r(table)[1,2], r(table)[5,2], r(table)[6,2]
			putexcel AI4 = matrix(weighted), nformat(0.00)
	
	
	* By single social identities/positions
	
	tab1 birthsex ethnicity sexual_minority_23y_augm poverty_9m_3y, miss
	
	local rownumber = 5
	
	foreach var in birthsex ethnicity_6cat sexual_minority_23y_augm poverty_9m_3y {
		
		* Variable heading
		putexcel A`rownumber' = "`var'"
		local rownumber = `rownumber' + 1
		
		* Unweighted frequencies and proportions
		recode `var' (. = 999)
		
		tab `var', matcell(freq) matrow(names)
		putexcel A`rownumber' = matrix(names)
		putexcel B`rownumber' = matrix(freq)
		putexcel C`rownumber' = matrix(freq/r(N)), nformat(0.00)
		
		* Weighted proportions
		prop `var' [pweight=hovwt2]
		matrix a = e(b)'
		putexcel S`rownumber' = matrix(a), nformat(0.00)
		
		
		* Unweighted outcome descriptives
		tab `var' if kessler_sr_23y != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel D`rownumber' = matrix(freqnm)
		mean kessler_sr_23y, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel E`rownumber' = matrix(a), nformat(0.00)
		putexcel F`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if caseness_23y != ., matcell(freqnm)
			putexcel G`rownumber' = matrix(freqnm)
		proportion caseness_23y, over(`var')
			local half = colsof(e(b))/2+1 // only need to do this once
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel H`rownumber' = matrix(a), nformat(0.00)
		
		tab `var' if swemwbs_sr_23y != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel I`rownumber' = matrix(freqnm)
		mean swemwbs_sr_23y, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel J`rownumber' = matrix(a), nformat(0.00)
		putexcel K`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if selfharm_23y != ., matcell(freqnm)
			putexcel L`rownumber' = matrix(freqnm)
		proportion selfharm_23y, over(`var')
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel M`rownumber' = matrix(a), nformat(0.00)
		
		tab `var' if selfharm_23y_cont != ., matcell(freqnm) // to get the number of non-missing observations by outcome
			putexcel N`rownumber' = matrix(freqnm)
		mean selfharm_23y_cont, over(`var')
			mat a = e(b)'
			mat sd = e(sd)'
		putexcel O`rownumber' = matrix(a), nformat(0.00)
		putexcel P`rownumber' = matrix(sd), nformat(0.00)
		
		tab `var' if suicide_23y != ., matcell(freqnm)
			putexcel Q`rownumber' = matrix(freqnm)
		proportion suicide_23y, over(`var')
			mat a = r(table)[1,`half'..colsof(e(b))]' // selecting the estimate and SE of the bottom half (where event == 1)
		putexcel R`rownumber' = matrix(a), nformat(0.00)
		
		
		* Weighted outcome descriptives
		
		mean kessler_sr_23y [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel T`rownumber' = matrix(a), nformat(0.00)
			
		proportion caseness_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel W`rownumber' = matrix(a), nformat(0.00)
		
		mean swemwbs_sr_23y [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel Z`rownumber' = matrix(a), nformat(0.00)
			
		proportion selfharm_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel AC`rownumber' = matrix(a), nformat(0.00)
			
		mean selfharm_23y_cont [pweight=hovwt2], over(`var')
			mata: st_matrix("a", st_matrix("r(table)")[(1,5,6),.]') // to select non-contiguous rows in matrix
			putexcel AF`rownumber' = matrix(a), nformat(0.00)	
			
		proportion suicide_23y [pweight=hovwt2], over(`var')
			mat a = (r(table)[1,`half'..colsof(e(b))] \ r(table)[5,`half'..colsof(e(b))] \ r(table)[6,`half'..colsof(e(b))])'
			putexcel AI`rownumber' = matrix(a), nformat(0.00)
			
		quietly tab `var', miss
		local rownumber = `rownumber' + `r(r)' // local rownumber = `rownumber' + rowsof(a)
		
		recode `var' (999 = .)		
	}
	
	

	
	
********************************************************************************
********************************************************************************
********************************************************************************


	
**# Strata creation 

	use "$datasets/mcs_combined_clean", clear
	
	* Renaming variables
	rename sexual_minority_23y sexual_minority_23y_og
	rename sexual_minority_23y_augm sexual_minority_23y

	**## One strata and by single variables // to export dataset for analysis
	
		gen strata1 = .
		replace strata1 = 1 if birthsex != . | ethnicity_6cat != . | sexual_minority_23y != . | poverty_9m_3y != .
		bysort strata1: gen strata1_n = _N
		
		foreach var in birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y { // shortening name of sexual_minority_23y_a to allow for the (otherwise too long) name of the derived variable
			gen strata_`var' = `var'
			bysort `var': gen strata_`var'_n = _N
		}
		
	**## Two-way strata

		**### Strata 12a: birthsex * ethnicity_6cat 
		
			egen strata12_sex_eth = concat(birthsex ethnicity_6cat)
				bysort strata12_sex_eth: gen strata12_sex_eth_n = _N
				replace strata12_sex_eth = "" if birthsex == . | ethnicity_6cat == .
				destring strata12_sex_eth, replace
				
					
		**### Strata 4a: birthsex * sexuality_23y_cat
		
			egen strata4_sex_sexid = concat(birthsex sexual_minority_23y)
				bysort strata4_sex_sexid: gen strata4_sex_sexid_n = _N
				replace strata4_sex_sexid = "" if birthsex == . | sexual_minority_23y == .
				destring strata4_sex_sexid, replace
				
						
		**### Strata 4b: birthsex * poverty_9m_3y
		
			egen strata4_sex_pov = concat(birthsex poverty_9m_3y)
				bysort strata4_sex_pov: gen strata4_sex_pov_n = _N
				replace strata4_sex_pov = "" if birthsex == . | poverty_9m_3y == .
				destring strata4_sex_pov, replace
				
			
		**### Strata 12b: ethnicity_6cat * sexual_minority_23y
		
			egen strata12_eth_sexid = concat(ethnicity_6cat sexual_minority_23y)
				bysort strata12_eth_sexid: gen strata12_eth_sexid_n = _N
				replace strata12_eth_sexid = "" if ethnicity_6cat == . | sexual_minority_23y == .
				destring strata12_eth_sexid, replace
				
									
		**### Strata 14b: ethnicity_6cat * poverty_9m_3y
		
			egen strata12_eth_pov = concat(ethnicity_6cat poverty_9m_3y)
				bysort strata12_eth_pov: gen strata12_eth_pov_n = _N
				replace strata12_eth_pov = "" if ethnicity_6cat == . | poverty_9m_3y == .
				destring strata12_eth_pov, replace
				
						
		**### Strata 4c: sexual_minority_23y * poverty_9m_3y
		
			egen strata4_sexid_pov = concat(sexual_minority_23y poverty_9m_3y)
				bysort strata4_sexid_pov: gen strata4_sexid_pov_n = _N
				replace strata4_sexid_pov = "" if sexual_minority_23y == . | poverty_9m_3y == .
				destring strata4_sexid_pov, replace
				
			
	**## Three-way strata (as per protocol and additional one)
	
		**### Strata 24a: birthsex * ethnicity_6cat * sexual_minority_23y
		
			egen strata24_sex_eth_sexid = concat(birthsex ethnicity_6cat sexual_minority_23y)
				bysort strata24_sex_eth_sexid: gen strata24_sex_eth_sexid_n = _N
				replace strata24_sex_eth_sexid = "" if birthsex == . | ethnicity_6cat == . | sexual_minority_23y == .
				destring strata24_sex_eth_sexid, replace
				
					
		**### Strata 24b - birthsex * ethnicity_6cat * poverty_9m_3y
		
			egen strata24_sex_eth_pov = concat(birthsex ethnicity_6cat poverty_9m_3y)
				bysort strata24_sex_eth_pov: gen strata24_sex_eth_pov_n = _N
				replace strata24_sex_eth_pov = "" if birthsex == . | ethnicity_6cat == . | poverty_9m_3y == .
				destring strata24_sex_eth_pov, replace
				
			
		**### Strata 8: birthsex * sexual_minority_23y * poverty_9m_3y
		
			egen strata8_sex_sexid_pov = concat(birthsex sexual_minority_23y poverty_9m_3y)
				bysort strata8_sex_sexid_pov: gen strata8_sex_sexid_pov_n = _N
				replace strata8_sex_sexid_pov = "" if birthsex == . | poverty_9m_3y == . | sexual_minority_23y == .
				destring strata8_sex_sexid_pov, replace
				
			
	**## Four-way strata (as per protocol)
	
		**### Strata 48: birthsex * ethnicity_6cat * sexual_minority_23y * poverty_9m_3y
		
			egen strata48 = concat(birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y)
				ta strata48 if birthsex == . | ethnicity_6cat == . | sexual_minority_23y == . | poverty_9m_3y == . // 13 cases missing
				ta strata48 if !(birthsex == . | ethnicity_6cat == . | sexual_minority_23y == . | poverty_9m_3y == .) // 9662 valid sample
				dis r(r) // one stratum is completely missing --> 1520
				
			bysort strata48: gen strata48_n = _N
				replace strata48 = "" if birthsex == . | ethnicity_6cat == . | poverty_9m_3y == . | sexual_minority_23y == . 
				destring strata48, replace


	sort MCSIDCNUM
	
	compress
	save "$datasets/mcs_combined_strata", replace	
	

	
	
********************************************************************************
********************************************************************************
********************************************************************************



	
**# Table with % of strata with x+ obs
	
	use "$datasets/mcs_combined_strata", clear
	
	putexcel set "$excelfile/MMV MCS23 results.xlsx", modify sheet("strata_size_range")
	
	putexcel A1 = "Sample size"
	putexcel B1 = "No of strata"
	putexcel C1 = "Proportion of strata"
	
	tab strata48, miss
	local strata = r(r)
	
	local i = 2
	foreach n in 1000 500 250 100 50 20 10 {
		putexcel A`i' = "`n'+"
		tab strata48 if strata48_n >= `n'
		putexcel B`i' = `r(r)'
		putexcel C`i' = `r(r)'/`strata', nformat(0.00)
		local i = `i' + 1
	}
	
	collapse (count) n = MCSIDCNUM_link, by(strata48)
	foreach n in 1000 500 250 100 50 20 10 0 {
		gen n_`n' = 1 if n >= `n'
	}
	
	ta strata48 if n_1000 == 1, matrow(names)
	matrix list names
		list strata48 if n_1000 == 1


	
	
********************************************************************************
********************************************************************************
********************************************************************************



	
**# Preparation of datasets for Mplus
	
	**## Create lookup dataset with all theoretical possibilities within each stratification to be able to detect which ones are completely missing
	
	tempfile lookup_tmp
	postfile lookup_handle ///
		str40 stratification ///
		long stratum ///
		byte birthsex ///
		byte ethnicity_6cat ///
		byte sexual_minority_23y ///
		byte poverty_9m_3y ///
		using `lookup_tmp', replace

		* Strata 1
		
			post lookup_handle ("strata1") (1) (.) (.) (.) (.)

		* One-way strata
		
			foreach b in 1 2 {
				post lookup_handle ("strata_birthsex") (`b') (`b') (.) (.) (.)
			}

			foreach e in 1 2 3 4 5 6 {
				post lookup_handle ("strata_ethnicity_6cat") (`e') (.) (`e') (.) (.)
			}

			foreach s in 0 1 {
				post lookup_handle ("strata_sexual_minority_23y") (`s') (.) (.) (`s') (.)
			}

			foreach p in 0 1 {
				post lookup_handle ("strata_poverty_9m_3y") (`p') (.) (.) (.) (`p')
			}
			
		* Two-way strata

			foreach b in 1 2 {
				foreach e in 1 2 3 4 5 6 {
					local code = real("`b'`e'")
					post lookup_handle ("strata12_sex_eth") (`code') (`b') (`e') (.) (.)
				}
			}

			foreach b in 1 2 {
				foreach s in 0 1 {
					local code = real("`b'`s'")
					post lookup_handle ("strata4_sex_sexid") (`code') (`b') (.) (`s') (.)
				}
			}

			foreach b in 1 2 {
				foreach p in 0 1 {
					local code = real("`b'`p'")
					post lookup_handle ("strata4_sex_pov") (`code') (`b') (.) (.) (`p')
				}
			}

			foreach e in 1 2 3 4 5 6 {
				foreach s in 0 1 {
					local code = real("`e'`s'")
					post lookup_handle ("strata12_eth_sexid") (`code') (.) (`e') (`s') (.)
				}
			}

			foreach e in 1 2 3 4 5 6 {
				foreach p in 0 1 {
					local code = real("`e'`p'")
					post lookup_handle ("strata12_eth_pov") (`code') (.) (`e') (.) (`p')
				}
			}

			foreach s in 0 1 {
				foreach p in 0 1 {
					local code = real("`s'`p'")
					post lookup_handle ("strata4_sexid_pov") (`code') (.) (.) (`s') (`p')
				}
			}
			
		* Three-way strata
		
			foreach b in 1 2 {
				foreach e in 1 2 3 4 5 6 {
					foreach s in 0 1 {
						local code = real("`b'`e'`s'")
						post lookup_handle ("strata24_sex_eth_sexid") (`code') (`b') (`e') (`s') (.)
					}
				}
			}

			foreach b in 1 2 {
				foreach e in 1 2 3 4 5 6 {
					foreach p in 0 1 {
						local code = real("`b'`e'`p'")
						post lookup_handle ("strata24_sex_eth_pov") (`code') (`b') (`e') (.) (`p')
					}
				}
			}

			foreach b in 1 2 {
				foreach s in 0 1 {
					foreach p in 0 1 {
						local code = real("`b'`s'`p'")
						post lookup_handle ("strata8_sex_sexid_pov") (`code') (`b') (.) (`s') (`p')
					}
				}
			}
			
		* Four-way strata

			foreach b in 1 2 {
				foreach e in 1 2 3 4 5 6 {
					foreach s in 0 1 {
						foreach p in 0 1 {
							local code = real("`b'`e'`s'`p'")
							post lookup_handle ("strata48") (`code') (`b') (`e') (`s') (`p')
						}
					}
				}
			}

	postclose lookup_handle

	use `lookup_tmp', clear
	sort stratification stratum
	save "$mplus/datasets/strata_lookup.dta", replace

	
	**## Create audit dataset and loop through strata: audit + export datasets
	
	use "$datasets/mcs_combined_strata", clear
	
	tempfile audit_tmp
	postfile audit_handle ///
		str40 stratification ///
		long stratum ///
		long n_obs ///
		str30 reason ///
		using `audit_tmp', replace
		
	foreach strata in ///
		strata1 ///
		strata_birthsex strata_ethnicity_6cat strata_sexual_minority_23y strata_poverty_9m_3y ///
		strata12_sex_eth strata4_sex_sexid strata4_sex_pov strata12_eth_sexid strata12_eth_pov strata4_sexid_pov ///
		strata24_sex_eth_sexid strata24_sex_eth_pov strata8_sex_sexid_pov ///
		strata48 {
		
		* Audit missing / invalid strata information
		
			preserve
				quietly count if missing(`strata')
				local n_miss = r(N)

				if `n_miss' > 0 {
					post audit_handle ("`strata'") (.) (`n_miss') ("missing strata info")
				}
			restore

		* Audit strata with n < 20
		
			preserve
				keep `strata' `strata'_n
				keep if !missing(`strata')
				egen tag = tag(`strata')
				keep if tag & `strata'_n < 20

				rename `strata' stratum
				rename `strata'_n n_obs

				quietly count
				local N_small = r(N)

				if `N_small' > 0 {
					forvalues i = 1/`N_small' {
						post audit_handle ("`strata'") (stratum[`i']) (n_obs[`i']) ("n<20")
					}
				}
			restore

		* Export K6 / SWEMWBS files; drops: missing strata, n<20 only
		
			preserve

				keep if !missing(`strata') & `strata'_n >= 20
				
				keep MCSIDCNUM_link pttype2 sptn00 hovwt2 ///
					birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y ///
					`strata' ///
					hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec ///
					hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 ///
					hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00
					
				order MCSIDCNUM_link pttype2 sptn00 hovwt2 ///
					birthsex ethnicity_6cat sexual_minority_23y poverty_9m_3y ///
					`strata' ///
					hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec ///
					hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 ///
					hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00
					
				quietly recode MCSIDCNUM_link-hsshrm00 (. = -9999)
				
				sort MCSIDCNUM_link
			
				export delimited using "$mplus/datasets/align_`strata'", novarnames nolabel replace
				
			restore
		}

		* Add zero-observation strata to audit (theoretical but absent)
	
		foreach strata in `strata_list' {

			preserve
				keep `strata'
				keep if !missing(`strata')
				duplicates drop
				gen stratification = "`strata'"
				rename `strata' stratum
				tempfile obs_`strata'
				save `obs_`strata'', replace
			restore

			preserve
				use "$mplus/datasets/strata_lookup.dta", clear
				keep if stratification == "`strata'"

				merge 1:1 stratification stratum using `obs_`strata''

				keep if _merge == 1
				gen n_obs = 0

				quietly count
				local N_zero = r(N)

				if `N_zero' > 0 {
					forvalues i = 1/`N_zero' {
						post audit_handle ("`strata'") (stratum[`i']) (0) ("zero observations")
					}
				}
			restore
		}

		postclose audit_handle

		* Save and export audit datasets
	
		use `audit_tmp', clear
		sort stratification reason stratum

		save "$mplus/datasets/strata_audit_detail.dta", replace
		export delimited using "$mplus/datasets/strata_audit_detail.csv", replace

		preserve
			collapse (count) n_strata = stratum (sum) n_obs = n_obs, by(stratification reason)
			sort stratification reason
			save "$mplus/datasets/strata_audit_summary.dta", replace
			export delimited using "$mplus/datasets/strata_audit_summary.csv", replace
		restore