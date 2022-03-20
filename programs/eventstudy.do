
*******************************************************************
* Subject: Empirical Political Economy
* Authors: Philipp, Niccolo, Ramzi, Marton & Adam
* Project: "Hit or Miss"
*******************************************************************

version 9.2
clear
set mem 300m
set more off
set matsize 2000

local fixedeffectvars = "weapondum* numserdum* " 		


use "data/country_year_data.dta", clear

**************************************
*** Table 6: Tenure of Leader and Duration Effects
**************************************

* Column 1: All serious attempts

tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4 if seriousattempt == 1  , cluster(cowcode)
*maketablerank using table_6, rhs(success) varcol(All) replace 	pval noastr rankpval(`pvalnonparm')


********************************************************************************
********************************************************************************


***
* eventstudy code
***

*preserve original data
*preserve

* prepare data 
*remove the duplicates around the ten year window for eventstudy
replace success=0 if success[_n-1]==1 & cowcode[_n-1]==cowcode
replace success=0 if success[_n-2]==1 & cowcode[_n-2]==cowcode
replace success=0 if success[_n-3]==1 & cowcode[_n-3]==cowcode
replace success=0 if success[_n-4]==1 & cowcode[_n-4]==cowcode
replace success=0 if success[_n-5]==1 & cowcode[_n-5]==cowcode
replace success=0 if success[_n-6]==1 & cowcode[_n-6]==cowcode
replace success=0 if success[_n-7]==1 & cowcode[_n-7]==cowcode
replace success=0 if success[_n-8]==1 & cowcode[_n-8]==cowcode
replace success=0 if success[_n-9]==1 & cowcode[_n-9]==cowcode
replace success=0 if success[_n-10]==1 & cowcode[_n-10]==cowcode

*condition on seriousattempt
gen panel_attempt=1 if seriousattempt[_n+10]==1 & cowcode[_n+10]==cowcode
replace panel_attempt=1 if seriousattempt[_n+9]==1 & cowcode[_n+9]==cowcode
replace panel_attempt=1 if seriousattempt[_n+8]==1 & cowcode[_n+8]==cowcode
replace panel_attempt=1 if seriousattempt[_n+7]==1 & cowcode[_n+7]==cowcode
replace panel_attempt=1 if seriousattempt[_n+6]==1 & cowcode[_n+6]==cowcode
replace panel_attempt=1 if seriousattempt[_n+5]==1 & cowcode[_n+5]==cowcode
replace panel_attempt=1 if seriousattempt[_n+4]==1 & cowcode[_n+4]==cowcode
replace panel_attempt=1 if seriousattempt[_n+3]==1 & cowcode[_n+3]==cowcode
replace panel_attempt=1 if seriousattempt[_n+2]==1 & cowcode[_n+2]==cowcode
replace panel_attempt=1 if seriousattempt[_n+1]==1 & cowcode[_n+1]==cowcode
replace panel_attempt=1 if seriousattempt==1 
replace panel_attempt=1 if seriousattempt[_n-1]==1 & cowcode[_n-1]==cowcode
replace panel_attempt=1 if seriousattempt[_n-2]==1 & cowcode[_n-2]==cowcode
replace panel_attempt=1 if seriousattempt[_n-3]==1 & cowcode[_n-3]==cowcode
replace panel_attempt=1 if seriousattempt[_n-4]==1 & cowcode[_n-4]==cowcode
replace panel_attempt=1 if seriousattempt[_n-5]==1 & cowcode[_n-5]==cowcode
replace panel_attempt=1 if seriousattempt[_n-6]==1 & cowcode[_n-6]==cowcode
replace panel_attempt=1 if seriousattempt[_n-7]==1 & cowcode[_n-7]==cowcode
replace panel_attempt=1 if seriousattempt[_n-8]==1 & cowcode[_n-8]==cowcode
replace panel_attempt=1 if seriousattempt[_n-9]==1 & cowcode[_n-9]==cowcode
replace panel_attempt=1 if seriousattempt[_n-10]==1 & cowcode[_n-10]==cowcode

***
* condition on attempts
***

keep if panel_attempt==1 


***

*for later diagnostics
*create the success indicator variable
gen panel_success=-5 if success[_n+5]==1 & cowcode[_n+5]==cowcode
replace panel_success=-4 if success[_n+4]==1 & cowcode[_n+4]==cowcode
replace panel_success=-3 if success[_n+3]==1 & cowcode[_n+3]==cowcode
replace panel_success=-2 if success[_n+2]==1 & cowcode[_n+2]==cowcode
replace panel_success=-1 if success[_n+1]==1 & cowcode[_n+1]==cowcode
replace panel_success=0 if success==1 
replace panel_success=1 if success[_n-1]==1 & cowcode[_n-1]==cowcode
replace panel_success=2 if success[_n-2]==1 & cowcode[_n-2]==cowcode
replace panel_success=3 if success[_n-3]==1 & cowcode[_n-3]==cowcode
replace panel_success=4 if success[_n-4]==1 & cowcode[_n-4]==cowcode
replace panel_success=5 if success[_n-5]==1 & cowcode[_n-5]==cowcode

*shift to pos. values
replace panel_success=panel_success+6
replace panel_success=0 if panel_success==.


*create the success dummies like discussed
gen success_m5=0
replace success_m5=1 if success[_n+5]==1 & cowcode[_n+5]==cowcode
gen success_m4=0
replace success_m4=1 if success[_n+4]==1 & cowcode[_n+4]==cowcode
gen success_m3=0
replace success_m3=1 if success[_n+3]==1 & cowcode[_n+3]==cowcode
gen success_m2=0
replace success_m2=1 if success[_n+2]==1 & cowcode[_n+2]==cowcode
gen success_m1=0
replace success_m1=1 if success[_n+1]==1 & cowcode[_n+1]==cowcode

gen success_p0=0
replace success_p0=1 if success==1 

gen success_p1=0
replace success_p1=1 if success[_n-1]==1 & cowcode[_n-1]==cowcode
gen success_p2=0
replace success_p2=1 if success[_n-2]==1 & cowcode[_n-2]==cowcode
gen success_p3=0
replace success_p3=1 if success[_n-3]==1 & cowcode[_n-3]==cowcode
gen success_p4=0
replace success_p4=1 if success[_n-4]==1 & cowcode[_n-4]==cowcode
gen success_p5=0
replace success_p5=1 if success[_n-5]==1 & cowcode[_n-5]==cowcode


***
*NEW CODE WITH EVENTSTUDY INTERACT PACKAGE
***

*INSTALL PACKAGES
*ssc install eventstudyinteract, all replace
*ssc install avar
*ssc install reghdfe
*ssc install ftools

*gen our outcome of interest
gen difpol2= polity2 - l.polity2 if cowcode[_n-1]==cowcode
gen chgpol2= difpol2
replace chgpol2= 0 if difpol2 ==.
replace chgpol2= 1 if chgpol2 >=1
replace chgpol2= -1 if chgpol2 <=-1 


*code the cohort categorical variable based on when the individual first joined the union, which will be
*inputted in cohort(varname).
gen success_year = year if success == 1
bysort cowcode: egen first_success = min(success_year)
*drop success_year
 
*code the relative time categorical variable.
gen relative_year = year - first_success

*for the first example, we take the control cohort to be individuals that never unionized.
gen never_success = (first_success == .)

*we will consider the dynamic effect of union status on income.  We first generate these relative time
*indicators, and leave out the distant leads due to few observations.  Implicitly this assumes that effects
*outside the lead windows are zero.
 
 forvalues k = 10(-1)2 {
 gen g_`k' = relative_year == -`k'
 }
 forvalues k = 0/10 {
 gen g`k' = relative_year == `k'
 }
        
