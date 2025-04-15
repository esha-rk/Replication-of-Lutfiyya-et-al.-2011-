set more off
capture log close
clear
log using finalproject2019.log, replace

/*----------------------------------
Replicate Lutfiyya et al. (2011) using 2019 BRFSS
-----------------------------------*/

**************************************
** Bring in BRFSS data            
**************************************
import sasxport5 LLCP2019.XPT

*************************************
** Apply survey weight
*************************************
svyset _psu [pweight=_llcpwt], strata(_ststr) singleunit(centered)

**************************************
** Clean and create key variables            
**************************************
*keep variables for population of interest
keep if _age65yr==2
tab diabete4, missing
keep if diabete4==1
*create binary variable for rural and non-rural
tab mscode, missing
drop if mscode==.
gen rural = mscode==4 | mscode==5
tab rural
*cleaning glucose test var
tab bldsugar, missing
drop if bldsugar==777 | bldsugar==999 | bldsugar==.
gen glucosetest = bldsugar
replace glucosetest = 1 if bldsugar<888
replace glucosetest = 0 if bldsugar==888
tab glucosetest, missing
*cleaning self foot check var
tab feetchk3, missing
drop if feetchk3==999 | feetchk3==777 | feetchk3==555 | feetchk3==.
gen footcheck = feetchk3
replace footcheck=1 if feetchk3<555
replace footcheck=0 if feetchk3==888
tab footcheck, missing
*creating and cleaning blood pressure var
gen controlledbp = .
tab _rfhype5, missing
drop if _rfhype5==9
tab bpmeds, missing
drop if bpmeds==9 | bpmeds==7 | bpmeds==.
replace controlledbp = 1 if [_rfhype5==2 & bpmeds==1] | _rfhype5==1
replace controlledbp = 0 if _rfhype5==2 & bpmeds==2
tab controlledbp, missing
*cleaning cholesterol check var
tab cholchk, missing
drop if cholchk==7 | cholchk==9 | cholchk==.
gen cholesterol=.
replace cholesterol = 1 if cholchk==2
replace cholesterol = 0 if cholchk>2 | cholchk==1
tab cholesterol, missing
*cleaning flu shot var
tab _flshot7, missing
keep if _flshot7==1 | _flshot7==2
gen flushot = .
replace flushot = 1 if _flshot7==1
replace flushot = 0 if _flshot7>1
tab flushot, missing
*cleaning pneumonia vax var
tab pneuvac4, missing
drop if pneuvac4==7 | pneuvac4==9 | pneuvac4==.
gen pneumonia=.
replace pneumonia = 1 if pneuvac4==1
replace pneumonia = 0 if pneuvac4==2
tab pneumonia, missing
*cleaning diabetes checks var
tab doctdiab, missing
drop if doctdiab==77 | doctdiab==99 | doctdiab==.
gen diacheck = .
replace diacheck = 1 if doctdiab>=2
replace diacheck = 0 if doctdiab==88 | doctdiab==1
tab diacheck, missing
*cleaning a one c checks var 
tab chkhemo3, missing
drop if chkhemo3>=98
gen a1c = .
replace a1c = 1 if chkhemo3>=2
replace a1c = 0 if chkhemo3==88 | chkhemo3==1
tab a1c, missing
*cleaning feet check by healthcare prof var
tab feetchk, missing
drop if feetchk==77 | feetchk==99 | feetchk==.
gen footcheck_d = .
replace footcheck_d = 1 if feetchk>=2
replace footcheck_d = 0 if feetchk==88 | feetchk==1
tab footcheck_d, missing
*cleaning eye exam var
tab eyeexam1, missing
drop if eyeexam1==7 | eyeexam1==9| eyeexam1==.
gen eyecheck = .
replace eyecheck = 1 if eyeexam1==1 | eyeexam1==2
replace eyecheck = 0 if eyeexam1==3 | eyeexam1==4 | eyeexam1==8
tab eyecheck, missing
*cleaning diabetes education var
tab diabedu, missing
drop if diabedu==7 | diabedu==9 | diabedu==.
gen dia_eduction = .
replace dia_eduction = 1 if diabedu==1
replace dia_eduction = 0 if diabedu==2
tab dia_eduction, missing
*gen variable for optimal care
egen carescore = rowtotal(glucosetest footcheck controlledbp cholesterol flushot pneumonia a1c diacheck footcheck_d eyecheck dia_eduction)
gen adequatecare = .
replace adequatecare = 0 if carescore>8
replace adequatecare = 1 if carescore<=8
tab adequatecare, missing
*create race/ethnicity var
tab _imprace, missing
gen race_eth = .
replace race_eth = 0 if _imprace==1 //white
replace race_eth = 1 if _imprace==2 //black
replace race_eth = 2 if _imprace==5 // hispanic
replace race_eth = 3 if _imprace==3 | _imprace==4 | _imprace==6 //other or multi
tab race_eth, missing
*gen physical activity var
tab actin12_, missing
drop if actin12_==.
gen physact = .
replace physact = 0 if actin12_==1 | actin12_==2
replace physact = 1 if actin12_==0
tab physact, missing
*clean education var
tab educa, missing
drop if educa==9 | educa==.
gen education = .
replace education = 1 if educa==1 | educa==2 | educa==3
replace education = 2 if educa==4 | educa==5
replace education = 0 if educa==6
tab education, missing
*clean annual household income var
tab income2
drop if income2==77 | income2==99 | income2==.
gen income = .
replace income = 0 if income2>=6
replace income = 1 if income2<6
tab income, missing
*clean marital status var
tab marital, missing
drop if marital==9 | marital==.
gen marstatus = .
replace marstatus = 0 if marital==1 | marital==4
replace marstatus = 1 if marital==2 | marital==3 | marital==5 | marital==6
tab marstatus, missing
*clean self reported health status var
tab genhlth, missing
drop if genhlth==7 | genhlth==9 | genhlth==.
gen srh = .
replace srh = 1 if genhlth==4 | genhlth==5
replace srh = 0 if genhlth<=3
tab srh, missing
*clean health care professional var
tab persdoc2, missing
drop if persdoc2==7 | persdoc2==9 | persdoc2==.
gen provider = .
replace provider = 0 if persdoc2==1 | persdoc2==2
replace provider = 1 if persdoc2==3
tab provider, missing
*clean bmi var
tab _bmi5cat, missing
drop if _bmi5cat==9
gen bmi = .
replace bmi = 0 if _bmi5cat==1 |_bmi5cat==2
replace bmi = 1 if _bmi5cat==3
replace bmi = 2 if _bmi5cat==4
tab bmi, missing
*clean smoking var
tab _rfsmok3, missing
drop if _rfsmok3==9
gen smoker = .
replace smoker = 1 if _rfsmok3==2
replace smoker = 0 if _rfsmok3==1
tab smoker, missing
*clean routine checkup var
tab checkup1, missing
drop if checkup1==7 | checkup1==9 | checkup1==8
gen routine_checkup = .
replace routine_checkup = 0 if checkup1==1
replace routine_checkup = 1 if checkup>1
tab routine_checkup, missing
*clean insulin use var
tab insulin1, missing
drop if insulin1==9 | insulin1==. | insulin1==7
gen insulin_use = .
replace insulin_use = 1 if insulin1==1
replace insulin_use = 0 if insulin1==2
tab insulin_use, missing
*clean affect eyes var
tab diabeye, missing
drop if diabeye==7 | diabeye==9 | diabeye==.
gen affect_eyes = .
replace affect_eyes = 1 if diabeye==1
replace affect_eyes = 0 if diabeye==2
tab affect_eyes, missing
*clean sex var (only missing dropped)
tab sex, missing
*clean insurance var (only missing dropped)
tab hlthpln1, missing
drop if hlthpln1==7 | hlthpln1==9 | hlthpln1==.
*clean deferment var (only missing dropped)
tab medcost, missing
drop if medcost==7 | medcost==9 | medcost==.
*clean age of onset var
tab diabage3, missing
drop if diabage3==98 | diabage3==99 | diabage3==.
gen age_onset = .
replace age_onset = 0 if diabage3<45
replace age_onset = 1 if diabage3>=45 & diabage3<=64
replace age_onset = 2 if diabage3>=65
tab age_onset, missing
**************************************
** Recreate Table 1: demographic summary        
**************************************
foreach var in sex race_eth education marstatus income hlthpln1 medcost  provider routine_checkup srh {
	display "Proportion `var'"
	svy: proportion `var' if rural==0
	svy: proportion `var' if rural==1
}

**************************************
** Recreate Table 3: multivariate reg           
**************************************
svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthpln1 ib2.medcost provider routine_checkup

svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthpln1 ib2.medcost provider routine_checkup if rural==1

svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthpln1 ib2.medcost provider routine_checkup if rural==0

log close