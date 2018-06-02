*****Building Dataset for Fiscal Inequality Project*******


*************************Step 1: Merge State/Local + State Only + Local Only Rev and Spending Vars
*************note these are TOTAL values (in thousands) and adjusted to 2015 dollars

***state and local total
import delimited "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State and Local From TPC--Real 2015 Dollars.csv"
rename e036educationalassistancee19 e036educassistancee19
foreach x of var * { 
	rename `x' stloc_`x' 
} 
rename stloc_state state
rename stloc_year year
statastates, name(state)
drop _merge
drop if state_fips==.
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State and Local From TPC--Real 2015 Dollars.dta", replace

clear

***state only
import delimited "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State Only From TPC--Real 2015 Dollars.csv"
rename e036educationalassistancee19 e036educassistancee19
foreach x of var * { 
	rename `x' st_`x' 
} 
rename st_state state
rename st_year year
statastates, name(state)
drop if state_fips==.
drop _merge
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State Only From TPC--Real 2015 Dollars.dta", replace

clear

***local only

import delimited "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/Local Only From TPC--Real 2015 Dollars.csv"
rename e036educationalassistancee19 e036educassistancee19
foreach x of var * { 
	rename `x' loc_`x' 
} 
rename loc_state state
rename loc_year year
statastates, name(state)
drop if state_fips==.
drop _merge
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/Local Only From TPC--Real 2015 Dollars.dta", replace




*********step 2: ready other datasets for merge
use "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/cps_states_aggregate.dta"
statastates, fips(statefip)
gen state_fips=statefip
drop if state_fips==.
drop _merge
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/cps_states_aggregate1.dta", replace

clear

use "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/correlatesofstatepolicyprojectv1_14.dta"
statastates, name(state)
drop if state_fips==.
drop _merge
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/correlatesofstatepolicyprojectv1_141.dta", replace

clear

import delimited "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/WilliametteStateData.csv"
foreach x of var * { 
	rename `x' w_`x' 
} 
gen state_fips=w_fips_code_state
gen year=w_year4
drop if state_fips==.
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/williametteStateData.dta", replace

clear

use  "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/incomeshares.dta"
gen state_fips=statefip
drop if state_fips==.
save  "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/incomeshares1.dta", replace

clear

import delimited "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/total taxable resources.csv"
statastates, name(state)
drop _merge
save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/totaltaxableresources.dta", replace

***step 3: merge all together using state_fips year


use "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State and Local From TPC--Real 2015 Dollars.dta"
merge 1:1 state_fips year using "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/State Only From TPC--Real 2015 Dollars.dta"
rename _merge merge1
merge 1:1 state_fips year using "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/Local Only From TPC--Real 2015 Dollars.dta"
rename _merge merge2
merge 1:1 state_fips year using "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/cps_states_aggregate1.dta"
rename _merge merge3
merge 1:1 state_fips year using "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/correlatesofstatepolicyprojectv1_141.dta"
rename _merge merge4
merge 1:1 state_fips year using "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/williametteStateData.dta"
rename _merge merge5
merge 1:1 state_fips year using  "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/incomeshares1.dta"
rename _merge merge6
merge 1:1 state_fips year using  "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/totaltaxableresources.dta"
rename _merge merge7

save "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/Fiscal Inequality Master Data.dta", replace






