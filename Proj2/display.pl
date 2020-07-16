print_board([], [], Size) :-
  boarder_size(Size, BorderSize),
  write(' '), print_border(BorderSize), nl.

print_board([H|T], [ZH|ZT], Size) :-
  boarder_size(Size, BorderSize),
  write(' '), print_border(BorderSize), nl,
  print_row_empty(H, ZH), nl,
  print_row(H, ZH), nl,
  print_row_empty(H, ZH), nl,
  print_board(T, ZT, Size).

print_row([],[]) :- write('|').
print_row([H|T], [ZH|ZT]) :-
  write('|'), write_space_star(ZH,1), write(' '),
  write_value(H, Value),
  write(Value), write(' '), write_space_star(ZH,1),
  print_row(T, ZT).

print_row_empty([], []) :- write('|').
print_row_empty([_|T], [ZH|ZT]) :-
  write('|'), write_space_star(ZH,5),
  print_row_empty(T, ZT).

print_border(0).
print_border(BorderSize) :-
  write('-'),
  NewBorderSize is BorderSize - 1,
  print_border(NewBorderSize).

write_space_star(_ ,0).

write_space_star(X, N) :-
  NewN is N - 1,
  convert(X, S),
  write(S),
  write_space_star(X,NewN).
