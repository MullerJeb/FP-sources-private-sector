/*=======================================================================================================================================================
			*Project Title			: The role of private sector in improving access to FP in Ethiopia.															
			*Purpose/ Objectives	: To assess the characteristics of FP users from private health sectors over time
			*proposed analysis:     : These include but not limited to descriptive statistics, measure of inequtiy, small area estimation, Multi     level                                 Mixed effect logistic regression Modeling, bayesian  Analysis and multivariate decomposition analysis
			*Source.raw data	 	: DHS, CSA and EPHI has collected five rounds of data  
			*Acknowledgments		: Greatful to BMGF and FMOH 
			*Author(s) and Date	started	: Mulusew J Geerbaba, Zelalem Adugna (06 May 2022)	
			*Analysis was done by   : Mulusew J Gerbaba  
			*Reviewed by            : Zelalem Adugna 
			*Last updated			: 26.08.2022																								*
			*Affiliation			: HANZ Consultany PLC. and Jimma University
			*Excution instruction:
				*download the "mmasterdata"
				*save it in yor prefered directory (you will use this directory as  global raw data directory)
			*=========================================================================================================================================================================================================================*/

      //seting global directories
	  * Clear all stored values in memory*
		clear all
		
	 * Set basic memory limits
		set maxvar 		32767 
		set matsize 	1000
		
	*Set advanced memory limits, these are values
		set min_memory	0
		set max_memory	.
		set segmentsize	32m
		set niceness	5

	*Set default options
		set more 		off
		set varabbrev 	off
		
	*set log file 
	
		capture log close

			
*******************************************************************************************************************************************
*							 PREPARING GLOBALS 								          *
*******************************************************************************************************************************************
		if 1{
		
		global muller		1
		global otheruser    0 

		* Gdrive globals
		* -----------------		

		if $muller{
		global gdrive "F:\HANZ\SecData\EDHS\Data\raw_data"
		}
		
		if $others{
		global gdrive "F:\HANZ\"
		}

		* Folders globals
		* -----------------
		global project 				"Private Sector & FP Ethiopia"
		global data 				"$gdrive/$project/Data"
		global dofiles       		"$gdrirve/$project/do_file"
		global outputs              "$gdrive/$project/Outputs" 
		
		* Activating parts of dofile 
		global part_1      		1
		global part_2 			1
		global part_3			1
		
}

		
		global raw_data   "data/raw"
		global cleaned_data   "data/clean"
		global analysis "data/analysis"
		global logs  "logs" 
		
		log using "c.smcl", replace
		
		*use "/Users/muller/Desktop/HANZ/SecData/ET_2019_MDHS/ETHR81DT/ETHR81FL.DTA", clear	
		
		use "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETHR81DT\ETHR81FL.DTA", clear	
		gen int v001 = hv001
		gen int v002 = hv002
		gen byte v003 = hv003
		sort v001 v002 v003
		
		*save "/Users/muller/Desktop/HANZ/SecData/ET_2019_MDHS/ETHR81DT/ETHR81FL_sort.dta", replace 
		
		save "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETHR81DT\ETHR81FL_sort.dta", replace 	
		
		*use "/Users/muller\Desktop/HANZ/SecData/ET_2019_MDHS/ETIR81DT/ETIR81FL.dta", clear 
		
		use "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETIR81DT\ETIR81FL.dta", clear 
		
		sort v001 v002 v003
		
		**Note    *
		
		merge 1:m v001 v002 v003 using "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETHR81DT\ETHR81FL_sort.dta"
		drop _merge
		
		sort v001 v002 v003
		
		save "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ET_HR_IR_81FL.dta",replace 
		
	   
		use "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ET_HR_IR_81FL.dta",clear
 		sort v001 v002 v003
		
		
		use "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETBR81DT\ETBR81FL.DTA", clear
		
		sort v001 v002 v003
	
		
		*merge v001 v002 v003 using  "/Users/muller/Desktop/HANZ/SecData/ET_2019_MDHS/ET_HR_IR_81FL.dta"
		
		
		save "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ET_HR_IR_BR_81FL.dta",replace 
		
	
		*use "/Users/muller/Desktop/HANZ/SecData/ET_2019_MDHS/ET_HR_IR_BR_81FL.dta",clear 
 		use "F:\HANZ\SecData\EDHS\Data\raw_data\ET_2019_MDHS\ETIR81DT\ETIR81FL.dta", clear 

		
