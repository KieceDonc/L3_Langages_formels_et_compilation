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
    int listIndex = 0;
    int inList = 0;

    extern int TAB[100][5];
%}
%union {int indice;}

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
        | liste {listIndex=0;inList = 0;changeTabValue(yyval.indice,3,-2);}
        | texte_formatte 
    titre: BALTIT texte FINTIT 
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST 
    texte_formatte: italique 
        | gras 
        | grasitalique 
    italique: ETOILE texte ETOILE {changeTabValue(yyval.indice,4,1);}
    gras: ETOILE ETOILE texte ETOILE ETOILE {changeTabValue(yyval.indice,4,2);}
    grasitalique: ETOILE ETOILE ETOILE texte ETOILE ETOILE ETOILE {changeTabValue(yyval.indice,4,3);}
    liste_textes: texte  {initList(yyval.indice);listIndex++;}
        | texte_formatte  {initList(yyval.indice);listIndex++;}
        | texte liste_textes {initList(yyval.indice);}
        | texte_formatte liste_textes {initList(yyval.indice);}
    texte: TXT {handleList(yyval.indice);}
        | TXTETOILE {handleList(yyval.indice);}
        | TXTANTISLASH {handleList(yyval.indice);}
%%

int initList(int indice){
    if(!inList){
        changeTabValue(indice,3,-1);
        inList = 1;
    }
}

int handleList(int indice){
    if(inList){
        if(TAB[indice][3]!=-1){
            changeTabValue(indice,3,listIndex);
        }
    }
}

void changeTabValue(int indexD1, int indexD2,int value){
    TAB[indexD1][indexD2]=value;
}