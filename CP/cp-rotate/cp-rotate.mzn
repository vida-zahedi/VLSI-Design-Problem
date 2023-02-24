%" The VLSI Design Problem  Rotation, Combinatorial Decision Making and Optimization Course

%%%%%%%%%%"Team memebers"%%%%%%%%%

% vida.zahedi@studio.unibo.it 
% samral.tahirli@studio.unibo.it 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&
include "cumulative.mzn";
include "diffn.mzn";

% Set of pieces
set of int: PIECES = 1..Number;

% Rotation variable 
array[PIECES] of var bool: rotation;

% Inputs of the model
int: Width;
int: Number;
array[PIECES] of int: Widths;
array[PIECES] of int: Heights;

% Defining the lower and upper bound for height
int: max_height = sum(Widths);
int: min_height = (sum(i in PIECES)(Widths[i] * Heights[i])) div Width;

% Defining the coordinations for each piece on the plate
array[PIECES] of var 0..Width: x_ith;
array[PIECES] of var 0..max_height: y_ith;

% Rotation constraint
array[PIECES] of var 0..Width: widths_r; 
array[PIECES] of var 0..max_height: heights_r;

constraint forall(i in PIECES)( (rotation[i] -> widths_r[i] = Heights[i]) /\ (not(rotation[i]) -> widths_r[i] = Widths[i]) );

% Defining the constraints
var min_height..max_height: opt_height;
constraint opt_height = max([Heights[i] + y_ith[i] | i in PIECES]);
constraint cumulative(y_ith, Heights, Widths, Width);
constraint cumulative(x_ith, Widths, Heights, max_height);
constraint diffn(x_ith, y_ith, Widths, Heights);
constraint max(i in PIECES)(widths_r[i] + x_ith[i]) <= Width;
constraint max(i in PIECES)(heights_r[i] + y_ith[i]) <= opt_height;

% Solving the model
solve minimize opt_height;

output [
    "x coordinates := ", show(x_ith), "\n",
    "y coordinates:= ", show(y_ith), "\n",
    "OptHeight := ", show(opt_height), "\n",
];