% Une fonction d'initialisation du plateau de jeu
init:-	asserta(tablejoueur(j1,[2, 2, 2, 2, 4, 6],0) ),
		asserta(tablejoueur(j2,[2, 2, 2, 2, 2, 2],0) ),
	    asserta(joueur(j1)).

victoire(S):- S>=18.

%--------------------------------------------------
%ENCORE UN BUG SUR LE TOUR COMPLET

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

imprime_liste_inversee(L):-inverse(L,L1), imprime_liste(L1).

%affichage(Joueur,Liste):- write(Joueur),write(' : '),imprime_liste(Liste).

affichage(JoueurUn, ListeUn, PtsUn, JoueurDeux, ListeDeux, PtsDeux):-
				write('  ______________'),nl,
				write(JoueurDeux),write('|'),imprime_liste_inversee(ListeDeux),write('|'),write('Score: '),write(PtsDeux),nl,
				write('  |____________|'),nl,
				write(JoueurUn),write('|'),imprime_liste(ListeUn),write('|'),write('Score: '),write(PtsUn),nl,
				write('  |____________|'),nl.


%Pour récupérer un element en position X dans une liste L 
prendre(L,X,R):- nth0(X,L,R).	

%Fonction d'inversion de liste
inverse(L1, L2):-inverse(L1, [], L2).

inverse([], Acc,Acc).
inverse([X|Rest], Acc,Result):-inverse(Rest, [X|Acc], Result).

%Pour modifier l'objet en position Position de la liste Joueur avec la valeur Valeur, et la nouvelle liste est retournée dans NouveauJoueur
modifier(Liste,Position,Valeur,NouvelleListe):-  
   	 length(Temporaire, Position),
    	 append(Temporaire, [_|Tail], Liste),
    	 append(Temporaire, [Valeur|Tail], NouvelleListe).

	

%--------------------------------------------------------------------
verif_compte_points(Joueur, Autre, Position, 0, Value):-
		NewPosition is Position+1,
		verif_valeur_points(Joueur, Autre, NewPosition, Value),
		!.
verif_compte_points(_,_,_, _, _).


verif_valeur_points(Joueur,Autre,0,_):-
		write('1'),nl,
		!.
verif_valeur_points(Joueur,Autre, Position, 2):-
		write('2'),nl,
		pts(Joueur,Autre, Position, 2),
		!.
verif_valeur_points(Joueur,Autre, Position, 3):-
		write('3'),nl,
		pts(Joueur,Autre, Position, 3),
		!.
verif_valeur_points(Joueur,Autre,_,_):-
		write('4'),nl.
		
pts(Joueur, Autre, Position, Value):-
		write('pts'),nl,
		tablejoueur(Joueur, Liste, Points),
		%write('Points: '),write(Points),nl,
		NewPoints is Points + Value,
		%write('NewPoints: '),write(NewPoints),nl,
		retract(tablejoueur(Joueur,Liste, Points)),
 		asserta(tablejoueur(Joueur,Liste, NewPoints)),
		tablejoueur(Autre, ListeAutre, PointsAutre),
		NewValue is Value - Value,
		NewPosition is Position -1,
		modifier(ListeAutre,NewPosition,NewValue,Temp),
		retract(tablejoueur(Autre,ListeAutre, PointsAutre)),
 		asserta(tablejoueur(Autre,Temp, PointsAutre)),
		%write('Position: '),write(Position),nl,
		EncoreNewPosition is NewPosition -1,
		%write('NewPosition: '),write(NewPosition),nl,
		prendre(ListeAutre,EncoreNewPosition,R),
		verif_valeur_points(Joueur,Autre,NewPosition,R).
		

% Pour déplacer une graine d'un état i à un état i+1 dans une seule chaine

