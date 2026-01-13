PREFIX ?= /usr/local
INSTALL_DIR = $(PREFIX)/share/cprintf
BIN_DIR = $(PREFIX)/bin

.PHONY: install uninstall

install:
	mkdir -p $(INSTALL_DIR)
	cp -r * $(INSTALL_DIR)/
	chmod +x $(INSTALL_DIR)/cprintf
	ln -sf $(INSTALL_DIR)/cprintf $(BIN_DIR)/cprintf

uninstall:
	rm -f $(BIN_DIR)/cprintf
	rm -rf $(INSTALL_DIR)