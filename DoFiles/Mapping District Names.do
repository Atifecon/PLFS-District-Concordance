/*------------------------------------------------------------------------------------------

This do file performs the following tasks 


1.


------------------------------------------------------------------------------------------*/
	* Setting Project Directory 

if "`c(username)'" == "atifg" global root "C:\Users\atifg\Dropbox\Atif_shared_folder"

if "`c(username)'" == "atifa" global root "D:\Dropbox\Atif_shared_folder"

if "`c(username)'" == "Soham" global root ""

if "`c(username)'" == "Soham Sahoo" global root ""

    * Folder where the PLFS data set is stored
    global plfs_data "$root\PLFS\ProcessedData"

    * Folder for District Name List
    global dist_list "$root\PLFS\District Matching\District Names List"
	
	 * Folder for District Name Concordance Do files
    global dist_do "$root\PLFS\ProcessedData\District Matching\Do files"


	* Folder where the PhonePe Data set is stored
    global phone_pe "$root\Digitalisation\Phonepay Pulse\final_data"

	
*------------------------------------------------------------------------------------------*

* PHONEPAY AND PLFS 2017 MAPPING
use "$phone_pe\phone_pay_data",clear

unique StateName DistrictName

duplicates drop StateName DistrictName,force

count
drop district year quarter state registeredusers count amount transaction_user_merge
merge 1:1 StateName DistrictName using "$dist_list/district_codes_plfs17"

drop dist_id dist_id_PLFS
export excel using "$dist_list\PhonePe_PLFS17.xlsx", firstrow(variables) replace
* 261 Unmatched








*------------------------------------------------------------------------------------------*

* HCES AND TUS MAPPING
* Importing and Merging HCES with TUS, Exporting the Merged file as xlsx to map the unmacthed and saved it as HCES_TUS_Clean.xlsx

* IMPORT TUS 
import excel "$dist_list/State_District_List_TUS.xlsx", sheet("Clean") firstrow clear 

replace StateName = proper(StateName)

foreach var of varlist * {
	gen `var'_TUS =`var'
}

tostring StateCode DistrictCode, replace

replace StateCode = "0" + StateCode if length( StateCode ) == 1

replace DistrictCode = substr("0" + string(real( DistrictCode ), "%02.0f"), -2, 2)

save "$dist_list\TUS_dist_list", replace

* IMPORT HCES
import excel "$dist_list/State_District_List_HCES_2022.xlsx", sheet("Clean") firstrow allstring clear

drop E

foreach var of varlist * {
	gen `var'_HCES = `var'
}

replace StateCode = "0" + StateCode if length(StateCode)==1

replace DistrictCode = substr("0" + string(real( DistrictCode ), "%02.0f"), -2, 2)


save "$dist_list/HCES_dist_list",replace

merge m:1 StateName DistrictName using "$dist_list/TUS_dist_list.dta", force

export excel using "$dist_list\HCES_TUS.xlsx", firstrow(variables) replace
* 58 Unmatched

*------------------------------------------------------------------------------------------*

use "$dist_list/HCES_dist_list", clear
replace StateCode="01"	if 	StateName ==	"Ladakh"						
replace StateCode=	"26"	if 	StateName ==	"Dadra & Nagar Haveli and Daman and Diu"	& 	DistrictName ==	"Dadra  & Nagar Haveli"
replace StateName =	"Daman & Diu"	if 	DistrictName ==	"Diu"	|	DistrictName ==	"Daman"			
replace StateName =	"D & N Haveli"	if 	DistrictName ==	"Dadra  & Nagar Haveli"						
replace StateName =	"A & N Islands"	if 	DistrictName ==	"Nicobars"	|	DistrictName ==	"North & Middle Andaman"	|	DistrictName ==	"South Andaman"
replace StateName =	"Jammu & Kashmir"	if 	DistrictName ==	"Leh"	|	DistrictName ==	"Kargil"			
																				
