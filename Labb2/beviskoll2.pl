% ['C:/Users/tonac/Desktop/Prolog/Labb2/beviskoll2.pl'].
% ['beviskoll2.pl'].
% 'C:/Users/tonac/Desktop/Prolog/Labb2/tests/invalid01.txt'

verify(InputFileName) :- see(InputFileName),
	read(Prems), read(Goal), read(Proof),
	seen,
	valid_proof(Prems, Goal, Proof).

% Steg 1: kontrollera att slutsatsen goal i HL (sekventen) står på sista raden

valid_proof(Prems, Goal, Proof) :- 
	checkGoal(Goal, Proof),
	checkProof(Prems, Proof),
	write('predikatet uppfyll!').

checkGoal(Goal, Proof) :- 
	last(Proof, LastRow),
	nth1(2, LastRow, Goal).
	
% Steg 2: Kontrollera beviset rad för rad

checkProof(_, []).
checkProof(Prems, [H|T]) :- 
	checkRow(Prems, H),
	checkProof(Prems, T). 

checkRow(Prems, H) :-
	nth1(3, H, premise),
	nth1(2,H, X),
	member(X, Prems).
	
	
	




