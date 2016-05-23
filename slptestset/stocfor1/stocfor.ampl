# Forest planning stochastic programming model in AMPL
#
# The job of a long range forest planner is to decide what parts of the forest
# will be harvested when. Important criteria for such a decision are the age
# of the trees, and the likelihood that trees left standing will be destroyed by
# fire.
#
# References:
#
# 1. K. A. Ariyawansa and A. J. Felt. On a new collection of stochastic linear
#    programming test problems. Technical Report 4, Department of Mathematics,
#    Washington State University, Pullman, WA 99164, Apr. 2001.
#
# 2. H. I. Gassmann. Optimal harvest of a forest in the presence of uncertainty.
#    Canadian Journal of Forest Research, 19:1267–1274, 1989.
#
# AMPL coding by Victor Zverovich.

function expectation;
suffix stage IN;

# The number of age groups (K).
param NumAgeGroups;

# A set of age classifications of equal length (e.g. 20 years). Each portion
# of the forest is placed into one of the groups, according to the age of the
# trees within.
set AgeGroups = 1..NumAgeGroups;

# The future planning horizon is divided into T rounds, each with a time length
# equal to that of each age classification. That is, in one time round, any
# trees that are not destroyed or harvested will move to the next age group.
param T >= 0;

# The area of forest covered with timber in the different age groups at the
# beginning of time period 1.
param InitialArea{AgeGroups} >= 0;

# The total amount of area of the forest in each age group in round t (s_t).
var area{g in AgeGroups, t in 1..T + 1} >= 0 suffix stage t;

# The area of the forest harvested in each age group in round t (x_t).
var harvested{g in AgeGroups, t in 1..T} >= 0 suffix stage t;

# A random proportion of the area of unharvested trees
# area[g, t] - harvested[g, t] destroyed by fire in round t (P_t).
var FireRate{g in AgeGroups, t in 1..T} >= 0 <= 1;

# The yield in units currency / hectacre of forest harvested (y).
param Yield{AgeGroups} >= 0;

# Smallest fraction of the purchasing volume by which the latter can change
# from one time period to the next (\alpha).
param PurchaseLower >= 0;

# Largest fraction of the purchasing volume by which the latter can change
# from one time period to the next (\beta).
param PurchaseUpper >= 0;

# The purchasing volume in currency units.
var purchase{t in 1..T} = sum{g in AgeGroups} Yield[g] * harvested[g, t];

# Monetary values in future round t are discounted to current monetary scales
# by multiplying by DiscountFactor^(t - 1). For example, if each round is 20
# years long, for interest (or inflation) rate i, DiscountFactor = (1 - i)^20.
# Denoted by \delta in [1].
param DiscountFactor >= 0;

# The value of the trees standing after round T (v).
param Value{AgeGroups} >= 0;

# The amounts by which the purchasing volume goes below/above the soft limits.
var shortfall{2..T} >= 0;
var surplus{2..T} >= 0;

# Coefficient of the shortfall/surplus penalty term in the coefficient.
param Penalty default 50;

# Maximize the value of timber, both cut and remaining after round T.
maximize total_value:
  expectation(
    sum{t in 1..T} DiscountFactor^(t - 1) * purchase[t] +
    DiscountFactor^T *
      sum{g in AgeGroups} Value[g] * (area[g, T] - harvested[g, T]) -
    sum{t in 2..T}
      DiscountFactor^(t - 2) * Penalty * (shortfall[t] + surplus[t]));

s.t. initial_area{g in AgeGroups}: area[g, 1] = InitialArea[g];

s.t. harvest_limit{g in AgeGroups, t in 1..T}: harvested[g, t] <= area[g, t];

# All harvested and burned areas are immediately replanted, and therefore wind
# up in age group 1.
s.t. replant{t in 1..T}:
  area[1, t + 1] =
    sum{g in AgeGroups}
      (FireRate[g, t] * (area[g, t] - harvested[g, t]) + harvested[g, t]);

# The material balance constraint.
s.t. balance{g in 1..NumAgeGroups - 1, t in 1..T - 1}:
  area[g + 1, t + 1] = (1 - FireRate[g, t]) * (area[g, t] - harvested[g, t]) +
  if g == NumAgeGroups - 1 then
    (1 - FireRate[g + 1, t]) * (area[g + 1, t] - harvested[g + 1, t]);

# Constraints purchase_lower and purchase_upper might represent limits
# on how fast the timber industry can change its purchasing volume from one
# time period to the next.
s.t. purchase_lower{t in 2..T}:
  PurchaseLower * purchase[t - 1] - purchase[t] <= shortfall[t];
s.t. purchase_upper{t in 2..T}:
  purchase[t] - PurchaseUpper * purchase[t - 1] <= surplus[t];
