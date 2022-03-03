
cd "C:\Users\Vegh_Marton\Desktop\replication polecon"
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
tab absnpolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Baseline) replace 	pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if woundedbystander == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(WoundBystander) append 	pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if wounded == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(TargetWounded) append pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if attempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if attempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AnyAttempt) append 	pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if seriousattempt == 1 & solo == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Solo) append pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if seriousattempt == 1 & firstattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(FirstAttempt) append pval noastr rankpval(`pvalnonparm')

tab absnpolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg absnpolity2dummy11 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AddControls) append 	pval noastr rankpval(`pvalnonparm')


* Column 2: npolity2dummy11 
tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Baseline) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if woundedbystander == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(WoundBystander) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if wounded == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(TargetWounded) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if attempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if attempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AnyAttempt) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if seriousattempt == 1 & solo == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Solo) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if seriousattempt == 1 & firstattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(FirstAttempt) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AddControls) append 	pval noastr rankpval(`pvalnonparm')

* Column 3: npolity2dummy11  for autocrats
g npolity2dummy11A = npolity2dummy11  
tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1   , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(Baseline) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if woundedbystander == 1 & lautoc == 1 , exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(WoundBystander) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if wounded == 1 & lautoc == 1 , exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(TargetWounded) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if attempt == 1 & lautoc == 1 , exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if attempt == 1 , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(AnyAttempt) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1 & solo == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(Solo) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1 & firstattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  & firstattempt == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(FirstAttempt) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy11A success if seriousattempt == 1 & lautoc == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11A successlautoc successldemoc lautoc `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(AddControls) append 	pval noastr rankpval(`pvalnonparm')


* Column 4: perexitregularNC201
ranksumben perexitregularNC201 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Baseline) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if woundedbystander == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(WoundBystander) append 	pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if wounded == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(TargetWounded) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if attempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if attempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AnyAttempt) append 	pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if seriousattempt == 1 & solo == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(Solo) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if seriousattempt == 1 & firstattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & firstattempt == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(FirstAttempt) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201  if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(success) varcol(AddControls) append 	pval noastr rankpval(`pvalnonparm')

* Column 5: perexitregularNC201 autocrats
g perexitregularNC201A = perexitregularNC201 

ranksumben perexitregularNC201A if seriousattempt == 1 & lautoc == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1   , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(Baseline) append 	pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if woundedbystander == 1 & lautoc == 1 , by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if woundedbystander == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(WoundBystander) append 	pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if wounded == 1 & lautoc == 1 , by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if wounded ==  1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(TargetWounded) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if attempt == 1 & lautoc == 1 , by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if attempt == 1 , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(AnyAttempt) append 	pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if seriousattempt == 1 & lautoc == 1 & solo == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1 & solo == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(Solo) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if seriousattempt == 1 & lautoc == 1 & firstattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  & firstattempt == 1, cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(FirstAttempt) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201A if seriousattempt == 1 & lautoc == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201A successlautoc successldemoc lautoc `fixedeffectvars' qtrcentury* lpol2dum pol2duml1l3 lzGledAnywar anywarl1l3 llnenergy_pc llnpop lage lclock regdumAfrica regdumAsia regdumMENA regdumLatAm regdumEEur if seriousattempt == 1  , cluster(cowcode)
maketablerank using tables/table_8, rhs(successlautoc) varcol(AddControls) append 	pval noastr rankpval(`pvalnonparm')
