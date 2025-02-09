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

// Should we combine?

spearman confidence_localgov confidence_state
spearman confidence_localgov confidence_congress
spearman confidence_localgov confidence_police
spearman confidence_state confidence_congress
spearman confidence_state confidence_police
spearman confidence_congress confidence_police

// All spearman corr coef. above .29, will combine

gen confidence_sum = (confidence_congress + confidence_state + confidence_police + confidence_localgov)
summarize confidence_sum
label var confidence_sum "Summary of Confidence (1-16)"

gen confidence_mean = (confidence_congress + confidence_state + confidence_police + confidence_localgov)/4	
summarize confidence_mean
label var confidence_mean "Mean of Confidence (1-4)"

// Label new demographic

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

gen income_group2 = .
replace income_group2 = 1 if inlist(income_group, 1, 2) // low
replace income_group2 = 2 if inlist(income_group, 3, 4) // middle
replace income_group2 = 3 if inlist(income_group, 5) // high

label define income_lbl2 1 "Low income" 2 "Middle income" 3 "High income"
label values income_group2 income_lbl2

gen age = 2025-yob

// Basic histogram

tabulate confidence_congress [aw=weight]
tabulate confidence_state [aw=weight]
tabulate confidence_police [aw=weight]
tabulate confidence_localgov [aw=weight]

graph bar (count), over(confidence_localgov, label(angle(45))) title("Local Govt. Confidence Ratings") name(g1, replace)
graph bar (count), over(confidence_police, label(angle(45))) title("Police Confidence Ratings") name(g2, replace)
graph bar (count), over(confidence_congress, label(angle(45))) title("Congress Confidence Ratings") name(g3, replace)
graph bar (count), over(confidence_state, label(angle(45))) title("State Govt. Confidence Ratings") name(g4, replace)

graph combine g1 g2 g3 g4, col(2) title("Confidence Ratings") name(Basic_Confidence_Histograms, replace)

// Unified histogram

graph bar (count), over(confidence_sum) title("Summed Confidence Levels") name(Sum_Confidence_Histograms, replace)

mean confidence_sum

graph bar (count), over(confidence_mean) title("Mean Confidence Levels") name(Mean_Confidence_Histograms, replace)

mean confidence_mean

// Bivariate visualizations

