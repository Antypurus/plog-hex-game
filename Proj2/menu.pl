start:-
  cls,
  write('-----------------------------------------'),nl,
  write('            Welcome To LOL Sudoku'),nl,
  write('-----------------------------------------'),nl, nl,nl,
  write('            Select an example'),nl,
  write('-----------------------------------------'),nl,nl,
  write('             1 - Example 1'),nl,
  write('             2 - Example 2'),nl,
  write('             3 - Example 3'),nl,nl,
  write('             Example > '),
  read(Choice),
  example(Choice).

example_solution(2, _) :-
  start.
example_solution(1, Example) :-
  cls,
  write('-----------------------------------------'),nl,
  write('             Puzzle '), write(Example), nl,
  write('-----------------------------------------'),nl, nl,
  solve(Example, P, Z, Size), !,
  print_board(P, Z, Size), !,
  pressEnterToContinue,
  get_char(_),
  start.

example(Example) :-
  cls,
  write('-----------------------------------------'),nl,
  write('             Puzzle '), write(Example), nl,
  write('-----------------------------------------'),nl, nl,
  puzzle_and_zones(Example, P, Z, Size, _), !,
  print_board(P, Z, Size), !,
  nl, write('             1 - Solve it'),nl,
  nl, write('             2 - Back'), nl,
  read(Choice),
  example_solution(Choice, Example).
example(_).
