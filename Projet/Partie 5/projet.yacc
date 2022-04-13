    /*
    
    Autheurs : 
        - Valentin Verstracte ( Travail réalisé seul après plusieurs discordes dans mon groupe )

    Compiler :
        make test

    Pour tester sur un fichier :
        analyseur.o < (nom_du_fichier).txt
        
    */

%{
    #include <stdio.h>
    #include <stdlib.h>

    FILE* htmlFile;
    int listHasStarted = 0;
    int listItemHasStarted = 0;
    int listItemIndex = 1;
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
    element: TXT {writeInHTMLCHText($1,tabHTML);}
        | LIGVID {writeInHTMLWithConcact("<br>",tabHTML);}
        | titre 
        | liste {listItemIndex = 1;listHasStarted = 0; listItemHasStarted = 0;tabHTML--;writeInHTMLWithConcact("</ul>",tabHTML);}
        | texte_formatte {writeInHTMLCHText($1,tabHTML);}
    titre: BALTIT TXT FINTIT {writeInHTMLHeader($1,$2);}
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST {writeInHTMLList($1);}
    texte_formatte: italique 
        | gras 
        | grasitalique 
    italique: ETOILE TXT ETOILE {changeTabValue($2,4,1);$$ = $2;}
    gras: ETOILE ETOILE TXT ETOILE ETOILE {changeTabValue($3,4,2);$$ = $3;}
    grasitalique: ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE {changeTabValue($4,4,3);$$ = $4;}
    liste_textes: TXT  {changeTabValue($1,3,listItemIndex++);$$ = listItemIndex-1;}
        | texte_formatte  {changeTabValue($1,3,listItemIndex++);$$ = listItemIndex-1;}
        | TXT liste_textes {changeTabValue($1,3,$2); $$ = listItemIndex-1;}
        | texte_formatte liste_textes {changeTabValue($1,3,$2); $$ = listItemIndex-1;}
%%

void changeTabValue(int indexD1, int indexD2,int value){
    TAB[indexD1][indexD2]=value;
}

void closeHTMLFilePointer(){
    if(htmlFile != NULL){
        fclose(htmlFile);
    }
}

void writeInHTMLList(int indexLastItem){
    int founded = 0;
    int index = indexLastItem-1;
    while(!founded){
        if(index > 0){
            founded = TAB[index][3] == 0;
        }else{
            founded = 1;
        }
        index--;
    }
    index+=2;

    int currentItemIndex = TAB[index][3];
    for(int x = index; x <= indexLastItem; x++){
        if(currentItemIndex == TAB[x+1][3]){
            if(x!=indexLastItem){
                writeInHTMLListHelper(x,0,1);
            }else{
                writeInHTMLListHelper(x,0,0);

            }
        }else{
            writeInHTMLListHelper(x,1,1);
            currentItemIndex = TAB[x+1][3];
        }
    }
}

void writeInHTMLListHelper(int textIndex, int changeItem, int allowOpenItem){
    if(!listHasStarted){
        writeInHTMLWithConcact("<ul>",tabHTML);
        tabHTML++;
        listHasStarted = 1;
    }

    if(!listItemHasStarted && allowOpenItem){
        writeInHTMLWithConcact("<li>",tabHTML);
        tabHTML++;
        listItemHasStarted = 1;
    }

    writeInHTMLCHText(textIndex);

    if(changeItem){
        tabHTML--;
        writeInHTMLWithConcact("</li>",tabHTML);
        listItemHasStarted = 0;
    }

}

void writeInHTMLHeader(int headerType, int textIndex){
    char buffer[500];
    sprintf(buffer, "<h%d>", headerType);
    writeInHTMLWithConcact(buffer,tabHTML);
    tabHTML++;
    writeInHTMLCHText(textIndex);
    tabHTML--;
    sprintf(buffer, "</h%d>", headerType);
    writeInHTMLWithConcact(buffer,tabHTML);
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

void writeInHTMLCHText(int index){
    char text[500]; 
	strncpy(text,&CH[TAB[index][0]],TAB[index][1]); 
    text[TAB[index][1]] = '\0'; 
    switch(TAB[index][4]){
        case 1:{
            writeInHTMLWithConcact("<i>",tabHTML);
            break;
        }
        case 2:{
            writeInHTMLWithConcact("<strong>",tabHTML);
            break;
        }
        case 3:{
            writeInHTMLWithConcact("<i><strong>",tabHTML);
            break;
        }
    }
    tabHTML++;
    writeInHTMLWithConcact(text,tabHTML);
    tabHTML--;
    switch(TAB[index][4]){
        case 1:{
            writeInHTMLWithConcact("</i>",tabHTML);
            break;
        }
        case 2:{
            writeInHTMLWithConcact("</strong>",tabHTML);
            break;
        }
        case 3:{
            writeInHTMLWithConcact("</i></strong>",tabHTML);
            break;
        }
    }
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