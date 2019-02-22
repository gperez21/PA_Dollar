
cd "C:\Users\perez_g\Desktop\PA Dollar"
import delimited "C:\Users\perez_g\Desktop\PA Dollar\dollar_tree_locations.csv", varnames(1) clear
tostring store_number, replace
ren store_number name
replace name = "Dollar Tree #" + name
duplicates drop
ren store_name location
ren address address1


replace state = strtrim(state)
split state, p(" ")
ren (state_zip1 state_zip2) (state zip)
drop state_ 
gen full_address = address1 +" "+ city + ", " + state +" "+ zip

export delimited using "C:\Users\perez_g\Desktop\PA Dollar\dollar_tree_locations_clean.csv", replace
