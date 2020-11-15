%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Adeel Hussain & Philip Tonaczew 		    %
% 				Labb 2 - 2020-11-17						%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ['C:/Users/tonac/Desktop/Prolog/Labb2/beviskoll2.pl'].
% ['C:/Users/tonac/Documents/GitHub/DD1351/Labb2/beviskoll4.pl'].
% ['C:/Users/adeel/OneDrive/KTH/Årskurs 2/HT-20/Logik För Dataloger/DD1351/Labb 2/beviskoll2.pl'].
%
% cd C:/Users/tonac/Documents/GitHub/DD1351/Labb2/
% swipl
% ['test.pl'].
% test

% premise 			Klart
% assumption		Klart
% copy(x) 			Klart
% andint(x,y) 		Klart
% andel1(x) 		Klart
% andel2(x) 		Klart
% orint1(x) 		Klart
% orint2(x) 		Klart
% orel(x,y,u,v,w)	Klart 
% impint(x,y) 		Klart
% impel(x,y)		Klart
% negint(x,y) 		Klart
% negel(x,y) 		Klart
% contel(x) 		Klart
% negnegint(x) 		Klart
% negnegel(x) 		Klart
% mt(x,y) 			Klart (Ej Fullständig)
% pbc(x,y) 			Klart
% lem 				Klart
%
% valid16.txt failed. The proof is valid but your program rejected it!



verify(InputFileName) :- see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, Proof):- 
	checkGoal(Goal, Proof),
	checkProof(Prems, Proof, []), !,
	write('Predikatet uppfyllt!').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Kontrollera Goal		    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkGoal(Goal, Proof):- 
	last(Proof, LastRow),
	nth1(2, LastRow, Goal).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Kontrollera bevis rad för rad		    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkProof(_, [], _).
checkProof(Prems, [H|T], CheckedList):- 
	check_rule(Prems, H, CheckedList),
	addToList(H, CheckedList, NewList),
	checkProof(Prems, T, NewList).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Kontroll av regler		    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Kollar om det är en premiss
check_rule(Prems, [_, Atom, premise], _):-
	member(Atom, Prems),
	write('Premiss regeln!'),
	write('\n').	

% Kollar regel andint(X,Y)
check_rule(_, [_, and(Atom1,Atom2), andint(X,Y)], CheckedList):-
	member([X, Atom1, _], CheckedList),
	member([Y, Atom2, _], CheckedList),
	write('Andint regeln!'),
	write('\n').

% Kollar regel orint1(X)
check_rule(_,[_,or(Atom,_), orint1(Z)], CheckedList):-
	member([Z,Atom,_], CheckedList),
	write('Orint1 regeln!'),
	write('\n').

% Kollar regel orint2(X)
check_rule(_,[_,or(_,Atom), orint2(Z)], CheckedList) :-
	member([Z,Atom,_], CheckedList),
	write('Orint2 regeln!'),
	write('\n').

% Kollar regel andel1         
check_rule(_, [_, Atom, andel1(X)],CheckedList):-
	member([X, and(Atom,_), _], CheckedList),
	write('Andel1 regeln!'),
	write('\n').

% Kollar regel andel2 
check_rule(_, [_, Atom, andel2(X)],CheckedList):-
	member([X, and(_,Atom), _],CheckedList),
	write('Andel2 regeln!'),
	write('\n').

% Kollar regel impel(x,y)
check_rule(_, [_, Atom, impel(X,Y)],CheckedList):-
    member([X, Atom1,_],CheckedList),
	member([Y, imp(Atom1,Atom),_],CheckedList),
	write('Impel regeln!'),
	write('\n').

% Kollar regel lem
check_rule(_, [_,or(Atom, neg(Atom)), lem],_):-
	write('Orint2 regeln!'),
	write('\n').

% Kollar regel copy(x)
check_rule(_,[_,Atom, copy(X)],CheckedList):-
	member([X,Atom,_],CheckedList),
	write('Copy regeln!'),
	write('\n').

%Kollar regel negel(x)
check_rule(_,[_,cont, negel(X,Y)], CheckedList):-
	member([X, Atom,_], CheckedList),
	member([Y, neg(Atom),_], CheckedList),
	write('Negel regeln!'),
	write('\n').

% Kollar regel mt(x,y) (ska lägga in resternade tre scenario till)
check_rule(_,[_, neg(Atom), mt(X,Y)], CheckedList):-
	member([X,imp(Atom,neg(Atom2)),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList);

	member([X,imp(Atom,Atom2),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList),

	write('MT regeln!'),
	write('\n').

% Kollar regel mt(x,y) fast dubbel negation framför
check_rule(_,[_,neg(neg(Atom)), mt(X,Y)], CheckedList):-
	member([X,imp(neg(Atom,Atom2)),_], CheckedList),
	member([Y,neg(Atom2),_], CheckedList);

	member([X,imp(neg(Atom,neg(Atom2))),_], CheckedList),
	member([Y,neg(neg(Atom2)),_], CheckedList),

	write('MT regeln!'),
	write('\n').

% Kollar regel negnegint(x)
check_rule(_,[_, neg(neg(Atom)), negnegint(X)], CheckedList):-
	member([X, Atom,_], CheckedList),
	write('Negnegint regeln!'),
	write('\n').

% Kollar regel negnegel(x)
check_rule(_,[_,Atom, negnegel(X)], CheckedList):-
	member([X, neg(neg(Atom)),_], CheckedList),
	write('Negnegel regeln!'),
	write('\n').

% Kollar regel contel(x)
check_rule(_, [_, _, contel(X)], CheckedList):-
	member([X, cont, _], CheckedList),
	write('Contel regeln!'),
	write('\n').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Boxhantering & Regler		    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Kollar boxen och kallar checkProof som sedan rekursivt itererar igenom boxen
check_rule(Prems, [[X, Atom, assumption]|T], CheckedList):-
	addToList([X, Atom, assumption], CheckedList, NewList),
	write('Assumption box regeln!'),
	write('\n'),
	checkProof(Prems,T,NewList).
	
% Kollar regeln negint
check_rule(_, [_, neg(Atom), negint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom, assumption], BoxList),
	member([Y, cont, _], BoxList),
	write('Negint regeln!'),
	write('\n').

% Kollar regel impint
check_rule(_, [_, imp(Atom1,Atom2), impint(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, Atom1, assumption], BoxList),
	member([Y, Atom2, _], BoxList),
	write('Impint regeln!'),
	write('\n').

% Kollar regel pbc
check_rule(_, [_, Atom, pbc(X,Y)], CheckedList):-
	member(BoxList, CheckedList),
	member([X, neg(Atom), assumption], BoxList),
	member([Y, cont, _], BoxList),
	write('PBC regeln!'),
	write('\n').

% Kollar regel OR-eliminering orel(x,y,u,v,w)
check_rule(_, [_, Atom, orel(S1,S2,S3,S4,S5)], CheckedList):-
	member(BoxList1, CheckedList),
	member(BoxList2, CheckedList),
	member([S1, or(Atom1,Atom2),_], CheckedList),
	member([S2, Atom1, assumption], BoxList1),
	member([S3,Atom, _], BoxList1),
	member([S4,Atom2, assumption], BoxList2),
	member([S5,Atom, _], BoxList2),
	write('orel regeln!'),
	write('\n').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Listhantering		     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lägger till ny lista
addToList(H, CheckedList, NewList):-
	appendEl(H, CheckedList, NewList).
     
% Lägger in längst bak i nya listan
appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]):-
	appendEl(X, T, Y).