*Browse|Count|Describe for data insepction   //
	br
	desc
	describe, short 
	count  // The sample = 29,956
	drop if v012<15 | v012>49
	
* set up the data 
gen married=1 if v502==1
replace married=0 if v502!=1

**Age of the respondents 
tab v012
sum v012,d

ta v013

*Region   we can also use v101
ta v024 

* Place of residence we can also use v102
ta v025


** Education 
ta v106


** water sources
ta v113
*Facilities toilet

ta v116 

*own electricity

ta v119 
*own radio
ta v120 
recode v120(7=.)
ta v120

**own televsion
ta v121 
recode v121 (7=.)
ta v121

** floor 
ta v127 
*wall 
ta v128 
*main roof
ta v129 

*religion 
ta v130 

gen relig=.
replace relig=1 if v130==1
replace relig=2 if v130==3
replace relig=3 if v130==4
replace relig=4 if v130==2|v130==5|v130==96

label define relig_1 1 "Orthodox" 2 "Protestant" 3 "Muslim" 4 "Others"
label values relig relig_1

ta relig

*Number of household size
ta v136 
sum v136, d

*Numer of child 
ta v137  

sum v131, d 

**
tab v150 

 
*sex head of hhv
ta v151 

** cooking
ta v161
**wealth index

tab1 v190 v190a 


**analysis
gen sweight=v005/1000000

* mCP, tCP, Unmet Modern, and Demand Satisfied Modern
gen mcp=1 if v313==3 
replace mcp=0 if v313!=3


ta v717
gen occup=.
replace occup=0 if v717==0
replace occup=1 if v717==1|v717==2|v717==3|v717==4|v717==5|v717==6|v717==7|v717==8|v717==9
tab occup

* Method Prevelance (used to calculte method mix)
* want to check variable coding for v312 (method)    current users 
ta v312
ta v312, nolabel


*pill, injectable, IUD, implant, condom (male), condom (female), LAM, sterilization (male), sterilization (female), and the Standard Days Method. 
gen method="Pill" if v312==1
replace method = "IUD" if  v312==2
replace method = "Injectable" if v312==3 
replace method = "MCondom" if v312==5
replace method = "FSter" if v312==6 
replace method =  "Periabst" if  v312==8
replace method = "withdrwal" if v312==9
replace method = "Implant" if v312==11
replace method = "LAM" if v312==13
replace method = "SDM" if v312==18 

gen method_rec=.
replace method_rec=1 if v312==1
replace method_rec=2 if v312==2
replace method_rec=3 if v312==3
replace method_rec=4 if v312==5
replace method_rec=5 if v312==6
replace method_rec=6 if v312==8                                       
replace method_rec=7 if v312==9
replace method_rec=8 if v312==10
replace method_rec=9 if v312==11
replace method_rec=10 if v312==13
replace method_rec=11 if v312==16
replace method_rec=12 if v312==17
replace method_rec=13 if v312==18

tab method_rec
 
 
 //Currently use any method
gen fp_cruse_any = (v313>0 & v313<8)
label var fp_cruse_any "Currently used any contraceptive method"


//Currently use modern method
gen fp_cruse_mod = v313==3
la var fp_cruse_mod "Currently used any modern method"
 

 //Currently use female sterilization  
gen fp_cruse_fster = v312==6
la var fp_cruse_fster "Currently used female sterilization"
 
 
//Currently use the contraceptive pill 
gen fp_cruse_pill = v312==1
la var fp_cruse_pill "Currently used pill"

//Currently use Interuterine contraceptive device 
gen fp_cruse_iud = v312==2
la var fp_cruse_iud "Currently used IUD"

