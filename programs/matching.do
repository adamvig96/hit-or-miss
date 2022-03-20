
*******************************************************************
* Subject: Empirical Political Economy
* Authors: Philipp, Niccolo, Ramzi, Marton & Adam
* Project: "Hit or Miss"
*******************************************************************


version 9.2
clear
set mem 300m
set more off

local fixedeffectvars = "weapondum* numserdum* " 		

use "data/country_year_data.dta", clear

********************************************************************************


***
* old code from data
***

tsset
g anywarl1l3 = l.zGledAnywar - l3.zGledAnywar
g npolity2l1l3 = l.npolity2 - l3.npolity2
g lnenergy_pc = ln(energy) - ln(tpop)
g lnpop = ln(tpop)

g pol2dum = 0 if polity2<=0 & polity2!=. 
replace pol2dum = 1 if polity2>0 & polity2!=. 
g lpol2dum = l.pol2dum
g pol2duml1l3 = l.pol2dum - l3.pol2dum
for var npolity2 zGledAnywar lnenergy_pc lnpop age : g lX = l.X

foreach X of var prioanywar prioanywarP zGledAnywar zGledAnywarP {
	g `X'11 = f.`X' - l.`X'
	
}


**************************************
*** Table 9: Propensity score
**************************************

g failure = (seriousattempt == 1 & success == 0) if seriousattempt != . & success != .
	
capture drop lanywar
g lanywar = l.zGledAnywar
g ltenure = l.clock
*label var lnpolity2 "Polity score"
*label var ltenure "Tenure"
*label var lanywar "At war"
*label var llnenergy_pc "Ln energy use p.c."
*label var llnpop "Population"


dprobit seriousattempt lpol2dum , cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se replace title("Predicting attempts") bd(3) adds("P-val",r(p))

dprobit seriousattempt pol2duml1l3 , cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt lanywar , cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt anywarl1l3 , cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt llnenergy_pc , cluster(cowcode) 
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt llnpop, cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt lage, cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt ltenure, cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))

dprobit seriousattempt lpol2dum pol2duml1l3 lanywar anywarl1l3 llnenergy_pc llnpop lage ltenure , cluster(cowcode)
testparm *
outreg2 using "tables/table_9.tex", coefastr se append bd(3) adds("P-val",r(p))


**************************************
*** Table 10: Success vs. failure, institutional change
**************************************


***
* NEW CODE WITH MATCHING PACKAGES
*
* NEED TO INSTALL IF NECESSARY 
***

*INSTALL PACKAGES
*ssc install kmatch
*ssc install st0026
*ssc install psmatch2


* Set up propensity score variables
for var lpol2dum pol2duml1l3 anywarl1l3 lanywar llnpop llnenergy_pc lage ltenure : g mis_X = (X == .) \ g nonmis_X = X \ replace nonmis_X  = 0 if X == .

pscore seriousattempt nonmis_* mis_* if obsid != "" , pscore(pscoreseriousattempt) blockid(blockseriousattempt)

g failurelautoc = failure*lautoc
g failureldemoc = failure*ldemoc

********************************
* Table 10A
********************************

***
* COLUMNS (1) - (2)
***

eststo clear
quietly reg absnpolity2dummy11 success failure  , cluster(cowcode)
global reg_1s = _b[success]
global reg_1s_se = _se[success]
global reg_1f = _b[failure]
global reg_1f_se = _se[failure]

testparm success
eststo reg1, add(pvalS r(p))
testparm failure
eststo reg1, add(pvalF r(p))


quietly xi: reg absnpolity2dummy11 success failure nonmis_* mis_*  regdum* qtrcentury*  , cluster(cowcode)
global reg_2s = _b[success]
global reg_2s_se = _se[success]
global reg_2f = _b[failure]
global reg_2f_se = _se[failure]

testparm success
eststo reg2, add(pvalS r(p))
testparm failure
eststo reg2, add(pvalF r(p))

*propensity score matching
quietly xi: reg absnpolity2dummy11 success failure nonmis_* mis_*  i.blockserious regdum* qtrcentury*  , cluster(cowcode)
global reg_3s = _b[success]
global reg_3s_se = _se[success]
global reg_3f = _b[failure]
global reg_3f_se = _se[failure]

testparm success
eststo reg3, add(pvalS r(p))
testparm failure
eststo reg3, add(pvalF r(p))


estout, stat(pvalS pvalF)

***
* NEW METHODS
***

*nearest neighbor matching
attnd absnpolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw absnpolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_1s = r(attnd)
global attnd_1s_bse = r(bseattnd)

*nearest neighbor matching
attnd absnpolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw absnpolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_1f = r(attnd)
global attnd_1f_bse = r(bseattnd)

*kernel-density matching 
attk absnpolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_1s = r(attk)
global attk_1s_bse = r(bseattk)

*kernel-density matching 
attk absnpolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_1f = r(attk)
global attk_1f_bse = r(bseattk)

