init:-	   asserta(tablejoueur(j1,[4, 4, 4, 4, 4, 4]) ),
	   asserta(tablejoueur(j2,[4, 4, 4, 4, 4, 4]) ),
	   asserta(joueur(j1)).

victoire(S):- S>=25.

tourjoueur(X):- joueur(X),
		X=j1,
		!,
		retract(joueur(j1)),
		asserta(joueur(j2)).
		
tourjoueur(X):- joueur(X),
		X=j2,
		!,
		retract(joueur(j2)),
		asserta(joueur(j1)).
				
imprime_liste([]).
imprime_liste([T|Q]):- write(T),write('-'),imprime_liste(Q).
				
majtable(Joueur,Position) :-	tablejoueur(Joueur, [X1, X2, X3, X4, X5, X6]),
				prendre([X1, X2, X3, X4, X5, X6],Position,R),
				write('Objet a la position demande : '),write(R),nl,
				retract(tablejoueur(Joueur, [X1, X2, X3, X4, X5, X6]) ),
				X12 is X1-1,X22 is X2+1,
				asserta(tablejoueur(Joueur, [X12, X22, X3, X4, X5, X6]) ),
				!.


prendre(L,X,R):- nth0(X,L,R).


boucle_menu:- repeat,main,!.

main:-  	init,
		tourjoueur(X),
		write('Tour de : '),write(X),nl,
		write('---------------------'),nl,
		write('Choisir une position '),nl,
		read(C),
		C1 is C-1,
		majtable(X,C1),
		tablejoueur(X,L),
		imprime_liste(L),!.
