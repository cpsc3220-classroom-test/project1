# Project 1a: Text Sorting

## Requirement
You will write a text sorting program named **fastsort** that sorts lines of text using the word at a specified location in each line.

This program must support the following usages:

```./fastsort [-n] filename```

Note [] means the argument inside is optional. You don't really type [] in the command line. Here, "**n**" is an integer and the option argument "**-n**" specifies the location of the word that will be used to sort the lines of text. For example, the command 

```./fastsort -3 filename``` will use the third word of each line to sort the lines contained in the file "**filename**".

The option argument "**-n**" is optional. If the option is not provided in the command line, the program will use the first word of each line to sort the lines.

The program shall print the sorted output to the screen(i.e., stdout).

## Examples

Let's say you have a text file `test1.txt` that contains the following lines:

<pre>
this line is first
but this line is second
finally there is this line
</pre>

Because "but" is alphabetically before "finally" and "finally" is alphabetically before "this", the command ```./fastsort test1.txt``` will print the following results to the screen:
<pre>
but this line is second
finally there is this line
this line is first
</pre>

Similarly, the command ```./fastsort -2 test1.txt``` will print the following results to the screen:
<pre>
this line is first
finally there is this line
but this line is second
</pre>

## Breaking Ties
In certain cases, there will be a tie among two or more lines. For example, when sorting the lines in `test1.txt` using the third word, the lines "`this line is first`" and "`finally there is this line`" have a tie because both of their third words are "`is`". In this situation, you can use the original line number as a tie breaker. Here, the line number of "`this line is first`" is `0`, which is smaller than `2`, the line number of "`finally there is this line`". Therefore, "`this line is first`" will be placed before 
"`finally there is this line`" in the sorted output. Thus, the command ```./fastsort -3 test1.txt``` will print the following results to the screen:

<pre>
this line is first
finally there is this line
but this line is second
</pre>

## Assumptions and Errors

- **Exit code**: The program should exit with zero upon success and with 1 upon errors.

- **Max line length**: The max line length of the text will be 128. If you get a line longer than this, print "`Line too long`" to standard error and exit with 1.

- **Wrong arguments**: If the command line consists of more than two arguments, or exactly two arguments but the first one does not match the format of a dash followed 
    by an integer, you should EXACTLY print "`Error: Bad command line parameters`" to standard error and exit with 1.

- **Space character**: You can assume only space characters will be used to separate words in the input. However, your program should correctly handle the case where there are two or more spaces between words.

- **Not enough words**: If the command specifies an option argument `-n` but one line of the inut file does not have `n` words, you can use the last word of that line as the key to sort that line.

- **Empty line**: You should use an empty string to sort any empty lines (i.e., lines that are just a newline or spaces and a newline
    character).

- **File length**: May be pretty long! However, no need to implement a
    fancy two-pass sort or anything like that; the data set will fit
    into memory and you shouldn't have to do anything special to handle
    this. However, if `malloc()` does fail, print "`malloc failed`"
    to standard error and exit with 1.

- **Invalid files**: If the user specifies an input file that you cannot
    open (for whatever reason), the sort should EXACTLY print (to
    standard error): "`Error: Cannot open file [filename]`" with no extra spaces
    (you should replace the `[filename]` with actual filename provided in the command line) and then exit with return 1.

- **Important**: Upon any error, you should print the error message to stderr
    (standard error) and not stdout (standard output). This is
    accomplished in your C code as follows:

    `fprintf(stderr, “whatever error message\n”);`

- **Do not print anything to stdout except your sorted output.** 

## Hints

-   In your sorting program, you can just use `fopen()` to open the
    input file, `fgets()` to read each line of the file, and `fclose()`
    when you are done with the input file.

-   If you want to figure out how big the input file is before
    reading it in, use the `stat()` or `fstat()` calls.

-   To compare strings, use the `strcmp()` library call.

-   To sort the data, use any sort algorithm that you would like to use. You can also use a sort function like `qsort()` included in the standard library on Linux.

-   To break lines into words, you may use `strtok()`. Although, if you choose to use `strtok()`, you must realize that it is destructive and will change the  contents of the lines. Thus, if you use it, make sure to make a copy of the line to output. Alternatively, you may find it might be easier by just writing a function that extracts the `n-th` word for a given line.

-   The routine `atoi()` (or better yet, `strtol()`) can be used to
    transform a string into an integer. You can use it to parse the command argument -n.

-   To exit, call `exit()` with a single argument. This argument to
    `exit()` is then available to the user to see if the program
    returned an error (i.e., return 1 by calling `exit(1)`) or exited
    cleanly (i.e., returned 0 by calling `exit(0)`). You should just
    return from the main() function and pass the return code that way
    where appropriate.

-   The routine `malloc()` is useful for memory allocation. Make sure to
    exit cleanly if malloc fails!

-   If you don't know how to use these functions, use the man pages. For
    example, typing `man qsort` at the command line will give you a lot
    of information on how to use the library sorting routine.
    
## General Advice

- Design first before writing the code. Prepare some use/test cases, break the task into serveral smaller tasks, and think about what data structure serves the tasks better than others.

- Start small, and get things working incrementally. For example, first
get a program that simply reads in the input file, one line at a time,
and prints out what it reads in. After each stage, test the code to make sure it works as expected. Then, slowly add features and test them as you go.

- Testing is crucial. One great programmer said you have to write 5-10
lines of test code for every line of code you produce; testing your code
to make sure it works is crucial. Write tests to see if your code
handles all the cases you think it should. Be as comprehensive as you
can be. 

- Use git/github to save each version of your work! 

## Submission
-   The last commit to the `master` branch will be treated as the submission. You may choose to do your work on another branch, but be sure to merge it with master before the deadline. If your last commit is later than the due time, you will receive late penalties. 

-   Your **Makefile** can be the one provided, or your own. However, I
    should be able to use the `make` command in the shell with no
    additional arguments to compile your program.

-   Your Makefiles MUST produce a compiled executable named
    **fastsort**.

-   Your program must run on the lab 110 machines, at minimum.

-   Your program must be written in C (not C++ or other languages).

-   Your sort should be relatively fast. GNU `sort` can sort millions of
    lines in several seconds or less. Yours should not be much slower
    (definitely not minutes!).
