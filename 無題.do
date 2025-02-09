// data importing
cd "C:\Users\willq\Documents\Classes\Spring 2025\PLSC 370"
use "C:\Users\willq\Documents\Classes\Spring 2025\PLSC 370\cccs_2025_cleaned.dta", clear

describe

eda confidence_congress confidence_localgov confidence_police confidence_state confidence_sum age gender sexual_orientation race_cat party_new, o("eda-report-small") root("./") 

eda  [confidence_congress confidence_localgov confidence_police confidence_state confidence_sum age gender sexual_orientation race_cat party_new] [using] [if] [in] , o("eda-report-small") root("./") [ idvars(varlist)
strok[(varlist)] minnsize(integer) mincat(integer) maxcat(integer)
catvars(confidence_congress confidence_localgov confidence_police confidence_state gender sexual_orientation race_cat party_new) contvars(varlist) authorname(string) reportname(string)
scheme(string) keepgph grlablength(integer) missing percent
bargraphopts(string) nopiecharts
histogramopts(string) kdensity kdensopts(string) fivenumsum
fnsopts(string) nodistroplots distroplotopts(string) noladderplots 
lfit[(string)] qfit[(string)] lowess[(string)] fpfit[(string)] lfitci[(string)]
 noboxplots nomosaic noheatmap nobubbleplots
 compile byvars(varlist) byseq ]