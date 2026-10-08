PREFIX ?= /usr/local
BIN_DIR = $(PREFIX)/bin
MAN_DIR = $(PREFIX)/share/man/man1

.PHONY: build install uninstall clean

# Build the standalone single-file cprintf (full: core + all optional CLI modules).
build:
	./scripts/build-cprintf full

# Install the full build as the `cprintf` command, plus its man page.
install: build
	mkdir -p $(BIN_DIR)
	install -m 0755 dist/cprintf-full $(BIN_DIR)/cprintf
	@if [ -f doc/cprintf.1 ]; then \
		mkdir -p $(MAN_DIR); \
		install -m 0644 doc/cprintf.1 $(MAN_DIR)/cprintf.1; \
		echo "Installed man page to $(MAN_DIR)/cprintf.1"; \
	fi

uninstall:
	rm -f $(BIN_DIR)/cprintf
	rm -f $(MAN_DIR)/cprintf.1

clean:
	./scripts/build-cprintf clean
