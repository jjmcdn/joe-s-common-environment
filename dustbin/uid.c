#include <stdio.h>
#include <ctype.h>

static char *cline_user="1";

int main(int argc, char **argv)
{
   const char *user = NULL;
   int ct=0;
   int uid=-1;

   user = cline_user;

   while (*(user+ct)) {
      printf("considering: %c\n",*(user+ct));
      if (!isdigit(*(user+ct)))
         break;
      else
         printf("    okay.\n");
      ct++;
   }
   if (!(*(user+ct))) {
      uid = atoi(user);
      printf("UID: %d\n", uid);
   } else
      printf("guess %s isn't a UID\n",user);
}
