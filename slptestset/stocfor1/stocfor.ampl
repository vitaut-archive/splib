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

# A set of age classifications of equal length (e.g. 20 years).
# Each portion of the forest is placed into one of the classes,
# according to the age of the trees within.
set AgeClasses;

# The future planning horizon is divided into T rounds, each with a time length
# equal to that of each age classification. That is, in one time round, any
# trees that are not destroyed or harvested will move to the next age class.
param T >= 0;

# The total amount of area of the forest in each age class in round t (s_t).
param Area{AgeClasses, t in 1..T} >= 0;

# The area of the forest harvested in each age class in round t (x_t).
var harvested{c in AgeClasses, t in 1..T} >= 0 <= Area[c, t];

# A random proportion of the area of unharvested trees
# Area[c, t] - harvested[c, t] destroyed by fire in round t (P_t).
param Destroyed{c in AgeClasses, t in 1..T} >= 0 <= 1;

# The yield in units currency / hectacre of forest harvested (y).
param Yield{c in AgeClasses} >= 0;

# Smallest fraction of the purchasing volume by which the latter can change
# from one time period to the next (\alpha).
param PurchaseLower >= 0;

# Largest fraction of the purchasing volume by which the latter can change
# from one time period to the next (\beta).
param PurchaseUpper >= 0;

# The purchasing volume in currency units.
var purchase{t in 1..T} = sum{c in AgeClasses} Yield[c, t] * harvested[c, t];

# All harvested and burned areas are immediately replanted, and therefore wind
# up in age class 1.
s.t. replant{t in 1..T - 1}:
  Area[1, t + 1] =
    sum{c in AgeClasses}
      (Destroyed[c, t] * (Area[c, t] - harvested[c, t]) + harvested[c, t]);

# The material balance constraint.
s.t. balance{c in AgeClasses, t in 1..T - 1: c != 1}:
  Area[c, t + 1] = (1 - Destroyed[c, t]) * (Area[c, t] - harvested[c, t]);

# Constraints purchase_decrease and purchase_increase might represent limits
# on how fast the timber industry can change its purchasing volume from one
# time period to the next.
s.t. purchase_lower{t in 2..T}:
  purchase[t] >= PurchaseLower * purchase[t - 1];
s.t. purchase_upper{t in 2..T}:
  purchase[t] <= PurchaseUpper * purchase[t - 1];

# TODO
