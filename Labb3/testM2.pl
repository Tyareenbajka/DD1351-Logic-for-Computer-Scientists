%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Adeel Hussain & Philip Tonaczew 		    %
% 				  Labb 3 - 2020-12-10					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% cd C:/Users/tonac/Documents/GitHub/DD1351/Labb_3/
% swipl
% consult('modelchecker.pl').


% check(T, L, S, U, F)
% T - The transitions in form of adjacency lists
% L - The labeling
% S - Current state
% U - Currently recorded states
% F - CTL Formula to check.


verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Literals		    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

check(_, L, S, [], X):-
    member([S,Q], L),
    member(X,Q).

check(_, L, S, [], neg(X)):-
    member([S,Q], L),
    \+ member(X,Q).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		     And     	    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

check(T, L, S, [], and(X1,X2)):-
    check(T, L, S, [], X1),
    check(T, L, S, [], X2).

%%%%%%%%%%%%%%%%%%%%%%%%%
%		    Or		    %
%%%%%%%%%%%%%%%%%%%%%%%%%

check(T, L, S, [], or(X1,X2)):-
    check(T, L, S, [], X1);
    check(T, L, S, [], X2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		    AX - Alla nästa väg gäller fi   	    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

check(T, L, S, [], ax(X)):-
    member([S,Q], T),
    checkALL(T, L, Q, [], X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		     EX - I något av nästa vägarna gäller fi         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

check(T, L, S, [], ex(X)):-
    member([S,Q], T),
    checkSOME(T, L, Q, [], X).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		     AG - För alla vägar gäller fi alltid            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AG1 - basfall
check(_, _, S, U, ag(_)):-
    member(S, U).
%AG2
check(T, L, S, U, ag(X)):-
    \+ member(S, U),
    check(T, L, S, [], X),
    member([S,Q], T),
    checkALL(T, L, Q, [S|U], ag(X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		     EG - Det finns en väg där alltid fi gäller            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EG1 - basfall
check(_, _, S, U, eg(_)):-
    member(S, U).

% EG2
check(T, L, S, U, eg(X)):-
    \+ member(S, U),
    check(T, L, S, [], X),
    member([S,Q], T),
    checkSOME(T, L, Q, [S|U], eg(X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		     EF - Det finns en väg där så småningom fi gäller            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%EF1 - basfall
check(T, L, S, U, ef(X)):-
    \+ member(S, U),
    check(T, L, S, [], X).

%EF2
check(T, L, S, U, ef(X)):-
    \+ member(S, U),
    member([S,Q], T),
    checkSOME(T, L, Q, [S|U], ef(X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		        AF - Över alla vägar gäller fi så småningom              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AF1 - basfall
check(T, L, S, U, af(X)):-
    \+ member(S, U),
    check(T, L, S, [], X).

% AF2
check(T, L, S, U, af(X)):-
    \+ member(S, U),
    member([S,Q], T),
    checkALL(T, L, Q, [S|U], af(X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		        Predikat för att kolla alla vägar 'A'                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkALL(_, _, [], _, _).
checkALL(T, L, [Q1|Tail], U, X):-
    check(T, L, Q1, U, X),
    checkALL(T, L, Tail, U, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		        Predikat för att kolla någon väg 'E'                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkSOME(T, L, [Q1|Tail], U, X):-
    check(T, L, Q1, U, X);
    checkSOME(T, L, Tail, U, X).