%{
#include "token.h"

/* TODO: declare variables here */

%}

/* TODO: define regular expressions */
ELSE	(else)

/* TODO: define translation rules: pattern and action */
%%
{ELSE}		    			{ return (ELSEnum); }

%%

/* TODO: define the auxiliary functions you may use */

int yywrap() {
    return 1;
}
