% Une fonction d'initialisation du plateau de jeu
init:-		asserta(tablejoueur(j1,[4, 4, 4, 4, 4, 4],0) ),
		asserta(tablejoueur(j2,[4, 4, 4, 4, 4, 4],0) ),
	    	asserta(joueur(j2)).

victoire(S):- S>=25.

%--------------------------------------------------

%Fonction permettant de connaitre qui joue
tourjoueur(X):- joueur(X),
		(X==j1->
		retract(joueur(_)),
		asserta(joueur(j2));
		retract(joueur(_)),
		asserta(joueur(j1))
		).

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
		verif_valeur_points(Joueur, Autre, Position, Value),
		!.
verif_compte_points(_,_,_,_,_).
%Verif_compte_points verifie que nous sommes bien arrivé à la fin du coup du jouer grace à la condition R1=0

%?? Predicat faux
%verif_valeur_points(Joueur,Autre,0,_):-
%		pts(Joueur, Autre, 0),
%		!.
% Sami je les laissé car je sais pas pourquoi tu avais mis celui la? Pour moi il sert à rien mais il doit avoir un intéret. En tout cas il est 
% responsable d'un beug car peut importe le nombre de graine en position 1 du joueur adverse, si tu finis à cette position tu récuperes tous. 
% Maintenant qu'il n'y ai plus, le beug vient lorsque l'on a une prise en position 0. Ca reprend le score de 0.

		
verif_valeur_points(Joueur,Autre, Position, 2):-
		pts(Joueur,Autre, Position, 2),
		!.
verif_valeur_points(Joueur,Autre, Position, 3):-
		pts(Joueur,Autre, Position, 3),
		!.
verif_valeur_points(Joueur,Autre,_,_).
% Dernière condition qui exclue toute possibilité de point si on arrive sur une zone adverse ou il y a plus de 3 graines. 
			

pts(Joueur, Autre, Position):-
		tablejoueur(Joueur, Liste, Points),
		tablejoueur(Autre, ListeAutre, PointsAutre),
		prendre(ListeAutre,Position,Value),
		NewPoints is Points + Value,
		retract(tablejoueur(Joueur,Liste, Points)),
 		asserta(tablejoueur(Joueur,Liste, NewPoints)),
		NewValue is Value - Value,
		modifier(ListeAutre,Position,NewValue,Temp),
		retract(tablejoueur(Autre,ListeAutre, PointsAutre)),
 		asserta(tablejoueur(Autre,Temp, PointsAutre)).

		
pts(Joueur, Autre, Position, Value):-
		tablejoueur(Joueur, Liste, Points),
		NewPoints is Points + Value,
		retract(tablejoueur(Joueur,Liste, Points)),
 		asserta(tablejoueur(Joueur,Liste, NewPoints)),
		tablejoueur(Autre, ListeAutre, PointsAutre),
		NewValue is Value - Value,
		modifier(ListeAutre,Position,NewValue,Temp),
		retract(tablejoueur(Autre,ListeAutre, PointsAutre)),
 		asserta(tablejoueur(Autre,Temp, PointsAutre)),
		NewPosition is Position -1,
		prendre(ListeAutre,NewPosition,R),
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
		verif_compte_points(Joueur, Autre, Position, R1, Value1).


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
		(C1 > 5 ->
			write('Valeur trop grande,rejouer une position entre 1 et 6'),nl,tourjoueur(X)
			; (C1 < 0 ->
				write('Valeur négative ou nul impossible, veuillez choisir une autre position entre 1 et 6'),nl,tourjoueur(X)
				; 	prendre(L,C1,R),
					(R =\= 0 ->
					majtable(X,Y,C1,C1)
					; write('Impossible, nombre de graine nul, veuillez choisir une autre position'),nl,tourjoueur(X)
				         )
				)
			),
		jouer.

% Fonction principale du projet

boucle_menu:- repeat,main,!.

main:-  	init,
		jouer.
		
