    /*
    
    Autheurs : 
        - Valentin Verstracte ( Travail réalisé seul après plusieurs discordes dans mon groupe )

    Compiler :
        make analyseurs

    Pour tester sur un fichier :
        analyseur.o < (nom_du_fichier).txt
        
    */

%{
    #include <stdio.h>
    #include <stdlib.h>

%}

%token  TXT
%token  TXTETOILE
%token  TXTANTISLASH
%token  BALTIT
%token  FINTIT
%token  LIGVID 
%token  DEBLIST
%token  ITEMLIST
%token  FINLIST
%token  ETOILE

%start fichier

%%
    fichier: element
        | element fichier
    element: texte
        | LIGVID
        | titre
        | liste
        | texte_formatte 
    titre: BALTIT texte FINTIT 
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST
    texte_formatte: italique 
        | gras 
        | grasitalique 
    italique: ETOILE texte ETOILE 
    gras: ETOILE ETOILE texte ETOILE ETOILE 
    grasitalique: ETOILE ETOILE ETOILE texte ETOILE ETOILE ETOILE
    liste_textes: texte  
        | texte_formatte 
        | texte liste_textes 
        | texte_formatte liste_textes 
    texte: TXT
        | TXTETOILE
        | TXTANTISLASH
%%