all: fastsort

fastsort.o: fastsort.c
	gcc -Wall -Wextra fastsort.c -c

fastsort: fastsort.o
	gcc -Wall -Wextra fastsort.o -o fastsort

clean:
	rm -f fastsort fastsort.o
