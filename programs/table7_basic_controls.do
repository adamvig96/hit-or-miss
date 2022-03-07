clear
local fixedeffectvars = "weapondum* numserdum* " 		

use "data/country_year_data.dta", clear

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
capture drop outinfo*  varname

** Get average transition probabilities	
** Polity dummy

g trans = .
g toauttrans = .
g todemtrans = .
g toauttransD = .
g todemtransA = .

g period1 = 1 if year>=1875 & year<=1949
g period2 = 1 if year>=1950 & year<=2004
g period3 = 1 if year>=1875 & year<=2004

g perlab2 = "pre 1950" in 1
replace perlab2 = "post 1950" in 2
replace perlab2 = "All Years" in 3


* Polity data
foreach num of numlist 1/3 {

	qui tab absnpolity2dummy11 if period`num'==1, g(np2_p`num'_t)
	qui sum np2_p`num'_t2
	replace trans = `r(mean)' in `num'

	qui tab npolity2dummy11 if period`num'==1, g(np2_p`num'_)
	qui sum np2_p`num'_1
	replace toauttrans = `r(mean)' in `num'
	qui sum np2_p`num'_3
	replace todemtrans = `r(mean)' in `num'

	qui tab npolity2dummy11 if period`num'==1 & lautoc==1, g(np2_p`num'_a)
	qui sum np2_p`num'_a2
	replace todemtransA = `r(mean)' in `num'
	
	qui tab npolity2dummy11 if period`num'==1 & ldemoc==1, g(np2_p`num'_d)
	qui sum np2_p`num'_d1
	replace toauttransD = `r(mean)' in `num'

	drop np2_p*

}



** War transitions
g prioanywar11B = 0 if prioanywar11==0
replace prioanywar11B = 1 if prioanywar11>0 & prioanywar11!=.
replace prioanywar11B = -1 if prioanywar11<0 & prioanywar11!=.
g lprioanywar = l.prioanywar

* COW data
foreach var of varlist zGledAnywar11 {
	
	g up`var'=.
	g down`var'=.

	g up`var'NW=.
	g down`var'W=.
	
	* by period	
	foreach num of numlist 1/3 {
			
		qui tab `var' if period`num'==1, g(`var'p`num'_)
		qui sum `var'p`num'_3
		replace up`var' = `r(mean)' in `num'
		qui sum `var'p`num'_1
		replace down`var' = `r(mean)' in `num'

		qui tab `var' if period`num'==1 & lzGledAnywar==0, g(`var'p`num'_NW)
		qui sum `var'p`num'_NW2
		replace up`var'NW = `r(mean)' in `num'

		qui tab `var' if period`num'==1 & lzGledAnywar==1, g(`var'p`num'_W)
		qui sum `var'p`num'_W1
		replace down`var'W = `r(mean)' in `num'

		drop `var'p`num'_*

	}
	
}

* PRIO data
foreach var of varlist prioanywar11B {
	
	g up`var'=.
	g down`var'=.

	g up`var'NW=.
	g down`var'W=.
	
	* by period	
	foreach num of numlist 2/3 {
		
		qui tab `var' if period`num'==1, g(`var'p`num'_)
		qui sum `var'p`num'_3
		qui replace up`var' = `r(mean)' in `num'
		qui sum `var'p`num'_1
		replace down`var' = `r(mean)' in `num'

		qui tab `var' if period`num'==1 & lprioanywar==0, g(`var'p`num'_NW)
		qui sum `var'p`num'_NW2
		replace up`var'NW = `r(mean)' in `num'

		qui tab `var' if period`num'==1 & lprioanywar==1, g(`var'p`num'_W)
		qui sum `var'p`num'_W1
		replace down`var'W = `r(mean)' in `num'

		drop `var'p`num'_*

	}

}

*** Prio transition probabilities conditional on moderate war
g upmprioanywar11 = .
g downmprioanywar11 = .
* post 1950 period only
foreach num of numlist 2/3 {
	tab prioanywar11B if period`num'==1 & lprioanywar==.5, g(mprioanywar11p`num'_)
	qui sum mprioanywar11p`num'_3
	replace upmprioanywar11 = `r(mean)' in `num'
	qui sum mprioanywar11p`num'_1
	replace downmprioanywar11 = `r(mean)' in `num'
}