*we use the IW estimator to estimate the dynamic effect on log wage associated with each relative time.
*with many leads and lags, we need a large matrix size to hold intermediate estimates.


********************************************************************************

***
* Panel A with Event Study
*
* Directional change in POLITY2 dummy
***

* use 2 leads and 10 lags as before

*** All serious attempts
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment replace

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


*** Tenure <= 10
preserve
keep if durgroup == 1
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


*** Tenure > 10
preserve
sort country year
replace durgroup=durgroup[_n-1] if country==country[_n-1] & durgroup[_n-1]==2
replace durgroup=durgroup[_n+1] if country==country[_n+1] & durgroup[_n+1]==2
replace durgroup=durgroup[_n+2] if country==country[_n+2] & durgroup[_n+2]==2
replace durgroup=durgroup[_n+3] if country==country[_n+3] & durgroup[_n+3]==2
replace durgroup=durgroup[_n+4] if country==country[_n+4] & durgroup[_n+4]==2
replace durgroup=durgroup[_n+5] if country==country[_n+5] & durgroup[_n+5]==2

keep if durgroup == 2
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore

***
* AUTOCRATS
***

*** All serious attempts on autocrats
preserve 
keep if lautoc == 1
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore

*** Autocrat with tenure <= 10
preserve 
keep if lautoc == 1 & durgroup == 1
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


*** Autocrats with tenure > 10
preserve 
sort country year
replace durgroup=durgroup[_n-1] if country==country[_n-1] & durgroup[_n-1]==2
replace durgroup=durgroup[_n+1] if country==country[_n+1] & durgroup[_n+1]==2
replace durgroup=durgroup[_n+2] if country==country[_n+2] & durgroup[_n+2]==2
replace durgroup=durgroup[_n+3] if country==country[_n+3] & durgroup[_n+3]==2
replace durgroup=durgroup[_n+4] if country==country[_n+4] & durgroup[_n+4]==2
replace durgroup=durgroup[_n+5] if country==country[_n+5] & durgroup[_n+5]==2

keep if lautoc == 1 & durgroup == 2
eventstudyinteract difpol2 g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table6.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


