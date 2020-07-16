pressEnterToContinue :- get_char(_).

replace( [L|Ls] , 1 , Y , Z , [R|Ls] ) :-
  replace_column(L,Y,Z,R).
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :-
  X > 0 ,
  X1 is X-1 ,
  replace( Ls , X1 , Y , Z , Rs ).

replace_column( [_|Cs] , 1 , Z , [Z|Cs] ) .
replace_column( [C|Cs] , Y , Z , [C|Rs] ) :-
  Y > 0 ,
  Y1 is Y-1 ,
  replace_column( Cs , Y1 , Z , Rs ).

% get piece from board by its coordinates
getPiece(Board,X,Y,Out):-
	isPlacementValid(X,Y,Res),
	Res is 1,
	Xn is X-1,
	Yn is Y-1,
	Xc is 0,
	Yc is 0,
	getPieceRow(Board,Xn,Yn,IntermediateOutput,Xc,Yc),
	Out is IntermediateOutput.

getPiece(_, _, _, _):-
	fail.

getPieceRow([Head|_], X, Y, O, Xc, Yc):-
	Xc is X,
	!,
	getPieceCol(Head, Y, Yc, Out),
	O is Out.

getPieceRow([_|Tail], X, Y, O, Xc, Yc):-
	Xc2 is Xc + 1,
	getPieceRow(Tail, X, Y, O, Xc2, Yc).

getPieceCol([Head|_], Y, Yc, Out):-
	Yc is Y,
	!,
	Out is Head.

getPieceCol([_|Tail], Y, Yc, Out):-
	Yc2 is Yc + 1,
	getPieceCol(Tail, Y, Yc2, Out).

cls :- write('\33\[2J').

or(A, B, C, D):- A; B; C; D.
or(A, B):- A; B.


change_player_color(5, 1).
change_player_color(6, 2).

translateInternalBoardColor(Choice, Color) :-
  Choice is 1,
  !,
  Color is 5.

translateInternalBoardColor(Choice, Color) :-
  Choice is 2,
  !,
  Color is 6.


translateInternalBoardColor(_, Color) :-
    Color is 0.

validate_color_choice(Board, Choice):-
    pieces_remaining(Board, _, Purple),
    Choice is 1,
    Purple > 0.

validate_color_choice(Board, Choice):-
    pieces_remaining(Board, Orange, _),
    Choice is 2,
    Orange > 0.

validate_color_choice(_, _):-
    fail.