//Currently use injectables (Depo-Provera) 
gen fp_cruse_inj = v312==3
la var fp_cruse_inj "Currently used injectables"

//Currently use implants (Norplant) 
gen fp_cruse_imp = v312==11
la var fp_cruse_imp "Currently used implants"

//Currently use male condom 
gen fp_cruse_mcond = v312==5
la var fp_cruse_mcond "Currently used male condoms"


//Currently use standard days method (SDM) 
gen fp_cruse_sdm = v312==18
la var fp_cruse_sdm "Currently used standard days method"

//Currently use Lactational amenorrhea method (LAM) 
gen fp_cruse_lam = v312==13
la var fp_cruse_lam "Currently used LAM"

//Currently use emergency contraception 
gen fp_cruse_ec = v312==16
la var fp_cruse_ec "Currently used emergency contraception"

//Currently use country-specific modern methods and other modern contraceptive methods 
gen fp_cruse_omod = v312==17
la var fp_cruse_omod "Currently used other modern method"

//Currently use periodic abstinence (rhythm, calendar method) 
gen fp_cruse_rhy = v312==8
la var fp_cruse_rhy "Currently used rhythm method"

//Currently use withdrawal (coitus interruptus) 
gen fp_cruse_wthd = v312==9
la var fp_cruse_wthd "Currently used withdrawal method"




* FP Source

ta v326
ta v326, nolabel

gen fpsource1= .
replace fpsource1=1 if v326==11
replace fpsource1=2 if v326==12
replace fpsource1=3 if  v326==13
replace fpsource1=4 if v326==14|v326==16

label define fpsource1_lab 1 "Government hospital" 2 "Govt health center"  3 "healthpost"  4 "other public"
label values fpsource1 fpsource1_lab




gen fpsource2=.
replace fpsource2=1 if v326==21|v326==26
replace fpsource2=2 if v326==31
replace fpsource2=3 if v326==32
replace fpsource2=4 if v326==33|v326==36

label define fpsource2_lab 1 "NGO/FBO" 2 "Private hospital" 3 "Private clinic" 4  "Private pharmacy" 
label values fpsource2 fpsource2_lab




gen fpsource3=.
replace fpsource3=1 if v326==41
replace fpsource3=2 if v326==42
replace fpsource3=3 if v326==96


label define fpsource3_lab 1 "Shops" 2 "Friends/relatives" 3 "Others" 
label values fpsource3 fpsource3_lab



gen FPsource=.
replace FPsource = 1 if v326==11|v326==12|v326==13|v326==14|v326==16
replace FPsource = 2 if v326==31|v326==32|v326==33|v326==36|v326==21|v326==26 
replace FPsource = 3 if v326==41|v326==42|v326==96

gen FPsource2=.
replace FPsource2 = 0 if v326==11|v326==12|v326==13|v326==14|v326==16
replace FPsource2 = 1 if v326==31|v326==32|v326==33|v326==36|v326==21|v326==26 


//Source for all 
gen fp_source_tot = v326
label values fp_source_tot V326
la var fp_source_tot "Source of contraception - total"

//Source for female sterilization users
gen fp_source_fster = v326
replace fp_source_fster = . if v312!=6
label values fp_source_fster V326
la var fp_source_fster "Source for female sterilization"

//Source for pill users
gen fp_source_pill = v326
replace fp_source_pill = . if v312!=1
label values fp_source_pill V326
la var fp_source_pill "Source for pill"

//Source for IUD users
gen fp_source_iud = v326
replace fp_source_iud = . if v312!=2
label values fp_source_iud V326
la var fp_source_iud "Source for IUD"

//Source for injectable users
gen fp_source_inj = v326
replace fp_source_inj = . if v312!=3
label values fp_source_inj V326
la var fp_source_inj "Source for injectables"

//Source for implant users
gen fp_source_imp = v326
replace fp_source_imp = . if v312!=11
label values fp_source_imp V326
la var fp_source_imp "Source for implants"

