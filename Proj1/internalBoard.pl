b([
	[1, 2, 3, 4],
	[5, 6, 7],
	[8, 9, 10, 11]
]).
% board stuff
internalBoard([
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[-1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1]
]).



initialState([
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[-1,-1, 1, 1, 1, 1, 1, 1, 1, 1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1]
]).

midState([
	[-1,-1,-1,-1, 1, 1, 1, 1, 2, 2,-1,-1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1, 1, 1, 1, 1, 1, 2, 2, 1,-1,-1],
	[-1, 1, 1, 1, 1, 1, 2, 3, 1, 1,-1],
	[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[-1,-1, 1, 1, 1, 2, 1, 1, 1, 1,-1,-1],
	[-1,-1,-1, 1, 1, 3, 3, 3, 1, 1,-1,-1,-1],
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1]
]).

finalState([
	[-1,-1,-1,-1, 1, 1, 1, 2, 2, 2,-1,-1,-1,-1],
	[-1,-1,-1, 1, 1, 1, 1, 1, 1, 1,-1,-1,-1],
	[-1,-1, 1, 1, 1, 1, 3, 2, 2, 1,-1,-1],
	[-1, 1, 1, 1, 1, 3, 2, 3, 1, 1,-1],
	[ 1, 1, 1, 1, 2, 1, 1, 1, 1, 1],
	[-1, 1, 1, 1, 1, 1, 1, 1, 1, 1,-1],
	[-1,-1, 1, 1, 2, 2, 1, 1, 1, 1,-1,-1],
	[-1,-1,-1, 1, 1, 3, 3, 3, 3, 1,-1,-1,-1],
	[-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,-1,-1,-1,-1]
]).

printAllBoard(_,0).
printAllBoard(X, N) :-
	printBoard(X),
	N1 is N-1,
	printAllBoard(X, N1).

symbol(-1,S) :- S=' '.
symbol(1,S) :- S='#'.
symbol(2,S) :- S='X'.
symbol(3,S) :- S='O'.

printBoard([]).
printBoard([H|T]) :-
  printLine(H),
  nl,
  printBoard(T).

printLine([]).
printLine([H|T]) :-
symbol(H,S),
write(S),
printLine(T).

initialRepresentation(_):-
	initialState(X),
	printBoard(X).

midRepresentation(_):-
	midState(X),
	printBoard(X).

finalRepresentation(_):-
	finalState(X),
	printBoard(X).

representation(X):-
	write('\n\nInitial representation:\n'),
	initialRepresentation(X),
	write('\n\nMid representation:\n'),
	midRepresentation(X),
	write('\n\nFinal representation:\n'),
	finalRepresentation(X).

display_game(Board,Player):-
	printBoard(Board).

% turn stuff
player_message(0, S) :-
	S = 'Current Turn: Orange or Player 1' .
player_message(1, S) :-
	S = 'Current Turn: Purple or Player 2' .

player(0, S) :-
	S = 'Orange' .
player(1, S) :-
	S = 'Purple' .
player('Orange', S) :-
	S = 0 .
player('Purple', S) :-
	S = 1 .

%counts turns
turn_pass(I, O) :-
	O is I + 1 .

% gives us the player for the current turn through O, I is the current turn
turn_translate(I, O) :-
	0 is I mod 2 ,
	! ,
	O = 1 .
turn_translate(I, O) :-
	O = 0 .

% current player, returns next player through S.
turn(0, S) :-
	S = 1 ,
	player_message(S, L) ,
	write(L) .

turn(1, S) :-
	S = 0 ,
	player_message(S, L) ,
	write(L) .

%count remaining pieces stuff
pieces_remaining(Board) :-
	pieces_remaining(Board, O, P) ,
	write('Remaining Orange pieces:') ,
	write(O) ,
	nl ,
	write('Remaining Purple pieces:') ,
	write(P) ,
	nl .

pieces_remaining(Board, O, P) :-
	A = 25 ,
	B = 25 ,
	pieces_remaining_board(Board, A, B, O, P) .

