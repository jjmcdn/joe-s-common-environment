#include <stdio.h>
#include <stdlib.h>

struct node_ptr_s {
   struct node_ptr_s    *parent;
   int                  data;
} ;

#define NODES  10

int main (int c, char *argv[])
{
   /* create our list */
   struct node_ptr_s *base_p  = NULL;
   struct node_ptr_s *curr_p  = NULL;

   for (int x = 0; x < NODES ; x++)
   {
      printf("Node ...");
      curr_p = (struct node_ptr_s*)calloc(1, sizeof(struct node_ptr_s));
      curr_p->data = x+1;
      curr_p->parent = base_p;
      base_p = curr_p;
      printf(" complete.\n");
   }

   curr_p = base_p;

   do {
      printf("curr_p: 0x%016x\n", (unsigned int)curr_p);
      printf("  data: %d\n", curr_p->data);
   } while ((curr_p = curr_p->parent));
}
