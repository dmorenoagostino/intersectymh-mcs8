/*

Intersectional inequalities in youth mental health measurement and outcomes: 
population-representative evidence from the UK Millennium Cohort Study

Moreno-Agostino, D. et al., 2026 (add manuscript doi when available)

	Part 1. Data management
	
		This code draws from the Millennium Cohort Study data, which can be 
		obtained from the UK Data Service (http://doi.org/10.5255/UKDA-Series-2000031) 
		to create the dataset used in subsequent analyses.
	
*/

**# Setup

	global mcs1 "specify_working_directory\Original MCS datasets\4683 Millennium Cohort Study Age 9 months, Sweep 1, 2001\UKDA-4683-stata\stata\stata13" // sweep 1
	global mcs2 "specify_working_directory\Original MCS datasets\5350 Millennium Cohort Study Age 3, Sweep 2, 2004\UKDA-5350-stata\stata\stata13" // sweep 2
	global mcs3 "specify_working_directory\Original MCS datasets\5795 Millennium Cohort Study Age 5, Sweep 3, 2006\UKDA-5795-stata\stata\stata13" // sweep 3
	global mcs4 "specify_working_directory\Original MCS datasets\6411 Millennium Cohort Study Age 7, Sweep 4, 2008\UKDA-6411-stata\stata\stata13" // sweep 4
	global mcs5 "specify_working_directory\Original MCS datasets\7464 Millennium Cohort Study Age 11, Sweep 5, 2012\UKDA-7464-stata\stata\stata13" // sweep 5
	global mcs6 "specify_working_directory\Original MCS datasets\8156 Millennium Cohort Study Age 14, Sweep 6, 2015\UKDA-8156-stata\stata\stata13" // sweep 6
	global mcs7 "specify_working_directory\Original MCS datasets\8682 Millennium Cohort Study Age 17, Sweep 7, 2018\UKDA-8682-stata\stata\stata13" // sweep 7
	global mcs8 "specify_working_directory\Original MCS datasets\9509 Millennium Cohort Study Sweep 8, Age 23, 2023-2025\UKDA-9509-stata 202606\stata\stata13" // sweep 8
	global mcslong "specify_working_directory\Original MCS datasets\8172 Millennium Cohort Study Sweeps 1-8, 2001-2025 Longitudinal Files\UKDA-8172-stata 202606\stata\stata13" // longitudinal file
	
	global datasets "specify_working_directory\Analyses\Datasets" // folder to save working datasets
		
