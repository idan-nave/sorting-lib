CC=gcc
CFLAGS=-Wall -Werror -Iinclude
LDFLAGS=-lcmocka -pthread

all: build

build: bin/libsorting.a

bin/libsorting.a: src/sorting.c
	mkdir -p bin
	$(CC) $(CFLAGS) -c src/sorting.c -o bin/sorting.o
	ar rcs bin/libsorting.a bin/sorting.o

test: build test_dirs tests/bin/test_sorting
	@echo "✅ Running sorting tests..."
	@tests/bin/test_sorting

test_dirs:
	mkdir -p tests/bin

tests/bin/test_sorting: tests/test_sorting.c bin/libsorting.a
	$(CC) $(CFLAGS) -o tests/bin/test_sorting tests/test_sorting.c bin/libsorting.a $(LDFLAGS)

clean:
	rm -rf bin/ tests/bin/
