y.tab.c: notes2.yacc
	yacc notes2.yacc

y.tab.h: notes2.yacc
	yacc -d notes2.yacc

lex.yy.c: notes2.lex 
	lex notes2.lex

lex.yy.o: lex.yy.c y.tab.h
	gcc -Wall -c lex.yy.c

analyseur: y.tab.c lex.yy.o
	gcc -Wall y.tab.c lex.yy.o -lfl -o analyseur

test: analyseur test.txt
	./analyseur < test.txt

clear:
	(rm y.tab.h; rm y.tab.c; rm lex.yy.c: rm *.o; rm analyseur;) 2> /dev/null