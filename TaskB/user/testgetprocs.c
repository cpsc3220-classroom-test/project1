#include "kernel/types.h"
#include "user/user.h"

void forked()
{
    if (fork())
    {
    }
    else
    {
        sleep(2);
        exit(0);
    }
}

void dostuff(void)
{

    int numprocs;
    int i = 0;
    numprocs = getprocs();
    printf ("TEST1 %d\n", numprocs);
    for (i = 0; i < 5; i++)
    {
        forked();
    }
    numprocs = getprocs();
    printf ("TEST2 %d\n", numprocs);
    for (i = 0; i < 3; i++)
    {
        wait(0);
    }
    numprocs = getprocs();
    printf ("TEST3 %d\n", numprocs);
    for (i = 0; i < 2; i++)
    {
        wait(0);
    }
    numprocs = getprocs();
    printf ("TEST4 %d\n", numprocs);

}

int main()
{
   dostuff(); 
    exit(0);
}
