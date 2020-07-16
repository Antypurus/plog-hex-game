
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
	H is 5,
	! ,
	IntermediatePurple is InputPurple - 1 ,
	IntermediateOrange is InputOrange ,
	pieces_remaining_line(T, IntermediateOrange, IntermediatePurple, OutputOrange, OutputPurple) .

pieces_remaining_line([H|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	H is 6,
	! ,
	IntermediateOrange is InputOrange - 1 ,
	IntermediatePurple is InputPurple ,
	pieces_remaining_line(T, IntermediateOrange, IntermediatePurple, OutputOrange, OutputPurple) .

pieces_remaining_line([_|T], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	pieces_remaining_line(T, InputOrange, InputPurple, OutputOrange, OutputPurple) .

pieces_remaining_line([], InputOrange, InputPurple, OutputOrange, OutputPurple) :-
	OutputOrange is InputOrange ,
	OutputPurple is InputPurple .


% calculate neighboring coordinates
getNeighborhood(X, Y, Output):-
	X is 5,
	!,
	Xp1 is X + 1,
	Xm1 is X - 1,
	Yp1 is Y + 1,
	Ym1 is Y - 1,
	Output=[[Xm1, X, X, Xp1, Xm1, Xp1], [Y, Ym1, Yp1, Y, Ym1, Ym1]].

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

% checks if the selected coorindates are valid
isPlacementValid(X, Y, Result):-
	or(X is 1, X is 9),
	Y > 0,
	Y < 7,
	Result is 1.

isPlacementValid(X, Y, Result):-
	or(X is 2, X is 8),
	Y > 0,
	Y < 8,
	Result is 1.

isPlacementValid(X, Y, Result):-
	or(X is 3, X is 7),
	Y > 0,
	Y < 9,
	Result is 1.

isPlacementValid(X, Y, Result):-
	or(X is 4, X is 6),
	Y > 0,
	Y < 10,
	Result is 1.

isPlacementValid(X, Y, Result):-
	or(X is 5, X is 5),
	Y > 0,
	Y < 11,
	Result is 1.

isPlacementValid(_,_,Result):-
	Result is 0.

% divides a list in two sublists
divide([Head|Tail], Ret1, Ret2):-
	Ret1 = Head,
	divide(Tail, Ret2).

divide([Head|_], Ret):-
	Ret = Head.

%get piece grouping
getPieceGrouping(Board, X, Y, Output):-
	getPiece(Board, X, Y, Val),
	Counter is 1,
	!,
	getPieceGroupingForColorStart(Board, X, Y, Val, [(X,Y)], _, Counter, IntermediateOutput),
	Output is IntermediateOutput.

getPieceGroupingForColorStart(Board, X, Y, Expected, VisitedGroup, OutVisited, Counter, Output):-
	!,
	getNeighborhood(X, Y, Neighborhood),
	divide(Neighborhood, Nx, Ny),
	getPieceGroupingForColor(Board, Nx, Ny, Expected, VisitedGroup, OutVisitedGroup, Counter, Out),
	OutVisited = OutVisitedGroup,
	Output is Out.

getPieceGroupingForColor(Board, [HeadX|TailX], [HeadY|TailY], Expected, VisitedGroup, OutVisitedGroup, Counter, Output):-
	\+member((HeadX,HeadY), VisitedGroup),
	isPlacementValid(HeadX, HeadY, Validity),
	Validity is 1,
	getPiece(Board, HeadX, HeadY, PieceVal),
	PieceVal is Expected,
	!,
	NewCounter is Counter + 1,
	append(VisitedGroup, [(HeadX,HeadY)], NewVisitedGroup),
	getPieceGroupingForColorStart(Board, HeadX, HeadY, Expected, NewVisitedGroup, VisitedGroup2, NewCounter, Result),
	getPieceGroupingForColor(Board, TailX, TailY, Expected, VisitedGroup2, VisitedGroup3, Result, Out),
	OutVisitedGroup = VisitedGroup3,
	Output is Out.

getPieceGroupingForColor(Board, [HeadX|TailX], [HeadY|TailY], Expected, VisitedGroup, OutVisitedGroup, Counter, Output):-
	\+member((HeadX,HeadY), VisitedGroup),
	isPlacementValid(HeadX, HeadY, Validity),
	Validity is 1,
	!,
	append(VisitedGroup, [(HeadX,HeadY)], NewVisitedGroup),
	getPieceGroupingForColor(Board, TailX, TailY, Expected, NewVisitedGroup, VisitedGroup2, Counter, Out),
	OutVisitedGroup = VisitedGroup2,
	Output is Out.

getPieceGroupingForColor(Board, [_|TailX], [_|TailY], Expected, VisitedGroup, OutVisitedGroup, Counter, Output):-
	!,
	getPieceGroupingForColor(Board, TailX, TailY, Expected, VisitedGroup, VisitedGroup2, Counter, Out),
	OutVisitedGroup = VisitedGroup2,
	Output is Out.

getPieceGroupingForColor(_, [], [], _, VisitedGroup, OutVisitedGroup, Counter, Output):-
	!,
	OutVisitedGroup = VisitedGroup,
	Output is Counter.

getPieceGroupingForColor(_, [_|_], [_|_], _,VisitedGroup,OutVisitedGroup,Counter,Output):-
	!,
	OutVisitedGroup = VisitedGroup,
	Output is Counter.


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
turn_translate(_, O) :-
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

%translate game state to who wins text
write_game_state(1, 5, I, Board):-
  cls,
  cls,
  printRealBoard(I, Board),
	write('Purple Player Wins!').

write_game_state(2, 5, I, Board):-
  cls,
  cls,
  printRealBoard(I, Board),
	write('Purple Player Loses!').

write_game_state(1, 6, I, Board):-
  cls,
  cls,
  printRealBoard(I, Board),
	write('Orange Player Wins!').

write_game_state(2, 6, I, Board):-
  cls,
  cls,
  printRealBoard(I, Board),
	write('Orange  Player Loses!').

write_game_state(3, _, I, Board):-
  cls,
  cls,
  printRealBoard(I, Board),
	write('Game Ends In A Tie!').

write_game_state(_, _, _, _).

%check who wins
check_victory(Board,Player_Color,Result):-
	check_vict_row(Board,Board,Player_Color,1,Out),
	or(Out is 1,Out is 2),
	!,
	Result is Out.

check_victory(Board,Player_Color,Result):-
	check_vict_row(Board,Board,Player_Color,1,Out),
	Out is 3,
	!,
	Result is Out.

check_victory(Board,Player_Color,Result):-
	check_vict_row(Board,Board,Player_Color,1,Out),
	Out is 0,
	pieces_remaining(Board,Orange,Purple),
	Orange is 0,
	Purple is 0,
	Result is 3.

check_victory(Board,Player_Color,Result):-
	check_vict_row(Board,Board,Player_Color,1,Out),
	Result is Out.

check_vict_row(Board,[Head|_],Color,Row,Result):-
	check_vict_col(Board,Head,Color,Row,1,Out),
	Out is 1,%palyer wins
	Result is Out.

check_vict_row(Board,[Head|_],Color,Row,Result):-
	check_vict_col(Board,Head,Color,Row,1,Out),
	Out is 2,% player loses
	Result is Out.

check_vict_row(Board,[Head|Tail],Color,Row,Result):-
	check_vict_col(Board,Head,Color,Row,1,Out),
	Out is 0,
	NewRow is Row + 1,
	check_vict_row(Board,Tail,Color,NewRow,Output),
	Result is Output.

check_vict_row(_, [], _, _,Result):-
	Result is 0.

check_vict_col(Board,[Head|_],Color,Row,Col,Result):-
	Head is Color,
	getPieceGrouping(Board,Row,Col,Val),
	Val is 4,%players loses
	Result is 2.

check_vict_col(Board,[Head|_],Color,Row,Col,Result):-
	Head is Color,
	getPieceGrouping(Board,Row,Col,Val),
	Val is 5,%player wins
	Result is 1.

check_vict_col(Board,[_|Tail],Color,Row,Col,Result):-
	NewCol is Col + 1,
	check_vict_col(Board,Tail,Color,Row,NewCol,Out),
	Result is Out.

check_vict_col(_, [], _, _, _, Result):-
	Result is 0.

validate_coord(X,Y):-
	or(X is 1,X is 9),
	between(1, 6, Y).

validate_coord(X,Y):-
	or(X is 2,X is 8),
	between(1, 7, Y).

validate_coord(X,Y):-
	or(X is 3,X is 7),
	between(1, 8, Y).

validate_coord(X,Y):-
	or(X is 4,X is 6),
	between(1, 9, Y).

validate_coord(X,Y):-
	or(X is 5,X is 5),
	between(1, 10, Y).

validate_coord(_,_):-
	fail.

play_validator(Board,Color,X,Y):-
	Color is 5,
	pieces_remaining(Board,_,Purple),
	Purple > 0,
	validate_coord(X,Y),
	getPiece(Board,X,Y,0),
	getPieceGroupingForColorStart(Board,X,Y,Color,[(X,Y)],_,1,Result),
    Result < 6.

play_validator(Board, Color, X, Y):-
	Color is 6,
	pieces_remaining(Board, Orange, _),
	Orange > 0,
  validate_coord(X, Y),
  getPiece(Board, X, Y, 0),
	getPieceGroupingForColorStart(Board, X, Y, Color, [(X, Y)], _, 1, Result),
    Result < 6.

get_all_valid_plays(Board,Out):-
	findall([X,Y,Color], play_validator(Board, Color, X, Y), List),
	sort(List,Out).

player_or_bot(0, 2, _, _, Board, NewBoard) :-
  !,
  select_piece_to_play(Board, Piece),
  select_coords_to_play(Board, Piece, X, Y),
  replace(Board, X, Y, Piece, NewBoard).

player_or_bot(1, 3, _, _, Board, NewBoard) :-
  !,
  select_piece_to_play(Board, Piece),
  select_coords_to_play(Board, Piece, X, Y),
  replace(Board, X, Y, Piece, NewBoard).

player_or_bot(1, 2, 1, _, Board, NewBoard) :-
	!,
  easy_ai(Board, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(0, 3, 1, _, Board, NewBoard) :-
	!,
  easy_ai(Board, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(_, 4, 1, _, Board, NewBoard) :-
	!,
  easy_ai(Board, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(1, 2, 2, Color, Board, NewBoard) :-
	!,
  hard_ai(Board, Color, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(0, 3, 2, Color, Board, NewBoard) :-
	!,
  hard_ai(Board, Color, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(_, 4, 2, Color, Board, NewBoard) :-
	!,
  hard_ai(Board, Color, NewBoard),
  pressEnterToContinue, nl,
  pressEnterToContinue, nl.

player_or_bot(_, _, _, _, _, _).

validate_piece_coordinate_choice(Board, X, Y, Color):-
    getPiece(Board,X,Y,0),
    isPlacementValid(X, Y, 1),
    getPieceGroupingForColorStart(Board, X, Y, Color, [(X,Y)] , _, 1, Result),
    Result < 6.

validate_piece_coordinate_choice(_, _, _, _):-
    fail.


validate_game_mode_choice(Input):-
    or(Input is 1,Input is 2, Input is 3, Input is 4).

validate_game_mode_choice(_):-
    fail.

check_game_state(State):-
    State is 0.

check_game_state(_):-
    pressEnterToContinue,
    nl,
    throw('Game Finished').

turn_end(Turn,TurnOut):-
  turn_pass(Turn,TurnOut).
  %check for vicotory loss or draw

turn_start(Turn):-
  cls,
  turn_translate(Turn,Out),
  player_message(Out,Message),
  write(Message),nl.

turn_player_color(Turn,Out):-
    turn_translate(Turn,O),
    O is 1,
    Out is 5.

turn_player_color(Turn,Out):-
    turn_translate(Turn,O),
    O is 0,
    Out is 6.
