% ---------------------------------------------------
% ------------------- AWALE -------------------------
% ---------------------------------------------------
% 
% Projet réalisé dans le cadre de l'UV IA02 de l'Université de Technologie de Compiègne (UTC).
%
% Membres du groupe:	Sami 		Yacoubi
% 						Nicolas 	Szewe
%						Alexandre 	Mirgalet
%
%
%
% ---------------------------------------------------
% -----		FONCTIONS DE BASE
% ---------------------------------------------------
%
% Ici nous plaçons toute nos fonctions dites usuelle ou de base
%

	% Une fonction d'initialisation du plateau de jeu
init:-	asserta(tablejoueur(j1,[4, 4, 4, 4, 4, 4], 0) ),
		asserta(tablejoueur(j2,[4, 4, 4, 4, 4, 4], 0) ),
	    asserta(joueur(j2)),
	    asserta(possible(99)).	
			

	% Permet de passer au joueur suivant	
joueursuivant:-
		joueur(X),	% On récupère le joueur actuel, et on change le prédicat en mémoire en fonction de cette valeur.
		(X==j1->
			!,
			retract(joueur(_) ),
			asserta(joueur(j2) )
		;
			!,
			retract(joueur(_) ),
			asserta(joueur(j1) )
		).

	% Permet de retourner l'adversaire du joueur courant
adversaire(Y):-
		joueur(X),
		(X==j1->
			Y=j2
		;
			Y=j1
		).

	% Récupère l'élément en position X dans lal liste L
prendre(L,X,R):- nth0(X,L,R).	

	% Inverse la liste L1 et la renvoie dans L2
inverse(L1, L2):-inverse(L1, [], L2).

inverse([], L2, L2).
inverse([X|Rest], Tmp, L2):-
	inverse(Rest, [X|Tmp], L2).

	% Modifie la valeur de l'élément en position Position avec la valeur Valeur, et retourne la nouvelle liste dans NouvelleListe
modifier(Liste, Position, Valeur, NouvelleListe):-  
   	length(Temporaire, Position), % Créé une liste Temporaire de longueur Position
    append(Temporaire, [_|Tail], Liste), % Permet d'obtenir Tail, c'est à dire la liste des éléments suivant l'élément à la position Position
    append(Temporaire, [Valeur|Tail], NouvelleListe).

% replace([_|T], 0, X, [X|T]).
% replace([H|T], I, X, [H|R]):-
	% I > -1,
	% NI is I-1,
	% replace(T, NI, X, R),
	% !.
% replace(L, _, _, L).


% ---------------------------------------------------
% -----		FONCTIONS D'AFFICHAGE
% ---------------------------------------------------
%
% Ici nous plaçons toute nos fonctions dites usuelle ou de base
%

	% Imprime la liste passée en argument
imprime_liste([Q]):-
		write(Q).
imprime_liste([T|Q]):-
		write(T),
		write('-'),
		imprime_liste(Q).

	% Imprime la liste passée en argument de manière inversée
imprime_liste_inversee(L):-
		inverse(L, L1),
		imprime_liste(L1).

	% Affiche l'état du jeu en cours
affichage(JoueurUn, ListeUn, PtsUn, JoueurDeux, ListeDeux, PtsDeux):-
				write('   ___________'), nl,
					write(JoueurDeux),
					write('|'),
					imprime_liste_inversee(ListeDeux),
					write('|'),
					write('Score: '),
					write(PtsDeux),
					nl,
				write('  |___________|'), nl,
					write(JoueurUn),
					write('|'),
					imprime_liste(ListeUn),
					write('|'),
					write('Score: '),
					write(PtsUn),
					nl,
				write('  |___________|'), nl.
				
	% Affichage en cas de victoire d'un des joueurs
victoire( Joueur):-
		tablejoueur( Joueur, _, Points),
		write(' Victoire du joueur: '),
		write( Joueur),
		write(' avec un score de '),
		write(Points).

	% Affichage en cas d'égalité
egalite:-
		write('Egalite entre les deux joueurs!').


% ---------------------------------------------------
% -----		FONCTIONS DE VERIFICATION
% ---------------------------------------------------
%
% Nous avons ici les fonctions de vérification
%

