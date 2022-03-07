
use "data/country_year_data.dta", clear
local fixedeffectvars = "weapondum* numserdum* " 		


**************************************
*** Table 5: Assassinations and Institutional Change
**************************************

reg absnpolity2dummy11  success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
tab absnpolity2dummy11  success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
outreg2 using tables/table_5a, coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') replace title("Table 5")

reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
outreg2 using tables/table_5a, coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') append 

reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm success
local pvalparm = r(p)
ranksumben perexitregularNC201 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
outreg2 using tables/table_5a, coefastr se adds("Parm p",`pvalparm',"Nonparm p",`pvalnonparm') append 


reg npolity2dummy11   successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm successlautoc 
local pvalparmA = r(p)
testparm successldemoc
local pvalparmD = r(p)

tab npolity2dummy11  success if lautoc == 1 & seriousattempt == 1, exact chi2
local pvalnonparmA = r(p_exact)
tab npolity2dummy11  success if ldemoc == 1 & seriousattempt == 1, exact chi2
local pvalnonparmD = r(p_exact)
outreg2 using tables/table_5b, coefastr se adds("Autoc-Parm p",`pvalparmA',"Autoc-Nonparm p",`pvalnonparmA',"Democ-Parm p",`pvalparmD',"Democ-Nonparm p",`pvalnonparmD') replace title("Table 5b")


reg perexitregularNC201 successlautoc successldemoc lautoc `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
testparm successlautoc 
local pvalparmA = r(p)
testparm successldemoc
local pvalparmD = r(p)

ranksumben perexitregularNC201 if lautoc == 1 & seriousattempt == 1, by(successlautoc)
local pvalnonparmA = r(p)
ranksumben perexitregularNC201 if ldemoc == 1 & seriousattempt == 1, by(successldemoc)
local pvalnonparmD = r(p)
outreg2 using tables/table_5b,  coefastr se adds("Autoc-Parm p",`pvalparmA',"Autoc-Nonparm p",`pvalnonparmA',"Democ-Parm p",`pvalparmD',"Democ-Nonparm p",`pvalnonparmD') append 
