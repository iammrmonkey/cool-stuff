#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <time.h>
#include <sys/wait.h>
#include <fcntl.h>
#define MAXLINE 3000

void clearspace (char *s) {
    int i = 0;
    while (s[i] == ' ') i++; strcpy (s, s+i);
}

void my_handler (int s) {
    puts ("");
    puts ("Bye bye ~");
    exit (1);           /* got an error */
}

int main ( ) {
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = my_handler;
    sigemptyset (&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
    sigaction (SIGINT, &sigIntHandler, NULL);

    char command_line [MAXLINE];	
    int command_count;
    
	/*fetch, decode, execute*/
	while( fgets (command_line, MAXLINE, stdin) ) {
		/*parse them into a set of commands*/
		int pipefd1[2];
        int pipefd2[2];
        pid_t pid, another_pid, still_another_pid, still_still_another_pid;
        char command [100] [MAXLINE]; 
		memset (command[0], 0, MAXLINE);
        memset (command[1], 0, MAXLINE);
        memset (command[2], 0, MAXLINE);
        char *argv[100], *argx[100], *argy[100];
		int i, j = 0;
        for (i = 0; i < 100; i++) {argv[i] = argx[i] = argy[i] = NULL;} i = 0;
		char* ptr = strtok (command_line, "\n|");
		while (ptr != NULL) {
			strcpy (command[i], ptr);   i++;
			ptr = strtok (NULL, "\n|");
		}
        command_count = i;

        /* what to do depends on how many types there are */
        /* in this small program we can only do three piping commands */
        if (command_count == 1) {           /* one command only */
            /* create a new process */
            i = 0;
            ptr = strtok (command[0], " ");
            while (ptr != NULL) {
                argv [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argv[i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argv [i] = NULL;
            pid = fork ( );

            if (pid < 0) {                  /* error */
                return -1;
            } else if (pid > 0) {           /* parent */
                /* do nothing */
            } else {                        /* child */
                execvp (argv[0], argv);
                exit (0);
            }
        } else if (command_count == 2) {    /* one pipe */
            i = 0;
            ptr = strtok (command[0], " ");
            while (ptr != NULL) {
                argv [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argv [i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argv [i] = NULL;

            i = 0;
            clearspace (command[1]);
            ptr = strtok (command[1], " ");
            while (ptr != NULL) {
                argx [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argx [i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argx [i] = NULL;

            /* make a pipe */
            pipe (pipefd1);

            if ((pid = fork()) == 0) {
                dup2 (pipefd1[1], 1);
                close (pipefd1[0]);
                execvp (argv[0], argv);
                perror ("exec fails");
                exit (EXIT_FAILURE);
            }

            if ((another_pid = fork())  == 0) {
                dup2 (pipefd1[0], 0);
                close (pipefd1[1]);
                execvp (argx[0], argx);
                perror ("exec fails");
                exit (EXIT_FAILURE);
            }

        } else if (command_count == 3) {
            i = 0;
            ptr = strtok (command[0], " ");
            while (ptr != NULL) {
                argv [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argv [i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argv [i] = NULL;

            i = 0;
            clearspace (command[1]);
            ptr = strtok (command[1], " ");
            while (ptr != NULL) {
                argx [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argx [i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argx [i] = NULL;

            i = 0;
            clearspace (command[2]);
            ptr = strtok (command[2], " ");
            while (ptr != NULL) {
                argy [i] = (char*) malloc (strlen (ptr)+1);
                strcpy (argy [i], ptr); i++;
                ptr = strtok (NULL, " ");
            }
            argy [i] = NULL;

            /* make two pipes: stdin in pipefd1[0], stdout in pipefd1[1] */
            pipe (pipefd1);
            
            if ((pid = fork()) == 0) {
                dup2 (pipefd1[1], STDOUT_FILENO);
                close (pipefd1[0]);
                execvp (argv[0], argv);
                perror ("exec fails");
                exit (EXIT_FAILURE);
            }

            close (pipefd1[1]);
            pipe (pipefd2);

            if ((another_pid = fork())  == 0) {
                close (pipefd2[0]);
                dup2 (pipefd1[0], STDIN_FILENO);
                dup2 (pipefd2[1], STDOUT_FILENO);
                execvp (argx[0], argx);
                perror ("exec fails");
                exit (EXIT_FAILURE);
            }

            close (pipefd2[1]);

            if ((still_another_pid = fork()) == 0) {
                dup2 (pipefd2[0], STDIN_FILENO);
                execvp (argy[0], argy);
                exit (0);
            }

            waitpid (-1, NULL, 0);

        }

    }
}
