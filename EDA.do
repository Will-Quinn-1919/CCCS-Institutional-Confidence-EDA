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

// Label new demographic

label define educ_lbl 1 "<GED" 2 "GED" 3 "<AD" 4 "AD" 5 "BD" 6 "BD<"
label values educ educ_lbl

label define party_lbl 1 "Democrat" 2 "Republic" 3 "Independent" 4 "Other"
label values pol_party party_lbl

label define gender_lbl 1 "Male" 2 "Female" 3 "Neither"
label values gender gender_lbl

label define orient_lbl 1 "Gay/Lesbian" 2 "Straight" 3 "Bisexual" 4 "Not listed"
label values sexual_orientation orient_lbl


// Basic histogram

tabulate confidence_congress
tabulate confidence_state
tabulate confidence_police
tabulate confidence_localgov

graph bar (count), over(confidence_localgov, label(angle(45))) title("Local Govt. Confidence Ratings") name(g1, replace)
graph bar (count), over(confidence_police, label(angle(45))) title("Police Confidence Ratings") name(g2, replace)
graph bar (count), over(confidence_congress, label(angle(45))) title("Congress Confidence Ratings") name(g3, replace)
graph bar (count), over(confidence_state, label(angle(45))) title("State Govt. Confidence Ratings") name(g4, replace)

graph combine g1 g2 g3 g4, col(2)

// Local Government Confidence Against Explanatory Variables

graph bar (count), over(confidence_localgov, label(angle(45))) over(pol_party) title("Local Govt. Confidence Ratings Against Political Party") name(gp1, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(sexual_orientation) title("Local Govt. Confidence Ratings Against Sexual Orientation") name(gp2, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(educ) title("Local Govt. Confidence Ratings Against Education") name(gp3, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(children) title("Local Govt. Confidence Ratings Against Children") name(gp4, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(race_cat) title("Local Govt. Confidence Ratings Against Race") name(gp5, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(chicago) title("Local Govt. Confidence Ratings Against Chicago Residency") name(gp6, replace)

graph bar (count), over(confidence_localgov, label(angle(45))) over(gender) title("Local Govt. Confidence Ratings Against Gender") name(gp7, replace)

// Police Confidence Against Explanatory Variables

graph bar (count), over(confidence_police, label(angle(45))) over(pol_party) title("Police Confidence Ratings Against Political Party") name(ga1, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(sexual_orientation) title("Police Confidence Ratings Against Sexual Orientation") name(ga2, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(educ) title("Police Confidence Ratings Against Education") name(ga3, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(children) title("Police Confidence Ratings Against Children") name(ga4, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(race_cat) title("Police Confidence Ratings Against Race") name(ga5, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(chicago) title("Police Confidence Ratings Against Chicago Residency") name(ga6, replace)

graph bar (count), over(confidence_police, label(angle(45))) over(gender) title("Police Confidence Ratings Against Gender") name(ga7, replace)

// Congress Against Explanatory Variables

graph bar (count), over(confidence_congress, label(angle(45))) over(pol_party) title("Congress Confidence Ratings Against Political Party") name(gb1, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(sexual_orientation) title("Congress Confidence Ratings Against Sexual Orientation") name(gb2, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(educ) title("Congress Confidence Ratings Against Education") name(gb3, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(children) title("Congess Confidence Ratings Against Children") name(gb4, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(race_cat) title("Congress Confidence Ratings Against Race") name(gb5, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(chicago) title("Congress Confidence Ratings Against Chicago Residency") name(gb6, replace)

graph bar (count), over(confidence_congress, label(angle(45))) over(gender) title("Congress Confidence Ratings Against Gender") name(gb7, replace)

// State Confidence Against Explanatory Variables

graph bar (count), over(confidence_state, label(angle(45))) over(pol_party) title("State Confidence Ratings Against Political Party") name(gc1, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(sexual_orientation) title("State Confidence Ratings Against Sexual Orientation") name(gc2, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(educ) title("State Confidence Ratings Against Education") name(gc3, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(children) title("State Confidence Ratings Against Children") name(gc4, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(race_cat) title("State Confidence Ratings Against Race") name(gc5, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(chicago) title("State Confidence Ratings Against Chicago Residency") name(gc6, replace)

graph bar (count), over(confidence_state, label(angle(45))) over(gender) title("State Confidence Ratings Against Gender") name(gc7, replace)

// chi-squared for confidence for chicago exp. var.

tabulate chicago confidence_localgov, chi2
// significant

tabulate chicago confidence_congress, chi2
// insignificant

tabulate chicago confidence_labor, chi2
// insignificant

tabulate chicago confidence_police, chi2
// significant



