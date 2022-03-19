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
    #include <string.h>
    void yyerror(char * s);
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
        | texte_formante
    titre: BALTIT TXT FINTIT
    liste: DEBLIST liste_texte suite_liste
    suite_liste: ITEMLIST liste_texte suite_liste
        | FINLIST
    texte_formante: italique
        | gras
        | grasitalique
    italique: ETOILE TXT ETOILE
    gras: ETOILE ETOILE TXT ETOILE ETOILE
    grasitalique: ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
    liste_texte: TXT
        | texte_formante
        | TXT liste_texte
        | texte_formante liste_texte
%%

int main(){
    yyparse();
    yywrap();
    return 0;
}

void yyerror(char *s){
    fprintf(stderr, "erreur %s\n", s);
}