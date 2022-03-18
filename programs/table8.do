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
local numvar = 1

g str40 varname = ""
g outinfo1 = .
g outinfo2 = .
g outinfo3 = .
g outinfo4 = .
local numvar = 1

preserve
		
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

**************************************
*** Table 8: Alternative specifications
*** Note: this table is transposed from the version in the text
**************************************

* Column 1: absnpolity2dummy11 
reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
tab absnpolity2dummy11 success if seriousattempt == 1, exact chi2
estadd scalar pvalnonparm1 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm1) replace nocons fragment

 
reg absnpolity2dummy11 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
tab absnpolity2dummy11 success if woundedbystander == 1, exact chi2
estadd scalar pvalnonparm2 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm2) append nocons fragment


reg absnpolity2dummy11 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
tab absnpolity2dummy11 success if wounded == 1, exact chi2
estadd scalar pvalnonparm3 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm3) append nocons fragment
 

reg absnpolity2dummy11 success `fixedeffectvars' if attempt == 1  , cluster(cowcode) 
tab absnpolity2dummy11 success if attempt == 1, exact chi2
estadd scalar pvalnonparm4 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm4) append nocons fragment
 

reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
tab absnpolity2dummy11 success if seriousattempt == 1 & solo == 1, exact chi2
estadd scalar pvalnonparm5 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm5) append nocons fragment
 

reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
tab absnpolity2dummy11 success if seriousattempt == 1 & firstattempt == 1, exact chi2
estadd scalar pvalnonparm6 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm6) append nocons fragment
 

reg absnpolity2dummy11 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm 
tab absnpolity2dummy11 success if seriousattempt == 1, exact chi2
estadd scalar pvalnonparm7 = r(p_exact)
esttab using "tables/table_8.tex", keep(success) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm7) append nocons fragment


* Column 2: npolity2dummy11 
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
tab npolity2dummy11 success if seriousattempt == 1, exact chi2
estadd scalar  pvalnonparm8 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm8) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
tab npolity2dummy11 success if woundedbystander == 1, exact chi2
estadd scalar  pvalnonparm9 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm9) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
tab npolity2dummy11 success if wounded == 1, exact chi2
estadd scalar  pvalnonparm10 = r(p_exact)
esttab using "tables/table_8.tex",cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm10) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' if attempt == 1  , cluster(cowcode)
tab npolity2dummy11 success if attempt == 1, exact chi2
estadd scalar  pvalnonparm11 = r(p_exact)
esttab using "tables/table_8.tex",cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm11) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
tab npolity2dummy11 success if seriousattempt == 1 & solo == 1, exact chi2
estadd scalar  pvalnonparm12 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm12) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
tab npolity2dummy11 success if seriousattempt == 1 & firstattempt == 1, exact chi2
estadd scalar  pvalnonparm13 = r(p_exact)
esttab using "tables/table_8.tex",cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm13) append nocons fragment

reg npolity2dummy11 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
tab npolity2dummy11 success if seriousattempt == 1, exact chi2
estadd scalar  pvalnonparm14 = r(p_exact)
esttab using "tables/table_8.tex",keep(success) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm14) append nocons fragment

* Column 3: npolity2dummy11  for autocrats
g npolity2dummy11A = npolity2dummy11  
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1   , cluster(cowcode)
tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1, exact chi2
estadd scalar  pvalnonparm15 = r(p_exact)
esttab using "tables/table_8.tex",cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm15) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
tab npolity2dummy11A success if woundedbystander == 1 & lautoc == 1 , exact chi2
estadd scalar  pvalnonparm16 = r(p_exact)
esttab using "tables/table_8.tex",cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm16) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
tab npolity2dummy11A success if wounded == 1 & lautoc == 1 , exact chi2
estadd scalar  pvalnonparm17 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm17) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if attempt == 1 , cluster(cowcode)
tab npolity2dummy11A success if attempt == 1 & lautoc == 1 , exact chi2
estadd scalar  pvalnonparm18 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm18) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1 & solo == 1, exact chi2
estadd scalar  pvalnonparm19 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm19) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  & firstattempt == 1, cluster(cowcode)
tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1 & firstattempt == 1, exact chi2
estadd scalar  pvalnonparm20 = r(p_exact)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm20) append nocons fragment

reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1, exact chi2
estadd scalar  pvalnonparm21 = r(p_exact)
esttab using "tables/table_8.tex",keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm21) append nocons fragment


* Column 4: perexitregularNC201
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
ranksum perexitregularNC201 if seriousattempt == 1, by(success)
estadd scalar  pvalnonparm22 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm22) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
ranksum perexitregularNC201  if woundedbystander == 1, by(success)
estadd scalar  pvalnonparm23 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm23) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
ranksum perexitregularNC201  if wounded == 1, by(success)
estadd scalar  pvalnonparm24 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm24) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' if attempt == 1  , cluster(cowcode)
ranksum perexitregularNC201  if attempt == 1, by(success)
estadd scalar  pvalnonparm25 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm25) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
ranksum perexitregularNC201  if seriousattempt == 1 & solo == 1, by(success)
estadd scalar pvalnonparm26 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm26) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
ranksum perexitregularNC201  if seriousattempt == 1 & firstattempt == 1, by(success)
estadd scalar  pvalnonparm27 = r(p)
esttab using "tables/table_8.tex", cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm27) append nocons fragment

reg perexitregularNC201 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
ranksum perexitregularNC201  if seriousattempt == 1, by(success)
estadd scalar  pvalnonparm28 = r(p)
esttab using "tables/table_8.tex", keep(success) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm28) append nocons fragment

* Column 5: perexitregularNC201 autocrats
g perexitregularNC201A = perexitregularNC201 

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1   , cluster(cowcode)
ranksum perexitregularNC201A if seriousattempt == 1 & lautoc == 1, by(success)
estadd scalar  pvalnonparm29 = r(p)
esttab using "tables/table_8.tex",keep(successlautoc)  cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm29) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
ranksum perexitregularNC201A if woundedbystander == 1 & lautoc == 1 , by(success)
estadd scalar  pvalnonparm30 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm30) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
ranksum perexitregularNC201A if wounded == 1 & lautoc == 1 , by(success)
estadd scalar  pvalnonparm31 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm31) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if attempt == 1 , cluster(cowcode)
ranksum perexitregularNC201A if attempt == 1 & lautoc == 1 , by(success)
estadd scalar  pvalnonparm32 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm32) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
ranksum perexitregularNC201A if seriousattempt == 1 & lautoc == 1 & solo == 1, by(success)
estadd scalar  pvalnonparm33 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm33) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  & firstattempt == 1, cluster(cowcode)
ranksum perexitregularNC201A if seriousattempt == 1 & lautoc == 1 & firstattempt == 1, by(success)
estadd scalar  pvalnonparm34 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm34) append nocons fragment

reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
ranksum perexitregularNC201A if seriousattempt == 1 & lautoc == 1, by(success)
estadd scalar  pvalnonparm35 = r(p)
esttab using "tables/table_8.tex", keep(successlautoc) cells(b(fmt(2)) se(fmt(2)) p(fmt(2) par)) stats(pvalnonparm35) append nocons fragment


*END
