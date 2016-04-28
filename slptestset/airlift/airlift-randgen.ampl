# Airlift operation scheduling problem with a data set generated
# randomly using the method from randgen.f.
#
# The original comment from randgen.f:
#
#   This file makes (non-block) indep vars, which is not what Midler
#   and Wollmer did, I think.  But it makes an interesting case, since
#   simplex/simplex takes 14 iterations
#
#   This file generates the stoch file of the airlift problem given
#   by Midler, J.L. and Wollmer, R.D., Stochastic programming models
#   for scheduling airlift operations, Naval Research Logistics Quarterly,
#   16 (1969), 315--330.
#
#   I had to guess what they meant by mu_1 = 1000, sigma_1 = 50,
#   mu_2 = 1500, sigma_2 = 300.  The usual interpretation is that
#   mu and sigma are properties of the normal distribution from which
#   the lognormal distribution is derived.  However, this gives 
#   unreasonably high values (~10^500).  So, I assumed they meant for
#   the expected value of the lognormal distribution to be mu and 
#   the std. dev. of the lognormal dist. to be sigma.
#
#   For a lognormal distribution derived from an N(mu_n, sigma_n) 
#   distribution, the mean is e^{mu_n + sigma_n^2/2}, and the variance
#   is e^{2 mu_n + sigma_n^2}(e^{sigma_n^2} - 1).  So, using mu_n = 0.0
#   and sigma_n = 1.0, to get a lognormal with mean mu_1 and std. dev. 
#   sigma_1, if X1 ~ N(0,1),
#
#   LX1 = (((exp(X1) - exp(1/2))/(e^2 - 1))* sigma_1) + mu_1.

model airlift.ampl;
data airlift-data.ampl;

function random;
demand{j in Routes}: RandomDemand[j] = random({s in 1..NumScen} Demand[j, s]);

let NumScen := 26;

param mu = 0;
param sigma = 1;
param Lmu default 1000;
param Lsigma default 50.0;
param Cmu = exp(mu + sigma^2 / 2);
param Csigma = sqrt(exp(2 * mu + sigma^2) * (exp(sigma^2) - 1));
param variance;
param V{1..2};
param W;
param X{1..2};
param indices{1..2};
param carry default 0;
param count;
param seeds{1..24};

data;

param indices := 1 24 2 10;

# Seeds converted to single precision for compatibility with randgen.f.
param seeds :=
  1 0.880441784859  2 0.269436508417  3 0.036768101156  4 0.406869888306
  5 0.455405205488  6 0.288063496351  7 0.146340802312  8 0.239033296704
  9 0.640729784966 10 0.175528302789 11 0.713294029236 12 0.491304308176
 13 0.297991812229 14 0.139685794711 15 0.358952790499 16 0.525480926037
 17 0.985774874687 18 0.461212694645 19 0.219644099474 20 0.784835100174
 21 0.409610003233 22 0.980735301971 23 0.268991500139 24 0.514035701752;

# The outer loop allows for doing more than one run with different seeds.
for {m in Routes} {
  if m = 2 then {
    let Lmu := 1500;
    let Lsigma := 300;
  }
  let count := 0;
  repeat while count < NumScen {
    # Compute two pseudo-random numbers U(0,1) using the algorithm from the
    # uniran function in randgen.f and store them in V[i].
    for {k in 1..2} {
      let V[k] := seeds[indices[1]] - seeds[indices[2]] - carry;
      if V[k] < 0 then {
         let V[k] := V[k] + 1;
         let carry := 1 / 16777216;
      } else {
         let carry := 0;
      }
      let seeds[indices[1]] := V[k];
      let{i in 1..2} indices[i] := 24 - (25 - indices[i]) mod 24;
    }

    let{k in 1..2} V[k] := 2 * V[k] - 1;
    let W := sum{k in 1..2} V[k]^2;
    if W < 1 then {
      let{k in 1..2} X[k] := mu + V[k] * sigma * sqrt(-2 * log(W) / W);
      let{k in 1..2}
        Demand[m, count + k] := ((X[k] - Cmu) / Csigma) * Lsigma + Lmu;
      let count := count + 2;
    }
  }
  #print 'Sample mean for run', m, 'is',
  #      sum{s in 1..NumScen} Demand[m, s] / NumScen; # Xbar
  #let variance :=
  #  sum{s in 1..NumScen} (Demand[m, s] - 1003.017)^2  / (NumScen - 1);
  #print 'Sample Variance for run', m, 'is', variance; # Sample variance (SV)
  #print 'Sample sigma for run', m, 'is', sqrt(variance);
}