pieces_remaining_board([H|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	pieces_remaining_line(H, InputOrange, InputPurple, IntermediateOrange, IntermediatePurple) ,
	pieces_remaining_board(T, IntermediateOrange, IntermediatePurple ,OutputOrange, OutputPurple) .

pieces_remaining_board([], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	OutputOrange is InputOrange ,
	OutputPurple is InputPurple .

pieces_remaining_line([H|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	H is 2 ,
	! ,
	IntermediatePurple is InputPurple - 1 ,
	IntermediateOrange is InputOrange ,
	pieces_remaining_line(T, IntermediateOrange, IntermediatePurple, OutputOrange, OutputPurple) .

pieces_remaining_line([H|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	H is 3 ,
	! ,
	IntermediateOrange is InputOrange - 1 ,
	IntermediatePurple is InputPurple ,
	pieces_remaining_line(T, IntermediateOrange, IntermediatePurple, OutputOrange, OutputPurple) .

pieces_remaining_line([H|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	pieces_remaining_line(T, InputOrange, InputPurple, OutputOrange, OutputPurple) .

pieces_remaining_line([], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	OutputOrange is InputOrange ,
	OutputPurple is InputPurple .

%piece():-
%	piece(A,B).

piece(A,B) :-
	read(A),
	read(B).

addPieceRow([_|T], 1, X, [X|T]).
addPieceRow([H|T], C, X, [H|R]) :-
	C > 0,
	C1 is C-1,
	addPieceRow(T, NI, X, R),
	!.
addPieceRow(L, _, _, L).

getRow(X, R, 0) :-
	write(R).
getRow([H|T], Row, N) :-
	N > 0 ,
	N1 is N - 1 ,
	getRow(T, H, N1).

% Não consegui fazer esta parte. O quarto argumento é a nova board.
addPiece(Board, R, C, V, [H|T]) :-
	getRow(Board, Row, R),
	addPieceRow(Row, C, V, NewRow).


% calculate neighboring coordinates
getNeighborhood(X,Y,Output):-
	X is 5,
	!,
	Xp1 is X+1,
	Xm1 is X-1,
	Yp1 is Y+1,
	Ym1 is Y-1,
	Output=[[Xm1,X,X,Xp1,Xm1,Xp1],[Y,Ym1,Yp1,Y,Ym1,Ym1]].

getNeighborhood(X,Y,Output):-
	X > 5,
	!,
	Xp1 is X+1,
	Xm1 is X-1,
	Yp1 is Y+1,
	Ym1 is Y-1,
	Output=[[Xm1,X,X,Xp1,Xm1,Xp1],[Y,Ym1,Yp1,Y,Yp1,Ym1]].

getNeighborhood(X,Y,Output):-
	X < 5,
	!,
	Xp1 is X+1,
	Xm1 is X-1,
	Yp1 is Y+1,
	Ym1 is Y-1,
	Output=[[Xm1,X,X,Xp1,Xm1,Xp1],[Y,Ym1,Yp1,Y,Ym1,Yp1]].

or(A,B):-A;B.

isPlacementValid(X,Y,Result):-
	or(X is 1,X is 9),
	Y>0,
	Y<7,
	Result is 1.

isPlacementValid(X,Y,Result):-
	or(X is 2,X is 8),
	Y>0,
	Y<8,
	Result is 1.

isPlacementValid(X,Y,Result):-
	or(X is 3,X is 7),
	Y>0,
	Y<9,
	Result is 1.

isPlacementValid(X,Y,Result):-
	or(X is 4,X is 6),
	Y>0,
	Y<10,
	Result is 1.

isPlacementValid(X,Y,Result):-
	or(X is 5,X is 5),
	Y>0,
	Y<11,
	Result is 1.

isPlacementValid(_,_,Result):-
	Result is 0.


getPiece(Board,X,Y,Out):-
	Xn is X-1,
	Yn is Y-1,
	Xc is 0,
	Yc is 0,
	getPieceRow(Board,Xn,Yn,IntermediateOutput,Xc,Yc),
	Out is IntermediateOutput.

getPieceRow([Head|Tail],X,Y,O,Xc,Yc):-
	Xc is X,
	!,
	getPieceCol(Head,Y,Yc,Out),
	O is Out.

getPieceRow([Head|Tail],X,Y,O,Xc,Yc):-
	Xc2 is Xc + 1,
	getPieceRow(Tail,X,Y,O,Xc2,Yc).

getPieceCol([Head|Tail],Y,Yc,Out):-
	Yc is Y,
	!,
	Out is Head.

getPieceCol([Head|Tail],Y,Yc,Out):-
	Yc2 is Yc+1,
	getPieceCol(Tail,Y,Yc2,Out).


divide([Head|Tail],Ret1,Ret2):-
	Ret1 = Head,
	divide(Tail,Ret2).

divide([Head|Tail],Ret):-
	Ret = Head.

%get piece grouping
getPieceGrouping(Board,X,Y,Output):-
	getPiece(Board,X,Y,Val),
	Counter is 1,
	getPieceGroupingForColorStart(Board,X,Y,Val,[(X,Y)],_,Counter,IntermediateOutput),
	Output is IntermediateOutput.

getPieceGroupingForColorStart(Board,X,Y,Expected,VisitedGroup,OutVisited,Counter,Output):-
	getNeighborhood(X,Y,Neighborhood),
	divide(Neighborhood,Nx,Ny),
	write(Neighborhood),
	nl,
	getPieceGroupingForColor(Board,Nx,Ny,Expected,VisitedGroup,OutVisitedGroup,Counter,Out),
	OutVisited = OutVisitedGroup,
	Output is Out.

getPieceGroupingForColor(Board,[HeadX|TailX],[HeadY|TailY],Expected,VisitedGroup,OutVisitedGroup,Counter,Output):-
	\+member((HeadX,HeadY), VisitedGroup),
	isPlacementValid(HeadX,HeadY,Validity),
	Validity is 1,
	getPiece(Board,HeadX,HeadY,PieceVal),
	PieceVal is Expected,
	!,
	NewCounter is Counter + 1,
	append(VisitedGroup,[(HeadX,HeadY)],NewVisitedGroup),
	getPieceGroupingForColorStart(Board,HeadX,HeadY,Expected,NewVisitedGroup,VisitedGroup2,NewCounter,Result),
	getPieceGroupingForColor(Board,TailX,TailY,Expected,VisitedGroup2,VisitedGroup3,Result,Out),
	OutVisitedGroup = VisitedGroup3,
	Output is Out.
	
getPieceGroupingForColor(Board,[HeadX|TailX],[HeadY|TailY],Expected,VisitedGroup,OutVisitedGroup,Counter,Output):-
	\+member((HeadX,HeadY), VisitedGroup),
	isPlacementValid(HeadX,HeadY,Validity),
	Validity is 1,
	append(VisitedGroup,[(HeadX,HeadY)],NewVisitedGroup),
	getPieceGroupingForColor(Board,TailX,TailY,Expected,NewVisitedGroup,VisitedGroup2,Counter,Out),
	OutVisitedGroup = VisitedGroup2,
	Output is Out.

getPieceGroupingForColor(Board,[HeadX|TailX],[HeadY|TailY],Expected,VisitedGroup,OutVisitedGroup,Counter,Output):-
	getPieceGroupingForColor(Board,TailX,TailY,Expected,VisitedGroup,VisitedGroup2,Counter,Out),
	OutVisitedGroup = VisitedGroup2,
	Output is Out.

getPieceGroupingForColor(Board,[],[],Expected,VisitedGroup,OutVisitedGroup,Counter,Output):-
	OutVisitedGroup = VisitedGroup,
	Output is Counter.

getPieceGroupingForColor(Board,[HeadX|TailX],[HeadY|TailY],Expected,VisitedGroup,OutVisitedGroup,Counter,Output):-
	OutVisitedGroup = VisitedGroup,
	Output is Counter.

