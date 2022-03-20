
cd "/Users/adamvig/Dropbox/CEU/5. trimester/PolEcon/hit-or-miss"

* Set your project directory here
* cd "/your/project/path"

capture mkdir "tables"

do "programs/create_country_year_data.do"
do "programs/table4.do"
do "programs/table5.do"
do "programs/table5_basic_controls.do"
do "programs/table5_basic_regional_controls.do"
do "programs/table6.do"
do "programs/table7.do"
do "programs/table7_basic_controls.do"
do "programs/table7_basic_regional_controls.do"
do "programs/table8.do"
do "programs/eventstudy.do"
do "programs/matching.do"
