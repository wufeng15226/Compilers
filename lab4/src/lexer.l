%{
#include "proj2.h"
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXSTRTABLE 10000
#define MAXSINGLELEN 1000
// char  strg_tbl[];
extern YYSTYPE yylval;
int yyline=0, yycolumn=1; // 初始行列号均为1
char strg_tbl[MAXSTRTABLE]={}; // 标识符和字符串的table，间隔为\0，这里没有定义最大长度
int strCnt=0; // 标识符和字符串计数，这里没有定义最大数量
char strBuff[MAXSINGLELEN]={}; // 处理转义字符时使用的string buffer
char* yyptr = strg_tbl; // 处理table的指针

void solveNewLine(char* str); // 处理字符串内的换行符，使行列号符合预期
void tranStr(char* from, char* to); // from为输入字符串，返回值为转义过的字符串
int nextIndex(char* ptr, int* index); // ptr为table头，返回值为table中index后的下一个字符串的开始地址偏移量，index在函数内会自更新为该偏移
// int strExist(char* str); // 在table中查找str，若找到，返回值为table中的偏移量，若没找到，返回-1，这里全部使用loc_str替换

// {EOF}                   {
//     yycolumn+=yyleng;
//     yycolumn--;
//     return EOF; 
// }

%}

ANDnum              (&&)
ASSGNnum            (:=)
DECLARATIONSnum     (declarations)
DOTnum              (\.)
ENDDECLARATIONSnum  (enddeclarations)
EQUALnum            (=)
GTnum               (>)
INTnum              (int)
LBRACnum            (\[)
LPARENnum           (\()
METHODnum           (method)
NEnum               (\!=)
ORnum               (\|\|)
PROGRAMnum          (program)
RBRACnum            (\])
RPARENnum           (\))
SEMInum             (;)
VALnum              (val|VAL)
WHILEnum            (while)
CLASSnum            (class)
COMMAnum            (,)
DIVIDEnum           (\/)
ELSEnum	            (else)
EQnum               (==)
GEnum               (>=)
IFnum               (if)
LBRACEnum           (\{)
LEnum               (<=)
LTnum               (<)
MINUSnum            (-)
NOTnum              (!)
PLUSnum             (\+)
RBRACEnum           (\})
RETURNnum           (return)
TIMESnum            (\*)
VOIDnum             (void)
EOF                 (^z)
SCONSTnum           ('([^'\n\t]|\\')*')
ICONSTnum           (0|[1-9][0-9]*)
IDnum               ([a-zA-Z_][a-zA-Z0-9_]*)
BLANKSPACE          ([' '])
NEWLINE             (\n|\r\n)
TAB                 (\t)
MALFORMEDID         ([0-9]*{IDnum})
UNMATCHEDS          ('[^'\n]*\n)
UNDEFINEDSYMBOL     ([|])
EOFINCOMMENT        (\/\*(".*"|[^\*]*|\*+[^\/])*)
ANNOTATION          (\/\*(".*"|[^\*]*|\*+[^\/])*\*\/)


%%

