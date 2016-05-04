model stocfor.ampl;

data;

param T := 7;
param NumAgeGroups := 8;
param DiscountFactor := 0.905;
param PurchaseLower := 0.9;
param PurchaseUpper := 1.1;

param:
      Value    InitialArea  Yield :=
  1  320.3417      241         0
  2  356.1874      125         0
  3  398.4370     1404        16
  4  448.2349     2004       107
  5  506.9294     9768       217
  6  564.9294    16385       275
  7  587.9294     2815       298
  8  595.9294    61995       306;

let{g in AgeGroups, t in 1..T} FireRate[g, t] := 0.06258;

option solver cplex;
solve;
