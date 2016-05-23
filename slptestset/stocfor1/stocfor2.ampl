# Forest planning problem with the second data set

model stocfor.ampl;
data stocfor-data.ampl;

param NumScen = 2;
param P{1..NumScen};
param FireRateData{1..NumScen};

function random;
demand{t in 2..T}: random(
  {s in 1..NumScen} P[s],
  {g in AgeGroups} (FireRate[g, t], {s in 1..NumScen} FireRateData[s]));

let{g in AgeGroups, t in 2..T + 1} area[g, t].stage := 2;
let{g in AgeGroups, t in 2..T} harvested[g, t].stage := 2;

data;

param:
       P    FireRateData :=
  1  0.6912    1
  2  0.3088    0.79732;
