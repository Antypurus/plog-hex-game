generate_random_row(Out):-
    random_between(1,9,Out).

generate_random_col(Row,Out):-
    or(Row is 1,Row is 9),
    random_between(1,6,Out).

generate_random_col(Row,Out):-
    or(Row is 2,Row is 8),
    random_between(1,7,Out).

generate_random_col(Row,Out):-
    or(Row is 3,Row is 7),
    random_between(1,8,Out).

generate_random_col(Row,Out):-
    or(Row is 4,Row is 6),
    random_between(1,9,Out).

generate_random_col(Row,Out):-
    or(Row is 5,Row is 5),
    random_between(1,10,Out).

generate_random_color(Color):-
    random_between(5,6,Color).

generate_random_coords(Board,Xout,Yout,Color):-
    generate_random_row(Xout),
    generate_random_col(Xout,Yout),
    generate_random_color(Color),
    getPiece(Board,Xout,Yout,Val),
    Val is 0,
    getPieceGroupingForColorStart(Board,Xout,Yout,Color,[(Xout,Yout)],_,1,Result),
    Result < 6.

easy_ai(Board,NewBoard):-
    generate_random_coords(Board, X, Y, Color),
    replace(Board, X, Y, Color, NewBoard).

get_coordinate(Neig, Index, Xout, Yout):-
    divide(Neig, Nx, Ny),
    get_coord_xy(Nx, Ny, 1, Index, Xout, Yout).

get_coord_xy([HeadX|_], [HeadY|_], Counter, Index, Xout, Yout):-
    Counter is Index,
    Xout is HeadX,
    Yout is HeadY.

get_coord_xy([_|TailX], [_|TailY], Counter, Index, Xout, Yout):-
    NewCounter is Counter + 1,
    get_coord_xy(TailX, TailY, NewCounter, Index, Xout, Yout).

get_coord_xy([], [], _, _,Xout,Yout):-
    Xout is 0,
    Yout is 0.

%evaluates a given play for how good it is to the AI
play_eval_func(Board,Player_Color,Color,X,Y,Result):-
    Color is Player_Color,
    getPieceGroupingForColorStart(Board,X,Y,Color,[(X,Y)],_,1,Group),
    Group is 4,
    Result is -5.

play_eval_func(Board, Player_Color, Color, X, Y, Result):-
    Color is Player_Color,
    getPieceGroupingForColorStart(Board, X, Y, Color, [(X,Y)], _, 1, Group),
    Group is 5,
    Result is 50.

play_eval_func(Board, Player_Color, Color, X, Y, Result):-
    Color is Player_Color,
    getPieceGroupingForColorStart(Board, X, Y, Color, [(X,Y)], _, 1, Group),
    Result is Group.

play_eval_func(Board, _, Color, X, Y, Result):-
    getPieceGroupingForColorStart(Board, X, Y, Color, [(X,Y)], _, 1, Group),
    Group is 4,
    Result is -5.

play_eval_func(Board, _, Color, X, Y, Result):-
    getPieceGroupingForColorStart(Board, X, Y, Color, [(X,Y)], _, 1, Group),
    Result is 5 - Group.

%gives a value to all plays that the AI can do
eval_all_plays(Plays, Board, Player_Color, Output):-
	eval_plays(Plays, Board, Player_Color, [], Output).

eval_plays([Play|Tail], Board, Player_Color, CurrList, Output):-
    eval_play(Play, Board, Player_Color, Res),
    Lst = [Res],
    append(CurrList, Lst, NewList),
    eval_plays(Tail, Board, Player_Color, NewList, Output).

eval_plays([], _, _,CurrList,Output):-
    Output = CurrList.

eval_play([X, Y, Color|_], Board, Player_Color, Output):-
    play_eval_func(Board, Player_Color, Color, X, Y, Res),
    Output = Res- [X, Y, Color].

% get all plays evaluates them and sorts them by value
get_all_plays_sorted(Board, Player_Color, Output):-
  get_all_valid_plays(Board, Res),
  eval_all_plays(Res, Board, Player_Color, Out),
	!,
	sort_plays_by_value(Out, Output).

sort_plays_by_value(Plays, Value) :-
  keysort(Plays, Sorted),
  keys_and_values(Sorted, _, NewList),
  reverse(NewList,Value).

%gets the play components
get_selected_play([Play|_], X, Y, Color):-
    get_play_X(Play, X, Y, Color).

get_play_X([HeadX|Tail], X, Y, Color):-
    X is HeadX,
    get_play_Y(Tail, Y, Color).

get_play_Y([HeadY|Tail], Y, Color):-
    Y is HeadY,
    get_play_color(Tail, Color).

get_play_color([HeadColor|_], Color):-
    Color is HeadColor.

%hard ai behavior
hard_ai(Board, AI_Color,NewBoard):-
    get_all_plays_sorted(Board, AI_Color, Plays),
    get_selected_play(Plays, X, Y, Color),
    replace(Board, X, Y, Color, NewBoard).
