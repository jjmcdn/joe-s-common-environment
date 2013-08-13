#include <stdio.h>
#include <stdlib.h>

#define STRING_1 "9324341"
#define STRING_2 "-1"
#define STRING_3 "\xE6\x88\x91\xE7\x9A\x84\xE6\x97\xA0\xE7\xBA\xBF"

int main (int argc, char** argv)
{
   unsigned long l = 0;
   char *endptr = NULL;

   l = strtoul (STRING_1, &endptr, 10);
   printf("value: %lu\nptr: 0x%08x\n", l, endptr);
   l = strtoul (STRING_2, &endptr, 10);
   printf("value: %lu\nptr: 0x%08x\n", l, endptr);
   printf("ESSID: %s\n", STRING_3);
}
