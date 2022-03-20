************
* Make tables for Hit or Miss?
* Final AEJ version
* August 20, 2008
************

version 9.2
clear
set mem 300m
set more off

local fixedeffectvars = "weapondum* numserdum* " 		


use "data/country_year_data.dta", clear

**************************************
*** Table 6: Tenure of Leader and Duration Effects
**************************************

* Column 1: All serious attempts
tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg1
maketablerank using "tables/table_6", rhs(success) varcol(All) replace 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg2
maketablerank using "tables/table_6", rhs(success) varcol(All) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg3
maketablerank using "tables/table_6", rhs(success) varcol(All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg4
maketablerank using "tables/table_6", rhs(success) varcol(All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg5
maketablerank using "tables/table_6", rhs(success) varcol(All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1  , cluster(cowcode)
*est store reg6
maketablerank using "tables/table_6", rhs(success) varcol(All) append pval noastr rankpval(`pvalnonparm')

*esttab reg1 reg2 reg3 reg4 reg5 reg6 using test.tex,keep(success) replace 


* Column 2: Tenure <= 10
tab npolity2dummy11 success if seriousattempt == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TL10) append pval noastr rankpval(`pvalnonparm')


* Column 3: Tenure > 10
tab npolity2dummy11 success if seriousattempt == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(TG10) append pval noastr rankpval(`pvalnonparm')


* Column 4: All serious attempts on autocrats

tab npolity2dummy11 success if seriousattempt == 1  & lautoc == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1 & lautoc == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1 & lautoc == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1 & lautoc == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1 & lautoc == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1 & lautoc == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-All) append pval noastr rankpval(`pvalnonparm')


* Column 5: Autocrat with tenure <= 10
tab npolity2dummy11 success if seriousattempt == 1 & lautoc == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1 & lautoc == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1 & lautoc == 1 & durgroup == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1 & lautoc == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1 & lautoc == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1 & lautoc == 1 & durgroup == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 1  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TL10) append pval noastr rankpval(`pvalnonparm')


* Column 6: Autocrats with tenure > 10
tab npolity2dummy11 success if seriousattempt == 1 & lautoc == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1 & lautoc == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1 & lautoc == 1 & durgroup == 2, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1 & lautoc == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1 & lautoc == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1 & lautoc == 1 & durgroup == 2, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' if seriousattempt == 1 & lautoc == 1 & durgroup == 2  , cluster(cowcode)
maketablerank using "tables/table_6", rhs(success) varcol(Autoc-TG10) append pval noastr rankpval(`pvalnonparm')


* Including tenure and Autocrat as variables in the Regression

tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) replace 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' durgroup lautoc if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(No Interaction) append pval noastr rankpval(`pvalnonparm')


gen inter_autoc_dur = durgroup*lautoc

tab npolity2dummy11 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy11 success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(With Interaction) append 	pval noastr rankpval(`pvalnonparm')

tab npolity2dummy101 success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy101  success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(With Interaction) append pval noastr rankpval(`pvalnonparm')

tab npolity2dummy201  success if seriousattempt == 1, exact chi2
local pvalnonparm = r(p_exact)
reg npolity2dummy201  success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(With Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC101 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC101 success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using table_6b, rhs(success) varcol(With Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC201 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC201 success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(With Interaction) append pval noastr rankpval(`pvalnonparm')

ranksumben perexitregularNC2010 if seriousattempt == 1, by(success)
local pvalnonparm = r(p)
reg perexitregularNC2010 success `fixedeffectvars' durgroup lautoc inter_autoc_dur if seriousattempt == 1  , cluster(cowcode)
maketablerank using "tables/table_6b", rhs(success) varcol(With Interaction) append pval noastr rankpval(`pvalnonparm')

