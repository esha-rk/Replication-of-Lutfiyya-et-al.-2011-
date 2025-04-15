set more off
capture log close
clear
log using finalproject2009.log, replace

/*----------------------------------
Replicate Lutfiyya et al. (2011)
-----------------------------------*/

**************************************
** Bring in BRFSS data            
**************************************
import sasxport5 CDBRFS09.XPT

*************************************
** Apply survey weight
*************************************
svyset _psu [pweight=_finalwt], strata(_ststr) singleunit(centered)

**************************************
** Clean and create key variables            
**************************************
*keep variables for population of interest
keep if age>=65
tab diabete2, missing
keep if diabete2==1
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
tab feetchk2, missing
drop if feetchk2==999 | feetchk2==777 | feetchk2==555 | feetchk2==.
gen footcheck = feetchk2
replace footcheck=1 if feetchk2<555
replace footcheck=0 if feetchk2==888
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
replace cholesterol = 1 if cholchk==1
replace cholesterol = 0 if cholchk>1
tab cholesterol, missing
*cleaning flu shot var
tab _flshot3, missing
keep if _flshot3==1 | _flshot3==2
gen flushot = .
replace flushot = 1 if _flshot3==1
replace flushot = 0 if _flshot3>1
tab flushot, missing
*cleaning pneumonia vax var
tab pneuvac3, missing
drop if pneuvac3==7 | pneuvac3==9 | pneuvac3==.
gen pneumonia=.
replace pneumonia = 1 if pneuvac3==1
replace pneumonia = 0 if pneuvac3==2
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
tab eyeexam, missing
drop if eyeexam==7 | eyeexam==9| eyeexam==.
gen eyecheck = .
replace eyecheck = 1 if eyeexam==1 | eyeexam==2
replace eyecheck = 0 if eyeexam==3 | eyeexam==4 | eyeexam==8
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
tab race2, missing
drop if race2==9 | race2==.
gen race_eth = .
replace race_eth = 0 if race2==1 //white
replace race_eth = 1 if race2==2 //black
replace race_eth = 2 if race2==8 // hispanic
replace race_eth = 3 if race2>=3 & race2<=7 //other or multi
tab race_eth, missing
*gen physical activity var
tab _rfpamod, missing
drop if _rfpamod==9
gen physact = .
replace physact = 0 if _rfpamod==1
replace physact = 1 if _rfpamod==2
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
tab _bmi4cat, missing
drop if _bmi4cat==9
gen bmi = .
replace bmi = 0 if _bmi4cat==1
replace bmi = 1 if _bmi4cat==2
replace bmi = 2 if _bmi4cat==3
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
tab insulin, missing
drop if insulin==9 | insulin==.
gen insulin_use = .
replace insulin_use = 1 if insulin==1
replace insulin_use = 0 if insulin==2
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
tab hlthplan, missing
drop if hlthplan==7 | hlthplan==9
*clean deferment var (only missing dropped)
tab medcost, missing
drop if medcost==7 | medcost==9
*clean age of onset var
tab diabage2, missing
drop if diabage2==98 | diabage2==99 | diabage2==.
gen age_onset = .
replace age_onset = 0 if diabage2<45
replace age_onset = 1 if diabage2>=45 & diabage2<=64
replace age_onset = 2 if diabage2>=65
tab age_onset, missing
**************************************
** Recreate Table 1: demographic summary        
**************************************
foreach var in sex race_eth education marstatus income hlthplan medcost  provider routine_checkup srh {
	display "Proportion `var'"
	svy: proportion `var' if rural==0
	svy: proportion `var' if rural==1
}

**************************************
** Recreate Table 3: multivariate reg           
**************************************
svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthplan i.medcost provider routine_checkup

svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthplan ib2.medcost provider routine_checkup if rural==1

svy: logistic adequatecare rural ib2.sex i.race_eth i.education marstatus income srh i.age_onset insulin_use i.bmi physact smoker ib2.hlthplan ib2.medcost provider routine_checkup if rural==0

log close