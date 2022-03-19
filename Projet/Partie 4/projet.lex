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
    int position = 1;
    int it = 0;
    int TAB[100][3];
%}

TXT [^#*_\n]+
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
    fillTab(position,yyleng,0);
    return TXT;
}

{BALTIT} {
    printf("Balise de titre\n");
    fillTab(position,yyleng,2);
    BEGIN TITRE;
    return BALTIT;
}

<TITRE>{FINTIT} {
    printf("Fin de titre\n");
    fillTab(position,yyleng,2);
    BEGIN INITIAL;
    return FINTIT;
}

<INITIAL>{LIGVID} {
    printf("Ligne vide\n");
    return LIGVID; 
}

<INITIAL>{DEBLIST} {
    printf("Début de liste\n");
    fillTab(position,yyleng,1);
    BEGIN ITEM;
    return DEBLIST;
}

<ITEM>{ITEMLIST} {
    printf("Item de liste\n");
    fillTab(position,yyleng,1);
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
void fillTab(int posi, int length, int type){
	TAB[it][0] = posi;
	TAB[it][1] = length;
	TAB[it][2] = type;
	position+=length;
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
                printLineTab(x,"normal");
                break;
            }
            case 1:{
                printLineTab(x,"item");
                break;
            }
            case 2:{
                printLineTab(x,"titre");
                break;
            }
        } 
    }
}

int yywrap(){
    printTAB();
    return 1;
}