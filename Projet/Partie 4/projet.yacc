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

%start Fichier

%%
    Fichier:Element | Element Fichier
    Element:TXT | LIGVID | Titre | Liste | Texte_formante
    Titre:BALTIT TXT FINTIT
    Liste:DEBLIST Liste_texte Suite_liste
    Suite_liste:ITEMLIST Liste_texte Suite_liste | FINLIST
    Texte_formante:Italique | Gras | Grasitalique
    Gras:ETOILE TXT ETOILE
    Italique:ETOILE ETOILE TXT ETOILE ETOILE
    Grasitalique:ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE
    Liste_texte:TXT | Texte_formante | TXT Liste_texte | Texte_formante Liste_texte
%%

int main(){
    yyparse();
    return 0;
}

void yyerror(char *s){
    fprintf(stderr, "erreur %s\n", s);
}