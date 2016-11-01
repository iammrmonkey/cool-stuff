#include <asm/uaccess.h>
#include <asm/siginfo.h>
#include <linux/kernel.h>
#include <linux/sched.h>
#include <linux/string.h>
#include <linux/slab.h>
#define CMDLINE_LEN 1024

asmlinkage long sys_change_cmdline(char* ptr) {

	/* the newline: already under kernel mode */
    char *new_cmdline = "Ryan Hsu 9917265";

    /* copy the original command line string to user space variable(the address is 'ptr') below */

	copy_to_user (ptr, current->mm->arg_start, current->mm->arg_end - current->mm->arg_start);

    /* modify the command line string below */

	int i = 0;
	int len = strlen (new_cmdline);
	current->mm->arg_end = current->mm->arg_start + len + 1;
	memcpy (current->mm->arg_start, new_cmdline, len+1);

    return 0;
}
