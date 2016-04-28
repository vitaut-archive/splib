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

# Scenario probabilities.
param P{1..NumScen};

function random;
demand{j in Routes}: random(
  {s in 1..NumScen} P[s], RandomDemand[j], {s in 1..NumScen} Demand[j, s]);

data;

# The number of independent scenarios.
param NumScen := 5;

param P :=
  1  0.0668
  2  0.2417
  3  0.3830
  4  0.2417
  5  0.0668;

param Demand (tr):
        1        2 :=
  1   988.16  1428.94
  2   989.98  1439.86
  3   994.92  1469.54
  4  1008.37  1550.22
  5  1044.92  1769.54;
