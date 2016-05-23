# Common data for forest planning problem instances

data;

param T := 7;
param NumAgeGroups := 8;

# Use more exact value to match the data in stocfor1.cor.
param DiscountFactor := 0.9050629;

param PurchaseLower := 0.9;
param PurchaseUpper := 1.1;

# InitialArea divided by 1000 to match the SMPS problem.
param:
      Value    InitialArea  Yield :=
  1  320.3417     0.241        0
  2  356.1874     0.125        0
  3  398.4370     1.404       16
  4  448.2349     2.004      107
  5  506.9294     9.768      217
  6  564.9294    16.385      275
  7  587.9294     2.815      298
  8  595.9294    61.995      306;
