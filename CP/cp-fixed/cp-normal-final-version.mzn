%" The VLSI Design Problem , Combinatorial Decision Making and Optimization Course
%%%%%%%%%%"Team memebers"%%%%%%%%%
% vida.zahedi@studio.unibo.it 
% samral.tahirli@studio.unibo.it 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "cumulative.mzn";
include "diffn.mzn";
% Define the pieces and their respective widths and heights
int: Number;
set of int: PIECES = 1..Number;
array[PIECES] of int: Widths;
array[PIECES] of int: Heights;

% Define the plate's width and the height bounds
int: Width;
int: MaxHeight = sum(Widths);
int: MinHeight = (sum(i in PIECES)(Widths[i] * Heights[i])) div Width;

% Define the coordinates for each piece on the plate
array[PIECES] of var 0..Width: x_ith;
array[PIECES] of var 0..MaxHeight: y_ith;

% Define the optimal height variable and constraints
var MinHeight..MaxHeight: OptHeight;
constraint OptHeight = max([Heights[i] + y_ith[i] | i in PIECES]);
constraint cumulative(y_ith, Heights, Widths, Width);
constraint cumulative(x_ith, Widths, Heights, MaxHeight);
constraint diffn(x_ith, y_ith, Widths, Heights);
constraint max(i in PIECES)(Widths[i] + x_ith[i]) <= Width;
constraint max(i in PIECES)(Heights[i] + y_ith[i]) <= OptHeight;

% Add a constraint to place the largest piece first
array[PIECES] of int: area = [Widths[i]*Heights[i] | i in PIECES];
array[PIECES] of var PIECES: order;
constraint forall(i in 2..Number)(area[order[i-1]] >= area[order[i]]);
constraint x_ith[order[1]] = 0 /\ y_ith[order[1]] = 0;
constraint forall(i in 2..Number) (x_ith[order[i-1]] <= x_ith[order[i]] /\ y_ith[order[i-1]] <= y_ith[order[i]]);
solve minimize OptHeight;
output [    "x coordinates := ", show(x_ith), "\n",    "y coordinates:= ", show(y_ith), "\n",    "OptHeight := ", show(OptHeight), "\n",];