**************************************
*** tables/table 7: Assassinations and Conflict: Change 1 Year After Attempt
**************************************

g lnenergy = ln(energy)

local basiccontrols = "lnpop llnpop age lage lnenergy_pc llnenergy_pc lclock"


* Panel A
reg zGledAnywar11 success  `basiccontrols' `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
tab zGledAnywar11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
outreg2 using "tables/table_7a_control.tex", coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') replace title("tables/table 7a")

reg zGledAnywarP11 success `basiccontrols' `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
tab zGledAnywarP11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
outreg2 using "tables/table_7a_control.tex", coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') append 

reg prioanywarP11 success `basiccontrols' `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
tab prioanywarP11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
outreg2 using "tables/table_7a_control.tex", coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') append 

* Panel B
g l1anywar = l1.zGledAnywar
g l1nowar = (1-l1anywar)
g successl1anywar = success * l1anywar
g successl1nowar = success * l1nowar
label var l1anywar  "Lag any war"

reg zGledAnywar11 successl1anywar successl1nowar  l1anywar `basiccontrols' `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm successl1anywar 
local pvalparmA = r(p)
testparm successl1nowar  
local pvalparmN = r(p)
tab zGledAnywar11  success if l1anywar == 1 & seriousattempt == 1, exact chi2
local pvalnonparmA = r(p_exact)
tab zGledAnywar11  success if l1anywar == 0 & seriousattempt == 1, exact chi2
local pvalnonparmN = r(p_exact)
outreg2 using "tables/table_7b_control.tex", coefastr se adds("Intense war-Parm p",`pvalparmA',"Intense war-Nonparm p",`pvalnonparmA',"No war-Parm p",`pvalparmN',"No war-Nonparm p",`pvalnonparmN') replace


reg zGledAnywarP11 successl1anywar successl1nowar  l1anywar l1anywar `basiccontrols' `fixedeffectvars' if seriousattempt == 1 , cluster(cowcode)
testparm successl1anywar 
local pvalparmA = r(p)
testparm successl1nowar  
local pvalparmN = r(p)
tab zGledAnywarP11  success if l1anywar == 1 & seriousattempt == 1, exact chi2
local pvalnonparmA = r(p_exact)
tab zGledAnywarP11  success if l1anywar == 0 & seriousattempt == 1, exact chi2
local pvalnonparmN = r(p_exact)
outreg2 using "tables/table_7b_control.tex", coefastr se adds("Intense war-Parm p",`pvalparmA',"Intense war-Nonparm p",`pvalnonparmA',"No war-Parm p",`pvalparmN',"No war-Nonparm p",`pvalnonparmN') append


drop successl1anywar successl1nowar l1anywar l1nowar
g l1fullwar = (l1.prioanywarP == 1) if l1.prioanywarP != .
g l1somewar = (l1.prioanywarP == .5) if l1.prioanywarP != .
g l1nowar = (l1.prioanywarP == 0) if l1.prioanywarP != .
g successl1fullwar = success * l1fullwar
g successl1somewar = success * l1somewar
g successl1nowar = success * l1nowar
label var l1fullwar  "Lag intense war"
label var l1somewar  "Lag moderate war"


reg prioanywarP11 successl1fullwar successl1somewar  successl1nowar l1fullwar l1somewar `basiccontrols' `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm successl1fullwar 
local pvalparmA = r(p)
testparm successl1somewar 
local pvalparmS = r(p)
testparm successl1nowar  
local pvalparmN = r(p)

tab prioanywarP11 success if l1fullwar == 1 & seriousattempt == 1, exact chi2
local pvalnonparmA = r(p_exact)
tab prioanywarP11 success if l1somewar == 1 & seriousattempt == 1, exact chi2
local pvalnonparmS = r(p_exact)
tab prioanywarP11 success if l1nowar == 1 & seriousattempt == 1, exact chi2
local pvalnonparmN = r(p_exact)
outreg2 using "tables/table_7b_control.tex", coefastr se adds("Intense war-Parm p",`pvalparmA',"Intense war-Nonparm p",`pvalnonparmA',"Moderate war-Parm p",`pvalparmS',"Moderate war-Nonparm p",`pvalnonparmS',"No war-Parm p",`pvalparmN',"No war-Nonparm p",`pvalnonparmN') append 

