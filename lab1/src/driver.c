#include "token.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/* TODO: handle the tokens, and output the result */

// yylex() is in lex.yy.c
// 把所有的字符串操作都放在driver.c内进行，lexer.l仅负责传递yytext，yyleng两个变量
extern int yylex();
extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;
extern int yyleng;

// 行列和table的信息作为全局变量
int yyline=1, yycolumn=1; // 初始行列号均为1
char yylval[MAXSTRTABLE]={}; // 标识符和字符串的table，间隔为\0，这里没有定义最大长度
int strCnt=0; // 标识符和字符串计数，这里没有定义最大数量

// 辅助函数
void solveNewLine(char* str); // 处理字符串内的换行符，使行列号符合预期
void tranStr(char* from, char* to); // from为输入字符串，返回值为转义过的字符串
int nextIndex(char* ptr, int* index); // ptr为table头，返回值为table中index后的下一个字符串的开始地址偏移量，index在函数内会自更新为该偏移
int strExist(char* str); // 在table中查找str，若找到，返回值为table中的偏移量，若没找到，返回-1
int isToken(int tokenType); // 判断该词类型是否为需要输出的合法token

// 运行需要两个命令行参数，第一个参数是lex的输入文件，第二个参数是token输出文件
int main (int argc, char* argv[]) {
	
	// File open
	if(argc!=3){
		printf("没有文件\n");
	}
	FILE* inFile = fopen(argv[1], "r");
	if(!inFile) printf("inFile open error!\n");
	FILE* outFile = fopen(argv[2], "w+");
	if(!inFile) printf("outFile open error!\n");
	
	yyin = inFile;
    int lexRtn = -1;			// return value of yylex
	
	/* recognize each token type */
	char token[20]={}; // 输出token信息的buffer
	char strBuff[MAXSINGLELEN]={}; // 处理转义字符时使用的string buffer
	char* yyptr = yylval; // 处理table的指针

	int index = -1; // 当前table的string索引
	fprintf(outFile, "Line\tColumn\tToken\t\t\tIndex in String table\n");
	while (1) {
		lexRtn = yylex();
		memset(token, 0, 20);
		yycolumn+=yyleng;
		switch (lexRtn) {
			case ANDnum: strcpy(token, "ANDnum"); break;
			case ASSGNnum: strcpy(token, "ASSGNnum"); break;
			case DECLARATIONSnum: strcpy(token, "DECLARATIONSnum"); break;
			case DOTnum: strcpy(token, "DOTnum"); break;
			case ENDDECLARATIONSnum: strcpy(token, "ENDDECLARATIONSnum"); break;
			case EQUALnum: strcpy(token, "EQUALnum"); break;
			case GTnum: strcpy(token, "GTnum"); break;
			case INTnum: strcpy(token, "INTnum"); break;
			case LBRACnum: strcpy(token, "LBRACnum"); break;
			case LPARENnum: strcpy(token, "LPARENnum"); break;
			case METHODnum: strcpy(token, "METHODnum"); break;
			case NEnum: strcpy(token, "NEnum"); break;
			case ORnum: strcpy(token, "ORnum"); break;
			case PROGRAMnum: strcpy(token, "PROGRAMnum"); break;
			case RBRACnum: strcpy(token, "RBRACnum"); break;
			case RPARENnum: strcpy(token, "RPARENnum"); break;
			case SEMInum: strcpy(token, "SEMInum"); break;
			case VALnum: strcpy(token, "VALnum"); break;
			case WHILEnum: strcpy(token, "WHILEnum"); break;
			case CLASSnum: strcpy(token, "CLASSnum"); break;
			case COMMAnum: strcpy(token, "COMMAnum"); break;
			case DIVIDEnum: strcpy(token, "DIVIDEnum"); break;
			case ELSEnum: strcpy(token, "ELSEnum"); break;
			case EQnum: strcpy(token, "EQnum"); break;
			case GEnum: strcpy(token, "GEnum"); break;
			case IFnum: strcpy(token, "IFnum"); break;
			case LBRACEnum: strcpy(token, "LBRACEnum"); break;
			case LEnum: strcpy(token, "LEnum"); break;
			case LTnum: strcpy(token, "LTnum"); break;
			case MINUSnum: strcpy(token, "MINUSnum"); break;
			case NOTnum: strcpy(token, "NOTnum"); break;
			case PLUSnum: strcpy(token, "PLUSnum"); break;
			case RBRACEnum: strcpy(token, "RBRACEnum"); break;
			case RETURNnum: strcpy(token, "RETURNnum"); break;
			case TIMESnum: strcpy(token, "TIMESnum"); break;
			case VOIDnum: strcpy(token, "VOIDnum"); break;
			case EOFnum: yycolumn--; strcpy(token, "EOFnum"); break;
			case SCONSTnum:
				strcpy(token, "SCONSTnum");
            	tranStr(yytext, strBuff);
				if(strExist(strBuff)==-1){
                    strCnt++;
                    strcpy(yyptr,strBuff);
                    yyptr+=strlen(strBuff)+1;
				}
				break;
			case IDnum:
				strcpy(token, "IDnum");
				if(strExist(yytext)==-1){
					strCnt++;
					strcpy(yyptr,yytext);
					yyptr+=yyleng+1;
				}
				break;
			case ICONSTnum:
				strcpy(token, "ICONSTnum");
				break;
			case MALFORMEDID:
				fprintf(outFile, "Error: Malformed identifier '%s', at line %d column %d\n", yytext, yyline, yycolumn-yyleng);
				break;
			case UNMATCHEDS:
				fprintf(outFile, "Error: Unmatched string constant, at line %d column %d\n", yyline, yycolumn-yyleng);
				solveNewLine(yytext);
				break;
			case UNDEFINEDSYMBOL:
				fprintf(outFile, "Error: Undefined symbol '%s', at line %d column %d\n", yytext, yyline, yycolumn-yyleng);
				break;
			case EOFINCOOMMENT:
				solveNewLine(yytext); 
				fprintf(outFile, "Error: EOF found in comment, at line %d column %d\n", yyline, yycolumn);
				break;
			case BLANKSPACE:
				break;
			case NEWLINE:
				yyline++;
				yycolumn=1;
				break;
			case TAB:
				break;
			case ANNOTATION:
				solveNewLine(yytext);
				break;
			default: break;
		}
		if(isToken(lexRtn)){
			if(lexRtn==IDnum){
				fprintf(outFile, "%-4d\t%-6d\t%-16s%d\n", yyline, yycolumn, token, index=strExist(yytext));
			}else if(lexRtn==SCONSTnum){
				index = nextIndex(yylval, &index);
				fprintf(outFile, "%-4d\t%-6d\t%-16s%d\n", yyline, yycolumn, token, index);
			}else fprintf(outFile, "%-4d\t%-6d\t%-16s\n", yyline, yycolumn, token);
		}
		if (lexRtn == EOFnum) break;
	}

	// print table
	fprintf(outFile, "\nString Table : ");
	int i=0;
	for(;strCnt&&i<MAXSTRTABLE;i++){
		if(!yylval[i]) strCnt--;
		fprintf(outFile, "%c",yylval[i]?yylval[i]:' ');
	}
	
	// File close
	fclose(inFile);
	fclose(outFile);
	return 0;
}

