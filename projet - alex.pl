init:- 	   asserta(Tablejoueur(j1, [4, 4, 4, 4, 4, 4]) ),
	   asserta(Tablejoueur(j2, [4, 4, 4, 4, 4, 4]) ),
	   asserta(joueur(j1) ).

main:-  init,
		TourJoueur(X),
		MajTable( X),
		Tablejoueur(X, L),
		imprime_liste(L).

victoire(S):- S>=25.

TourJoueur(X):- joueur(X),
				X=j1,
				!,
				retract(joueur(j1)),
				asserta(joueur(j2)).
TourJoueur(X):- joueur(X),
				X=j2,
				!,
				retract(joueur(j2)),
				asserta(joueur(j1)).
				
imprime_liste([]).
imprime_liste([T|Q]):- write(T),write('-'),imprime_liste(Q).
				
MajTable( joueur) :- Tablejoueur(joueur, [X1, X2, X3, X4, X5, X6]),
				write('OK'),
				retract(Tablejoueur(joueur, [X1, X2, X3, X4, X5, X6]) ),
				write('OK'),
				X12 is X1+1,
				write('OK'),
				asserta(Tablejoueur(joueur, [X12, X2, X3, X4, X5, X6]) ).


prendre(X, L, R):- bouclePrendre(1, X, L, R).
bouclePrendre(I, X, [T|Q], R):- I=<X,
							R = T,
							NewI is I+1,
							bouclePrendre(NewI, X, Q, R).
bouclePrendre(I, X, L, R):- I > X.