// Race Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(race_cat) ///
    title("Confidence in Police by Race", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpr, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(race_cat) ///
    title("Confidence in Local Govt. by Race", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(glr, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(race_cat) ///
    title("Confidence in State Govt. by Race", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gsr, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(race_cat) ///
    title("Confidence in Congress by Race", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcr, replace) ///
    legend(off)
	
graph combine gpr glr gsr gcr, col(2) title("Confidence Ratings by Race") name(Confidence_Race, replace)

// Gender Against Response
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(gender) ///
    title("Confidence in Police by Gender", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpg, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(gender) ///
    title("Confidence in Local Govt. by Gender", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(glg, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(gender) ///
    title("Confidence in State Govt. by Gender", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gsg, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(gender) ///
    title("Confidence in Congress by Gender", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcg, replace) ///
    legend(off)
	
graph combine gpg glg gsg gcg, col(2) title("Confidence Ratings by Gender") name(Confidence_Gender, replace)

// Chicago Residency Against Response
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(chicago) ///
    title("Confidence in Police by Chicago Res.", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpchi, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(chicago) ///
    title("Confidence in Local Govt. by Chicago Res.", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(glchi, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(chicago) ///
    title("Confidence in State Govt. by Chicago Res.", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gschi, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(chicago) ///
    title("Confidence in Congress by Chicago Res.", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcchi, replace) ///
    legend(off)

graph combine gpchi glchi gschi gcchi, col(2) ///
    imargin(2) ///
    title("Confidence Ratings by Chicago Residency", size(small)) ///
    name(Confidence_Chi, replace)

// Education Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(educ) ///
    title("Confidence in Police by Education", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpe, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(educ) ///
    title("Confidence in Local Govt. by Education", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gle, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(educ) ///
    title("Confidence in State Govt. by Education", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gse, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(educ) ///
    title("Confidence in Congress by Education", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gce, replace) ///
    legend(off)
	
graph combine gpe gle gse gce, col(2) title("Confidence Ratings by Education") name(Confidence_Education, replace)

// Parenthood Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(children) ///
    title("Confidence in Police by Parenthood", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpc, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(children) ///
    title("Confidence in Local Govt. by Parenthood", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(glc, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(children) ///
    title("Confidence in State Govt. by Parenthood", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gsc, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(children) ///
    title("Confidence in Congress by Parenthood", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcc, replace) ///
    legend(off)
	
graph combine gpc glc gsc gcc, col(2) title("Confidence Ratings by Parenthood") name(Confidence_Parent, replace)

// Scatterplot Age Against Mean
scatter confidence_mean age, mcolor(blue) || lfit confidence_mean age, lcolor(red) ///
    title("Mean Confidence in Institutions by Age") ///
    xtitle("Age") ytitle("Confidence Level") ///
	name(sa, replace) ///
	legend(off)
tabulate race_cat, nolabel

twoway (scatter confidence_mean age if race_cat == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if race_cat == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if race_cat == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if race_cat == 1, lcolor(orange) lwidth(0.8)) ///
       (qfit confidence_mean age if race_cat == 2, lcolor(gold) lwidth(0.8)) ///
       (qfit confidence_mean age if race_cat == 3, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Race") ///
	   name(sar, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "White" 2 "Hispanic" 3 "Black" 4 "White Trend" 5 "Hispanic Trend" 6 "Black Trend") ///
              size(small))  // 凡例を小さくする

twoway (scatter confidence_mean age if gender == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if gender == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if gender == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if gender == 1, lcolor(orange) lwidth(0.8)) ///
       (qfit confidence_mean age if gender == 2, lcolor(gold) lwidth(0.8)) ///
       (qfit confidence_mean age if gender == 3, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Gender") ///
	   name(sag, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Male" 2 "Female" 3 "Non-binary" 4 "Male Trend" 5 "Female Trend" 6 "Non-binary Trend") ///
              size(small))  // 

twoway (scatter confidence_mean age if chicago == 0, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if chicago == 1, mcolor(red) msize(small)) ///
       (qfit confidence_mean age if chicago == 0, lcolor(orange) lwidth(0.8)) ///
       (qfit confidence_mean age if chicago == 1, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Chicago Residency") ///
	   name(sag, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Not in Chicago" 2 "In Chicago" 3 "N/ Chi Trend" 4 "Chi Trend") ///
              size(small))  // 	  
			  
// Educational attainment has too many levels, will skip

twoway (scatter confidence_mean age if children == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if children == 2, mcolor(red) msize(small)) ///
       (lpoly confidence_mean age if party_new == 1, lcolor(orange) lwidth(0.8)) ///
       (lpoly confidence_mean age if party_new == 2, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Parenthood") ///
	   name(sap, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Parent" 2 "No Child" 3 "Parent Trend" 4 "No Child Trend") ///
              size(small))  // 

twoway (scatter confidence_mean age if party_new == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if party_new == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if party_new == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if party_new == 1, lcolor(orange) lwidth(0.8)) ///
       (qfit confidence_mean age if party_new == 2, lcolor(gold) lwidth(0.8)) ///
       (qfit confidence_mean age if party_new == 3, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Political Party") ///
	   name(sap, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Democrat" 2 "Repub." 3 "Other" 4 "Democrat Trend" 5 "Repub. Trend" 6 "Other Trend") ///
              size(small))  // 
			  
twoway (scatter confidence_mean age if income_group2 == 1, mcolor(blue) msize(small)) ///
       (scatter confidence_mean age if income_group2 == 2, mcolor(red) msize(small)) ///
       (scatter confidence_mean age if income_group2 == 3, mcolor(green) msize(small)) ///
       (qfit confidence_mean age if income_group2 == 1, lcolor(orange) lwidth(0.8)) ///
       (qfit confidence_mean age if income_group2 == 2, lcolor(gold) lwidth(0.8)) ///
       (qfit confidence_mean age if income_group2 == 3, lcolor(black) lwidth(0.8)), ///
       title("Mean Confidence in Institutions by Age and Income") ///
	   name(sai, replace) ///
       xtitle("Age") ytitle("Confidence Level") ///
       legend(order(1 "Low" 2 "Middle" 3 "High" 4 "Low Trend" 5 "Middle Trend" 6 "High Trend") ///
              size(small))  //

// Party Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(party_new) ///
    title("Confidence in Police by Party", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpp, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(party_new) ///
    title("Confidence in Local Govt. by Party", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(glp, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(party_new) ///
    title("Confidence in State Govt. by Party", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gsp, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(party_new) ///
    title("Confidence in Congress by Party", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcp, replace) ///
    legend(off)
	
graph combine gpp glp gsp gcp, col(2) title("Confidence Ratings by Party") name(Confidence_Party, replace)

// Sexual Orientation Against Response	
graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(sexual_orientation) ///
    title("Confidence in Police by Sexual Orientation", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gps, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(sexual_orientation) ///
    title("Confidence in Local Govt. by Sexual Orientation", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gls, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(sexual_orientation) ///
    title("Confidence in State Govt. by Sexual Orientation", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gss, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(sexual_orientation) ///
    title("Confidence in Congress by Sexual Orientation", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gcs, replace) ///
    legend(off)
	
graph combine gps gls gss gcs, col(2) title("Confidence Ratings by Sexual Orientation") name(Confidence_Orient, replace)

// Income Against Response	

graph bar (count) [aw=weight], ///
    over(confidence_police, label(angle(45))) ///
    over(income_group2) ///
    title("Confidence in Police by Income Group", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gpi, replace) ///
    legend(off)

graph bar (count) [aw=weight], ///
    over(confidence_localgov, label(angle(45))) ///
    over(income_group2) ///
    title("Confidence in Local Govt. by Income Group", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gli, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_state, label(angle(45))) ///
    over(income_group2) ///
    title("Confidence in State Govt. by Income Group", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gsi, replace) ///
    legend(off)
	
graph bar (count) [aw=weight], ///
    over(confidence_congress, label(angle(45))) ///
    over(income_group2) ///
    title("Confidence in Congress by Income Group", size(small)) ///
    ylabel(, labsize(small)) ytitle("Frequency", size(small)) ///
    bar(1, color(navy)) ///
    yline(100 200 300, lcolor(gs12)) ///
    name(gci, replace) ///
    legend(off)
	
graph combine gpi gli gsi gci, col(2) title("Confidence Ratings by Income Group") name(Confidence_Orient, replace)