replace DistrictName =	"Bathinda"	if 	DistrictName_HCES ==	"Bhatinda"	& 	StateName_HCES ==	"Punjab"	
replace DistrictName =	"North West Delhi"	if 	DistrictName_HCES ==	"North West"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"North Delhi"	if 	DistrictName_HCES ==	"North"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"North East Delhi"	if 	DistrictName_HCES ==	"North East"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"East Delhi"	if 	DistrictName_HCES ==	"East"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"Central Delhi"	if 	DistrictName_HCES ==	"Central"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"West Delhi"	if 	DistrictName_HCES ==	"West"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"South West Delhi"	if 	DistrictName_HCES ==	"South West"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"South Delhi"	if 	DistrictName_HCES ==	"South"	& 	StateName_HCES ==	"Delhi"	
replace DistrictName =	"Mahrajganj"	if 	DistrictName_HCES ==	"Maharajganj"	& 	StateName_HCES ==	"Uttar Pradesh"	
replace DistrictName =	"Sant Ravidas Nagar (Bhadohi)"	if 	DistrictName_HCES ==	"Sant Ravidas Nagar(Bhadohi)"	& 	StateName_HCES ==	"Uttar Pradesh"	
replace DistrictName =	"Aizawl"	if 	DistrictName_HCES ==	"Aizwal"	& 	StateName_HCES ==	"Mizoram"	
replace DistrictName =	"North Tripura"	if 	DistrictName_HCES ==	"Unakoti"	& 	StateName_HCES ==	"Tripura"	
replace DistrictName =	"West Tripura"	if 	DistrictName_HCES ==	"Khowai"	& 	StateName_HCES ==	"Tripura"	
replace DistrictName =	"West Tripura"	if 	DistrictName_HCES ==	"Sepahijala"	& 	StateName_HCES ==	"Tripura"	
replace DistrictName =	"South Tripura"	if 	DistrictName_HCES ==	"Gomati"	& 	StateName_HCES ==	"Tripura"	
replace DistrictName =	"Nagaon"	if 	DistrictName_HCES ==	"Hojai"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Karbi Anglong"	if 	DistrictName_HCES ==	"West karbi Anglong"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Sivasagar"	if 	DistrictName_HCES ==	"Charaideo"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Dhubri"	if 	DistrictName_HCES ==	"South Salmara Mankachar"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Sonitpur"	if 	DistrictName_HCES ==	"Biswanath"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Jorhat"	if 	DistrictName_HCES ==	"Majuli"	& 	StateName_HCES ==	"Assam"	
replace DistrictName =	"Ahmedabad"	if 	DistrictName_HCES ==	"Ahmadabad"	& 	StateName_HCES ==	"Gujarat"	
replace DistrictName =	"DevBhumi-Dwarka"	if 	DistrictName_HCES ==	"Dev Bhumi-Dwarka"	& 	StateName_HCES ==	"Gujarat"	
replace DistrictName =	"Bangalore (Rural)"	if 	DistrictName_HCES ==	"Bangalore Rural"	& 	StateName_HCES ==	"Karnataka"	
replace DistrictName =	"Jayashankar"	if 	DistrictName_HCES ==	"Mulugu"	& 	StateName_HCES ==	"Telangana"	
replace DistrictName =	"Mahbubnagar"	if 	DistrictName_HCES ==	"Narayanpet"	& 	StateName_HCES ==	"Telangana"	
replace DistrictName =	"Dadra & Nagar Haveli"	if 	DistrictName_HCES ==	"Dadra  & Nagar Haveli"	& 	StateName_HCES ==	"Dadra & Nagar Haveli and Daman and Diu"	

merge m:1 StateName DistrictName using "$dist_list/TUS_dist_list.dta", force

drop _merge // all matched
save "$dist_list/HCES_TUS_clean.dta", replace


replace StateName =	"A & N Island"	if 	StateName==	"A & N Islands"
replace StateName =	"Uttrakhand"	if 	StateName==	"Uttarakhand"

*------------------------------------------------------------------------------------------*


use "$dist_list/district_codes_plfs17", clear

foreach var of varlist * {
	gen `var'_PLFS = `var'
}

merge 1:1 StateName DistrictName using "$dist_list/TUS_dist_list.dta",force

sort StateName DistrictName

export excel using "$dist_list\PLFS_TUS.xlsx", firstrow(variables) replace



	* GETTING DISTRICT CODES FROM NSS 2017, TUS 2019 and HCES 2022
 
 * NSS, 2017-2018 (651 unique dist codes)
import excel "$root\2017-2018\Documents\Data_LayoutPLFS_1718.xlsx", sheet("NSS-Region") firstrow clear



*egen dist_id = concat(StateCode DistrictCode)
*lab var dist_id "District ID - Generated"

tempfile plfs_17_dist
 save `plfs_17_dist'

import excel "$root\2017-2018\Documents\Data_LayoutPLFS_1718.xlsx", sheet("State code") firstrow clear

drop if StateCode==""

merge 1:m StateCode using `plfs_17_dist'

drop _merge NSSRegioncode NSSRegionName

sort StateCode DistrictCode 

foreach var of varlist * {
	gen `var'_PLFS = `var'
}

use "$dist_list/HCES_TUS_clean.dta",clear

merge 1:m StateName DistrictName using  "$dist_list/district_codes_plfs17"

merge 1:m StateName DistrictName using "$dist_list/HCES_TUS_clean.dta"

export excel using "$dist_list\HCES_TUS_PLFS.xlsx", firstrow(variables) replace
* 58 Unmatched

save "$root/2017-2018/district_codes_plfs17", replace

*-----------------------------------------------------------------------------*

* Time Use Survey , 2019-20 (683 unique dist codes)
import excel "$root\District Matching\District Names List\State_District_List_TUS.xlsx", sheet("Clean") firstrow clear 