//Source for male condom users
gen fp_source_mcond = v326
replace fp_source_mcond = . if v312!=5
label values fp_source_mcond V326
la var fp_source_mcond "Source for male condom"
*******************************************************************************

**Know FP method

//Any method 
gen fp_know_any = (v301>0 & v301<8)
la var fp_know_any "Know any contraceptive method"

//Modern method
gen fp_know_mod = v301==3
label var fp_know_mod "Know any modern method"

//Female sterilization  
gen fp_know_fster = (v304_06>0 & v304_06<8)
label var fp_know_fster "Know female sterilization"

//Male sterilization  
gen fp_know_mster = (v304_07>0 & v304_07<8)
label var fp_know_mster "Know male sterilization"

//The contraceptive pill 
gen fp_know_pill = (v304_01>0 & v304_01<8)
label var fp_know_pill "Know pill"

//Interuterine contraceptive device 
gen fp_know_iud = (v304_02>0 & v304_02<8)
label var fp_know_iud "Know IUD"

//Injectables (Depo-Provera) 
gen fp_know_inj = (v304_03>0 & v304_03<8)
label var fp_know_inj "Know injectables"

//Implants (Norplant) 
gen fp_know_imp = (v304_11>0 & v304_11<8)
label var fp_know_imp "Know implants"

//Male condom 
gen fp_know_mcond = (v304_05>0 & v304_05<8)
label var fp_know_mcond "Know male condoms"

//Female condom 
gen fp_know_fcond = (v304_14>0 & v304_14<8)
label var fp_know_fcond "Know female condom"

//Emergency contraception 
gen fp_know_ec = (v304_16>0 & v304_16<8)
label var fp_know_ec "Know emergency contraception"

//Standard days method (SDM) 
gen fp_know_sdm = (v304_18>0 & v304_18<8)
label var fp_know_sdm "Know standard days method"

//Lactational amenorrhea method (LAM) 
gen fp_know_lam = (v304_13>0 & v304_13<8)
label var fp_know_lam "Know LAM"

//Country-specific modern methods and other modern contraceptive methods 
gen fp_know_omod = (v304_17>0 & v304_17<8)
label var fp_know_omod "Know other modern method"

//Periodic abstinence (rhythm, calendar method) 
gen fp_know_rhy = (v304_08>0 & v304_08<8)
label var fp_know_rhy "Know rhythm method"

//Withdrawal (coitus interruptus) 
gen fp_know_wthd = (v304_09>0 & v304_09<8)
label var fp_know_wthd "Know withdrawal method"

//Country-specific traditional methods, and folk methods 
gen fp_know_other = (v304_10>0 & v304_10<8)
label var fp_know_other "Know other method"

//Any traditional
gen fp_know_trad=0
replace fp_know_trad=1 if fp_know_rhy | fp_know_wthd==1 | fp_know_other==1
label var fp_know_trad "Know any traditional method"

//Mean methods known
gen fp_know_sum	=	fp_know_fster + fp_know_mster + fp_know_pill + fp_know_iud + fp_know_inj + fp_know_imp + ///
					fp_know_mcond + fp_know_fcond + fp_know_ec + fp_know_sdm + fp_know_lam + ///
					fp_know_rhy + fp_know_wthd + fp_know_omod + fp_know_other
				
sum fp_know_sum [aw=v005/1000000]
gen fp_know_mean_all=r(mean)

label var fp_know_mean_all "Mean number of methods known - all"

sum fp_know_sum if v502==1 [aw=v005/1000000]
gen fp_know_mean_mar=r(mean)

label var fp_know_mean_mar "Mean number of methods known - among currently married"







* mCP All women
tab mcp [aw=sweight]
* mCP Married women
tab mcp if married==1 [aw=sweight]
* mCP Unmarried women
tab mcp if married==0 [aw=sweight]

* Family Planning Source
tab FPsource [aw=sweight]
tab FPsource2 [aw=sweight]

* Family Planning Source by Method
tab method FPsource2  [aw=sweight], row
tab method FPsource2  [aw=sweight], col

