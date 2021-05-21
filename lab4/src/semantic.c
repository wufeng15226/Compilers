#include "proj2.h"
#include "proj3.h"

void traverse(tree root) {

}

void do_semantic(tree parseTree) {
   STInit();           		// Initialize the symbol table
   traverse(parseTree);     // Traverse tree
   STPrint();          		// Print the symbol table
}
