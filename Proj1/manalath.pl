:- include('utils.pl').
:- include('display.pl').
:- include('ai.pl').
:- include('testing.pl').
:- include('menus.pl').
:- include('logic.pl').

:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(pairs)).
%:- dynamic keys_and_values/3.

game_over(Board, Player, Winner, InternalBoard):-
  check_victory(Board, Player, State),
  write_game_state(State, Player, InternalBoard, Board),
  check_game_state(State),
  Winner is State.

valid_moves(Board,ListOfMoves):-
    get_all_valid_plays(Board,ListOfMoves).


move(X,Y,Color,Board,NewBoard):-
	validate_piece_coordinate_choice(Board,X,Y,Color),
    replace(Board, X, Y, Color, NewBoard).

choose_move(Board,Level,AI_Color,X,Y,Color):-
    Level is 2,
    get_all_plays_sorted(Board, AI_Color, Plays),
    get_selected_play(Plays, X, Y, Color).

choose_move(Board,Level,_,X,Y,Color):-
    Level is 1,
    generate_random_coords(Board, X, Y, Color).

play:-start.
