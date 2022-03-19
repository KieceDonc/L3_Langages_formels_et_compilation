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

    void yyerror(char * s);

    int position = 0;
    int it = 0;
    int TAB[100][3];
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
    element: TXT {fillTab($1,0);}
        | LIGVID
        | titre
        | liste
        | texte_formante {fillTab($$,0);}
    titre: BALTIT TXT FINTIT {fillTab($2,2);};
    liste: DEBLIST liste_textes suite_liste
    suite_liste: ITEMLIST liste_textes suite_liste 
        | FINLIST
    texte_formante: italique {$$ = $1;};
        | gras {$$ = $1;};
        | grasitalique {$$ = $1;};
    italique: ETOILE TXT ETOILE {$$ = $2;}
    gras: ETOILE ETOILE TXT ETOILE ETOILE {$$ = $3;};
    grasitalique: ETOILE ETOILE ETOILE TXT ETOILE ETOILE ETOILE {$$ = $4;};
    liste_textes: TXT {fillTab($1,1);}; 
        | texte_formante {fillTab($1,1);};
        | TXT liste_textes {fillTab($1,1);};
        | texte_formante liste_textes {fillTab($1,1);};
%%

void fillTab(int length, int type){
	TAB[it][0] = position;
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
    yywrap();
    return 0;
}

void yywrap(){
    printTAB();
    return 1;
}

void yyerror(char *s){
    fprintf(stderr, "erreur syntaxique\n", s);
}