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

    FILE* htmlFile;
    
    int listIndex = 0;
    int inList = 0;
    int tabHTML = 2;

    extern int TAB[100][6];
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
        | LIGVID {changeTabValue(yyval.indice,5,1);writeInHTMLWithContact("<br>",tabHTML);}
        | titre 
        | liste {listIndex=0;inList = 0;}
        | texte_formatte 
    titre: BALTIT texte FINTIT {changeTabValue(yyval.indice,5,1);writeInHTMLWithContact("<br>",tabHTML);}
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST {changeTabValue(yyval.indice,5,1);changeTabValue(yyval.indice,3,-2);writeInHTMLWithContact("</ul>",--tabHTML);writeInHTMLWithContact("<br>",tabHTML);}
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
        writeInHTMLWithContact("<ul>",tabHTML++);
        writeInHTMLWithContact("<li>Some text</li>",tabHTML);
    }
}

int handleList(int indice){
    if(inList){
        if(TAB[indice][3]!=-1){
            changeTabValue(indice,3,listIndex+1);
            writeInHTMLWithContact("<li>Some text</li>",tabHTML);
        }
    }
}

void changeTabValue(int indexD1, int indexD2,int value){
    TAB[indexD1][indexD2]=value;
}

void closeHTMLFilePointer(){
    if(htmlFile != NULL){
        fclose(htmlFile);
    }
}

void writeBeginningHTML(){
    htmlFile = fopen("projet.html", "w");
    fprintf(htmlFile, "");
    closeHTMLFilePointer();
    htmlFile = fopen("projet.html", "a");
    writeInHTML("<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset='utf-8'>\n\t\t<title>Projet LFC</title>\n\t</head>\n\t<body>\n");   
}

void writeEndHTML(){
    writeInHTML("\n\t</body>\n</html>");
    closeHTMLFilePointer();
}

void writeInHTMLWithContact(char* text,int tabValue){
    for(int x = 0; x < tabValue ; x++){
        writeInHTML("\t");
    }
    writeInHTML(text);
    writeInHTML("\n");
}

void writeInHTML(char* text){
    fprintf(htmlFile, "%s", text);
}

int main(){
    writeBeginningHTML();
    yyparse();
    yywrap();
    writeEndHTML();
    return 0;
}