init:-asserta(etat(j1, [4, 4, 4, 4, 4, 4]) ),
      asserta(etat(j2, [4, 4, 4, 4, 4, 4]) ),
      asserta(joueur(J1)).

modification(joueur,liste):-
	write("coucou"),
	imprime(liste),
	retract(etat(joueur,_)),
	asserta(etat(joueur,liste)).
	


imprime([]).
imprime([T|Q]):- write(T),write('-'),imprime(Q).

incr(X, X1) :- X1 is X+1.

														
boucle_menu:- repeat,main,!.

main:-  init,
	etat(joueur1,X),imprime(X),
	write('Joueur 1 Choisir une position ? '),nl,
	read(C),
	appel(C),
	etat(joueur1,X),imprime(X).
	
		
	
appel(1):- etat(joueur1,[X,X2,X3,X4,X5,X6]),
	   incr(X,X1),
	   write(X1),
	   modification(joueur1,[X1,X2,X3,X4,X5,X6]).

appel2(6):- joueur2([_,_,_,_,_,X]),
	    incr(X,X1),
	    write(X1).



