// This file spatially joins xy data to shapefiles

* set up
clear
set type double
cd "C:\Users\perez_g\Desktop\PA Dollar\stata\do"

gl root "C:\Users\perez_g\Desktop\PA Dollar"
gl GIS "$root/GIS"
gl Shapefiles "$GIS/shapefiles"
gl Stata "$root/Stata"
gl Data "$Stata/data"
gl Dollar_data "$root/DS excel"


import delimited "C:\Users\perez_g\Desktop\PA Dollar\family_dollar_locations_clean.csv", varnames(1) clear
tempfile FD
save `FD'

import delimited "C:\Users\perez_g\Desktop\PA Dollar\dollar_tree_locations_clean.csv", varnames(1) clear
tempfile DT
save `DT'

import delimited "C:\Users\perez_g\Desktop\PA Dollar\dollar_general_locations_clean.csv", varnames(1) clear
append using `FD'
append using `DT'

drop phone locatio

// geocode
opencagegeo, key(e4c5a22b9a9540e880b666c332b7351f) fulladdress(full_address)

// export clean file with geocode data
export delimited using "C:\Users\perez_g\Desktop\PA Dollar\DS excel\clean\DS_locations_clean.csv", replace

{
// get county info
capture shp2dta using "$Shapefiles/PA_Counties_clip.shp", genid(_ID) data("$Data\County_data.dta") coor("$Data\County_coor.dta") replace



*Import CSV with xy data
import delimited "$Dollar_data\clean\DS_locations_clean.csv", clear 


gen _X = g_lon
gen _Y = g_lat

save "$Data\DS_PA_store_info.dta", replace


* Spatial join using geoinpoly points to polygons
geoinpoly _Y _X using "$Data\County_coor.dta"


* merge the matched polygons with the database and get attributes
merge m:1 _ID using "$Data\County_data.dta", keep(master match) 
// Drop Canadian WF
keep if _m == 3
drop _m

save "$Data\DS_mapped_to_county.dta", replace


use "$Data\DS_mapped_to_county.dta", clear
* Find number of counties with a Whole Foods
gen Number_of_DS = 1 
collapse (sum) Number_of_DS, by(NAME NAMELSAD _ID)
export delimited "$Dollar_data\clean\DS_by_county.csv"
}


// Map
import excel "C:\Users\perez_g\Desktop\PA Dollar\DS excel\clean\DS_by_county.xlsx", sheet("DS_by_county") firstrow
ren GEO_ID _ID
* Make PA map
spmap Per_100k using "$Data\County_coor.dta", id(_ID) fcolor(Reds) ///
legend(symy(*2) symx(*2) size(*2) position (4)) 