deplacer(Joueur,Autre,Position,PositionDepart,R1):- 
		tablejoueur(Joueur, Liste, PointsUn),
		tablejoueur(Autre,ListeAutre, PointsDeux),
		prendre(Liste,Position,Value),
		%Value est la valeur de la case a laquelle on ajoute 1
		prendre(Liste,PositionDepart,R),
		%R est la valeur actuelle de la case de départ
		R1 is R-1,
		Value1 is Value+1,
		modifier(Liste,Position,Value1,Temp),
		%Temp est la nouvelle liste modifiee
		modifier(Temp,PositionDepart,R1,NouvelleListe),
		%NouvelleListe est la nouvelle liste modifiee
		retract(tablejoueur(Joueur,Liste, Points)),
 		asserta(tablejoueur(Joueur,NouvelleListe, Points)).
		
% Pour déplacer une graine d'un état i à un état i+1 dans les deux chaines
	
deplacer_deux_listes(Joueur,Autre,Position,PositionDepart,R1):- 
		tablejoueur(Joueur, Liste, PointsUn),
		tablejoueur(Autre,ListeAutre, PointsDeux),
		prendre(ListeAutre,Position,Value),
		%Value est la valeur de la case a laquelle on ajoute 1
		prendre(Liste,PositionDepart,R),
		%R est la valeur actuelle de la case de départ
		R1 is R-1,
		Value1 is Value+1,
		modifier(ListeAutre,Position,Value1,Temp),
		%Temp est la nouvelle liste modifiee
		modifier(Liste,PositionDepart,R1,NouvelleListe),
		%NouvelleListe est la nouvelle liste modifiee
		retract(tablejoueur(Joueur,Liste, PointsUn)),
 		asserta(tablejoueur(Joueur,NouvelleListe, PointsUn)),
		retract(tablejoueur(Autre,ListeAutre, PointsDeux)),
 		asserta(tablejoueur(Autre,Temp, PointsDeux)),
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		write('R1: '),write(R1),nl,
		verif_compte_points(Joueur, Autre, Position, R1, Value1).
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Mise à jour de la table en fonction de l'action demandé par l'utilisateur

majtable(Joueur,Autre,PositionDepart,PositionAvancer) :-	
							tablejoueur(Joueur, Liste, PointsUn),
							tablejoueur(Autre,ListeAutre, PointsDeux),
							prendre(Liste,PositionDepart,R),
							%R est la valeur de la case choisie
							NouvellePosition is PositionAvancer+1,
							%Premiere condition pour gérer les cas ou on repasse sur la case qui distribue
							(NouvellePosition = PositionDepart ->
								majtable(Joueur,Autre,PositionDepart,NouvellePosition);
								%Deuxième condition qui vérifie si que l'on retourne sur le plateau du joueur
								%actuel si on a beaucoup de jetons
								(NouvellePosition > 11 ->
									PositionTemp is NouvellePosition -13,
									majtable(Joueur,Autre,PositionDepart,PositionTemp);
									%Troisieme condition qui vérifie si l'on distribue sur le plateau de l'adversaire
									(NouvellePosition > 5 ->
										(R > 0 ->
										
											PositionChaineDeux is NouvellePosition-6,
											deplacer_deux_listes(Joueur,Autre,PositionChaineDeux,PositionDepart,R1),
											(R1 > 0 ->
												majtable(Joueur,Autre,PositionDepart,NouvellePosition);
												write('')
											)
										;write(''))
										;(R > 0 ->
											deplacer(Joueur,Autre,NouvellePosition,PositionDepart,R1),
											(R1 > 0 ->
												majtable(Joueur,Autre,PositionDepart,NouvellePosition);
												write('')
											)
										;write(''))
									)
								)
							).

%Interrogation Joueur

jouer:- 	tourjoueur(X),
		autrejoueur(Y),
		tablejoueur(X,L,P),
		tablejoueur(Y,Y2,P2),
		affichage(X,L,P,Y,Y2,P2),nl,
		write('Tour de : '),write(X),nl,
		write('Choisir une position '),nl,
		read(C),
		C1 is C-1,
		majtable(X,Y,C1,C1),
		(victoire(P) ->
				write('Victoire');
				jouer
		).

% Fonction principale du projet

boucle_menu:- repeat,main,!.

main:-  	init,
		jouer.
		
