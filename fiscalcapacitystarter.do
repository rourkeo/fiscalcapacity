
***pull master datafile
use "/Users/rourkeobrien/Google Drive/__Current Projects/____Federalism and Fiscal Capacity/Data/Fiscal Inequality Master Data.dta"


***drop data from before 77
drop if year<1977

***create cpi INFLATION ADJUSTMENT using 2015 real dollars *add numbers from https://www.bls.gov/data/inflation_calculator.htm
cpigen
replace cpi=1.35 if year==2013
replace cpi=1.38 if year==2014
replace cpi=1.38 if year==2015



********State Fiscal Capacity Measures
***1. Total taxable resources
**multiply by 1 billion to get total number, then adjust for inflation to 2015
gen ttr_real15=((totaltaxableresources_inbn*1000000000)/cpi)*1.38
gen ttr_real15_percap=ttr_real15/w_population

***2. Gross State Product
**multiply by 1 million to get total number (from correlates of state policy dataset), then adjust for inflation to 2015
gen gsp_real15=((gsptotal*1000000)/cpi)*1.38
gen gsp_real15_percap=gsptotal_real15/w_population

***3. Personal income
**multiply by 1,000 to get total number (from correlates of state policy dataset), then adjust for inflation to 2015
gen personalincome_real15=((personal_income1000s_annual*1000)/cpi)*1.38
gen personalincome_real15_percap=personalincome_real15/w_population




***********************
********MEASURES OF STATE FISCAL EFFORT
***1. total state + Local own revenues as % of TTR 

gen stloc_totalrevownsources_real15=((stloc_r02totalrevownsources*1000)/cpi)*1.38
gen stloc_totrevownsources_r15_pcap=stloc_totalrevownsources_real15/w_population

gen stlocrevownsources_byttr_real15=stloc_totalrevownsources_real15/ttr_real15


***2. total state + local own revenues as % of GSP
gen stlocrevownsources_bygsp_real15=stloc_totalrevownsources_real15/gsptotal_real15




***Federal intergovernemntal revenue to state measures
***FEDERAL INTERGOVERNMENTAL REVENUE (NOTE: only revenue TO STATES; does not include fed $$ to localities (mostly housing and infrastructure)
gen total_fed_ig_revenue_real15=((w_total_fed_ig_revenue*1000)/cpi)*1.38
gen total_fed_ig_rev_real15_percap=total_fed_ig_revenue_real15/w_population

gen fed_igrev_pubwelfare_real15=((w_fed_igr_public_welf*1000)/cpi)*1.38 
gen fed_igrev_pubwelfare_real15_pcap=fed_igrev_pubwelfare_real15/w_population





*****************************POLITICAL PARTY CONTROL
**party coding
***partisan control (note: ranney4_control is missing for nebraska, need to set to split party)
*recode NE
replace ranney4_control=.5 if state_fips==31

gen unifiedrepub=.
replace unifiedrepub=1 if ranney4_control==0
replace unifiedrepub=0 if ranney4_control==1|ranney4_control==.5


gen unifieddemocrat=.
replace unifieddemocrat=1 if ranney4_control==1
replace unifieddemocrat=0 if ranney4_control==0|ranney4_control==.5

gen splitparty=.
replace splitparty=1 if ranney4_control==.5 
replace splitparty=0 if ranney4_control==0|ranney4_control==1


**POLITICAL RECODE (CATEGORICAL VARIABLE WITH THREE LEVELS)
gen party =.
replace party = 0 if unifiedrepub == 1
replace party = 1 if splitparty == 1
replace party = 2 if unifieddemocrat == 1
