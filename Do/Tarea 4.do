clear all
cd "C:\Users\Dac12\Desktop\Causal Inference BSSE\RDD\Data"
use https://github.com/scunning1975/causal-inference-class/raw/master/hansen_dwi, clear
save Hansen_dwi.dta, replace


/////////////////////////////////////Run from here
clear all
cd "C:\Users\Dac12\Desktop\Causal Inference BSSE\RDD\Data"
use Hansen_dwi.dta, replace
//3. Generating dummy for treatment
gen D=1 if bac1>= 0.08 
	replace D=0 if D==.

//4. 
rddensity bac1, all c(0.08) plot
outreg2 rddensity bac1, all c(0.08) plot save("McCraryTest.doc")
asdoc rddensity bac1, all c(0.08) plot save("McCraryTest") replace


net install DCdensity, from(http://eml.berkeley.edu/~jmccrary/DCdensity/)
DCdensity bac1, c(0.08) 

hist bac1, freq discrete xline(0.08)
kdensity bac1, xline(0.08)



//5. Balance Test
gen Dbac1=D*bac1

reg male D bac1 Dbac1, r
	outreg2 using "BalanceCheck.doc", replace title("Table 2. Regression Discontinuity Estimates for the Effect of Exceeding BAC Thresholds on Predetermined Characteristics")
reg white D bac1 Dbac1, r
	outreg2 using "BalanceCheck.doc", append
reg aged D bac1 Dbac1, r
	outreg2 using "BalanceCheck.doc", append
reg acc D bac1 Dbac1, r
	outreg2 using "BalanceCheck.doc", append

	
//6. Nonparametric Hist

cmogram male bac1, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) title("Panel A1. Male")
cmogram male bac1, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) title("Panel A2. Male")

cmogram white bac1, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) title("Panel B1. White")
cmogram white bac1, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) title("Panel B2. White")

cmogram aged bac1, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002))title("Panel C1. Age")
cmogram aged bac1, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) title("Panel C2. Age")

cmogram acc bac1, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) title("Panel D1. Accidents")
cmogram acc bac1, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) title("Panel D2. Accidents")

cd "C:\Users\Dac12\Desktop\Causal Inference BSSE\RDD\Figures"
graph combine "A1Male" "A2Male" "B1White" "B2White" "C1Age" "C2Age" "D1Acc" "D2Acc", title("Figure 4. Balance Analysis")

graph combine "A1Male" "B1White" "C1Age" "D1Acc" , title("Figure 4A. Balance Analysis. Linear Fit")
graph combine "A2Male" "B2White" "C2Age" "D2Acc" , title("Figure 4B. Balance Analysis. Quadratic Fit")

//7.
gen bac1sq=bac1^2
gen Dbac1sq=bac1sq*D

**"Table 3—Regression Discontinuity Estimates for the Effect of Exceeding the 0.08 BAC Threshold on Recidivism"

reg recidivism D bac1 male white aged acc if bac1>=0.03 & bac1<=0.13, r
	outreg2 using "RD.doc", replace title("Panel A") 
reg recidivism D bac1 Dbac1 male white aged acc if bac1>=0.03 & bac1<=0.13, r
	outreg2 using "RD.doc", append 
reg recidivism D bac1 Dbac1 bac1sq Dbac1sq male white aged acc if bac1>=0.03 & bac1<=0.13, r
	outreg2 using "RD.doc", append 

reg recidivism D bac1 male white aged acc if bac1>=0.055 & bac1<=0.105, r
	outreg2 using "RD.doc", append 
reg recidivism D bac1 Dbac1 male white aged acc if bac1>=0.055 & bac1<=0.105, r
	outreg2 using "RD.doc", append 
reg recidivism D bac1 Dbac1 bac1sq Dbac1sq male white aged acc if bac1>=0.055 & bac1<=0.105, r
	outreg2 using "RD.doc", append 
	
//8.

cmogram recidivism bac1 if bac1<0.15, cut(0.08) scatter line(0.08) lfitci histopts(width(0.002)) title("Panel A. Linear Fit")
cmogram recidivism bac1 if bac1<0.15, cut(0.08) scatter line(0.08) qfitci histopts(width(0.002)) title("Panel B. Quatratic Fit")
reg recidivism D bac1 Dbac1 bac1sq Dbac1sq male white aged acc if bac1<0.15, r
	outreg2 using "RD2.doc", replace
cd "C:\Users\Dac12\Desktop\Causal Inference BSSE\RDD\Figures"
graph combine "LFRecid" "QFRecid", title("Figure 5. Recidivism")









