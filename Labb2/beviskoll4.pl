% ['C:/Users/tonac/Desktop/Prolog/Labb2/beviskoll2.pl'].
% ['beviskoll4.pl'].

verify(InputFileName) :- see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	valid_proof(Prems, Goal, Proof).

% Steg 1: kontrollera att slutsatsen goal i HL (sekventen) står på sista raden

valid_proof(Prems, Goal, Proof):- 
	checkGoal(Goal, Proof),
	checkProof(Prems, Proof, []), !,
	write('predikatet uppfyll!').

checkGoal(Goal, Proof):- 
	last(Proof, LastRow),
	nth1(2, LastRow, Goal).
	
% Steg 2: Kontrollera beviset rad för rad

checkProof(_, [], _).
checkProof(Prems, [H|T], CheckedList) :- 
    check_rule(Prems, H, CheckedList),
    addToList(H, CheckedList, NewList), 
    checkProof(Prems, T, NewList).

%% Kollar om det är en premiss
check_rule(Prems, [_, Atom, premise],_):-
	member(Atom, Prems).

% Kollar regel impel(x,y)
check_rule(_, [_, Atom, impel(X,Y)], CheckedList):-
    member([X, X2,_], CheckedList),
    member([Y, imp(X2,Atom),_], CheckedList).

% Lägger till ny lista
addToList(H, CheckedList, NewList):-
    appendEl(H, CheckedList, NewList).
     
% Lägger in längst bak i nya listan
appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]) :-
	appendEl(X, T, Y).
	
	
	




