use "Z:\Documents\Stata\CAnD3\RRWM\gss-12M0025-E-2017-c-31_F1.dta", clear

**# Cleaning
clonevar marst = MARSTAT
recode marst (1 2 = 1)(3 4 5 6 = 0)
label define marst 1 "married or common-law" 0 "single, separated/divorced/widowed"
label values marst marst


gen genst = .
replace genst = 1 if BRTHCAN == 2 
replace genst = 2 if BRTHCAN == 1 & BRTHFCAN == 2
replace genst = 2 if BRTHCAN == 1 & BRTHMCAN == 2
replace genst = 3 if BRTHCAN == 1 & BRTHFCAN == 1
replace genst = 3 if BRTHCAN == 1 & BRTHMCAN == 1
label define genst 1 "1st gen" 2 "2nd gen" 3 "3rd+ gen"
label values genst genst

gen visgen = .
replace visgen = 1 if VISMIN == 1 & genst == 1 
replace visgen = 2 if VISMIN == 1 & genst == 2
replace visgen = 3 if VISMIN == 1 & genst == 3
replace visgen = 4 if VISMIN == 2 & genst == 1 
replace visgen = 5 if VISMIN == 2 & genst == 2 
replace visgen = 6 if VISMIN == 2 & genst == 3 
label define visgen 1 "vismin 1st gen" 2 "vismin 2nd gen" 3 "vismin 3rd+ gen" 4 "nonvismin 1st gen" 5 "nonvismin 2nd gen" 6 "nonvismin 3rd+gen"
label values visgen visgen

gen prvisgen = .
replace prvisgen = 1 if VISMINPR == 1 & BRTHPCAN == 1
replace prvisgen = 2 if VISMINPR == 1 & BRTHPCAN == 2
replace prvisgen = 3 if VISMINPR == 2 & BRTHPCAN == 1
replace prvisgen = 4 if VISMINPR == 2 & BRTHPCAN == 2
label define prvisgen 1 "vismin 1st gen" 2 "vismin 2+gen" 3 "nonvismin 1st gen" 4 "nonvismin 2+gen"
label values prvisgen prvisgen



**# Descriptives
tab VISMIN genst [aweight = WGHT_PER], col
tab VISMIN VISMINPR [aweight = WGHT_PER], col
tab BRTHPCAN genst [aweight = WGHT_PER], col
tab visgen prvisgen [aweight = WGHT_PER], col



**# Regression
logistic marst ib6.visgen#ib4.prvisgen [pweight = WGHT_PER]
logistic marst ib6.visgen#ib4.prvisgen AGEGR10 GU_190 [pweight = WGHT_PER]
logistic marst ib6.visgen#ib4.prvisgen AGEGR10 GU_190 TOTCHDC EHG3_01B [pweight = WGHT_PER]



