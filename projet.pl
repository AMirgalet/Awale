% Une fonction d'initialisation du plateau de jeu
init:-		asserta(tablejoueur(j1,[4, 4, 4, 4, 4, 4],0) ),
		asserta(tablejoueur(j2,[4, 4, 4,4, 4, 4],0) ),
	    	asserta(joueur(j2)).

%--------------------------------------------------

%Fonction permettant de connaitre qui joue
tourjoueur(X):- joueur(X),
		(X==j1->
		!,retract(joueur(_)),
		asserta(joueur(j2));
		!,retract(joueur(_)),
		asserta(joueur(j1))
		).

autrejoueur(Y):- joueur(Y).
		
joueursuivant:-
		joueur(X),
		(X==j1->
		!,retract(joueur(_)),
		asserta(joueur(j2));
		!,retract(joueur(_)),
		asserta(joueur(j1))
		).

adversaire(Y):-
		joueur(X),
		(X==j1->
			Y=j2
		;
			Y=j1
		).

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


verif_valeur_points(Joueur,Autre,0,2):-
		pts(Joueur, Autre, 0),
	!.

verif_valeur_points(Joueur,Autre,0,3):-
		pts(Joueur, Autre, 0),
	!.


		
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

%Verification de fin
victoire(Joueur):-
		tablejoueur(Joueur, Liste, Points),
		write(' Victoire du joueur: '),write(Joueur), write(' avec un score de '),write(Points).

egalite:- write('Egalite entre les deux joueurs!').


%Verification que la liste donnée a toutes ses cases à 0
verif_position_zero(Liste, 6, 0, Retour):-
		prendre(Liste, 0, R),
		Retour is R+1,
		!.
		
verif_position_zero(Liste, Position, 0, Retour):-
		prendre(Liste, Position, R),
		( R <  1 ->
				NewPosition is Position +1,
				verif_position_zero(Liste, NewPosition, 0, Retour);
				Retour is R-R
		).
%On verifie que, quoi que le joueur joue, aucune graine arrivera sur le terrain ennemi
verif_liste_autre(Liste, 0, Retour):-
		prendre(Liste, 0, R),
		ValeurTest is 5 - R,
		( 0 =< ValeurTest ->
				Retour is R- R;
				Retour is Position +1
		),
		!.

verif_liste_autre(Liste, Position, Retour):-
		prendre(Liste, Position, R),
		ValeurTest is 5 - R,
		( Position =< ValeurTest ->
				NewPosition is Position -1,
				verif_liste_autre(Liste, NewPosition, Retour);
				Retour is Position
		).
		
%On verifie si on est en position de blocage en fin de jeu
verif_blocage(Joueur,Autre, RetourVerif):-
		tablejoueur(Joueur, Liste, Points),
		tablejoueur(Autre,ListeAutre, PointsAutre),
		verif_position_zero(Liste, 0, 0, Retour),
		( Retour > 0 ->
				verif_liste_autre(ListeAutre, 5, RetourAutre),
				RetourVerif is RetourAutre;
				write('')
		).
		
%On compte les points restants sur le plateau pour les ajouter au score final		
prendre_points_fin(Joueur, 6, NewPoints):-
		!.
		
prendre_points_fin(Joueur, Position, PointsTemp):-
		tablejoueur(Joueur, Liste, Points),
		prendre(Liste, Position, R),
		NewPoints is Points + R,
		NewPosition is Position +1,
		write('de: '), write(NewPoints),nl,
		retract(tablejoueur(Joueur,Liste, Points)),
 		asserta(tablejoueur(Joueur,Liste, NewPoints)),
		prendre_points_fin(Joueur, NewPosition, PointsTemp).

%Le jeu est en blocage, on compte donc les points pour connaitre le vainqueur
fin_jeu_decompte_points(Joueur,Autre):-
		prendre_points_fin(Joueur, 0, NewPoints),
		tablejoueur(Joueur, Liste, Points),
		write('final: '),write(Points),nl,
		prendre_points_fin(Autre, 0, NewPointsAutre),
		tablejoueur(Autre, ListeAutre, PointsAutre),
		write('final: '),write(PointsAutre),nl,
		( Points > PointsAutre ->
				victoire(Joueur);
				( Points < PointsAutre ->
						victoire(Autre);
						egalite
				)
		).
		
verification_fin(Joueur,Autre):-
		tablejoueur(Joueur, Liste, Points),
		tablejoueur(Autre,ListeAutre, PointsAutre),
		( Points > 24 ->
				write('arrive la'),nl,
				victoire(Joueur)
		;
				verif_blocage(Joueur, Autre, Retour),
				( Retour == 0 ->
						fin_jeu_decompte_points(Joueur,Autre)
				;
						verif_blocage(Autre,Joueur, RetourAutre),
						(RetourAutre == 0 ->
								fin_jeu_decompte_points(Autre,Joueur)
						;
								jouer
						)
				)	
		).

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

% Fonction permettant de connaitre les coups engendrant une prise

coup_prise(Joueur,Autre) :-
			tablejoueur(Joueur, Liste, PointsUn),
			tablejoueur(Autre,ListeAutre, PointsDeux),
			parcoure(ListeAutre,Compteur).

parcoure([],0).
parcoure([X|Q],Compteur):- 
		X=<2,
		X>0,
		parcoure(Q,Compteur1),
		Compteur is Compteur1+1,
		write('Prise en Position '),write(Compteur),nl.
		
		
parcoure([X|Q],Compteur) :- parcoure(Q,Compteur1),Compteur is Compteur1+1.
		

%Interrogation Joueur

jouer:-
		joueur(X),
		adversaire(Y),
		tablejoueur(X,L,P),
		tablejoueur(Y,Y2,P2),
		affichage(X,L,P,Y,Y2,P2),nl,
		write('Tour de : '),write(X),nl,
		coup_prise(X,Y),
		write('Choisir une position '),nl,
		read(C),
		C1 is C-1,
		(C1 > 5 ->
			write('Valeur trop grande,rejouer une position entre 1 et 6'), nl%, !
		;
			(C1 < 0 ->
				write('Valeur négative ou nul impossible, veuillez choisir une autre position entre 1 et 6'), nl%, !
			;
				prendre(L,C1,R),
				(R =\= 0 ->
					majtable(X,Y,C1,C1),
					joueursuivant
				;
					write('Impossible, nombre de graine nul, veuillez choisir une autre position'), nl%, !
				)
			)
		),
		
		verification_fin(X,Y).

% Fonction principale du projet

boucle_menu:- repeat,jouer,!.

main:- init, boucle_menu.



		