* Percentage of women who decided to use family planning alone or jointly with their husbands/partners
gen decision= 1 if v632==1 | v632==3
replace decision= 0 if v632!=1 & v632!=3 & v632!=.
tab decision [aw=sweight]

	********************************************************************************************
	preserve
	table1, by(FPsource2) vars(v013 cat\v024 cat\v025 cat\v106 cat\v119 cat \v120 cat\v121 cat\relig cat\v151 cat\v190 cat\v136 contn\v137 contn\method cat\v502 cat) format(%2.1f) onecol saving ("table 1.xlsx", replace)
	restore

	preserve
	table1_mc, by(FPsource2) vars(v013 cat\v024 cat\v025 cat\v106 cat\v120 cat\v121 cat\relig cat\v151 cat\v190 cat\v136 contn\v137 contn\method cat\married cat) format(%2.1f) catrowperc saving ("table_mc4.xlsx", replace)
	restore


***Weight is not possible using table1
tab v013 FPsource2 [aw=sweight], row
tab v024 FPsource2 [aw=sweight], row
tab v025 FPsource2 [aw=sweight], row
tab v106 FPsource2 [aw=sweight], row
tab v119 FPsource2 [aw=sweight], row
tab v120 FPsource2 [aw=sweight], row
tab v130 FPsource2 [aw=sweight], row
tab v151 FPsource2 [aw=sweight], row
tab v136 FPsource2 [aw=sweight], row
tab v137 FPsource2 [aw=sweight], row
tab v502 FPsource2 [aw=sweight], row
tab method FPsource2 [aw=sweight], row
x




gen year=2019
save "F:\HANZ\SecData\EDHS\Data\raw_data\MEDHS_2019_ALL.dta", replace
qui append using "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2016_ALL.dta"
qui append using "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2011_ALL.dta"
qui append using "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2005_ALL.dta"
qui append using  "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2000_ALL.dta"

save "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2000_2019_ALL.dta", replace

use "F:\HANZ\SecData\EDHS\Data\raw_data\EDHS_2000_2019_ALL.dta", clear

bys year: tab1 v024, nolabel
recode v024 (12=8) (13=9) (14=10 ) (15=11)
bys year: tab1 v024, nolabel

label define region_lab 1 "Tigray" 2 "Afar" 3 "Amhara" 4 "Oromia"  5  "Somali" 6 "Benishangul" 7 "SNNPR"  8 "Gambela"  9 "Harari" 10 "Addis Adaba"  11 "Dire Dawa"
label values v024 region_lab
tab v024



//source of family planing 
		
graph pie [aw=sweight] if year==2019, over(FPsource2) plabel(_all percent)   
graph save graph1.gph, replace

graph pie [aw=sweight] if year==2016, over(FPsource2) plabel(_all percent)   
graph save graph2.gph, replace

graph pie [aw=sweight] if year==2011, over(FPsource2) plabel(_all percent)   
graph save graph3.gph, replace

graph pie [aw=sweight] if year==2005, over(FPsource2) plabel(_all percent)   
graph save graph4.gph, replace

graph pie [aw=sweight] if year==2000, over(FPsource2) plabel(_all percent)   
graph save graph5.gph, replace

graph combine graph1.gph graph2.gph graph3.gph graph4.gph graph5.gph, row(2)



graph bar (count) [pw=sweight], over(FPsource) over(year) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
			
graph hbar (count) [pw=sweight] , over(FPsource2) over(year) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 	
	

**within private compare across region 		

graph hbar (count)[pw=sweight], over(fpsource2) over(year) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 
			

graph hbar (count)[pw=sweight], over(fpsource2) over(v024) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 			
			
* trends in method mix		
			
			
			
			
			
graph hbar (count), over(FPsource) over(v024) percent stack asyvars 

graph hbar (count), over(fpsource1) over(v024) over(v025) percent stack asyvars 

graph bar (count), over(FPsource) over(v190a) percent stack asyvars 
graph bar (count), over(FPsource) over(v190a) percent stack asyvars 
graph bar (count) [pw=sweight]  , over(FPsource) over(method) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph bar (count) [pw=sweight] if married==1 , over(FPsource) over(method) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 

