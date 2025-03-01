# Compiler and Flags
CC       := gcc
CFLAGS   := -Wall -Werror -Iinclude -fPIC
LDFLAGS  := -shared -lcmocka -pthread -ldl

# Library Versioning
VERSION  := 1.0.0
SONAME   := libsorting.so.1
LIBNAME  := libsorting.so

# Directories
SRC_DIR  := src
BIN_DIR  := bin
TEST_DIR := tests
INSTALL_DIR := /usr/local/lib

# Targets
all: build

# =============================================
# Build the shared library
# =============================================
build: $(BIN_DIR)/$(LIBNAME).$(VERSION)

$(BIN_DIR)/$(LIBNAME).$(VERSION): $(SRC_DIR)/sorting.c
	@echo "📦 Building shared library $(LIBNAME) $(VERSION)..."
	mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -c $(SRC_DIR)/sorting.c -o $(BIN_DIR)/sorting.o
	$(CC) $(LDFLAGS) -Wl,-soname,$(SONAME) -o $(BIN_DIR)/$(LIBNAME).$(VERSION) $(BIN_DIR)/sorting.o

	# Create symbolic links for versioning
	ln -sf $(LIBNAME).$(VERSION) $(BIN_DIR)/$(LIBNAME)
	ln -sf $(LIBNAME).$(VERSION) $(BIN_DIR)/$(SONAME)

# =============================================
# Running Tests
# =============================================
test: build test_dirs $(TEST_DIR)/bin/test_sorting
	@echo "✅ Running sorting tests..."
	LD_LIBRARY_PATH=$(BIN_DIR) $(TEST_DIR)/bin/test_sorting

test_dirs:
	mkdir -p $(TEST_DIR)/bin

# Compile test program
$(TEST_DIR)/bin/test_sorting: $(TEST_DIR)/test_sorting.c
	mkdir -p $(TEST_DIR)/bin
	$(CC) $(CFLAGS) -o $(TEST_DIR)/bin/test_sorting $(TEST_DIR)/test_sorting.c -L$(BIN_DIR) -lsorting -lcmocka -pthread -ldl

# =============================================
# Installation
# =============================================
install: build
	@echo "📦 Installing $(LIBNAME) $(VERSION) to $(INSTALL_DIR)..."
	sudo cp $(BIN_DIR)/$(LIBNAME).$(VERSION) $(INSTALL_DIR)/
	sudo ln -sf $(INSTALL_DIR)/$(LIBNAME).$(VERSION) $(INSTALL_DIR)/$(LIBNAME)
	sudo ln -sf $(INSTALL_DIR)/$(LIBNAME).$(VERSION) $(INSTALL_DIR)/$(SONAME)
	sudo ldconfig
	@echo "✅ Installation complete!"

# =============================================
# Uninstallation
# =============================================
uninstall:
	@echo "🗑 Removing installed library..."
	sudo rm -f $(INSTALL_DIR)/$(LIBNAME).$(VERSION)
	sudo rm -f $(INSTALL_DIR)/$(LIBNAME)
	sudo rm -f $(INSTALL_DIR)/$(SONAME)
	sudo ldconfig
	@echo "✅ Uninstallation complete!"

# =============================================
# Cleanup
# =============================================
clean:
	@echo "🧹 Cleaning build files..."
	rm -rf $(BIN_DIR)/ $(TEST_DIR)/bin/
	@echo "✅ Cleanup complete!"

# =============================================
# Help
# =============================================
help:
	@echo "📌 Available Makefile commands:"
	@echo "  make build      - Compile the shared library"
	@echo "  make test       - Run unit tests"
	@echo "  make install    - Install the shared library system-wide"
	@echo "  make uninstall  - Uninstall the shared library"
	@echo "  make clean      - Remove compiled files"
	@echo "  make help       - Show this help message"
