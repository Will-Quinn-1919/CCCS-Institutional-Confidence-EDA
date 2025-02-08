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

gen confidence_mean = (confidence_congress + confidence_state + confidence_police + confidence_localgov)/4
summarize confidence_mean
label var confidence_mean "Mean of Confidence (1-4)"

// Label new demographic

// devide a specific cross section by demoraphic whole
// example: males w/ no confidence in police / males as whole

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

gen income_group2 = .
replace income_group2 = 1 if inlist(income_group, 1, 2) // low
replace income_group2 = 2 if inlist(income_group, 3, 4) // middle
replace income_group2 = 3 if inlist(income_group, 5) // high


label define income_lbl2 1 "Low income" 2 "Middle income" 3 "High income"
label values income_group2 income_lbl2

// Scatter plots

scatter confidence_mean age, mcolor(blue) || lfit confidence_mean age, lcolor(red) ///
    title("Confidence in Institutions by Age") ///
    xtitle("Age") ytitle("Confidence Level") ///
	legend(off)
	
twoway (scatter confidence_mean age if gender == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if gender == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if gender == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if gender == 1, lcolor(blue)) ///
       (qfit confidence_mean age if gender == 2, lcolor(red)) ///
       (qfit confidence_mean age if gender == 3, lcolor(green)), ///
       title("Confidence in Institutions by Age and Gender") ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Male" 2 "Female" 3 "Non-binary" 4 "Male Trend" 5 "Female Trend" 6 "Non-binary Trend") ///
              size(small))  // 凡例を小さくする

twoway (scatter confidence_mean age if party_new == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if party_new == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if party_new == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if party_new == 1, lcolor(blue)) ///
       (qfit confidence_mean age if party_new == 2, lcolor(red)) ///
       (qfit confidence_mean age if party_new == 3, lcolor(black)), ///
       title("Confidence in Institutions by Age and Political Party") ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Democrat" 2 "Repub." 3 "Other" 4 "Democrat Trend" 5 "Repub. Trend" 6 "Other Trend") ///
              size(small))  // 
			
twoway (scatter confidence_mean age if income_group2 == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if income_group2 == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if income_group2 == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if income_group2 == 1, lcolor(yellow)) ///
       (qfit confidence_mean age if income_group2 == 2, lcolor(gray)) ///
       (qfit confidence_mean age if income_group2 == 3, lcolor(black)), ///
       title("Confidence in Institutions by Age and Income") ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Low" 2 "Middle" 3 "High" 4 "Low Trend" 5 "Middle Trend" 6 "High Trend") ///
              size(small))  // 



