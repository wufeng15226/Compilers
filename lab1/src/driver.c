#include "token.h"
#include <stdio.h>
#include <stdlib.h>

/* TODO: handle the tokens, and output the result */

// yylex() is in lex.yy.c
extern int yylex();

int main (int argc, char* argv[]) {
    int lexRtn = -1;			// return value of yylex

	/* recognize each token type */
	while (1) {
		lexRtn = yylex();
		switch (lexRtn) {
			case ELSEnum:			{ break; }
		}

		if (lexRtn == EOFnum) break;
	}

	return 0;
}
