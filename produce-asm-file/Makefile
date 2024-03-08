# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -Wextra -O2 -g  # Add -g for debugging symbols

# Source files
SRCS = p.c

# Object files
OBJS = $(SRCS:.c=.o)

# Assembly files
 ASM = $(SRCS:.c=.s)

# Executable name
TARGET = program

 # Default target
all: $(TARGET)

# Compile source files to assembly
$(ASM): $(SRCS)
	$(CC) $(CFLAGS) -S $< -o $@

# Compile assembly files to object files
$(OBJS): $(ASM)
	$(CC) $(CFLAGS) -c $< -o $@

# Link object files to create executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

# Clean objects, assembly files, and executable
clean:
	rm -f $(OBJS) $(ASM) $(TARGET)

