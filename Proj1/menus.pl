% main menu
start:-
    cls,
    write('-----------------------------------------'),nl,
    write('            Welcome To Manalath'),nl,
    write('-----------------------------------------'),nl,
    write('Press Enter To Start Playing'),nl,
    pressEnterToContinue,
    select_game_mode(Game),
    ai_difficulty_mode(Game, Difficulty),
    initialState(I),
    initialBoard(Board),
    %wins(Board),
    game_mode(I, Board, Game, Difficulty, 1).

game_mode(I, Board, Game, _, Turn) :-
  Game is 1,
  !,
  repeat,
  cls,
  cls,
  turn_start(Turn),
  printRealBoard(I, Board),
  select_piece_to_play(Board,Piece),
  select_coords_to_play(Board,Piece,X,Y),
  replace(Board, X, Y, Piece, NewBoard),
  turn_player_color(Turn,PColor),
  check_victory(NewBoard, PColor, State),
  write_game_state(State, PColor, I, NewBoard),
  check_game_state(State),
  turn_end(Turn,NextTurn),
  game_mode(I, NewBoard, Game, _, NextTurn).

game_mode(I, Board, Game, Difficulty, Turn) :-
  repeat,
  cls,
  cls,
  turn_start(Turn),
  turn_translate(Turn, Player),
  printRealBoard(I, Board),
  turn_player_color(Turn,PColor),
  player_or_bot(Player, Game, Difficulty, PColor, Board, NewBoard),
  check_victory(NewBoard, PColor, State),
  write_game_state(State, PColor, I, NewBoard),
  check_game_state(State),
  turn_end(Turn,NextTurn),
  game_mode(I, NewBoard, Game, Difficulty, NextTurn).

% menu for selecting game mode
select_game_mode(Output):-
    repeat,
    cls,
    write('  Select Game Mode'),nl,
    write('---------------------'),nl,
    write(' 1 - Player vs Player '),nl,
    write(' 2 - Player vs AI'),nl,
    write(' 3 - AI vs Player'),nl,
    write(' 4 - AI vs AI'),nl,
    write('Choice:'),
    read(Choice),
    validate_game_mode_choice(Choice),
    Output is Choice.


% menu for selecting ai difficulty
ai_difficulty_mode(1, _).
ai_difficulty_mode(_, Output):-
    repeat,
    cls,
    write('  Select AI Difficulty'),nl,
    write('-------------------------'),nl,
    write(' 1 - Easy '),nl,
    write(' 2 - Hard '),nl,
    write('Choice:'),
    read(Choice),
    validate_game_mode_choice(Choice),
    Output is Choice.

% menu for selecting color of piece to play
select_piece_to_play(Board,Output):-
    repeat,
    write('  Select Color Of Piece To Play'),nl,
    write('-------------------------------------'),nl,
    write(' 1 - Purple '),nl,
    write(' 2 - Orange '),nl,
    write('-------------------------------------'),nl,
    pieces_remaining(Board),
    write('-------------------------------------'),nl,
    write('Choice:'),
    read(Choice),
    validate_game_mode_choice(Choice),
    validate_color_choice(Board,Choice),
    Output is Choice + 4.


% menu for selecting color of piece to play
select_coords_to_play(Board, Color, OutputX, OutputY):-
    write('  Select Coordinates To Place Piece In '), nl,
    write('------------------------------------------'), nl,
    write('X Coordinate:'),
    read(Xcoord), nl,
    write('------------------------------------------'), nl,
    write('Y Coordinate:'),
    read(Ycoord), nl,
    write('------------------------------------------'),nl,
    validate_piece_coordinate_choice(Board, Xcoord, Ycoord, Color),
    OutputX is Xcoord,
    OutputY is Ycoord.
