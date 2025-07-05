CC ?= gcc
CFLAGS ?= -O3 -mtune=native -march=native

override CFLAGS += -Ilib
LDLIBS = -lm

OUT = monitor_cpu
SRC = \
      monitor_cpu.c \
      lib/libsmu.c \
      # EOL
OBJ = $(SRC:.c=.o)

all: $(OUT)

$(OUT): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -rf *.o lib/*.o
