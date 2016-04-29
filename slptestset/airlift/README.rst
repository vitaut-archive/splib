Airlift scheduling problem
--------------------------

* ``airlift.ampl``: model file
* ``airlift-data.ampl``: non-random data
* ``airlift-first.ampl``: airlift problem with the first data set
* ``airlift-second.ampl``: airlift problem with the second data set
* ``airlift-randgen.ampl``: airlift problem with a randomly generated data set

Usage::

  ampl: model arlift-first.ampl
  ampl: write gtest;

Replace ``airlift-first.ampl`` with ``airlift-second.ampl`` or ``airlift-randgen.ampl``
to use a different data set. ``airlift-randgen.ampl`` accepts option ``rangen_method``
with takes one of the following values:

1. Generate block independent random variables/parameters (default)
2. Generate (non-block) indepependent random variables/parameters

Example::

  ampl: option randgen_method 2;
  ampl: model arlift-randgen.ampl
  ampl: write gtest;