graph bar (count) [pw=sweight] , over(FPsource) over(v013) over(v025) percent stack asyvars 

graph bar (count) [pw=sweight], over(FPsource) over(v106) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph bar (count) [pw=sweight], over(FPsource) over(v106) over(v025) percent stack asyvars 			
			
			
** Wealth 

graph bar (count) [pw=sweight] if year==2016, over(FPsource2) over(v190a) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph1.gph, replace

graph bar (count) [pw=sweight] if year==2016, over(FPsource2) over(v190a) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph2.gph, replace


graph bar (count) [pw=sweight] if year==2019, over(FPsource2) over(v190a) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph1.gph, replace

graph bar (count) [pw=sweight] if year==2019, over(FPsource2) over(v190a) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph2.gph, replace

** Residence 
graph bar (count) [pw=sweight] if year==2019, over(FPsource2) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph1.gph, replace

graph bar (count) [pw=sweight] if year==2016, over(FPsource2) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph2.gph, replace

graph bar (count) [pw=sweight] if year==2011, over(FPsource2) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph3.gph, replace

graph bar (count) [pw=sweight] if year==2005, over(FPsource2) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph4.gph, replace

graph bar (count) [pw=sweight] if year==2000, over(FPsource2) over(v025) percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 
graph save graph5.gph, replace
graph combine graph1.gph graph2.gph graph3.gph graph4.gph graph5.gph, row(2)



graph hbar (count) [pw=sweight] if year==2019, over(FPsource2) over(v024) over(v025)  percent stack asyvars blabel(bar, position(outside) format(%3.0f)) ylabel(none) yscale(r(0,80)) 





graph bar (count) [pw=sweight], over(v025) over(method) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
		
		
***************************************************************************************

//Facility types - private		 
graph bar (count) [pw=sweight] , over(fpsource2) over(year) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
			
//Facility type - public 
graph bar (count) [pw=sweight] , over(fpsource1) over(year) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)

//Contraceptive use across regions by FP source		

graph hbar (count)[pw=sweight] , over(FPsource2) over(v024) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 
			
//Contraceptive use across regions by FP source 
			
graph hbar (count)[pw=sweight] if year==2011, over(FPsource) over(v024) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))
			
graph hbar (count)[pw=sweight] if year==2016, over(FPsource) over(v024) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))
			
graph hbar (count)[pw=sweight] if year==2019, over(FPsource) over(v024) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))
			
//Contraceptive use across regions by FP source and rural urban category		
graph hbar (count)[pw=sweight] if year==2011, over(FPsource) over(v024) over(v025) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))
			
graph hbar (count)[pw=sweight] if year==2016, over(FPsource) over(v024) over(v025) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))
			
graph hbar (count)[pw=sweight] if year==2019, over(FPsource) over(v024) over(v025) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))


//Contraceptive use across regions by FP source and rural urban catagory
graph hbar (count)[pw=sweight] , over(FPsource2) over(v025) over(year) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 
			
//Contraceptive use across regions by FP source and rural urban catagory
graph hbar (count)[pw=sweight] , over(FPsource2) over(v024) over(v025) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 
						
			
			
			
			
			
//Source of family planing by age group 

graph bar (count) [pw=sweight] if year==2019, over (FPsource2) over(v013) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
graph save graph1.gph, replace

graph bar (count) [pw=sweight] if year==2016, over (FPsource2) over(v013) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
graph save graph2.gph, replace
		
			
graph bar (count) [pw=sweight] if year==2011, over (FPsource2) over(v013) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
graph save graph3.gph, replace			
			
graph bar (count) [pw=sweight] if year==2005, over (FPsource2) over(v013) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
graph save graph4.gph, replace			
						
			
graph bar (count) [pw=sweight] if year==2000, over (FPsource2) over(v013) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
graph save graph5.gph, replace			
						
			
graph combine graph1.gph graph2.gph graph3.gph graph4.gph graph5.gph, row(3)


			
graph bar (count) [pw=sweight] if year==2016, over (FPsource2) over(v013) over(v025) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)

