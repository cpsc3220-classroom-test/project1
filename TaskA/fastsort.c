#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <sys/mman.h>

struct line_t
{
    char* key;
    char* line;
};

// returns index word to start on
int parse_args(int argc, char* argv[], int* input, size_t* fsize)
{
    struct stat st;
    char* fname = NULL;
    int sword = 1;
    if (argc == 3)
    {
        fname = argv[2];
        sword = atoi(argv[1]+1);
    }
    else if (argc == 2) fname = argv[1];
    else 
    {
        fprintf(stderr, "Args incorrect:\n");
        for (int i = 0; i < argc; i++)
        {
            printf("%s\n", argv[i]);
        }
        exit(1);
    }
    stat(fname, &st);
    *fsize = st.st_size;

    *input = open(fname, O_RDONLY);
    if (*input == -1)
    {
        fprintf(stderr, "File does not exist\n");
        exit(1);
    }
    return sword;
}


int get_lines(int fd, size_t fsize, struct line_t** lines, int sword)
{
    size_t i;
    int num_lines = 0;
    char* buffer = (char*)malloc(fsize);
    read(fd, buffer, fsize);
    int cperline = 0;
    for (i = 0; i < fsize; i++)
    {
        char temp = buffer[i];
        ++cperline;
        if (cperline > 128)
        {
            fprintf(stderr, "Line too long.\n");
            exit(1);
        }
        if (temp == '\n')
        {
            cperline = 0;
            temp = '\0';
            ++num_lines;         
        }
        buffer[i] = temp;
    }
    // this is silly but combines two ideas for efficiency
    // Main purpose: count lines and place them in line array
    // Secondary: Identify key on first parse and store that too
    //
    // That way we can correlate the key we sort on with the line we print in hte end
    if (num_lines)
    {
        *lines = malloc(sizeof(struct line_t) * num_lines);
        (*lines)[0].line = buffer;

        char* cur_line = buffer;
        char* prev_word = "";
        int current_line = 0;
        int word_count = 0;
        bool in_word = false;

        for (i = 0; i < fsize; i++)
        {
            // end of line
            if (buffer[i] == '\0')
            {
                (*lines)[current_line].key = prev_word;
                (*lines)[current_line].line = cur_line;
                cur_line = &buffer[i] + 1;
                prev_word = "";
                word_count = 0;
                ++current_line;
            }
            // in the middle of parsing a word
            if (in_word)
            {
                if (!isalpha(buffer[i])) in_word = false;
            }
            else
            {
                // if we just encountered a word and we're not done looking for the key
                if (word_count < sword && isalpha(buffer[i]))
                {
                    ++word_count;
                    prev_word = &buffer[i];
                    in_word = true;
                }
            }
        }
    }
    return num_lines;
}


void fix_newlines(char** lines, int numlines, char* og)
{
    int i;
    for (i = 0; i < numlines; i++)
    {
        if (lines[i] != og)
        {
            *(lines[i] - 1) = '\n';
        }
    }
}


void print_str(struct line_t* lines, int numlines)
{
    for (int i = 0; i < numlines; i++)
    {
        printf("%s\n", lines[i].line);
    }
}


// modified from man page for qsort
static int cmpstringp(const void *p1, const void *p2)
{
    /* The actual arguments to this function are "pointers to
       pointers to char", but strcmp(3) arguments are "pointers
       to char", hence the following cast plus dereference */
    const struct line_t* sp1 = (const struct line_t*)p1;
    const struct line_t* sp2 = (const struct line_t*)p2;

    return strcmp(sp1->key, sp2->key);
}

void fix_buffer(struct line_t* lines, char* buffer, int num_lines)
{
    char* next_line = buffer;
    for (int i = 0; i < num_lines; i++)
    {
        next_line += sprintf(next_line, "%s\n", lines[i].line);
    }
}

int main(int argc, char* argv[])
{
    int numlines;
    int fd;
    size_t fsize;
    //char* out_buffer = NULL;
    struct line_t* lines = NULL;
    char* full_buf = NULL;
    int sword = parse_args(argc, argv, &fd, &fsize);
    numlines = get_lines(fd, fsize, &lines, sword);
    if (numlines) full_buf = lines[0].line;
    close(fd);

    qsort(lines, numlines, sizeof(struct line_t), cmpstringp);
    
    //out_buffer = malloc(sizeof(char*) * fsize);
    //fix_buffer(lines, out_buffer, numlines);
    //printf("%s", out_buffer);
    print_str(lines, numlines);

    //cleanup
    //free(out_buffer);
    free(full_buf);
    free(lines);
    return 0;
}
