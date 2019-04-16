calc: flexprog bisonprog
	gcc -o calc calc.tab.c lex.yy.c -lfl -w -lm

flexprog: calc.l
		flex -l calc.l

bisonprog: calc.y
		bison -dv calc.y
