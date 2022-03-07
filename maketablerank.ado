

****************************
* Make table program that displays results
****************************

program define maketablerank

	local maxrows = 500
	
	syntax using/, rhs(string) varcol(string) [rankpval(real 99)] [replace] [append] [noastr] [pval]
	
	/*inputs:
	 1 = dep variable name
	 2 = indep variable name
	 3 = variable number (this is the nth variable in the table)*/ 
	
	local lhs = e(depvar)
	local newb = _b[`rhs']
	local newse = _se[`rhs']
	qui test `rhs' = 0
	local newp = r(p)
	
	if "`replace'" != "replace" & "`append'" != "append" {
		display "Must specify either replace or append"
		exit	
	}
	
	/*initialize dataset*/
	preserve
	clear
	if "`replace'" == "replace" {
		qui set obs `maxrows'
		qui g col0 = ""
		qui g col1 = "`varcol'" in 1
		local whichcol = "col1"
	}
	else {
		capture insheet using `using'.out, names
		if _rc != 0 {
			display "File not found"
			exit
		}
		local whichcol = ""
		local howmanycols = 0
		foreach X of var col* {
			qui count if `X' == "`varcol'"
			if r(N) > 0 {
				local whichcol = "`X'"	
			}
			local howmanycols = `howmanycols' + 1
		}
			
		if "`whichcol'" == "" {
			/*make a new column*/
			qui g col`howmanycols' = "`varcol'" in 1
			local whichcol = "col`howmanycols'"
			}					
			
	}
	
	/*find which row to use*/
	local lastrow = 0
	local brow = 0
	foreach X of num 1/`maxrows' {
		qui count if col0 == "`lhs'" in `X'
		if r(N) == 1 & `brow' == 0 {
			local brow = `X'	
		}
		qui count if col0 != "" in `X'
		if r(N) == 1 {
			local lastrow = `X'	
		}	
	}
	if `brow' == 0 {
		local brow = `lastrow' + 2
		if "`pval'" == "pval" {
			local brow = `brow' + 1
		}
		
		if `rankpval' != 99 {
			local brow = `brow' + 1
		}
		
	}
	
	local browse = `brow' + 1
	qui replace col0 = "`lhs'" in `brow'
	qui replace `whichcol' = string(`newb',"%4.3f") in `brow'
	qui replace `whichcol' = "(" + string(`newse',"%4.3f") + ")" in `browse'
	
	if "`noastr'" != "noastr" {
			qui replace `whichcol' = `whichcol' + "*" in `brow' if `newp' <= 0.10
			qui replace `whichcol' = `whichcol' + "*" in `brow' if `newp' <= 0.05
			qui replace `whichcol' = `whichcol' + "*" in `brow' if `newp' <= 0.01
	}
	
	local browpval = `browse' 
	if "`pval'" == "pval" {
			local browpval = `browse' + 1
			qui replace `whichcol' = string(`newp',"%3.2f") in `browpval'
		
	}
	if `rankpval' != 99 {
			local browpval = `browpval' + 1
			qui replace `whichcol' = string(`rankpval',"%3.2f")  in `browpval'
		
	}
	
	outsheet using `using'.out, replace
	restore

end