{ANDnum}                {
    yycolumn+=yyleng;
    return ANDnum; 
}
{ASSGNnum}              {
    yycolumn+=yyleng;
    return ASSGNnum; 
}
{DECLARATIONSnum}       {
    yycolumn+=yyleng;
    return DECLARATIONSnum; 
}
{DOTnum}                {
    yycolumn+=yyleng;
    return DOTnum; 
}
{ENDDECLARATIONSnum}    {
    yycolumn+=yyleng;
    return ENDDECLARATIONSnum; 
}
{EQUALnum}              {
    yycolumn+=yyleng;
    return EQUALnum; 
}
{GTnum}                 {
    yycolumn+=yyleng;
    return GTnum; 
}
{INTnum}                {
    yycolumn+=yyleng;
    return INTnum;  
}
{LBRACnum}              {
    yycolumn+=yyleng;
    return LBRACnum; 
}
{LPARENnum}             {
    yycolumn+=yyleng;
    return LPARENnum; 
}
{METHODnum}             {
    yycolumn+=yyleng;
    return METHODnum; 
}
{NEnum}                 {
    yycolumn+=yyleng;
    return NEnum; 
}
{ORnum}                 {
    yycolumn+=yyleng;
    return ORnum; 
}
{PROGRAMnum}            {
    yycolumn+=yyleng;
    return PROGRAMnum; 
}
{RBRACnum}              {
    yycolumn+=yyleng;
    return RBRACnum; 
}
{RPARENnum}             {
    yycolumn+=yyleng;
    return RPARENnum; 
}
{SEMInum}               {
    yycolumn+=yyleng;
    return SEMInum; 
}
{VALnum}                {
    yycolumn+=yyleng;
    return VALnum; 
}
{WHILEnum}              {
    yycolumn+=yyleng;
    return WHILEnum; 
}
{CLASSnum}              {
    yycolumn+=yyleng;
    return CLASSnum; 
}
{COMMAnum}              {
    yycolumn+=yyleng;
    return COMMAnum; 
}
{DIVIDEnum}             {
    yycolumn+=yyleng;
    return DIVIDEnum; 
}
{ELSEnum}		        {
    yycolumn+=yyleng;
    return ELSEnum; 
}
{EQnum}                 {
    yycolumn+=yyleng;
    return EQnum; 
}
{GEnum}                 {
    yycolumn+=yyleng;
    return GEnum; 
}
{IFnum}                 {
    yycolumn+=yyleng;
    return IFnum; 
}
{LBRACEnum}             {
    yycolumn+=yyleng;
    return LBRACEnum; 
}
{LEnum}                 {
    yycolumn+=yyleng;
    return LEnum; 
}
{LTnum}                 {
    yycolumn+=yyleng;
    return LTnum; 
}
{MINUSnum}              {
    yycolumn+=yyleng;
    return MINUSnum; 
}
{NOTnum}                {
    yycolumn+=yyleng;
    return NOTnum; 
}
{PLUSnum}               {
    yycolumn+=yyleng;
    return PLUSnum; 
}
{RBRACEnum}             {
    yycolumn+=yyleng;
    return RBRACEnum; 
}
{RETURNnum}             {
    yycolumn+=yyleng;
    return RETURNnum; 
}
{TIMESnum}              {
    yycolumn+=yyleng;
    return TIMESnum; 
}
{VOIDnum}               {
    yycolumn+=yyleng;
    return VOIDnum; 
}

{SCONSTnum}             {
    yycolumn+=yyleng;
    yylval.tptr = yyptr-strg_tbl;
    tranStr(yytext, strBuff);
	if(loc_str(strBuff)==-1){
        strCnt++;
        strcpy(yyptr,strBuff);
        yyptr+=strlen(strBuff)+1;
	}else{
        yylval.tptr = loc_str(strBuff);
    }
    return SCONSTnum; 
}
{IDnum}                 {
    yycolumn+=yyleng;
    yylval.tptr = yyptr-strg_tbl;
    if(loc_str(yytext)==-1){
		strCnt++;
		strcpy(yyptr,yytext);
		yyptr+=yyleng+1;
	}else{
        yylval.tptr = loc_str(yytext);
    }
    return IDnum; 
}
{ICONSTnum}             {
    yycolumn+=yyleng;
    yylval.intg = atoi(yytext);
    return ICONSTnum; 
}
{MALFORMEDID}           {
    yycolumn+=yyleng;
    printf("Error: Malformed identifier '%s', at line %d column %d\n", yytext, yyline, yycolumn-yyleng);
	return MALFORMEDID; 
}
{UNMATCHEDS}            {
    yycolumn+=yyleng;
	printf("Error: Unmatched string constant, at line %d column %d\n", yyline, yycolumn-yyleng);
    return UNMATCHEDS; 
}
{UNDEFINEDSYMBOL}       {
    yycolumn+=yyleng;
	printf("Error: Undefined symbol '%s', at line %d column %d\n", yytext, yyline, yycolumn-yyleng);
    return UNDEFINEDSYMBOL;
}
{EOFINCOMMENT}          {
    yycolumn+=yyleng;
	printf("Error: EOF found in comment, at line %d column %d\n", yyline, yycolumn);
    return EOFINCOOMMENT; 
}
{BLANKSPACE}            {
    yycolumn+=yyleng;
}
{NEWLINE}               {
    yyline++;
	yycolumn=1;
}
{TAB}                   {
    yycolumn+=yyleng;
}
{ANNOTATION}            {
    yycolumn+=yyleng;
    solveNewLine(yytext);
}

%%

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

// int strExist(char* str){
//     int index = -1;
//     int cnt = strCnt;
//     char* curr;
//     while(cnt--){
//         index = nextIndex(strg_tbl, &index);
//         curr = strg_tbl+index;
//         if(!strcmp(curr, str)){
//             return index;
//         }
//     }
//     return -1;
// }

int yywrap() {
    return 1;
}
