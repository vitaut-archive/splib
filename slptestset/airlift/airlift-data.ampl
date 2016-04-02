# Data for the airlift problem

set Routes := 1 2;

param: AircraftTypes: MaxHours :=
             1          7200
             2          7200;

param: Hours Capacity AssignCost :=
  1 1    24     50       7200
  1 2    14     75       6000
  2 1    49     20       7200
  2 2    29     20       4000;

param: ContractedCost UnusedCost :=
  1          500          0
  2          250          0;

param: SwitchedHours SwitchCost :=
  1 1 2     19          7000
  1 2 1     29          8200
  2 1 2     36          5500
  2 2 1     56          8700;

param NumScen := 25;