verif_compte_points( Joueur, Autre, Position, 0, Value):-
		verif_valeur_points( Joueur, Autre, Position, Value),
		!.
verif_compte_points( _, _, _, _, _).
% Verif_compte_points verifie que nous sommes bien arrivé à la fin du coup du jouer grace à la condition R1=0


verif_valeur_points( Joueur, Autre, 0, 2):-
		pts( Joueur, Autre, 0), !.
verif_valeur_points( Joueur, Autre, 0, 3):-
		pts( Joueur, Autre, 0), !.
verif_valeur_points( Joueur, Autre, Position, 2):-
		pts( Joueur, Autre, Position, 2), !.
verif_valeur_points( Joueur, Autre, Position, 3):-
		pts( Joueur, Autre, Position, 3), !.
verif_valeur_points( _, _, _, _).
% Cette dernière condition exclue toute possibilité de point si on arrive sur une zone adverse ou il y a plus de 3 graines.

% ---------------------------------------------------
% -----		FONCTIONS DE JEU
% ---------------------------------------------------
%
% Nous avons ici les fonctions qui servent au fonctionnement du jeu
%

	% Fonction de calcul de points
pts( Joueur, Autre, Position):-
		tablejoueur( Joueur, Liste, Points),
		tablejoueur( Autre, ListeAutre, PointsAutre),
		prendre( ListeAutre, Position,Value),
		NewPoints is Points + Value,
		retract( tablejoueur( Joueur, Liste, Points)),
 		asserta( tablejoueur( Joueur, Liste, NewPoints)),	% Mise à jour des points
		NewValue is Value - Value,	% On peut pas mettre 0 directement ?
		modifier( ListeAutre, Position, NewValue, Temp),	% Mise à jour de la table
		retract(tablejoueur(Autre, ListeAutre, PointsAutre)),
 		asserta(tablejoueur(Autre, Temp, PointsAutre)).

pts( Joueur, Autre, Position, Value):-
		tablejoueur( Joueur, Liste, Points),
		NewPoints is Points + Value,
		retract( tablejoueur( Joueur, Liste, Points)),
 		asserta( tablejoueur( Joueur, Liste, NewPoints)),
		tablejoueur(Autre, ListeAutre, PointsAutre),
		NewValue is Value - Value, % On peut pas mettre 0 directement ?
		modifier(ListeAutre,Position,NewValue,Temp),
		retract(tablejoueur(Autre,ListeAutre, PointsAutre)),
 		asserta(tablejoueur(Autre,Temp, PointsAutre)),
		NewPosition is Position -1,
		prendre(ListeAutre,NewPosition,R),
		verif_valeur_points(Joueur,Autre,NewPosition,R).
		
		

	% Pour déplacer une graine d'un état i à un état i+1 dans une seule chaine
deplacer( Joueur, Autre, Position, PositionDepart, R1):- 
		tablejoueur( Joueur, Liste, _),
		tablejoueur( Autre, _, _),
		prendre( Liste, Position, Value),	%Value est la valeur de la case que l'on va incrémenter
		NewValue is Value+1,
		prendre( Liste, PositionDepart, R),	%R est la valeur actuelle de la case de départ
											%	donc le nombre de graines restantes à répartir
		R1 is R-1,
		modifier( Liste, Position, NewValue, Tmp), 			% Tmp est la liste temporaire où seul l'élément à la position Position a été modifié
		modifier( Tmp, PositionDepart, R1, NouvelleListe),	% NouvelleListe est donc la liste où les deux valeurs ont été modifiées
		retract(tablejoueur( Joueur, Liste, Points)),
 		asserta(tablejoueur( Joueur, NouvelleListe, Points)). % On enregistre le nouvel etat du joueur Joueur.

	% Pour déplacer une graine d'un état i à un état i+1 dans les deux chaines