**# Data from previous sweeps

	**## 9m sweep
	
		* Family-/household-level information

			use "$mcs1/mcs1_parent_derived", clear
			gen ethnicity_mother_9m_temp = ADD11E00 if inlist(ADDRES00,1,11,15)
			gen ethnicity_father_9m_temp = ADD11E00 if inlist(ADDRES00,2,12,16)
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_9m = max(ethnicity_mother_9m_temp) 
			bysort MCSID: egen ethnicity_father_9m = max(ethnicity_father_9m_temp) 
				label values ethnicity* ADD11E00
						
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
					
			merge 1:1 MCSID using "$mcs1/mcs1_family_derived", nogen
			recode ADOEDP00 (-1 = .)

			keep MCSID ethnicity_mother_9m ethnicity_father_9m ADOEDP00 
			
			tempfile mcs1_family
			save `mcs1_family'
		
		* Individual-level information
		
			use "$mcs1/mcs1_hhgrid", clear
			recode AHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_9m)
			keep if inrange(ACNUM00,1,2)
			ta female, miss
			
			merge 1:1 MCSID ACNUM00 using "$mcs1/mcs1_cm_derived"
			keep MCSID ACNUM00 female ADC11E00 // parent-reported CM ethnicity
			
			merge m:1 MCSID using `mcs1_family', nogen
			
		rename ACNUM00 CNUM00
		tempfile mcs1
		save `mcs1'
		
		
	**## 3y sweep
	
		* Family-/household-level information

			use "$mcs2/mcs2_parent_derived", clear
			gen ethnicity_mother_3y_temp = BDD11E00 if BDDREL00 == 1
			gen ethnicity_father_3y_temp = BDD11E00 if BDDREL00 == 2
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_3y = max(ethnicity_mother_3y_temp) 
			bysort MCSID: egen ethnicity_father_3y = max(ethnicity_father_3y_temp) 
				label values ethnicity* BDD11E00
			
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
					
			merge 1:1 MCSID using "$mcs2/mcs2_family_derived", nogen
			recode BDOEDP00 (-1 = .)
			
			keep MCSID ethnicity_mother_3y ethnicity_father_3y BDOEDP00
			
			tempfile mcs2_family
			save `mcs2_family'
		
		* Individual-level information
		
			use "$mcs2/mcs2_hhgrid", clear
			recode BHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_3y)
			keep MCSID BCNUM00 female
			keep if inrange(BCNUM00,1,2)
			ta female, miss
			
			merge 1:1 MCSID BCNUM00 using "$mcs2/mcs2_cm_derived", nogen
			
			keep MCSID BCNUM00 female BDC11E00 
			
			merge m:1 MCSID using `mcs2_family', nogen
			
		rename BCNUM00 CNUM00
		tempfile mcs2
		save `mcs2'


	**## 5y sweep

		* Family-/household-level information

			use "$mcs3/mcs3_parent_derived", clear
			gen ethnicity_mother_5y_temp = CDD11E00 if CDDREL00 == 1
			gen ethnicity_father_5y_temp = CDD11E00 if CDDREL00 == 2
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_5y = max(ethnicity_mother_5y_temp) 
			bysort MCSID: egen ethnicity_father_5y = max(ethnicity_father_5y_temp) 
				label values ethnicity* ADD11E00
		
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
			
			merge 1:1 MCSID using "$mcs3/mcs3_family_derived", nogen
			recode CDOEDP00 (-1 = .)
			
			keep MCSID ethnicity_mother_5y ethnicity_father_5y CDOEDP00
						
			tempfile mcs3_family
			save `mcs3_family'
			
		* Individual-level information
			
			use "$mcs3/mcs3_hhgrid", clear
			recode CHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_5y)
			keep MCSID CCNUM00 female
			keep if inrange(CCNUM00,1,2)
			ta female, miss
		
			merge 1:1 MCSID CCNUM00 using "$mcs3/mcs3_cm_derived", nogen
			keep MCSID CCNUM00 female CDC11E00
			
			merge m:1 MCSID using `mcs3_family', nogen
			
		rename CCNUM00 CNUM00
		tempfile mcs3
		save `mcs3'
			
			
	**## 7y sweep

		* Family-/household-level information		
		
			use "$mcs4/mcs4_parent_derived", clear
			gen ethnicity_mother_7y_temp = DDD11E00 if DDDREL00 == 1
			gen ethnicity_father_7y_temp = DDD11E00 if DDDREL00 == 2
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_7y = max(ethnicity_mother_7y_temp) 
			bysort MCSID: egen ethnicity_father_7y = max(ethnicity_father_7y_temp) 
				label values ethnicity* ADD11E00
		
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
			
			merge 1:1 MCSID using "$mcs4/mcs4_family_derived", nogen
			recode DDOEDP00 (-1 = .)
			
			keep MCSID ethnicity_mother_7y ethnicity_father_7y DDOEDP00
						
			tempfile mcs4_family
			save `mcs4_family'
			
			
		* Individual-level information
			
			use "$mcs4/mcs4_hhgrid", clear
			recode DHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_7y)
			keep if inrange(DCNUM00,1,2)
			ta female, miss		
			
			merge 1:1 MCSID DCNUM00 using "$mcs4/mcs4_cm_derived", nogen
			keep MCSID DCNUM00 female_7y DDC11E00
			
			merge m:1 MCSID using `mcs4_family', nogen
		
		rename DCNUM00 CNUM00
		tempfile mcs4
		save `mcs4'		
		
		
	**## 11y sweep

		* Family-/household-level information	
		
			use "$mcs5/mcs5_parent_derived", clear
			gen ethnicity_mother_11y_temp = ED11E00 if inlist(EDRES00,1,11,15)
			gen ethnicity_father_11y_temp = ED11E00 if inlist(EDRES00,2,12,16)
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_11y = max(ethnicity_mother_11y_temp) 
			bysort MCSID: egen ethnicity_father_11y = max(ethnicity_father_11y_temp) 
				label values ethnicity* ADD11E00
		
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
									
			merge 1:1 MCSID using "$mcs5/mcs5_family_derived", nogen
			recode EOEDP00 (-1 = .)
			
			keep MCSID ethnicity_mother_11y ethnicity_father_11y EOEDP00
			
			tempfile mcs5_family
			save `mcs5_family'
			
			
		* Individual-level information
			
			use "$mcs5/mcs5_hhgrid", clear
			recode ECSEX0000 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_11y)
			keep MCSID ECNUM00 female
			keep if inrange(ECNUM00,1,2)
			ta female, miss
			
			merge m:1 MCSID using `mcs5_family', nogen
			
		rename ECNUM00 CNUM00
		tempfile mcs5
		save `mcs5'	

		
	**## 14y sweep

		* Family-/household-level information	
		
			use "$mcs6/mcs6_parent_derived", clear
			
			gen ethnicity_mother_14y_temp = FD11E00 if inlist(FDRES00,1,11,15)
			gen ethnicity_father_14y_temp = FD11E00 if inlist(FDRES00,2,12,16)
			recode ethnicity* (-9/-1 = .)
			
			bysort MCSID: egen ethnicity_mother_14y = max(ethnicity_mother_14y_temp) 
			bysort MCSID: egen ethnicity_father_14y = max(ethnicity_father_14y_temp) 
				label values ethnicity* ADD11E00
		
			bysort MCSID: gen nobs = _n
			keep if nobs == 1 // keeping one observation per family/household
									
			merge 1:1 MCSID using "$mcs6/mcs6_family_derived", nogen
			recode FOEDP00 (-1 = .)
			
			keep MCSID ethnicity_mother_14y ethnicity_father_14y FOEDP00
			
			tempfile mcs6_family
			save `mcs6_family'		
			
			
		* Individual-level information

			use "$mcs6/mcs6_hhgrid", clear
			recode FHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female"), gen(female_14y)
			keep MCSID FCNUM00 female
			keep if inrange(FCNUM00,1,2)
			ta female, miss	
			
			merge 1:1 MCSID FCNUM00 using "$mcs6/mcs6_cm_derived", nogen
			keep MCSID FCNUM00 female_14y FDCE1100
			
			merge 1:1 MCSID FCNUM00 using "$mcs6/mcs6_cm_interview", nogen
			
			gen ethnicity_sr_14y = .
			
			replace ethnicity_sr_14y = 1 if inlist(FCETHE00_R20,1,2,4) | FCETHW00_R5 == 1 | inlist(FCETHS00_R5,1,2,4) | FCETHN00_R5 == 1 // White
			replace ethnicity_sr_14y = 2 if FCETHE00_R20 == 5 | FCETHW00_R5 == 5 | FCETHN00_R5 == 3 // Mixed White & Black Caribbean
			replace ethnicity_sr_14y = 3 if FCETHE00_R20 == 6 | FCETHW00_R5 == 6 | FCETHN00_R5 == 4 // Mixed White & Black African
			replace ethnicity_sr_14y = 4 if FCETHE00_R20 == 7 | FCETHW00_R5 == 7 // Mixed White & Asian
			replace ethnicity_sr_14y = 5 if FCETHE00_R20 == 8 | FCETHW00_R5 == 8  | FCETHS00_R5 == 7 // Other Mixed
			replace ethnicity_sr_14y = 6 if FCETHE00_R20 == 9 | FCETHS00_R5 == 9 // Indian
			replace ethnicity_sr_14y = 7 if FCETHE00_R20 == 10 | FCETHW00_R5 == 10 | FCETHS00_R5 == 8 // Pakistani
			replace ethnicity_sr_14y = 8 if FCETHE00_R20 == 11 | FCETHW00_R5 == 11 // Bangladeshi
			replace ethnicity_sr_14y = 9 if FCETHE00_R20 == 13 // Other Asian
			replace ethnicity_sr_14y = 10 if FCETHE00_R20 == 14 | FCETHW00_R5 == 14 // Black African 
			replace ethnicity_sr_14y = 11 if FCETHE00_R20 == 15 // Black Caribbean
			replace ethnicity_sr_14y = 12 if FCETHE00_R20 == 16 // Other Black
			replace ethnicity_sr_14y = 13 if FCETHE00_R20 == 17 | FCETHW00_R5 == 17 | FCETHN00_R5 == 15 // Arab
			replace ethnicity_sr_14y = 14 if FCETHE00_R20 == 18 // Other
			
			label define ethnicity ///
				1 "1 White" ///
				2 "2 Mixed White & Black Caribbean" ///
				3 "3 Mixed White & Black African" ///
				4 "4 Mixed White & Asian" ///
				5 "5 Other Mixed" ///
				6 "6 Indian" ///
				7 "7 Pakistani" ///
				8 "8 Bangladeshi" ///
				9 "9 Other Asian" ///
				10 "10 Black African" ///
				11 "11 Black Caribbean" ///
				12 "12 Other Black" ///
				13 "13 Arab" ///
				14 "14 Other"
				
			label values ethnicity_sr_14y ethnicity
			tab ethnicity_sr_14y, mis
			
			tab1 FCROMG00 FCROMB00
				recode FCROMG00 (1 = 1) (2 = 0) (else = .), gen(attractedtofemale_sr_14y)
				recode FCROMB00 (1 = 1) (2 = 0) (else = .), gen(attractedtomale_sr_14y)
				tab1 attracted*
				
			
			keep MCSID FCNUM00 female_14y FDCE1100 ethnicity_sr_14y attracted*
						
			merge m:1 MCSID using `mcs6_family', nogen
			
		rename FCNUM00 CNUM00
		tempfile mcs6
		save `mcs6'				
			
			
	**## 17y sweep

		* Family-/household-level information	
		
			use "$mcs7/mcs7_parent_derived", clear
			gen ethnicity_mother_17y_temp = GD11E00 if inlist(GDRES00,1,11,15)
			gen ethnicity_father_17y_temp = GD11E00 if inlist(GDRES00,2,12,16)
			recode ethnicity* (-9/-1 = .)
			label values ethnicity* GD11E00
			tab1 ethnicity*
			
			bysort MCSID: egen ethnicity_mother_17y = max(ethnicity_mother_17y_temp) 
			bysort MCSID: egen ethnicity_father_17y = max(ethnicity_father_17y_temp)
				label values ethnicity* ADD11E00
			
			bysort MCSID: gen nobs = _n
			keep if nobs == 1
			
			keep MCSID ethnicity_mother_17y ethnicity_father_17y 
			
			tempfile mcs7_family
			save `mcs7_family'				
			
			
		* Individual-level information
			
			use "$mcs7/mcs7_hhgrid", clear
			recode GHCSEX00 (1 = 0 "0 Male") (2 = 1 "1 Female") (else = .), gen(female_17y)
			keep MCSID GCNUM00 female
			keep if inrange(GCNUM00,1,2)
			ta female, miss
			
			merge 1:1 MCSID GCNUM00 using "$mcs7/mcs7_cm_interview", nogen
			
			recode GCSUIC00 (1 = 1) (2 = 0) (else = .), gen(suicide_17y)
			
			ta GCSXID00, mis
			recode GCSXID00 (-1 = -1) (7 8 = .) (1 = 0) (else = 1), gen(sexual_minority_17y) // keeping separate the "not applicable" value to be able to trace it
			ta sexual_minority_17y, miss
			
			rename GCSXID00 sexuality_17y
			
			keep MCSID GCNUM00 female_17y suicide_17y sexuality_17y sexual_minority_17y 
			
			merge m:1 MCSID using `mcs7_family', nogen
			
		rename GCNUM00 CNUM00
		tempfile mcs7
		save `mcs7'	
		
			
	**## 23y sweep		

		* Outcome variables
	
			use "$mcs8/mcs8_23y_cm_survey", clear
			
			recode hsphde00 hsphho00 hsphrf00 hsphee00 hsphwo00 hsphne00 hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 (-9 -8 -3 -1 = .) 
			
			sum hsphde00 hsphho00 hsphrf00 hsphee00 hsphwo00 hsphne00 // Kessler-6
			foreach var in hsphde00 hsphho00 hsphrf00 hsphee00 hsphwo00 hsphne00 {
				recode `var' (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0) (else = .), gen(`var'_rec)
			}
			egen kessler_sr_23y_miss = rowmiss(hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec)
			egen kessler_sr_23y = rowtotal(hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec) if kessler_sr_23y_miss == 0
			sum kessler_sr_23y
			
			recode kessler_sr_23y (0/12 = 0) (13/24 = 1), gen(caseness_23y)
			egen kessler_sr_23y_part = rowtotal(hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec), miss
			recode kessler_sr_23y_part (0/12 = 0) (13/24 = 1), gen(caseness_part)
			ta caseness*, miss // one observation would already pass the caseness threshold when considering partial information in the items 
			gen maxmissingdistress = 4 * kessler_sr_23y_miss
			gen kessler_sr_23y_part_max = kessler_sr_23y_part + maxmissingdistress
			recode kessler_sr_23y_part_max (0/12 = 0) (13/24 = 1), gen(caseness_part_max)
			replace caseness_part = 0 if caseness_part_max == 0 // no additional case can be assigned to caseness == 0 with the partial information as they all could in principle go beyond the threshold
			replace caseness_23y = caseness_part if caseness_part == 1 & kessler_sr_23y_miss != 0 
			drop *part *part_max
			label variable caseness_23y "Recode of kessler_sr_23y (0/12=0, 13/24=1)"
			
			sum hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 //SWEMWBS
			egen swemwbs_sr_23y_miss = rowmiss(hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00)
			egen swemwbs_sr_23y = rowtotal(hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00) if swemwbs_sr_23y_miss == 0
			sum swemwbs_sr_23y
			
			sum hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 // self-harm grid
			recode hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 (1 = 1) (2 = 0)
			egen selfharm_23y = rowmax(hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00)
			ta selfharm_23y, miss
			
			reg hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00
			egen selfharm_23y_cont = rowtotal(hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00) if e(sample) == 1 // "continuous" self-harm sum score
			ta selfharm_23y_cont 
			
			recode hssuic00 (1 = 1) (2 = 0) (else = .), gen(suicide_23y_original)
			
			sort mcsid hcnum00
			
		* Individual-level information
		
			ta hssxid_r, mis // this is a recoded variable already, does not include all the categories as in the questionnaire, unclear whether "heterosexual" includes both "completely" and "mainly" heterosexual categories 
			recode hssxid_r (1 /*heterosexual*/ = 0) (2 /*gay or lesbian*/ 3 /*bisexual*/ 4 /*other*/ 6 /*pansexual*/ 7 /*asexual*/ 8 /*queer*/ = 1) (-1 /*not applicable*/ = -1) (-8 /*don't know*/ 5 /*prefer not to say*/ = .), gen(sexual_minority_23y) // keeping "not applicable" separate to be able to trace it
			rename hssxid_r sexuality_23y
			
		
		* Additional variables
	
			merge 1:1 mcsid hcnum00 using "$mcs8/mcs8_23y_cm_derived", nogen
			recode hdsurvey_mode (1 3 = 0 "0 In-person") (2 4 5 = 1 "1 Online"), gen(mode_23y)
			recode hdsurvey_mode (1/4 = 0) (5 = 1), gen(mopup_23y) // variable identifying cases that took part on the mop-up survey
			rename hdsurvey_mode hdsurvey_mode_23y
			
			rename mcsid hcnum00, upper
			keep MCSID HCNUM00 ///
				hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec kessler_sr_23y caseness_23y ///
				hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 swemwbs_sr_23y ///
				hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 selfharm_23y selfharm_23y_cont ///
				suicide_23y_original ///
				sexuality_23y sexual_minority_23y ///
				hdsurvey_mode_23y mode_23y mopup_23y 
			
		rename HCNUM00 CNUM00
		tempfile mcs8
		save `mcs8'	

		
	**## Longitudinal file
	
		use "$mcslong/mcs_longitudinal_cm_file", clear
		keep mcsid cnum pttype2 sptn00 nh2 hnrespwt hovwt1 hovwt2 hovwtgb hissued haoutc00 hcasetype data_licence data_availability
		rename (mcsid cnum) (MCSID CNUM00)
		tempfile mcslong
		save `mcslong'

		
		
	**## Combined dataset

		use `mcs1', clear
		merge 1:1 MCSID CNUM00 using `mcs2', nogen
		merge 1:1 MCSID CNUM00 using `mcs3', nogen
		merge 1:1 MCSID CNUM00 using `mcs4', nogen
		merge 1:1 MCSID CNUM00 using `mcs5', nogen
		merge 1:1 MCSID CNUM00 using `mcs6', nogen
		merge 1:1 MCSID CNUM00 using `mcs7', nogen
		merge 1:1 MCSID CNUM00 using `mcs8', nogen
		merge 1:1 MCSID CNUM00 using `mcslong', nogen

	
**# Combined data management + preparation + cleaning	
	
	* Restricting sample to participants in age 23 sweep
	
		recode hovwt2 (-2 -1 = .)
		
		keep if hovwt2 != . // keeping cases with valid weights
		keep if data_availability == 1 // keeping cases with data available for research
		drop if hcasetype == 3 // dropping proxy interviews
		egen MCSIDCNUM = concat(MCSID CNUM00)
			
			* the following line requires the "distinct" package, which can be installed using the following line of code
			* ssc install distinct
		
		distinct MCSIDCNUM // 9675 participants, as per preregistration
			
	
	* Creating single variable for sex assigned at birth
	
		egen female_concat = concat(female_9m female_3y female_5y female_7y female_11y female_14y female_17y)
		ta female_concat
		gen female = female_9m
		foreach var in female_3y female_5y female_7y female_11y female_14y female_17y {
			replace female = `var' if female == . & `var' != .
		}
		ta female, miss
		recode female (0 = 2 "2 AMAB") (1 = 1 "1 AFAB"), gen(birthsex)
	
	* Augmenting self-designated information on ethnicity at age 14 with parent-reported information on cohort member's ethnicity and natural parents' self-reported information on ethnicity
	
		sum ADC11E00 BDC11E00 CDC11E00 DDC11E00 FDCE1100
		recode ADC11E00 BDC11E00 CDC11E00 DDC11E00 FDCE1100 (-9 -8 -1 = .)
		gen ethnicity_parentreported = 	FDCE1100
		foreach var in DDC11E00 CDC11E00 BDC11E00 ADC11E00 {
			replace ethnicity_parentreported = `var' if ethnicity_parentreported == . & `var' != .
		}
		label values ethnicity_parentreported ADC11E00
		ta ethnicity_parentreported, miss
		
		foreach parent in mother father {
			gen ethnicity_`parent' = ethnicity_`parent'_9m
			foreach sweep in 3 5 7 11 14 17 {
				replace ethnicity_`parent' = ethnicity_`parent'_`sweep' if ethnicity_`parent' == . & ethnicity_`parent'_`sweep' != .
			}
		}
		label values ethnicity_mother ethnicity_father ADC11E00
		tab1 ethnicity_mother ethnicity_father, miss
		
		gen ethnicity = ethnicity_sr_14y
		ta ethnicity, miss
		label values ethnicity ethnicity
		
		replace ethnicity = 1 if ethnicity_parentreported == 1 & ethnicity == .
		replace ethnicity = 6 if ethnicity_parentreported == 3 & ethnicity == .
		replace ethnicity = 7 if ethnicity_parentreported == 4 & ethnicity == .
		replace ethnicity = 8 if ethnicity_parentreported == 5 & ethnicity == .
		replace ethnicity = 9 if inlist(ethnicity_parentreported,6,10) & ethnicity == . // Other Asian and Chinese
		replace ethnicity = 10 if ethnicity_parentreported == 8 & ethnicity == .
		replace ethnicity = 11 if ethnicity_parentreported == 7 & ethnicity == .
		replace ethnicity = 12 if ethnicity_parentreported == 9 & ethnicity == .
		replace ethnicity = 14 if ethnicity_parentreported == 11 & ethnicity == .
		// information from Mixed ethnicities is available in a high-level manner only from parents for some participants with missing self-reported information
		ta ethnicity, miss
		
		gen ethnicity_augm_flag = 0
		replace ethnicity_augm_flag = 1 if ethnicity != ethnicity_sr_14y
		ta ethnicity_augm_flag // flagging cases where cohort member's ethnicity has been augmented with parent-reported information on the cohort member's ethnicity
		
		ta ethnicity_mother ethnicity_father if ethnicity == . // will replace self-reported information in cases where there's available and consistent information from both natural parents
			replace ethnicity = 1 if ethnicity_mother == 1 & ethnicity_father == 1 & ethnicity == .
			replace ethnicity = 6 if ethnicity_mother == 3 & ethnicity_father == 3 & ethnicity == .
			replace ethnicity = 7 if ethnicity_mother == 4 & ethnicity_father == 4 & ethnicity == .
			replace ethnicity = 8 if ethnicity_mother == 5 & ethnicity_father == 5 & ethnicity == .
			replace ethnicity = 9 if inlist(ethnicity_mother,6,10) & inlist(ethnicity_father,6,10) & ethnicity == . // Other Asian and Chinese
			replace ethnicity = 10 if ethnicity_mother == 8 & ethnicity_father == 8 & ethnicity == .
			replace ethnicity = 11 if ethnicity_mother == 7 & ethnicity_father == 7 & ethnicity == .
			replace ethnicity = 12 if ethnicity_mother == 9 & ethnicity_father == 9 & ethnicity == .
			replace ethnicity = 14 if ethnicity_mother == 11 & ethnicity_father == 11 & ethnicity == .
		ta ethnicity, miss
		
		ta ethnicity_mother ethnicity_father if ethnicity == .
			replace ethnicity = 2 if (ethnicity_mother == 1 & ethnicity_father == 7 & ethnicity == .) | (ethnicity_mother == 7 & ethnicity_father == 1 & ethnicity == .) // assigning Mixed White & Black Caribbean if parents reported being White and Black Caribbean
			replace ethnicity = 3 if (ethnicity_mother == 1 & ethnicity_father == 8 & ethnicity == .) | (ethnicity_mother == 8 & ethnicity_father == 1 & ethnicity == .) // ditto for Mixed White & Black African
			replace ethnicity = 4 if (ethnicity_mother == 1 & inlist(ethnicity_father,3,4,5,6,10) & ethnicity == .) | (inlist(ethnicity_mother,3,4,5,6,10) & ethnicity_father == 1 & ethnicity == .) // ditto for Mixed White & Asian (Asian includes Indian, Pakistani, Bangladeshi, Other Asian, and Chinese)
			replace ethnicity = 5 if ///
				(inlist(ethnicity_mother,1/*White*/,2/*Mixed*/) & inlist(ethnicity_father,9/*other Black*/,11/*other ethnic group*/) & ethnicity == .) | ///
				(ethnicity_mother == 2 & ethnicity == .) | /// if mother or father self-reported being Mixed background, assigning Other Mixed to cohort member
				(inlist(ethnicity_father,1/*White*/,2/*Mixed*/) & inlist(ethnicity_mother,9/*other Black*/,11/*other ethnic group*/) & ethnicity == .) | ///
				(ethnicity_father == 2 & ethnicity == .) | ///
				(inlist(ethnicity_mother,10,11) & inlist(ethnicity_father,3,4,6,7,8) & ethnicity == .)
		ta ethnicity_mother ethnicity_father if ethnicity == . // one remaining case that could be assigned as South Asian if higher-level
		ta ethnicity, miss
		ta ethnicity_sr_14y ethnicity, miss
		
		recode ethnicity_sr_14y (1 = 1 "1 White") (2 3 4 5 = 2 "2 Mixed") (6 = 3 "3 Indian") (7 = 4 "4 Pakistani") (8 = 5 "5 Bangladeshi") (10 11 12 = 6 "6 Black (African/Caribbean/British/Other") (9 13 14 = 7 "7 Other"), gen(ethnicity_sr_14y_7cat)
		
		recode ethnicity (1 = 1 "1 White") (2 3 4 5 = 2 "2 Mixed") (6 = 3 "3 Indian") (7 = 4 "4 Pakistani") (8 = 5 "5 Bangladeshi") (10 11 12 = 6 "6 Black (African/Caribbean/British/Other") (9 13 14 = 7 "7 Other"), gen(ethnicity_7cat)
			gen ethnicity_augm_7cat_flag = ethnicity_augm_flag
			replace ethnicity_augm_7cat_flag = 1 if ethnicity_parentreported == 2 & ethnicity_7cat == .
			replace ethnicity_7cat = 2 if ethnicity_parentreported == 2 & ethnicity_7cat == .

		replace ethnicity_augm_flag = 2 if ethnicity != ethnicity_sr_14y & ethnicity_augm_flag != 1
		replace ethnicity_augm_7cat_flag = 2 if ethnicity_augm_flag == 2 & ethnicity_augm_7cat_flag != 1
		label define ethnicity_augm_flag 0 "No changes" 1 "Assigned from parent-reported information on cohort member" 2 "Assigned from parent-reported information on natural parents"
		label values ethnicity_augm_flag ethnicity_augm_7cat_flag ethnicity_augm_flag
		tab1 ethnicity_augm_flag ethnicity_augm_7cat_flag
		
		replace ethnicity_augm_flag = . if ethnicity == .
		replace ethnicity_augm_7cat_flag = . if ethnicity_7cat == .
		
		recode ethnicity_7cat (5 = 4) (6 = 5) (7 = 6), gen(ethnicity_6cat)
		label copy ethnicity_7cat ethnicity_6cat
		label define ethnicity_6cat 4 "4 Pakistani/Bangladeshi" 5 "5 Black" 6 "6 Other", modify
		label values ethnicity_6cat ethnicity_6cat
		ta ethnicity_6cat
	
	
	* Augmenting self-reported information on sexual orientation at age 17 with information on sexual attraction at age 14
	
		ta sexual_minority_17y, miss
		
		gen attractedtosamesex = .
		replace attractedtosamesex = 1 if (female == 1 & attractedtofemale_sr_14y == 1) | (female == 0 & attractedtomale_sr_14y == 1)
		ta sexual_minority_17y attractedtosamesex, miss // 69+5 cases attracted to same sex and missing sexual orientation information; 87 cases attracted to same sex and no sexual minority status
		
		gen sexual_minority_17y_augm_flag = 1 if (sexual_minority_17y == . | sexual_minority_17y == -1) & ((female == 1 & attractedtofemale_sr_14y == 1) | (female == 0 & attractedtomale_sr_14y == 1))
		gen sexual_minority_17y_augm = sexual_minority_17y
			replace sexual_minority_17y_augm = 1 if sexual_minority_17y_augm_flag == 1 // only replacing values in those cases where there is no information on sexual identity at age 17
			
		drop attracted*
		
	* Augmenting self-reported information on sexual identity at age 23 with information at age 17
	
		ta sexual_minority_23y sexual_minority_17y_augm, miss
		ta sexuality_23y if sexuality_17y == 2, miss // cases that identified as mainly heterosexual at age 17
		ta sexuality_17y if !inrange(sexual_minority_23y,0,1) & inrange(sexual_minority_17y_augm,0,1) // these are the cases that can be augmented, 25 "mainly heterosexual" that would go into "heterosexual" based on age 23 categories (EUL data)
		ta sexuality_17y sexual_minority_17y_augm_flag if !inrange(sexual_minority_23y,0,1) & inrange(sexual_minority_17y_augm,0,1), miss // of those, only 1 would be informed by sexual attraction at age 14
		gen sexual_minority_23y_augm_flag = 1 if !inrange(sexual_minority_23y,0,1) & inrange(sexual_minority_17y_augm,0,1)
		gen sexual_minority_23y_augm = sexual_minority_23y
		replace sexual_minority_23y_augm = sexual_minority_17y_augm if sexual_minority_23y_augm_flag == 1
			replace sexual_minority_23y_augm = 0 if sexuality_17y == 2 /*if mainly heterosexual*/ & sexual_minority_23y_augm_flag == 1 // to keep consistency with operationalisation of "heterosexual" at age 23
		ta sexual_minority_23y_augm, miss
		ta sexuality_23y sexual_minority_23y_augm, miss
		
	* Recoding "not applicable" values of sexuality at age 23 as missing
	
		recode sexual_minority_23y* (-1 = .)
		
	* Augmenting lifetime attempted suicides at age 23 with information at age 17
	
		ta suicide_17y suicide_23y_original, miss
		gen suicide_23y = suicide_23y_original
		replace suicide_23y = suicide_17y if suicide_17y == 1 & suicide_23y_original != 1
	
	* Creating indicator of early-life poverty status
	
		egen poverty_9m_3y = rowmax(ADOEDP00 BDOEDP00)
			ta poverty_9m_3y, miss
				
	* Augmenting indicator with information on later-life poverty status
	
		rename (CDOEDP00 DDOEDP00 EOEDP000 FOEDP000) (poverty_5y poverty_7y poverty_11y poverty_14y)
		egen poverty_5y_14y_times = rowtotal(poverty_5y poverty_7y poverty_11y poverty_14y)
		egen poverty_5y_14y_nonmiss = rownonmiss(poverty_5y poverty_7y poverty_11y poverty_14y)
		gen poverty_5y_14y_prop = poverty_5y_14y_times / poverty_5y_14y_nonmiss
			drop poverty_5y poverty_7y poverty_11y poverty_14y poverty_5y_14y_times poverty_5y_14y_nonmiss
		
		replace poverty_9m_3y = 0 if poverty_5y_14y_prop == 0 & poverty_9m_3y == .
		replace poverty_9m_3y = 1 if poverty_5y_14y_prop == 1 & poverty_9m_3y == .
		
	* Some required additional steps for compatibility with Mplus
	
		rename sptn00 sptn00_string
		gen sptn00 = substr(sptn00_string,1,6)
		distinct sptn*
		destring sptn00, replace
		
		gen mcsid = substr(MCSIDCNUM,2,5)
		gen cnum = substr(MCSIDCNUM,8,1)
		egen MCSIDCNUM_link = concat(mcsid cnum)
		destring MCSIDCNUM_link, replace
		distinct MCSIDCNUM_link
		
	* Keeping and ordering variables
	
		keep ///
			MCSIDCNUM MCSIDCNUM_link pttype2 sptn00 hovwt2 hdsurvey_mode_23y mode_23y mopup_23y /// ID variable and survey features
			birthsex ethnicity ethnicity_6cat sexual_minority_23y_augm poverty_9m_3y /// variables defining strata
			sexuality_17y sexual_minority_17y sexual_minority_17y_augm sexuality_23y sexual_minority_23y /// additional variables relevant for descriptive analyses
			hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec /// Kessler-6 items
			hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 /// SWEMWBS items
			hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 suicide_23y /// self-harm and suicide items
			kessler_sr_23y caseness_23y swemwbs_sr_23y selfharm_23y selfharm_23y_cont /// sum score / combined outcomes
			suicide_17y suicide_23y_original // additional variables on suicide attempts relevant for descriptive analyses
			
		order  ///
			MCSIDCNUM MCSIDCNUM_link pttype2 sptn00 hovwt2 hdsurvey_mode_23y mode_23y mopup_23y /// ID variable and survey features
			birthsex ethnicity ethnicity_6cat sexual_minority_23y_augm poverty_9m_3y /// variables defining strata
			sexuality_17y sexual_minority_17y sexual_minority_17y_augm sexuality_23y sexual_minority_23y /// additional variables relevant for descriptive analyses
			hsphde00_rec hsphho00_rec hsphrf00_rec hsphee00_rec hsphwo00_rec hsphne00_rec /// Kessler-6 items
			hswwop00 hswwus00 hswwre00 hswwde00 hswwth00 hswwcl00 hswwmn00 /// SWEMWBS items
			hsshcu00 hsshbu00 hsshbr00 hsshod00 hsshpu00 hsshrm00 suicide_23y /// self-harm and suicide items
			kessler_sr_23y caseness_23y swemwbs_sr_23y selfharm_23y selfharm_23y_cont /// sum score / combined outcomes
			suicide_17y suicide_23y_original // additional variables on suicide attempts relevant for descriptive analyses
			
	sum
	
	sort MCSIDCNUM
	
	compress
	
	save "$datasets/mcs_combined_clean", replace