%{
    /*
    
    Autheurs : 
        - Valentin Verstracte ( Travail réalisé seul après plusieurs discordes dans mon groupe )

    Compiler :
        make test

    Pour tester sur un fichier :
        analyseur.o < (nom_du_fichier).txt
        
    */
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
    
    int it = 0;
    int TAB[100][5];
    
    char CH[1000];
    
    void yyerror(char * s);
%}

TXT (([^\t" "\\#*_\n]+[^#*\\_\n]*)|\\\*|\\|\\\*" "|\\" ")*
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
    int occ = 0;
    for (occ=0; yytext[occ]; yytext[occ]=='#' ? occ++ : *yytext++); // Pas mon code, jolie trouvail de stackoverflow https://stackoverflow.com/a/4235884
    yylval = occ;
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
    yylval = it;
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
    TAB[it][3] = 0;
    TAB[it][4] = 0;
    strcat(CH,str);
    yylval = it;
    it+=1;
}

char* getType(int type){
    switch(type){
        case 0:{
            return "Normal";
            break;
        }
        case 1:{
            return "Item";
            break;
        }
        case 2:{
            return "Titre";
            break;
        }
    }
}

char* getShaping(int shaping){
    switch(shaping){
        case 0:{
            return "\t";
            break;
        }
        case 1:{
            return "Italique";
            break;
        }
        case 2:{
            return "Gras\t";
            break;
        }
        case 3:{
            return "Italique & Gras";
            break;
        }
    }
}

char* getListInfo(int listInfo, char* toConcat){
    if(listInfo>0){
        sprintf(toConcat, "Item n°%d", listInfo);
        return toConcat;
    }else{
        return "\t";
    }
}

void printLineTab(int index, char type[], char listInfo[], char shaping[]){
    printf("\t%d\t|\t%d\t|\t%s\t|\t%s\t|\t%s\n",TAB[index][0],TAB[index][1],type,listInfo,shaping);
}

void printTAB(){
	printf("\n\n\nposition\t|length\t\t|type\t\t|listInfo\t\t|shaping\n");
	for(int x = 0 ; x < it ; x++){
        char toConcat[20];
        printLineTab(x,getType(TAB[x][2]),getListInfo(TAB[x][3],toConcat),getShaping(TAB[x][4]));
    }
}

yywrap(){
    printTAB();
}

void yyerror(char *s){
    fprintf(stderr, "Erreur syntaxique\n", s);
}