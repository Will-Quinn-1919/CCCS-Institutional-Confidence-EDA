// data importing
cd "C:\Users\willq\Documents\Classes\Spring 2025\PLSC 370"
use "C:\Users\willq\Documents\Classes\Spring 2025\PLSC 370\cccs_2025.dta", clear

// prelim inspection of confidence

describe

// obs: 1,167
// var: 116

// NA assess

misstable summarize confidence_*

// 5 missing observations
// no incorrect data entries

// NA Remove

drop if missing(confidence_congress, confidence_labor, confidence_police, confidence_localgov)

// Label new

label var confidence_labor "Confidence In Illinois Govt."
label var confidence_congress "Confidence In U.S. Congress"
label var confidence_police "Confidence In Police."
label var confidence_localgov "Confidence In Local Govt."

rename confidence_labor confidence_state

gen confidence_sum = (confidence_congress + confidence_state + confidence_police + confidence_localgov)
summarize confidence_sum
label var confidence_sum "Summary of Confidence (1-16)"

// Label new demographic

// devide a specific cross section by demoraphic whole
// example: males w/ no confidence in police / males as whole

gen income_group = .
replace income_group = 1 if inlist(fam_income, 1, 2) // Poverty
replace income_group = 2 if inlist(fam_income, 3, 4, 5) // Low income
replace income_group = 3 if inlist(fam_income, 6, 7, 8 , 9) // Low-middle income
replace income_group = 4 if inlist(fam_income, 10, 11, 12) // High-middle income
replace income_group = 5 if inlist(fam_income, 13, 14, 15, 16) // High income

label define gender_lbl 1 "Male" 2 "Female" 3 "Neither"
label values gender gender_lbl

label define educ_lbl 1 "<GED" 2 "GED" 3 "<AD" 4 "AD" 5 "BD" 6 "BD<"
label values educ educ_lbl

gen party_new = .
replace party_new = 1 if inlist(pol_party, 1) // Democrat
replace party_new = 2 if inlist(pol_party, 2) // Republican
replace party_new = 3 if inlist(pol_party, 3 ,4) // Low-middle income

label define party_lbl 1 "Democrat" 2 "Republican" 3 "Other"
label values party_new party_lbl

label define gender_lbl 1 "Male" 2 "Female" 3 "Neither"
label values gender gender_lbl

label define orient_lbl 1 "Gay/Lesbian" 2 "Straight" 3 "Bisexual" 4 "Not listed"
label values sexual_orientation orient_lbl

gen income_group = .
replace income_group = 1 if inlist(fam_income, 1, 2) // Poverty
replace income_group = 2 if inlist(fam_income, 3, 4, 5) // Low income
replace income_group = 3 if inlist(fam_income, 6, 7, 8 , 9) // Low-middle income
replace income_group = 4 if inlist(fam_income, 10, 11, 12) // High-middle income
replace income_group = 5 if inlist(fam_income, 13, 14, 15, 16) // High income

label define income_lbl 1 "Poverty" 2 "Low income" 3 "Low-middle income" 4 "High-middle income" 5 "High income"
label values income_group income_lbl

gen age = 2025-yob

// Basic histogram

tabulate confidence_congress
tabulate confidence_state
tabulate confidence_police
tabulate confidence_localgov

graph bar (count), over(confidence_localgov, label(angle(45))) title("Local Govt. Confidence Ratings") name(g1, replace)
graph bar (count), over(confidence_police, label(angle(45))) title("Police Confidence Ratings") name(g2, replace)
graph bar (count), over(confidence_congress, label(angle(45))) title("Congress Confidence Ratings") name(g3, replace)
graph bar (count), over(confidence_state, label(angle(45))) title("State Govt. Confidence Ratings") name(g4, replace)

graph combine g1 g2 g3 g4, col(2) title("Confidence Ratings") name(Basic_Confidence_Histograms, replace)

// Unified histogram

graph bar (count), over(confidence_sum) title("Summed Confidence Levels") name(Sum_Confidence_Histograms, replace)

// Correlatin Assessment

// Response Var. Against Explanatory Var.

// Gender Against Response
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(gender) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Gender") ///
	name(gpg, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(gender) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Gender") ///
	name(glg, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(gender) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Gender") ///
	name(gsg, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(gender) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Gender") ///
	name(gcg, replace)
	
graph combine gpg glg gsg gcg, col(2) title("Confidence Ratings by Gender") name(Confidence_Gender, replace)

// Party Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(party_new) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Party") ///
    name(gpp, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(party_new) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Party") ///
	name(glp, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(party_new) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Party") ///
	name(gsp, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(party_new) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Party") ///
	name(gcp, replace)
	
graph combine gpp glp gsp gcp, col(2) title("Confidence Ratings by Party") name(Confidence_Party, replace)

// Sexual Orientation Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(sexual_orientation) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Sexuality") ///
    name(gps, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(sexual_orientation) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Sexuality") ///
	name(gls, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(sexual_orientation) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Sexuality") ///
	name(gss, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(sexual_orientation) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Sexuality") ///
	name(gcs, replace)
	
graph combine gps gls gss gcs, col(2) title("Confidence Ratings by Sexual Orientation") name(Confidence_Orient, replace)

// Education Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(educ) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Education") ///
    name(gpe, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(educ) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Education") ///
	name(gle, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(educ) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Education") ///
	name(gse, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(educ) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Education") ///
	name(gce, replace)
	
graph combine gpe gle gse gce, col(2) title("Confidence Ratings by Education") name(Confidence_Education, replace)

// Parenthood Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(children) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Parenthood") ///
    name(gpc, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(children) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Parenthood") ///
	name(glc, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(children) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Parenthood") ///
	name(gsc, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(children) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Parenthood") ///
	name(gcc, replace)
	
graph combine gpc glc gsc gcc, col(2) title("Confidence Ratings by Parenthood") name(Confidence_Parent, replace)

// Race Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(race_cat) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Race") ///
    name(gpr, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(race_cat) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Race") ///
	name(glr, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(race_cat) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Race") ///
	name(gsr, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(race_cat) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Race") ///
	name(gcr, replace)
	
graph combine gpr glr gsr gcr, col(2) title("Confidence Ratings by Race") name(Confidence_Race, replace)

// Chicago Residency Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(chicago) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Police by Chicago Residency") ///
    name(gpchi, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(chicago) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Local Govt. by Chicago Residency") ///
	name(glchi, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(chicago) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in State Govt. by Chicago Residency") ///
	name(gschi, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(chicago) ///
    asyvars stack ///
    bar(1, color(orange_red)) bar(2, color(sand)) bar(3, color(ltblue)) bar(4, color(forest_green)) ///
    title("Confidence in Congress by Chicago Residency") ///
	name(gcchi, replace)
	
graph combine gpchi glchi gschi gcchi, col(2) title("Confidence Ratings by Chicago Residency") name(Confidence_Chi, replace)

// chi-squared for confidence for chicago exp. var.

tabulate chicago confidence_localgov, chi2
// significant

tabulate chicago confidence_congress, chi2
// insignificant

tabulate chicago confidence_labor, chi2
// insignificant

tabulate chicago confidence_police, chi2
// significant



