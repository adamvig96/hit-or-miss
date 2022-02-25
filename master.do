
cd "/Users/adamvig/Dropbox/CEU/5. trimester/PolEcon/hit-or-miss"

capture mkdir "tables"

do "programs/create_country_year_data.do"
do "programs/table4.do"
do "programs/table7.do"
do "programs/table7_basic_controls.do"
do "programs/table7_basic_regional_controls.do"
