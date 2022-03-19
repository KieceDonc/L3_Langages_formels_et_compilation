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
    extern int yylval;

%}

TXT [^\t" "#*_\n]+[^#*_\n]*
BALTIT ^" "{0,3}"#"{1,6}" "+
FINTIT \n|\n" "*\n+
LIGVID (\n|\r\n)(" "*(\n|\r\n))+
DEBLIST ^"*"" "+
ITEMLIST ^"*"" "+
FINLIST (\n|\r\n)(" "*(\n|\r\n))+
ETOILE "*"

%start TITRE
%start ITEM

%%
[" "|\t] {
    printf("");
}

{TXT} {
    printf("Morceau de texte : %s\n",yytext);
    yylval = yyleng;
    return TXT;
}

{BALTIT} {
    printf("Balise de titre\n");
    yylval = yyleng;
    BEGIN TITRE;
    return BALTIT;
}

<TITRE>{FINTIT} {
    printf("Fin de titre\n");
    yylval = yyleng;
    BEGIN INITIAL;
    return FINTIT;
}

<INITIAL>{LIGVID} {
    printf("Ligne vide\n");
    yylval = yyleng;
    return LIGVID; 
}

<INITIAL>{DEBLIST} {
    printf("Début de liste\n");
    yylval = yyleng;
    BEGIN ITEM;
    return DEBLIST;
}

<ITEM>{ITEMLIST} {
    printf("Item de liste\n");
    yylval = yyleng;
    return ITEMLIST;
}

<ITEM>{FINLIST} {
    printf("Fin de liste\n");
    yylval = yyleng;
    BEGIN INITIAL;
    return FINLIST;
}

{ETOILE} {
    printf("Etoile\n");
    yylval = yyleng; 
    return ETOILE;
}

\n {
    printf("");
}

. {
    printf("Erreur lexicale : Caractère %s non autorisé\n",yytext);
}

%%