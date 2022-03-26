    /*
    
    Autheurs : 
        - Valentin Verstracte
        - DIALLO Boubacar Biro
        - BARRY Thierno Oumar

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
    element: TXT
        | LIGVID
        | titre
        | liste
        | texte_formatte 
    titre: BALTIT TXT FINTIT 
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST
    texte_formatte: italique 
        | gras 
        | grasitalique 
    italique: ETOILE TXT ETOILE 
    gras: ETOILE ETOILE TXT ETOILE ETOILE 
    grasitalique: ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
    liste_textes: TXT  
        | texte_formatte 
        | TXT liste_textes 
        | texte_formatte liste_textes 
%%