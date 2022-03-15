y.tab.c: notes.yacc
	yacc notes.yacc

y.tab.h: notes.yacc
	yacc -d notes.yacc

lex.yy.c: notes.lex 
	lex notes.lex

lex.yy.o: lex.yy.c y.tab.h
	gcc -Wall -c lex.yy.c

analyseur: y.tab.c lex.yy.o
	gcc -Wall y.tab.c lex.yy.o -lfl -o analyseur

test: analyseur test.txt
	./analyseur < test.txt

clear:
	(rm y.tab.h; rm y.tab.c; rm lex.yy.c: rm *.o; rm analyseur;) 2> /dev/null