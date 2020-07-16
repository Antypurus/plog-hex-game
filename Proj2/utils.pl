board_size(H, Size) :-
  length(H, Size).

boarder_size(Size, BorderSize) :-
  Border1 is 5 * Size,
  Border2 is Size - 1,
  BorderSize is Border1 + Border2.

convert(0, ' ').
convert(1,'*').
convert(2,'?').
convert(3,'$').
convert(4,'+').
convert(5,'%').
convert(6,'#').
convert(7,'@').
convert(8,'=').

ite(If,Then,_):- If, !, Then.
ite(_,_,Else):- Else.

% if not instanciated it will give blank space
write_value(X, Val) :-
  ite(var(X), Val = ' ', Val = X).

pressEnterToContinue :- write('Press <Enter> to continue'), nl, nl,
get_char(_), !.

cls :- write('\33\[2J').

getPiece(Board,X,Y,Out):-
	Xn #= X-1,
	Yn #= Y-1,
	Xc #= 0,
	Yc #= 0,
	getPieceRow(Board,Xn,Yn,IntermediateOutput,Xc,Yc),
	Out #= IntermediateOutput.

getPiece(_, _, _, _):-
	fail.

getPieceRow([Head|_], X, Y, O, Xc, Yc):-
	Xc #= X,
	getPieceCol(Head, Y, Yc, Out),
	O #= Out.

getPieceRow([_|Tail], X, Y, O, Xc, Yc):-
	Xc2 #= Xc + 1,
	getPieceRow(Tail, X, Y, O, Xc2, Yc).

getPieceCol([Head|_], Y, Yc, Out):-
	Yc #= Y,
	Out #= Head.

getPieceCol([_|Tail], Y, Yc, Out):-
	Yc2 #= Yc + 1,
	getPieceCol(Tail, Y, Yc2, Out).

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
