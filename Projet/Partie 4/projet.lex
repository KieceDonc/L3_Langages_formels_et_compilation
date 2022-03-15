%{
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
    #include<stdio.h>
    #include "y.tab.h"
    int withDebug = 0;
    char CH[1000];

%}

TXT ([^#*_\n]+)
BALTIT (^" "{0,3}"#"{1,6}" "+)
FINTIT (\n|\n" "*\n+)
LIGVID ((\n|\r\n)(" "*(\n|\r\n))+)
DEBLIST (^"*"" "+)
ITEMLIST (^"*"" "+)
FINLIST ((\n|\r\n)(" "*(\n|\r\n))+)
ETOILE ("*")

%start TITRE
%start ITEM

%%
[" "|\t] {
    printf("");
}

{TXT} {
    printf("Morceau de texte\n");
    strcat(CH,yytext);
    return TXT;
}

<INITIAL>{BALTIT} {
    printf("Balise de titre\n");
    BEGIN TITRE;
    return BALTIT;
}

<TITRE>{FINTIT} {
    printf("Fin de titre\n");
    BEGIN INITIAL;
    return FINTIT;
}

{LIGVID} {
    printf("Ligne vide\n");
    return LIGVID; 
}

<INITIAL>{DEBLIST} {
    printf("Début de liste\n");
    BEGIN ITEM;
    return DEBLIST;
}

<ITEM>{ITEMLIST} {
    printf("Item de liste\n");
    BEGIN INITIAL;
    return ITEMLIST;
}

<ITEM>{FINLIST} {
    printf("Fin de liste\n");
    BEGIN INITIAL;
    return FINLIST;
}

{ETOILE} {
    printf("Etoile\n"); 
    return ETOILE;
}

. {
    printf("");
}

%%

int main()
{
    yyparse();
    
}