void solveNewLine(char* str){
    while(*str){
        if(*str++=='\n'){
            yyline++;
            yycolumn = 1;
        }
    }
}

void tranStr(char* from, char* to){
    char* fromCurr = from+1;
    while(*fromCurr){
        if(*fromCurr=='\\'){
            switch(*(fromCurr+1)){
				// proj1.pdf中目前仅要求这4种
                case 'n': *to++ = '\n'; fromCurr++; break;
                case 't': *to++ = '\t'; fromCurr++; break;
                case '\'': *to++ = '\''; fromCurr++; break;
                case '\\': *to++ = '\\'; fromCurr++; break;
                default: break;
            }
            fromCurr++;
        }else{
            *to++ = *fromCurr++;
        }
    }
	*(to-1) = '\0';
}

int nextIndex(char* ptr, int* index){
	if(*index==-1){
		*index=0;
		return 0;
	}
	while(ptr[*index]) *index+=1;
	*index+=1;
	return *index;
}

int strExist(char* str){
    int index = -1;
    int cnt = strCnt;
    char* curr;
    while(cnt--){
        index = nextIndex(yylval, &index);
        curr = yylval+index;
        if(!strcmp(curr, str)){
            return index;
        }
    }
    return -1;
}

int isToken(int tokenType){
	return tokenType/100==TOKEN||tokenType==EOFnum;
}