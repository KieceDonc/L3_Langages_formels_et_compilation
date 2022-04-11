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
    
    int listIndex = 1;
    int tabHTML = 2;

    extern int TAB[100][5];
    extern char CH[1000];
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
        | LIGVID {writeInHTMLWithConcact("<br>",tabHTML);}
        | titre 
        | liste {listIndex = 1;}
        | texte_formatte 
    titre: BALTIT TXT FINTIT {writeInHTMLWithConcact("<br>",tabHTML);}
    liste: DEBLIST liste_textes suite_liste 
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST 
    texte_formatte: italique 
        | gras 
        | grasitalique 
    italique: ETOILE TXT ETOILE {changeTabValue($2,4,1);$$ = $2;}
    gras: ETOILE ETOILE TXT ETOILE ETOILE {changeTabValue($3,4,2);$$ = $3;}
    grasitalique: ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE {changeTabValue($4,4,3);$$ = $4;}
    liste_textes: TXT  {changeTabValue($1,3,listIndex++);$$ = listIndex-1;}
        | texte_formatte  {changeTabValue($1,3,listIndex++);$$ = listIndex-1;}
        | TXT liste_textes {changeTabValue($1,3,$2); $$ = listIndex-1;}
        | texte_formatte liste_textes {changeTabValue($1,3,$2); $$ = listIndex-1;}
%%

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

void writeInHTMLText(int index){
    char text[500]; 
	strncpy(text,&CH[TAB[index][0]],TAB[index][1]); 
    text[TAB[index][1]] = '\0'; 
    writeInHTML(text);
}

void writeInHTMLWithConcact(char* text,int tabValue){
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