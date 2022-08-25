# CPSC/ECE 3200: Introduction to Operating System - Project #1

# 1. Setup

## 1.1 GitHub
Code submission for all projects in the class will be handled via GitHub classrooms. Your account on canvas has been connected to github. Each student will automatically have private repositories for the projects. <!-- Therefore, you must have a GitHub account. We will provide you with private repositories for all your projects. -->

You **must not create any public repositories** for storing your code. If you have discovered repositories with CPSC/ECE 3200 solutions, please notify the instructor. 

## 1.2 Lab Machines
Your code will be tested on School of Computing lab machines. You are recommended to use  these lab machines and test your code thoroughly before submission. Please consult the [Computer Help Desk](https://www.cs.clemson.edu/help/) page for information on how to access these machine.

### 1.2.1 ssh-keys
You may set up your ssh keys on the lab machines in order to authenticate with GitHub from these machines. If you have already done this steps before, you can skip this secttion. 

After log into one lab machine, run the following:
<pre><code>
$ ssh-keygen -N "" -f ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub
</code></pre>

Then, log in to GitHub and go to [github.com/settings/ssh](https://github.com/settings/ssh) to add this SSH public key to your GitHub account.

## 1.3 RISC-V Development Tools
In this course, you will work on several project on top of the [XV6 for RISC-V](https://github.com/mit-pdos/xv6-riscv) teaching operating system developed at MIT. To work with the RISC-V architecture on a X86 system, you'll need the RISC-V versions of a couple different tools: QEMU, GDB, GCC, and Binutils.

We have provided a bash script [install-riscv-tools.sh] which is included in the handout subdirectory. Simply run it under your home directory on any lab machine. You should see two generated directories: gnu and qemu. The script also does a simple test on the executables inside these directories. <!-- (https://github.com/cpsc3220/project1/blob/master/handout/install-riscv-tools.sh) which you can use to install these tools on a lab machine under your home directory.-->

<!--
<pre><code>
$ wget https://github.com/cpsc3220/project1/blob/master/handout/install-riscv-tools.sh
$ bash install-riscv-tools.sh
</code></pre>
-->

**Attention: make sure you pass the simple tests before you proceed to Task B**

# 2. Useful Tools

To work on the projects in this course effectively, you may need to use several userfule tools that make a good fit for in any system hacker's toolbox.

* Git: to clone the provided source files and submit your solutions through git commit and push
* make: to compile and link and generate executable from Makefile.
* man: to read manuals of commands and library functions.
* vim: an editor for you to change source codes
* gdb: gnu debuger
* ctags: a tool that will sift through your code
  
If you are unfamiliar with some of these tools, you can find some tutorial online or ask the TAs for help.

# 3. Your Assignment

This project consists two tasks:

## Task A: Text Sorting
## Task B: XV6 System Call

You can find the descriptions and requirements for these two tasks in the TaskA and TaskB folders.

# 4. Submission

To submit your work, do:

<pre>
cd ~/path/to/your-project-folder
git status
git add files-you-created-or-modified
git commit -m "Finished project1"
git push
</pre>

This will save your work and give the instructor and TAs to see your progress. 