deplacer_deux_listes( Joueur, Autre, Position, PositionDepart, R1):- 
		tablejoueur( Joueur, Liste, PointsUn),
		tablejoueur( Autre, ListeAutre, PointsDeux),
		prendre( ListeAutre, Position, Value),	% Value est la valeur de la case que l'on va incrémenter
		Value1 is Value+1,
		prendre( Liste, PositionDepart, R),		% R est la valeur actuelle de la case de départ
													%	donc le nombre de graines restantes à répartir
		R1 is R-1,
		modifier( ListeAutre, Position, Value1, Tmp),		% Tmp est la nouvelle liste modifiee
		modifier(Liste,PositionDepart,R1,NouvelleListe),	% NouvelleListe est la nouvelle liste modifiee
		retract(tablejoueur(Joueur,Liste, PointsUn)),
 		asserta(tablejoueur(Joueur,NouvelleListe, PointsUn)),	% On enregistre le nouvel etat du joueur Joueur
		retract(tablejoueur(Autre,ListeAutre, PointsDeux)),
 		asserta(tablejoueur(Autre,Tmp, PointsDeux)),			% On enregistre le nouvel etat de son adversaire
		verif_compte_points(Joueur, Autre, Position, R1, Value1).
			% À quoi sert cette fonction ?

	%Verification que la liste donnée a toutes ses cases à 0
verif_position_zero( Liste, 6, 0, Retour):-
		prendre( Liste, 0, R),
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
				Retour is Position +1 % /!\ Position n'est pas définie ! (enfin pas là, je crois)
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
				write('arrive la'),nl, % arrive là ?! c'est un printf de test ?
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
										;
											write('')
										)
									;
										(R > 0 ->
											deplacer(Joueur,Autre,NouvellePosition,PositionDepart,R1),
											(R1 > 0 ->
												majtable(Joueur,Autre,PositionDepart,NouvellePosition);
												write('')
											)
										;
											write('')
										)
									)
								)
							).


% ---------------------------------------------------
% -----		FONCTIONS D'IA
% ---------------------------------------------------
%
% Nous avons ici les fonctions d'assistance à l'utilisateur, ou décrivant le fonctionnement de l'IA
%
	% Fonction permettant de connaitre les coups engendrant une prise
coup_prise(Joueur,Autre) :-
			tablejoueur(Joueur, Liste, PointsUn),
			tablejoueur(Autre,ListeAutre, PointsDeux),
			parcoure(ListeAutre,Compteur),
			test(Liste,5).

	% Fonction qui selectionne toute les positions possible de de prise possible sans prise en compte de la liste du joueur courant
parcoure([],0).
parcoure([X|Q], Compteur):- 
		X=<2,
		X>0,
		parcoure(Q, Compteur1),
		Compteur is Compteur1+1,
		Resultat is 6-Compteur1,
		asserta(possible(Resultat)).
parcoure([X|Q],Compteur) :-
		parcoure(Q,Compteur1),
		Compteur is Compteur1+1.

%Fonction prenant en compte la liste du joueur courant

% Reste à faire 
 %Parcours de tous les X stockée dans possible. Ici on teste un seul de ces "possible"

test(Liste,-1).
		
test(Liste,Position):- 	possible(X),
			(X  =\=  99 ->
				prendre(Liste,Position,Y),	
				Z is Position+Y+1,
				(Z =< 6 ->
					write('')
				;
					(Z >12 ->
						write('')
					;
						B is X+6,
						(Z == B ->
							write('Prise possible si tu joues :  ') , Position_S is Position+1, write(Position_S), nl
						)
					)
				)
			;
				write('')
			),
			Position1 is Position-1,
			test(Liste,Position1).


% deplacer_deux_listes(Joueur,Autre,Position,PositionDepart,R1):- 
		% tablejoueur(Joueur, Liste, PointsUn),
		% tablejoueur(Autre,ListeAutre, PointsDeux),
		% prendre(ListeAutre,Position,Value),
		% %Value est la valeur de la case a laquelle on ajoute 1
		% prendre(Liste,PositionDepart,R),
		% %R est la valeur actuelle de la case de départ
		% R1 is R-1,
		% Value1 is Value+1,
		% modifier(ListeAutre,Position,Value1,Temp),
		% %Temp est la nouvelle liste modifiee
		% modifier(Liste,PositionDepart,R1,NouvelleListe),
		% %NouvelleListe est la nouvelle liste modifiee
		% retract(tablejoueur(Joueur,Liste, PointsUn)),
 		% asserta(tablejoueur(Joueur,NouvelleListe, PointsUn)),
		% retract(tablejoueur(Autre,ListeAutre, PointsDeux)),
 		% asserta(tablejoueur(Autre,Temp, PointsDeux)),
		% verif_compte_points(Joueur, Autre, Position, R1, Value1).

