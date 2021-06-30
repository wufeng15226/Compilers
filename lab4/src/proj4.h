#ifndef _PROJ4_H
#define _PROJ4_H

#include <stdio.h>
#include "proj2.h"
#include "proj3.h"

extern FILE* sFile;

#define LA 1
#define SW 2
#define ADDI 3
#define MOVE 4
#define LI 5
#define ADD 6
#define LW 7
#define SGE 8
#define BEQZ 9
#define B 10
#define JR 11
#define MUL 12
#define SGT 13
#define JAL 14
#define SLE 15
#define SUB 16
#define SLT 17
#define SEQ 18

void genCode(tree parseTree);

int getValue(tree root);

void emitCall(int symbolNum);

void emitReturn(int num, int referenceOffset);

void emitLabel();

void emitData(char* dataStr, int type, int size);

void emitStr(char* str);

void emitMost(int operator, int type, int numOp, int op1, int op2, int op3); 

#endif