*now I generate my matrix and the summary table
matrix A = $reg_1s, $reg_2s, $reg_3s, $attnd_1s, $attk_1s\ $reg_1s_se, $reg_2s_se, $reg_3s_se, $attnd_1s_bse, $attk_1s_bse\ $reg_1f, $reg_2f, $reg_3f, $attnd_1f, $attk_1f\ $reg_1f_se, $reg_2f_se, $reg_3f_se, $attnd_1f_bse, $attk_1f_bse
matrix rownames A = "Success" "Std_Error" "Failure" "Std_Error"
matrix colnames A = REG REG_con REG_con_pscore ATT_Neighbor ATT_Kernel 
matlist A, format(%15.4f) twidth(40) title(Summary of Results)

esttab matrix(A, fmt(3)) using "tables/matrix_table.tex", fragment replace



***
* COLUMNS (3) - (4)
***

reg npolity2dummy11 success failure  , cluster(cowcode)
global reg_4s = _b[success]
global reg_4s_se = _se[success]
global reg_4f = _b[failure]
global reg_4f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)


xi: reg npolity2dummy11 success failure nonmis_* mis_*  regdum* qtrcentury*  , cluster(cowcode)
global reg_5s = _b[success]
global reg_5s_se = _se[success]
global reg_5f = _b[failure]
global reg_5f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)

*propensity score matching
xi: reg npolity2dummy11 success failure nonmis_* mis_*  i.blockserious regdum* qtrcentury*  , cluster(cowcode)
global reg_6s = _b[success]
global reg_6s_se = _se[success]
global reg_6f = _b[failure]
global reg_6f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)


***
* NEW METHODS
***

*nearest neighbor matching
attnd npolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw npolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_2s = r(attnd)
global attnd_2s_bse = r(bseattnd)

*nearest neighbor matching
attnd npolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw npolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_2f = r(attnd)
global attnd_2f_bse = r(bseattnd)

*kernel-density matching 
attk npolity2dummy11 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_2s = r(attk)
global attk_2s_bse = r(bseattk)

*kernel-density matching 
attk npolity2dummy11 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_2f = r(attk)
global attk_2f_bse = r(bseattk)

*now I generate my matrix and the summary table
matrix B = $reg_4s, $reg_5s, $reg_6s, $attnd_2s, $attk_2s\ $reg_4s_se, $reg_5s_se, $reg_6s_se, $attnd_2s_bse, $attk_2s_bse\ $reg_4f, $reg_5f, $reg_6f, $attnd_2f, $attk_2f\ $reg_4f_se, $reg_5f_se, $reg_6f_se, $attnd_2f_bse, $attk_2f_bse
matrix rownames B = "Success" "Std_Error" "Failure" "Std_Error"
matrix colnames B = REG REG_con REG_con_pscore ATT_Neighbor ATT_Kernel 
matlist B, format(%15.4f) twidth(40) title(Summary of Results)

esttab matrix(B, fmt(3)) using tables/matrix_table.tex, fragment append



***
* COLUMNS (5) - (6)
***


reg perexitregularNC201 success failure  , cluster(cowcode)
global reg_7s = _b[success]
global reg_7s_se = _se[success]
global reg_7f = _b[failure]
global reg_7f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)


xi: reg perexitregularNC201 success failure nonmis_* mis_*  regdum* qtrcentury*  , cluster(cowcode)
global reg_8s = _b[success]
global reg_8s_se = _se[success]
global reg_8f = _b[failure]
global reg_8f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)


*propensity score matching
xi: reg perexitregularNC201 success failure nonmis_* mis_*  i.blockserious regdum* qtrcentury*  , cluster(cowcode)
global reg_9s = _b[success]
global reg_9s_se = _se[success]
global reg_9f = _b[failure]
global reg_9f_se = _se[failure]

testparm success
local pvalS = r(p)
testparm failure
local pvalF = r(p)



***
* NEW METHODS
***

*nearest neighbor matching
attnd perexitregularNC201 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw perexitregularNC201 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_3s = r(attnd)
global attnd_3s_bse = r(bseattnd)

*nearest neighbor matching
attnd perexitregularNC201 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*attnw perexitregularNC201 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attnd_3f = r(attnd)
global attnd_3f_bse = r(bseattnd)

*kernel-density matching 
attk perexitregularNC201 success failure nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_3s = r(attk)
global attk_3s_bse = r(bseattk)

*kernel-density matching 
attk perexitregularNC201 failure success nonmis_* mis_*, pscore(pscoreseriousattempt) bootstrap reps(100)
*save some r-class data
global attk_3f = r(attk)
global attk_3f_bse = r(bseattk)

*now I generate my matrix and the summary table
matrix C = $reg_7s, $reg_8s, $reg_9s, $attnd_3s, $attk_3s\ $reg_7s_se, $reg_8s_se, $reg_9s_se, $attnd_3s_bse, $attk_3s_bse\ $reg_7f, $reg_8f, $reg_9f, $attnd_3f, $attk_3f\ $reg_7f_se, $reg_8f_se, $reg_9f_se, $attnd_3f_bse, $attk_3f_bse
matrix rownames C = "Success" "Std_Error" "Failure" "Std_Error"
matrix colnames C = REG REG_con REG_con_pscore ATT_Neighbor ATT_Kernel 
matlist C, format(%15.4f) twidth(40) title(Summary of Results)

esttab matrix(C, fmt(3)) using "tables/matrix_table.tex", fragment append


********************************************************************************
********************************************************************************

**************
* END
**************
