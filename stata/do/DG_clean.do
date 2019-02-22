
cd "C:\Users\perez_g\Desktop\PA Dollar"
import delimited "C:\Users\perez_g\Desktop\PA Dollar\dollar_general_locations.csv", varnames(1) clear
drop ïdistance
duplicates drop

// check unique
split name, p("#")
replace name2 = strtrim(name2)
duplicates tag name2, gen(dups)
// keep PA only
gen flag_pa = 1 if strpos(state, "PA")
keep if flag_pa ==1
keep name address1 city state_zip phone
replace state = strtrim(state)
split state, p(" ")
ren (state_zip1 state_zip2) (state zip)
drop state_
gen full_address = address1 +" "+ city + ", " + state +" "+ zip
export delimited using "C:\Users\perez_g\Desktop\PA Dollar\dollar_general_locations_clean.csv", replace
