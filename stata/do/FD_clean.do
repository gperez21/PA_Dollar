
cd "C:\Users\perez_g\Desktop\PA Dollar"
import delimited "C:\Users\perez_g\Desktop\PA Dollar\family_dollar_locations.csv", varnames(1) clear
tostring ïstore_number, replace
ren ïstore_number name
duplicates drop

ren v2 location
ren address address1


replace state = strtrim(state)
split state, p(" ")
ren (state_zip1 state_zip2) (state zip)
drop state_*
gen full_address = address1 +" "+ city + ", " + state +" "+ zip

export delimited using "C:\Users\perez_g\Desktop\PA Dollar\family_dollar_locations_clean.csv", replace