% majtable(Joueur,Autre,PositionDepart,PositionAvancer) :-	
							% tablejoueur(Joueur, Liste, PointsUn),
							% tablejoueur(Autre,ListeAutre, PointsDeux),
							% prendre(Liste,PositionDepart,R),
							% %R est la valeur de la case choisie
							% NouvellePosition is PositionAvancer+1,
							% %Premiere condition pour gérer les cas ou on repasse sur la case qui distribue
							% (NouvellePosition = PositionDepart ->
								% majtable(Joueur,Autre,PositionDepart,NouvellePosition);
								% %Deuxième condition qui vérifie si que l'on retourne sur le plateau du joueur actuel si on a beaucoup de jetons
								% (NouvellePosition > 11 ->
									% PositionTemp is NouvellePosition -13,
									% majtable(Joueur,Autre,PositionDepart,PositionTemp);
									% %Troisieme condition qui vérifie si l'on distribue sur le plateau de l'adversaire
									% (NouvellePosition > 5 ->
										% (R > 0 ->
										
											% PositionChaineDeux is NouvellePosition-6,
											% deplacer_deux_listes(Joueur,Autre,PositionChaineDeux,PositionDepart,R1),
											% (R1 > 0 ->
												% majtable(Joueur,Autre,PositionDepart,NouvellePosition);
												% write('')
											% )
										% ;
											% write('')
										% )
									% ;
										% (R > 0 ->
											% deplacer(Joueur,Autre,NouvellePosition,PositionDepart,R1),
											% (R1 > 0 ->
												% majtable(Joueur,Autre,PositionDepart,NouvellePosition);
												% write('')
											% )
										% ;
											% write('')
										% )
									% )
								% )
							% ).

		% modifier(Liste,Position,Valeur,NouvelleListe)
		
% etat_suivant_potentiel(CaseChoisie, EtatSuivantJoueur, PointsSuivantJoueur, EtatSuivantAdversaire, PointsSuivantAdversaire):- % On doit lui envoyer la case choisie par l'utilisateur
		% joueur(Joueur),
		% adversaire(Adversaire),
		% tablejoueur(Joueur, ListeJoueur, PointsJoueur),
		% tablejoueur(Adversaire, ListeAdversaire, PointsAdversaire),
		% etat_suivant_potentiel( ListeJoueur, PointsJoueur, ListeAdversaire, PointsAdversaire, CaseChoisie, CaseChoisie, JoueurEnCours, EtatSuivantJoueur, EtatSuivantAdversaire)
		% .
		
		
% etat_suivant_potentiel( ListeJoueur, PointsJoueur, EtatAdversaire, PointsAdversaire, Position, PositionDepart, JoueurEnCours, EtatSuivantJoueur, EtatSuivantAdversaireAdversaire):-
		% prendre(ListeJoueur, PositionDepart, Deplacement),
		% ( Deplacement > 0 ->
			% NouveauDeplacement is Deplacement - 1,
			% modifier(ListeJoueur, PositionDepart, Deplacement, EtatIntermédiaireJoueur),
			% ( JoueurEnCours == joueur ->
				% prendre(ListeJoueur, Position, Valeur), % On récupère Valeur à la position Position dans ListeJoueur
				% NouvelleValeur is Valeur + 1, % On l'incrémente de 1
				% modifier(EtatIntermédiaireJoueur, Position, NouvelleValeur, EtatIntermédiaireJoueur2)
			
			% )	
		% ).
		

victoire_en_un_coup(PositionChoisie):- % S'efface si la position permet de gagner
		joueur(Joueur),
		adversaire(Adversaire)
		% En cours de rédaction
		.



% ---------------------------------------------------
% -----		FONCTIONS PRINCIPALES
% ---------------------------------------------------
%
% Nous avons ici les fonctions qui servent au lancement du jeu
%

% Fonction décrivant un tour de jeu
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
main:- init, repeat, jouer, !.



		
