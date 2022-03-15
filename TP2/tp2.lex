%{
    #include<stdio.h>
    int tab[100][5];
    int tab_index = 0;
    int offset = 1;
%}

%%

[^\t" "#*_\n]+[^#*_\n]* {
    printf("%s",yytext);
    incomingData(yyleng,0,0,0);
}

"*" {
    incomingData(0,1,0,0);
}

_ { 
    incomingData(0,11,0,0);
}

[^_] {
    printf("");
}
%%

int incomingData(int length, int type, int category, int titleType){
    // type 0|1|11, 0 = texte, 1 = étoile, 11 = titre
    // category 0|1|11, 0 = normal, 1 = item, 11 = titre

    tab[tab_index][0] = offset;
    tab[tab_index][1] = length;
    tab[tab_index][2] = type;
    tab[tab_index][3] = category;
    tab[tab_index][4] = titleType;

    offset+=length;

    return ++tab_index;
}

int countDieze(char array[]){
    size_t length = sizeof(array)/sizeof(array[0]);
    int count = 0;
    for(int x = 0; x<length; x++){
        if(array[x] == '#'){
            count+=1;
        }
    }
    return count;
}

void printTab(){
    printf("\n");
    for(int x = 0;x<tab_index;x++){
        printf("|\t%d\t|\t%d\t|\t%d\t|\t%d\t|\t%d\t|\n",tab[x][0],tab[x][1],tab[x][2],tab[x][3],tab[x][4]);
    }   
}

int main(){
    yylex();
    printTab();
    return 0;
}
