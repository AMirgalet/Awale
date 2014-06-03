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

autrejoueur(Y):- joueur(Y).


%--------------------------------------------------


%Ici nous placons toute nos fonctions dites usuelle ou de base

% Fonction d'affichage
imprime_liste([]).
imprime_liste([T|Q]):- write(T),write('-'),imprime_liste(Q).

affichage(Joueur,Liste):- write(Joueur),write(' : '),imprime_liste(Liste).



%Pour récupérer un element en position X dans une liste L 
prendre(L,X,R):- nth0(X,L,R).	


%Pour modifier l'objet en position Position de la liste Joueur avec la valeur Valeur, et la nouvelle liste est retournée dans NouveauJoueur
modifier(Liste,Position,Valeur,NouvelleListe):-  
   	 length(Temporaire, Position),
    	 append(Temporaire, [_|Tail], Liste),
    	 append(Temporaire, [Valeur|Tail], NouvelleListe).

	

%--------------------------------------------------------------------

% Pour déplacer une graine d'un état i à un état i+1 

deplacer(Joueur,Liste,Position,PositionDepart,R1):- 
		prendre(Liste,Position,Value),
		prendre(Liste,PositionDepart,R),
		Value1 is Value+1,
		modifier(Liste,Position,Value1,Temp),
		R1 is R-1,
		modifier(Temp,PositionDepart,R1,NouvelleListe),
		retract(tablejoueur(Joueur,Liste)),
 		asserta(tablejoueur(Joueur,NouvelleListe)).
 		



% Mise à jour de la table en fonction de l'action demandé par l'utilisateur

majtable(Joueur,Autre,PositionDepart,PositionAvancer) :-	
							tablejoueur(Joueur, Liste),
							tablejoueur(Autre,ListeAutre),
							prendre(Liste,PositionDepart,R),
							NouvellePosition is PositionAvancer+1,
							R > 0 ->
							(
								R < 5 -> (
								deplacer(Joueur,Liste,NouvellePosition,PositionDepart,R1);
								write('')),
								R1 > 0 ->(
								majtable(Joueur,PositionDepart,NouvellePosition); write(' '))
							).


%Interrogation Joueur

jouer:- 	tourjoueur(X),
		autrejoueur(Y),
		tablejoueur(X,L),
		write('Tour de : '),write(X),nl,
		imprime_liste(L),nl,
		write('---------------------'),nl,
		write('Choisir une position '),nl,
		read(C),
		C1 is C-1,
		majtable(X,Y,C1,C1),
		tablejoueur(X,L2),
		affichage(X,L2),nl,nl,nl,jouer.


% Fonction principale du projet

boucle_menu:- repeat,main,!.

main:-  	init,
		jouer.
		
