# Forest planning problem with the first data set

model stocfor.ampl;
data stocfor-data.ampl;

fix{g in AgeGroups, t in 1..T} FireRate[g, t] := 0.06258;
