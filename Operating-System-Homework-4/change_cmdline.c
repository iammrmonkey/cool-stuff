#include<linux/unistd.h>
#include<errno.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<fcntl.h>
#define CMDLINE_LEN 1024

int main() {

    // Use 'ps aux' show the original command line string
    printf("Use 'ps aux |grep change_cmdline' and capture the snapshot.\n");
    printf("Press any key to continue...\n");
    fgetc(stdin);

    char origin_cmdline[CMDLINE_LEN];

    /***
     * call your system call below
     *
     ***/
    // you should implement something here...
	
    if (syscall(351, origin_cmdline)) puts ("error");

    /***
     * print the original command line string
     *
     ***/
    printf("The orginal string: %s\n", origin_cmdline); // the value must be same as the first snapshot

    // Use 'ps aux' show the new command line string
    printf("Use 'ps aux |grep [the pid]' and capture the snapshot again.\n");
    printf("Press any key to continue...\n");
    fgetc(stdin);
    return 0;
}
