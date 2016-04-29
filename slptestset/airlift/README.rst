Airlift operation scheduling problem
------------------------------------

* `airlift.ampl <airlift.ampl>`_: model file
* `airlift-data.ampl <airlift-data.ampl>`_: non-random data
* `airlift-first.ampl <airlift-first.ampl>`_: airlift problem with the first data set
* `airlift-second.ampl <airlift-second.ampl>`_: airlift problem with the second data set
* `airlift-randgen.ampl <airlift-randgen.ampl>`_: airlift problem with a randomly generated data set

Usage::

  ampl: model arlift-first.ampl
  ampl: write gtest;

Replace ``airlift-first.ampl`` with ``airlift-second.ampl`` or ``airlift-randgen.ampl``
to use a different data set. ``airlift-randgen.ampl`` accepts option ``randgen_method``
with takes one of the following values:

1. Generate block independent random variables/parameters (default)
2. Generate (non-block) indepependent random variables/parameters

Example::

  ampl: option randgen_method 2;
  ampl: model arlift-randgen.ampl
  ampl: write gtest;
