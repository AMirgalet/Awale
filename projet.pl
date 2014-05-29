% Une fonction d'initialisation du plateau de jeu
init:-	   asserta(tablejoueur(j1,[4, 4, 4, 4, 4, 4]) ),
	   asserta(tablejoueur(j2,[4, 4, 4, 4, 4, 4]) ),
	   asserta(joueur(j1)).

victoire(S):- S>=25.

%--------------------------------------------------


%Fonction permettant de connaitre qui joue
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

%--------------------------------------------------


%Ici nous placons toute nos fonctions dites usuelle ou de base

% Pour imprimer une liste
imprime_liste([]).
imprime_liste([T|Q]):- write(T),write('-'),imprime_liste(Q).

%Pour récupérer un element en position X dans une liste L 
prendre(L,X,R):- nth0(X,L,R).	


%Pour modifier l'objet en position Position de la liste Joueur avec la valeur Valeur, et la nouvelle liste est retournée dans NouveauJoueur
modifier(Joueur,Liste,Position,Valeur,NouvelleListe):-  
   	 length(Temporaire, Position),
    	 append(Temporaire, [_|Tail], Liste),
    	 append(Temporaire, [Valeur|Tail], NouvelleListe).

	

%--------------------------------------------------------------------


% Mise à jour de la table en fonction de l'action demandé par l'utilisateur

majtable(Joueur,Position) :-	tablejoueur(Joueur, Liste),
				prendre(Liste,Position,R),
				write('Objet a la position demande : '),write(R),nl,
				NouvellePosition is Position+1,
				R > 0 ->
				(
					prendre(Liste,NouvellePosition,Value),
					Value1 is Value+1,
					modifier(Joueur,Liste,NouvellePosition,Value1,NouvelleListe),
					retract(tablejoueur(Joueur,Liste)),
 					asserta(tablejoueur(Joueur,NouvelleListe))
					%majtable(Joueur,NouvellePosition)
				);				
				!.





% Fonction principale du projet

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
