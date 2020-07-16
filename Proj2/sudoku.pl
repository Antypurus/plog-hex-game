get_Board(0, _, Board, Board).
get_Board(N, Size, BoardAux, Board) :-
  N > 0,
  N1 is N - 1,
  length(L, Size),
  append(BoardAux, [L], NewBoard),
  get_Board(N1, Size, NewBoard, Board).

puzzle_and_zones(1, Puzzle, Zones, Size,RZ) :-
  puzzle1(Puzzle),
  puzzle1_zones(Zones),
  board_size(Puzzle, Size),
  puzzle1_raw_zones(RZ).

puzzle_and_zones(2, Puzzle, Zones, Size,RZ) :-
  puzzle2(Puzzle),
  puzzle2_zones(Zones),
  board_size(Puzzle, Size),
  puzzle2_raw_zones(RZ).

puzzle_and_zones(3, Puzzle, Zones, Size,RZ) :-
  puzzle3(Puzzle),
  puzzle3_zones(Zones),
  board_size(Puzzle, Size),
  puzzle3_raw_zones(RZ).

print_zone([]):-nl.
print_zone([H|T]):-
  print(H),nl,
  print_zone(T).

print_zones([]).
print_zones([Zone|RestOfZones]):-
  print_zone(Zone),
  print_zones(RestOfZones).

solve(Example, P, Z, N) :-
  puzzle_and_zones(Example, P, Z, Size,RZ),
  length(P, N),
  get_Board(N, N, [], Board),
  P = Board,
  zone_gen(Zones,Size,RZ,Flat_zones),
  write('inserted zone constraints'),nl,
  sudoku(N, Board, Zones,Flat_Rows),
  write('inserted sudoku constraints'),nl,
  append(Flat_zones,Flat_Rows,Check),
  write('Searching for sollution'),nl,
  statistics(walltime, _),
  labeling([],Check),
  statistics(walltime, [_, ElapsedTime | _]),
  format('An answer has been found!~nElapsed time: ~3d seconds', ElapsedTime), nl,
	fd_statistics,
  write('zones:'),nl,
  print_zones(Zones),
	nl.

distinct_zone([],_,InVals,OutVals):-
  OutVals = InVals.

distinct_zone([[X,Y|_]|Tail],Rows,InVals,OutVals) :-
  getPiece(Rows,X,Y,Piece),
  %append(Rows,Line),
  %Coord #= X*Y,
  %element(Coord, Line, Piece),
  append(InVals,[Piece],NewVals),
  distinct_zone(Tail,Rows,NewVals,OutVals).

distinct_whithin_zones([],_).
distinct_whithin_zones([Zone|RestOfZones],Rows):-
  distinct_zone(Zone,Rows,[],Out),
  all_distinct(Out),
  distinct_whithin_zones(RestOfZones,Rows).

sudoku(Size, Rows, Zones,Out) :-
  length(Rows, Size),
  append(Rows, Vs), domain(Vs, 1, Size),
  maplist(all_distinct, Rows),
  transpose(Rows, Columns),
  maplist(all_distinct, Columns),
  distinct_whithin_zones(Zones,Rows),
  Out = Vs.
