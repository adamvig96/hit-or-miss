
**************************************
*** Table 4: Exogeniety tests 
**************************************

use data/country_year_data, clear

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
local numvar = 1

g str40 varname = ""
g outinfo1 = .
g outinfo2 = .
g outinfo3 = .
g outinfo4 = .
local numvar = 1
		
capture drop ltenure
capture drop lage

tsset
g ltenure = l.clock
g lage = l.age

label var lpol2dum "Democracy dummy (L1)"
label var pol2duml1l3 "Change in democracy dummy (L1 - L3)"
label var lzGledAnywar "Any war dummy (L1)"
label var anywarl1l3 "Change in any war dummy (L1 - L3)"
label var llnenergy_pc "Log energy user per capita (L1)"
label var llnpop "Log population (L1)"
label var lage "Age of leader (L1)"
label var lclock "Tenure of leader (L1)"


* move the dataset to the format where each observation is an attempt, rather than a country-year
bys cowcode year: assert _n == 1
expand num_seriousevents

* make sure we only have 1 success per year
bys cowcode year: replace success = 0 if _n > 1

foreach X of var lpol2dum pol2duml1l3 numexitanylast5 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock {
	
	local numstd = `numvar' + 1
	replace varname = "`X'" in `numvar'
	
	qui summ `X' if success == 1 & seriousattempt == 1
	replace outinfo1 = r(mean) in `numvar'
	replace outinfo1 = -1 * r(sd) / (r(N) ^ .5) in `numstd'
	
	qui summ `X' if success == 0 & seriousattempt == 1
	replace outinfo2 = r(mean) in `numvar'
	replace outinfo2 = -1 * r(sd) / (r(N) ^ .5) in `numstd'
	
	ttest `X' if seriousattempt == 1, by(success) unequal
	replace outinfo3 = outinfo1 - outinfo2 in `numvar'
	replace outinfo3 = -1 * r(se) in `numstd'
	
	replace outinfo4 = r(p) in `numvar'
	
	local numvar = `numvar' + 2
	}

qui count if success == 1 & seriousattempt == 1
replace outinfo1 = r(N) in `numvar'
qui count if success == 0 & seriousattempt == 1
replace outinfo2 = r(N) in `numvar'


outsheet varname outinfo* using tables/table_4a.txt in 1/`numvar', replace

* Parallel to below
dprobit success lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock if seriousattempt == 1, cluster(cowcode)
testparm lpol2dum pol2duml1l3 numexitanylast5 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock 
local pval = r(p)
testparm *
outreg2 using tables/table_4b, coefastr se replace title("table 3 regs") bd(3) adds("P-val",`pval',"P-val of regression",r(p))

dprobit success lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock weapondum* if seriousattempt == 1, cluster(cowcode)
testparm lpol2dum pol2duml1l3 numexitanylast5 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock 
local pval = r(p)
testparm *
outreg2 using tables/table_4b, coefastr se append bd(3) adds("P-val",`pval',"P-val of regression",r(p))


dprobit success lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur   if seriousattempt == 1, cluster(cowcode)
testparm lpol2dum pol2duml1l3 numexitanylast5 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock 
local pval = r(p)
testparm *
outreg2 using tables/table_4b, coefastr se append bd(3) adds("P-val",`pval',"P-val of regression",r(p))

dprobit success lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur weapondum*    if seriousattempt == 1, cluster(cowcode)
testparm lpol2dum pol2duml1l3 numexitanylast5 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock 
local pval = r(p)
testparm *
outreg2 using tables/table_4b, coefastr se append bd(3) adds("P-val",`pval',"P-val of regression",r(p))