graph bar (count) [pw=sweight] if year==2019, over (FPsource2) over(v013) over(v025) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)
			
graph bar (count) [pw=sweight] if year==2011, over (FPsource2) over(v013) over(v025) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)

graph bar (count) [pw=sweight] if year==2005, over (FPsource2) over(v013) over(v025) percent asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80))  bargap(10)			
			

//Source of family planing by marital 
**# Bookmark #2
graph bar (count)[pw=sweight] , over(FPsource2) over(married) over(year)  percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)
			
//Source of family planing by socio economic status 
graph bar (count)[pw=sweight] , over(FPsource) over(v190) over(year) percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)

//Source of family planing by socio economic status and rural urban
graph bar (count)[pw=sweight] , over(FPsource) over(v190) percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)
			
graph hbar (count)[pw=sweight] , over(FPsource) over(v190) over(year) percent stack asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) 
			
//Source of family planing by religion 
graph bar (count)[pw=sweight] , over(FPsource) over(relig) over(year) percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)		

//Source of family planing by reigion and rural urban
graph bar (count)[pw=sweight] , over(FPsource2) over(v025) over(relig) percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)
			
//SAM source 
graph pie [aw=sweight], over(fp_source_inj1) plabel(_all percent)
graph bar (count)[pw=sweight] , over(fp_source_inj1) over(year)  percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)

**Education
graph bar (count)[pw=sweight] , over(FPsource2) over(v106) over(year)  percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)
		
graph bar (count)[pw=sweight] if year==2019, over(FPsource2) over(v106) over(v025) percent  asyvars blabel(bar, position(outside) ///
			format(%3.0f)) ylabel(none) yscale(r(0,80)) bargap(8)

			
			
*Main analysis

*chekc icc
 * checking the distribution of outcomes
  tab1 mcp if married==1
 gen hhid= _n
 
** checking for model random intercepts
	ta v384b
	recode v384b (9=0)
	
	ta v701
	recode v701(8=.) (9=.)
	
	global covar i.year i.v106 i.v701 ib4.relig ib1.v025 ib7.v013 i.v190 v151 v136 v137 married occup 
	global covariates i.year i.v106 i.v701 ib4.relig ib1.v025 ib7.v013 i.v190 v151 v136 v137 married occup fp_know_sum decision v384b
	
	
	xtset hhid year
	xtmelogit FPsource2||v001:
	estat icc
	// 20.6 ICC//

	
	*Model building 
	xtmelogit FPsource2 i.year||v001: , or
	outreg2 using phf.xls,e(N r2 p) replace ctitle(model1)
	estimates store M1
	
	xtmelogit FPsource2 $covar ||v001: , or
    outreg2 using phf.xls,e(N r2 p) append ctitle(model2)
    estimates store M2
	
	xtmelogit FPsource2 $covariates ||v001:, or 
	outreg2 using phf.xls,e(N r2 p) append ctitle(model3)
    estimates store M3
	
	
	

		*********Effect Analysis*********************************************************************************
		
		***************************************************************************************************************************************************************************************
		**Regression OLS (mcp)
		logit mcp FPsource2 i.v106 i.relig v025 ib7.v013 i.v190 v151 v136 v137 married  fp_know_sum  
		outreg2 using mcp_fp.xls,e(N r2 p) replace ctitle(L mcp)
	
		
		/**do regression adjustment model
		The regression-adjustment (RA) estimator uses a model for the outcome. The RA estimator uses a difference in the average predictions for the treated and the average predictions for the nontreated to estimate the ATE. Below we use teffects ra to estimate the ATE when conditioning on the mother's marital status, her education level, whether she had a prenatal visit in the first trimester, and whether it was her first baby.*/
	
		xi: teffects ra ( FPsource2 relig v106 v025 v013 v190 v151 v136 fp_know_sum married) (mcp)
		outreg2 using mcp_fp.xls,e(N r2 p) append ctitle(RA mcp)

		
	
