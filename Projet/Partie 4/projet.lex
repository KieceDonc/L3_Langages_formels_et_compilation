%{
    /*
    
    Autheurs : 
        - Valentin Verstracte (Environ 85 % du travail effectuer)
        - DIALLO Boubacar Biro (Environ 5%)
        - BARRY Thierno Oumar (Environ 10%)
        - Im

    Compiler :
        make analyseur

    Pour tester sur un fichier :
        analyseur.o < (nom_du_fichier).txt
        
    */
    #include<stdio.h>
    #include "y.tab.h"
    
    int it = 0;
    int TAB[100][3];
    
    char CH[1000];
    
    void yyerror(char * s);
%}

TXT [^\t" "#*_\n]+[^#*_\n]*
BALTIT ^" "{0,3}"#"{1,6}" "+
FINTIT (\n|\r\n)
LIGVID (\n|\r\n)(" "*(\n|\r\n))+
DEBLIST ^"*"" "+
ITEMLIST ^"*"" "+
FINLIST {LIGVID}
ETOILE "*"

%start TITRE
%start ITEM

%%
(" "|\t)+ {
    printf("");
}

<ITEM>{TXT} {
    onText(yytext,1);
    return TXT;
}

<TITRE>{TXT} {
    onText(yytext,2);
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

<INITIAL>{LIGVID} {
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
    return ITEMLIST;
}

<ITEM>{FINLIST} {
    printf("Fin de liste\n");
    BEGIN INITIAL;
    return FINLIST; 
}

<INITIAL>{TXT} {
    onText(yytext,0);
    return TXT;
}

{ETOILE} {
    printf("Etoile\n");
    return ETOILE;
}

\n ;

. {
    printf("Erreur lexicale : Caractère %s non autorisé\n",yytext);
}

%%

void onText(char * str, int type){
    printf("Morceau de texte : %s\n",str);

    TAB[it][0] = strlen(CH);
	TAB[it][1] = strlen(str);
	TAB[it][2] = type;
	strcat(CH,str);
    it+=1;
}

void printLineTab(int index, char str[]){
    printf("\t%d\t|\t%d\t|\t%s\t\n",TAB[index][0],TAB[index][1],str);
}

void printTAB(){
	printf("position\t|length\t\t|type\t\n");
	for(int x = 0 ; x < it ; x++){
        int type = TAB[x][2];
        switch(type){
            case 0:{
                printLineTab(x,"Normal");
                break;
            }
            case 1:{
                printLineTab(x,"Item");
                break;
            }
            case 2:{
                printLineTab(x,"Titre");
                break;
            }
        } 
    }
}

int main(){
    yyparse();
    printTAB();
    return 0;
}

void yyerror(char *s){
    fprintf(stderr, "Erreur syntaxique\n", s);
}