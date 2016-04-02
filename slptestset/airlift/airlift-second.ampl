# Airlift operation scheduling problem with the second data set
#
# Solution:
# expected_cost = 269666
# flights :=
# 1 1   19.8984
# 1 2   20.6696
# 2 1    0
# 2 2    0
# thetastar = 2379.44

model airlift.ampl;
data airlift-data.ampl;

# Independent scenarios.
set IndepScen;
param IndepP{IndepScen};
param IndepDemand{j in Routes, s in IndepScen};

data;

param:
  IndepScen: IndepP :=
      1      0.0668
      2      0.2417
      3      0.3830
      4      0.2417
      5      0.0668;

param IndepDemand (tr):
           1        2 :=
  1      988.16  1428.94
  2      989.98  1439.86
  3      994.92  1469.54
  4     1008.37  1550.22
  5     1044.92  1769.54;

let NumScen := card(IndepScen) ^ 2;

param index;
for {i in IndepScen, j in IndepScen} {
  let index := (i - 1) * card(IndepScen) + j;
  let P[index] := IndepP[i] * IndepP[j];
  let Demand[1, index] := IndepDemand[1, i];
  let Demand[2, index] := IndepDemand[2, j];
}