/*
		
		Then chekc using the inverse-probability-weighted (IPW) estimator uses a model for the treatment instead of a model for the outcome; ///
		it uses the predicted treatment probabilities to weight the observed outcomes. The difference between the weighted treated outcomes and ///
		the weighted nontreated outcomes estimates the ATE. Conditioning on the same variables as above, we now use teffects ipw to estimate the ATE: */
		
		
		teffects ipw (mcp) (FPsource2 relig v106 v025 v013 v190 v151 v136 fp_know_sum married)
		


		teffects aipw (mcp relig v106 v025 v013 v190 v151 v136 fp_know_sum married) (FPsource2 relig v106 v025 v013 v190 v151 v136 fp_know_sum married)
		
		
		
		/*We could use both models instead of one. The shocking fact is that only one of the two models must be correct to estimate the ATE, whether we use the augmented-IPW (AIPW) combination proposed by Robins and Rotnitzky (1995) or the IPW-regression-adjust ment (IPWRA) combination proposed by Wooldridge (2010).The AIPW estimator augments the IPW estimator with a correction term. The term removes the bias if the treatment model is wrong and the outcome model is correct, and the term goes to 0 if the treatment model is correct and the outcome model is wrong. The IPWRA estimator uses IPW probability weights when performing RA. The weights do not affect the accuracy of the RA estimator if the treatment model is wrong and the outcome model is correct. The weights correct the RA estimator if the treatment model is correct and the outcome model is wrong. We now use teffects aipw to estimate the ATE:		*/
		
		//IPWRA
	
        xi: teffects ipwra (mcp relig v106 v025 v013 v190 v151 v136 fp_know_sum married ) (FPsource2 relig v106 v025 v013 v190 v151 v136 fp_know_sum married ) 
		outreg2 using mcp_fp.xls,e(N r2 p) append ctitle(ipwra mcp)
		
		
		
	**Measure of inequality 
	  lorenz estimate FPsource2, pvar(v190) over(v025)
	  lorenz g
	  concindc FPsource2, welf(v190)
	  
	  lorenz estimate FPsource2, pvar(v190) over(v025)
	  lorenz g
	  lorenz graph, overlay aspectratio(1) xlabel(, grid)
	

 ** how modern contraceptive and private sectors are distributed accross households 
	  lorenz FPsource2, pvar(v190) over(v025) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))
	  
	  lorenz FPsource2, pvar(v190) over(v025) graph(aspectratio(1) xlabels(, grid) overlay legend(cols(1)) noci title("") labels("") lpattern(dash_dot) xtitle("") ytitle(""))
	  
	  **cixr v190 FPsource2
	 
	  lorenz estimate FPsource2, pvar(v106)
	  lorenz g
	  concindc FPsource2, welf(v106)
	  lorenz FPsource2, pvar(v106) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))
	  
	  
	  	  
	  lorenz estimate FPsource2, pvar(v025)
	  lorenz g
	  concindc FPsource2, welf(v205)
	  lorenz FPsource2, pvar(v205) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))
	  
	  
	  
	  lorenz estimate FPsource2, pvar(v013)
	  lorenz g
	  concindc FPsource2, welf(v103)
	  lorenz FPsource2, pvar(v103) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))	  
	  lorenz FPsource2, pvar(v103) over(v025) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))	   
		  
	  lorenz estimate FPsource2, pvar(married)
	  lorenz g
	  concindc FPsource2, welf(married)
	  lorenz FPsource2, pvar(married) graph(overlay aspectratio(1) xlabels(, grid) legend(cols(1))ciopts(recast(rline) lp(dash)))	
	  
	  
	 
	*Multivariate decomposion analysis
	
	*gen year201821
	gen year201900=.
	replace year201900=0 if year==2000
	replace year201900=1 if year==2019
	tab year201900

	
	
	mvdcmp year201900: logit mcp 
	
	mvdcmp year201821: logit mcp $covariates
	
	
			