% Adeel Hussain & Philip Tonaczew 		    
% Labb 2 - 2020-11-17						
% 
% cd C:\Users\tonac\Documents\GitHub\Logik-for-dataloger\Labb2
% ['beviskoll4.pl'].
% ['run_all_tests.pl'].
% run_all_tests('beviskoll.pl').


verify(InputFileName) :- see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, Proof):- 
	checkGoal(Goal, Proof),
	checkProof(Prems, Proof, []), !.

%% Kontrollera Goal		    

checkGoal(Goal, Proof):- 
	last(Proof, LastRow),
	nth1(2, LastRow, Goal).
	
%% Kontrollera bevis rad för rad		    

checkProof(_, [], _).
checkProof(Prems, [H|T], CheckedList):- 
	check_rule(Prems, H, CheckedList),
	addToList(H, CheckedList, NewList),
	checkProof(Prems, T, NewList).
	
%% Kollar om det är en premiss
check_rule(Prems, [_, Atom, premise], _):-
	member(Atom, Prems).	

% Kollar regel andint(X,Y)
check_rule(_, [_, and(Atom1,Atom2), andint(X,Y)], CheckedList):-
	member([X, Atom1, _], CheckedList),
	member([Y, Atom2, _], CheckedList).

% Kollar regel orint1(X)
check_rule(_,[_,or(Atom,_), orint1(Z)], CheckedList):-
	member([Z,Atom,_], CheckedList).

% Kollar regel orint2(X)
check_rule(_,[_,or(_,Atom), orint2(Z)], CheckedList) :-
	member([Z,Atom,_], CheckedList).

% Kollar regel andel1         
check_rule(_, [_, Atom, andel1(X)],CheckedList):-
	member([X, and(Atom,_), _], CheckedList).

% Kollar regel andel2 
check_rule(_, [_, Atom, andel2(X)],CheckedList):-
	member([X, and(_,Atom), _],CheckedList).

% Kollar regel impel(x,y)
check_rule(_, [_, Atom, impel(X,Y)],CheckedList):-
    member([X, Atom1,_],CheckedList),
	member([Y, imp(Atom1,Atom),_],CheckedList).

% Kollar regel lem
check_rule(_, [_,or(Atom, neg(Atom)), lem],_).


% Kollar regel copy(x)
check_rule(_,[_,Atom, copy(X)],CheckedList):-
	member([X,Atom,_],CheckedList).

%Kollar regel negel(x)
check_rule(_,[_,cont, negel(X,Y)], CheckedList):-
	member([X, Atom,_], CheckedList),
	member([Y, neg(Atom),_], CheckedList).

% Kollar regel mt(x,y) 
check_rule(_,[_, neg(Atom), mt(X,Y)], CheckedList):-
	member([X,imp(Atom,neg(Atom2)),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList);

	member([X,imp(Atom,Atom2),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList).

% Kollar regel mt(x,y) fast dubbel negation framför
check_rule(_,[_,neg(neg(Atom)), mt(X,Y)], CheckedList):-
	member([X,imp(neg(Atom,Atom2)),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList);

	member([X,imp(neg(Atom,neg(Atom2))),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList).

% Kollar regel negnegint(x)
check_rule(_,[_, neg(neg(Atom)), negnegint(X)], CheckedList):-
	member([X, Atom,_], CheckedList).

% Kollar regel negnegel(x)
check_rule(_,[_,Atom, negnegel(X)], CheckedList):-
	member([X, neg(neg(Atom)),_], CheckedList).

% Kollar regel contel(x)
check_rule(_, [_, _, contel(X)], CheckedList):-
	member([X, cont, _], CheckedList).


%% Boxhantering & Regler

%Kollar boxen och kallar checkProof som sedan rekursivt itererar igenom boxen
check_rule(Prems, [[X, Atom, assumption]|T], CheckedList):-
	addToList([X, Atom, assumption], CheckedList, NewList),
	checkProof(Prems,T,NewList).
	
% Kollar regeln negint
check_rule(_, [_, neg(Atom), negint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom, assumption], BoxList),
	member([Y, cont, _], BoxList).

% Kollar regel impint
check_rule(_, [_, imp(Atom1,Atom2), impint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom1, assumption], BoxList),
	member([Y, Atom2, _], BoxList).

% Kollar regel pbc
check_rule(_, [_, Atom, pbc(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, neg(Atom), assumption], BoxList),
	member([Y, cont, _], BoxList).

% Kollar regel OR-eliminering orel(x,y,u,v,w)
check_rule(_, [_, Atom, orel(S1,S2,S3,S4,S5)], CheckedList):-
	member(BoxList1, CheckedList),
	member(BoxList2, CheckedList),
	member([S1, or(Atom1,Atom2),_], CheckedList),
	member([S2, Atom1, assumption], BoxList1),
	member([S3,Atom, _], BoxList1),
	member([S4,Atom2, assumption], BoxList2),
	member([S5,Atom, _], BoxList2).

% Lägger till ny lista
addToList(H, CheckedList, NewList):-
	appendEl(H, CheckedList, NewList).
     
% Lägger in längst bak i nya listan
appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]):-
	appendEl(X, T, Y).