tostring StateCode DistrictCode, replace

replace StateCode = "0" + StateCode if length( StateCode ) == 1


use "$root/2018-2019/ExtractedData/FHH_FV.dta", clear

append using "$root/2018-2019/ExtractedData/FHH_RV.dta"

egen dist_id = concat( state_ut_code district_code)
lab var dist_id "District ID - Generated"
distinct dist_id

merge m:1 dist_id using "$root/2017-2018/IntermediateData/district_codes_plfs_17"

* 2 unmacthed from the PLFS district_codes

use "$root/2019-2020/ExtractedData/FHH_FV.dta", clear

append using "$root/2019-2020/ExtractedData/FHH_RV.dta"


* 2020-21
use "$root/2020-2021/ExtractedData/FHH_FV.dta", clear

append using "$root/2020-2021/ExtractedData/FHH_RV.dta"

egen dist_id = concat( state_ut_code district_code)
lab var dist_id "District ID - Generated"
distinct dist_id

* 2021-22
use "$root/2021-2022/ExtractedData/FHH_FV.dta", clear

append using "$root/2021-2022/ExtractedData/FHH_RV.dta"

egen dist_id = concat( state_ut_code district_code)
lab var dist_id "District ID - Generated"
distinct dist_id

/*
* Mapping States 
* J&K Ladakh - 2 Districts 

*Kargil - Lower frequency in all rounds
*Leh (Ladakh)

gen StateCode =""
lab var StateCode "State Code Clean"
replace StateCode ="01" if state_ut_code=="37" 

* Leh (Ladakh)
replace dist_id ="0103" if state_ut_code=="37" & district_code=="01"

replace dist_id ="0104" if state_ut_code=="37" & district_code=="02"

* Also check for literacy rates (general_education_level) etc match with earlier rounds

	
	forvalues i = 2017/2022 {
	local i2 = `i'+1		
		use "$root//`i'-`i2'//IntermediateData/`i'_merged.dta", clear
		tab year
		destring earnings_regular_salary_wage_act, replace
		
		if `i' < 2021 {
		su earnings_regular_salary_wage_act if state=="01" & district_code=="03"
		su earnings_regular_salary_wage_act if state=="01" & district_code=="04"
		}
		else {
			su earnings_regular_salary_wage_act if state=="37" & district_code=="01"
		su earnings_regular_salary_wage_act if state=="37" & district_code=="02"
		}
		
	}


	forvalues i = 2017/2022 {
	local i2 = `i'+1		
		use "$root//`i'-`i2'//IntermediateData/`i'_merged.dta", clear
		tab year
		
		foreach var in general_education_level earnings_regular_salary_wage_act {
		destring `var', replace
		
		if `i' < 2021 {
		su `var' if state=="01" & district_code=="03"
		su `var' if state=="01" & district_code=="04"
		}
		else {
			su `var' if state=="37" & district_code=="01"
		su `var' if state=="37" & district_code=="02"
		}
		
	}
	}

	
* Daman and Diu State=25 and Dadra and Nagar Haveli State=26 

* Dadra and Nagar Haveli separated from Daman and Diu

replace StateCode ="26" if state_ut_code=="25" & district_code=="03"

* Dadra and Nagar Haveli 
replace dist_id="2601" if state_ut_code=="25" & district_code=="03"


	forvalues i = 2017/2022 {
	local i2 = `i'+1		
		use "$root//`i'-`i2'//IntermediateData/`i'_merged.dta", clear
		tab year
		
		foreach var in general_education_level earnings_regular_salary_wage_act {
		destring `var', replace
		
		if `i' < 2021 {
		su `var' if state=="25" & district_code=="01"
		su `var' if state=="25" & district_code=="02"
		su `var' if state=="26" & district_code=="01"
		}
		else {
			su `var' if state=="25" & district_code=="01"
		}
	}
	}	
*/

*-----------------------------------------------------------------------------*
* Annual Survey of Unincorporated Sector Enterprises (ASUSE) , 2023-24 (753 unique dist codes)

import excel "$dist_list\State_District_List_ASUSE_23_24.xlsx", sheet("Clean") firstrow allstring clear 

replace StateCode = "0" + StateCode if length( StateCode ) == 1

replace DistrictCode = "0" + DistrictCode if length( DistrictCode ) == 1

foreach var of varlist * {
	drop if `var' ==""
	gen `var'_ASUSE = `var'
}

* Elluru and Tirupathi from Andhra Pradesh; Sambhal and Amethi from Uttar Pradesh are repeated twice in the ASUSE list

duplicates drop StateCode StateName DistrictName DistrictCode,force

save "$dist_list\ASUSE_23_24_dist_list", replace

merge m:1 StateName DistrictName using "$dist_list/HCES_22_dist_list.dta", force
* 58 unmacthed





export excel using "$dist_list\ASUSE_HCES.xlsx", firstrow(variables) replace