***
* Panel B with Event Study Design
*
* Percentage of transitions by "regular" means
***

*** All serious attempts
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C, format(%9.3f)

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment replace

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


*** Tenure <= 10
preserve
keep if durgroup == 1
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


*** Tenure > 10
preserve
sort country year
replace durgroup=durgroup[_n-1] if country==country[_n-1] & durgroup[_n-1]==2
replace durgroup=durgroup[_n+1] if country==country[_n+1] & durgroup[_n+1]==2
replace durgroup=durgroup[_n+2] if country==country[_n+2] & durgroup[_n+2]==2
replace durgroup=durgroup[_n+3] if country==country[_n+3] & durgroup[_n+3]==2
replace durgroup=durgroup[_n+4] if country==country[_n+4] & durgroup[_n+4]==2
replace durgroup=durgroup[_n+5] if country==country[_n+5] & durgroup[_n+5]==2

keep if durgroup == 2
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


***
* AUTOCRATS
***

*** All serious attempts on autocrats
preserve 
keep if lautoc == 1
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)
matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


*** Autocrat with tenure <= 10
preserve 
keep if lautoc == 1 & durgroup == 1
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)
matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


*** Autocrats with tenure > 10
preserve 
replace durgroup=durgroup[_n-1] if country==country[_n-1] & durgroup[_n-1]==2
replace durgroup=durgroup[_n+1] if country==country[_n+1] & durgroup[_n+1]==2
replace durgroup=durgroup[_n+2] if country==country[_n+2] & durgroup[_n+2]==2
replace durgroup=durgroup[_n+3] if country==country[_n+3] & durgroup[_n+3]==2
replace durgroup=durgroup[_n+4] if country==country[_n+4] & durgroup[_n+4]==2
replace durgroup=durgroup[_n+5] if country==country[_n+5] & durgroup[_n+5]==2

keep if lautoc == 1 & durgroup == 2
eventstudyinteract exitregular g_2 g0 g2 g4 g6 g8 g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table7.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


********************************************************************************
***
*** ROBUSTNESS (Part I.1)
***

* use 5 leads and 5 lags, with controls as before 
eventstudyinteract difpol2 g_5-g_2 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table8.tex", fragment replace

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


*only leads
eventstudyinteract difpol2 g0-g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C
coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


***
*** ROBUSTNESS (Part I.2)
***

*** use CHGPOL2 - as dummy
* use 5 leads and 5 lags as before (now with covariates)
eventstudyinteract chgpol2 g_5-g_2 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table8.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


*only leads
eventstudyinteract chgpol2 g0-g10, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C
coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


********************************************************************************

***
* RESIDUAL DIAGNOSTICS
***

* see if there is a pattern in the residuals...
*directional change
*reg chgpol2 weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4 i.countrynum i.year, vce(cluster cowcode)
*predict res_chg, res
*predict fit_chg, xb 
*twoway (scatter res_chg fit_chg)
*twoway (scatter res_chg panel_success)

*continuous change variable
*reg difpol2 weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4 i.countrynum i.year, vce(cluster cowcode)
*predict res_dif, res
*predict fit_dif, xb
*twoway (scatter res_dif fit_dif)
*twoway (scatter res_dif panel_success)

*further diagnostics plots
*rvfplot


********************************************************************************
*** ROBUSTNESS (Part II)

*different clustering 

*use robust
eventstudyinteract difpol2 g_5-g_2 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(robust)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table8.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


* use region
eventstudyinteract difpol2 g_5-g_2 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster region)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table8.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


* use region
eventstudyinteract difpol2 g_5-g_2 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster year)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C

esttab matrix(C, fmt(3)) using "tables/event_table8.tex", fragment append

coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


********************************************************************************
*** ROBUSTNESS (Part III)

*pre-treatment effects seem relatively constant, which might suggest binning the many leads.  TODO: current
*implementation of bins does not follow Sun and Abraham (2020) exactly due to coding challenge.  But it is
*valid if effects in the bin are constant for each cohort.
gen g_l5 = relative_year <= -5

eventstudyinteract difpol2 g_l5 g0-g5, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)

matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C
coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)


***
* look at 1-10 years...
***

*only for exitregular, difpol2 and chgpol2 not sign.!

preserve
gen g_l10 = relative_year <= -10
gen g10x = (relative_year <= 10 & relative_year >= 1)
eventstudyinteract exitregular g_l10 g0 g10x, cohort(first_success) control_cohort(never_success) covariates(weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4) absorb(i.countrynum i.year) vce(cluster cowcode)
matrix C = e(b_iw)
mata st_matrix("A",sqrt(st_matrix("e(V_iw)")))
matrix C = C \ A
matrix list C
coefplot matrix(C[1]), se(C[2]) vertical drop(_cons weapondum2 weapondum3 weapondum4 weapondum5 weapondum6 numserdum2 numserdum3 numserdum4)
restore


********************************************************************************
********************************************************************************

**************
* END
**************
