PREFIX ?= /usr/local
INSTALL_DIR = $(PREFIX)/share/cprintf
BIN_DIR = $(PREFIX)/bin
MAN_DIR = $(PREFIX)/share/man/man1

.PHONY: install uninstall

install:
	mkdir -p $(INSTALL_DIR)
	cp -r * $(INSTALL_DIR)/
	chmod +x $(INSTALL_DIR)/cprintf
	ln -sf $(INSTALL_DIR)/cprintf $(BIN_DIR)/cprintf
	@if [ -f doc/cprintf.1 ]; then \
		mkdir -p $(MAN_DIR); \
		cp doc/cprintf.1 $(MAN_DIR)/cprintf.1; \
		chmod 644 $(MAN_DIR)/cprintf.1; \
		echo "Man page installed to $(MAN_DIR)/cprintf.1"; \
	fi

uninstall:
	rm -f $(BIN_DIR)/cprintf
	rm -f $(MAN_DIR)/cprintf.1
	rm -rf $(INSTALL_DIR)