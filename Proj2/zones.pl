:- use_module(library(clpfd)).
:- use_module(library(lists)).

check_zone(X,Y,Zone):-
    has_coord(X,Y,Zone,0,Out),
    Out #= 0.

% zone coordinates - other zones
check_intersection_single_zone([_|_],[]).
check_intersection_single_zone([X,Y|_],[Head|Tail]):-
    check_zone(X,Y,Head),
    check_intersection_single_zone([X,Y],Tail).

% Prameters: zone - zones to check
check_intersection_single([],_).
check_intersection_single([Head|Tail],OtherZones):-
    check_intersection_single_zone(Head,OtherZones),
    check_intersection_single(Tail,OtherZones).

check_intersection([],_).
check_intersection([CurrHead|CurrTail],CheckingList):-
    append(CheckingList,CurrTail,Checker),
    check_intersection_single(CurrHead,Checker),
    append([CurrHead],CheckingList,NewCheckingList),
    check_intersection(CurrTail,NewCheckingList).

init_length([],_).
init_length([Head|Tail],Size):-
    length(Head,Size),
    init_zone_domain(Head,Size),
    init_length(Tail,Size).

init_zone_domain([],_).
init_zone_domain([Head|Tail],Size):-
    length(Head,2),
    domain(Head,1,Size),
    init_zone_domain(Tail,Size).

has_coord(_,_,[],InCount,Count):-
    Count #= InCount.

has_coord(X,Y,[Head|Tail],InCount,Count):-
    has_coord_(X,Y,Head,Out),
    InterCount #= InCount + Out,
    has_coord(X,Y,Tail,InterCount,Count).

has_coord_(X,Y,[HeadX,HeadY|_],Out):-
    (X #= HeadX  #/\ Y #= HeadY) #<=> Out.

get_link_counter(X,Y,Zone,LinkCounter):-
    has_coord(X,Y,Zone,0,Out),
    Xp1 #= X + 1,
    Xm1 #= X - 1,
    Yp1 #= Y + 1,
    Ym1 #= Y - 1,
    has_coord(X,Yp1,Zone,0,Ex1),
    has_coord(X,Ym1,Zone,0,Ex2),
    has_coord(Xp1,Y,Zone,0,Ex3),
    has_coord(Xm1,Y,Zone,0,Ex4),
    LinkCounter #= (Ex1 + Ex2 + Ex3 + Ex4)*Out.

procces_link_counter(X,Y,Zone,LinkCounter):-
    Xp1 #= X + 1,
    Xm1 #= X - 1,
    Yp1 #= Y + 1,
    Ym1 #= Y - 1,
    get_link_counter(X,Yp1,Zone,LK1),
    get_link_counter(X,Ym1,Zone,LK2),
    get_link_counter(Xp1,Y,Zone,LK3),
    get_link_counter(Xm1,Y,Zone,LK4),
    maximum(LinkCounter,[LK1,LK2,LK3,LK4]).

check_zone_continuity([],_,_).
check_zone_continuity([[X,Y|_]|Tail],Entry,Size):-
    get_link_counter(X,Y,Entry,LinkCounter),
    LinkCounter #> 0,
    procces_link_counter(X,Y,Entry,NLK),
    (NLK #> 1) #<=> B2,
    (LinkCounter #= 1) #=> B2,
    %B #=> B2,
    check_zone_continuity(Tail,Entry,Size).

check_continuous_zones([],_).
check_continuous_zones([Head|Tail],Size):-
    check_zone_continuity(Head,Head,Size),
    check_continuous_zones(Tail,Size).

coordinate_uniqueness_check(_,[]).
coordinate_uniqueness_check([X,Y|_],Var):-
    has_coord(X,Y,Var,0,Out),
    Out #= 0.

check_uniqueness([],_).
check_uniqueness([FirstCoords|RestOfCoords],CheckingList):-
    append(RestOfCoords,CheckingList,Checker),
    coordinate_uniqueness_check(FirstCoords,Checker),
    append(CheckingList,[FirstCoords],NewCheckingList),
    check_uniqueness(RestOfCoords,NewCheckingList).

ensure_uniqueness([]).
ensure_uniqueness([Zone|RestOfZones]):-
    check_uniqueness(Zone,[]),
    ensure_uniqueness(RestOfZones).

flatten([Head|Tail],InOut,Out):-
    append(Head,FlatHead),
    append(InOut,FlatHead,InterOut),
    flatten(Tail,InterOut,Out).

flatten([],InOut,Out):-
    Out = InOut.

match_single_input(_,[]).
match_single_input([[X,Y|_]|RestOfCoords],[[InputX,InputY|_]|RestOfInputCoords]):-
    X #= InputX #/\ Y #= InputY,
    match_single_input(RestOfCoords,RestOfInputCoords).

match_input(_,[]).
match_input([FirstZone|RestOfZones],[FirstInput|RestOfInputs]):-
    match_single_input(FirstZone,FirstInput),
    match_input(RestOfZones,RestOfInputs).

zone_gen(Zones,Size):-
    length(Zones, Size),
    init_length(Zones,Size),
    check_continuous_zones(Zones,Size),
    check_intersection(Zones,[]),
    ensure_uniqueness(Zones),
    flatten(Zones,[],Out),
    labeling([], Out).

zone_gen(Zones,Size,Input,Out):-
    length(Zones, Size),
    init_length(Zones,Size),
    match_input(Zones,Input),
    check_continuous_zones(Zones,Size),
    check_intersection(Zones,[]),
    ensure_uniqueness(Zones),
    flatten(Zones,[],Out).
   % labeling([], Out),
   % write('solution found'),nl.
