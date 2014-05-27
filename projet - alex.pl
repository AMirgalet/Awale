init:- asserta(playerTable(j1, [4, 4, 4, 4, 4, 4]) ),
	   asserta(playerTable(j2, [4, 4, 4, 4, 4, 4]) ),
	   asserta(player(j1) ).

main:-  init,
		playerTurn(X),
		updateTable( X),
		playerTable(X, L),
		printList(L).

victory(S):- S>=25.

playerTurn(X):- player(X),
				X=j1,
				!,
				retract(player(j1)),
				asserta(player(j2)).
playerTurn(X):- player(X),
				X=j2,
				!,
				retract(player(j2)),
				asserta(player(j1)).
				
printList([]).
printList([T|Q]):- write(T),write('-'),printList(Q).
				
updateTable( joueur) :- playerTable(joueur, [X1, X2, X3, X4, X5, X6]),
				write('OK'),
				retract(playerTable(joueur, [X1, X2, X3, X4, X5, X6]) ),
				write('OK'),
				X12 is X1+1,
				write('OK'),
				asserta(playerTable(joueur, [X12, X2, X3, X4, X5, X6]) ).


prendre(X, L, R):- bouclePrendre(1, X, L, R).
bouclePrendre(I, X, [T|Q], R):- I=<X,
							R = T,
							NewI is I+1,
							bouclePrendre(NewI, X, Q, R).
bouclePrendre(I, X, L, R):- I > X.