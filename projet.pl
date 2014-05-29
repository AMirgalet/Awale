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

majtable(Joueur,PositionDepart,PositionAvancer) :-	tablejoueur(Joueur, Liste),
							prendre(Liste,PositionDepart,R),
							write('Objet a la position demande : '),write(R),nl,
							NouvellePosition is PositionAvancer+1,
							R > 0 ->
							(
								prendre(Liste,NouvellePosition,Value),
								Value1 is Value+1,
								modifier(Joueur,Liste,NouvellePosition,Value1,Temp),
								R1 is R-1,
								modifier(Joueur,Temp,PositionDepart,R1,NouvelleListe),
								retract(tablejoueur(Joueur,Liste)),
 								asserta(tablejoueur(Joueur,NouvelleListe)),
 								R1 > 0 ->
								majtable(Joueur,PositionDepart,NouvellePosition);
								write('')
							).





% Fonction principale du projet

boucle_menu:- repeat,main,!.

main:-  	init,
		tourjoueur(X),
		tablejoueur(X,L),
		write('Tour de : '),write(X),nl,
		imprime_liste(L),nl,
		write('---------------------'),nl,
		write('Choisir une position '),nl,
		read(C),
		C1 is C-1,
		majtable(X,C1,C1),
		tablejoueur(X,L2),
		imprime_liste(L2),!.
