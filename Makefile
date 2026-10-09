PREFIX ?= /usr/local
BIN_DIR = $(PREFIX)/bin
MAN_DIR = $(PREFIX)/share/man/man1
DEV_BIN ?= $(HOME)/.dev/bin

.PHONY: build install uninstall clean dev dev-clean

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

# Symlink the live cprintf script into the dev-override dir ($(DEV_BIN), kept first
# on PATH) as `cprintf`, shadowing any installed cprintf. It links to the SOURCE
# script (which sources its sibling cprintf-*.inc live), so edits are picked up
# immediately — no rebuild. `make dev-clean` removes it.
dev:
	@mkdir -p "$(DEV_BIN)"
	@ln -sf "$(abspath cprintf)" "$(DEV_BIN)/cprintf"
	@echo "Dev cprintf linked (live source): $(DEV_BIN)/cprintf -> $(abspath cprintf)"
	@case ":$$PATH:" in *":$(DEV_BIN):"*) ;; *) echo "WARNING: $(DEV_BIN) is not on PATH; add it (first) so the dev build is picked up." ;; esac

dev-clean:
	@rm -f "$(DEV_BIN)/cprintf"
	@echo "Removed dev override $(DEV_BIN)/cprintf (installed cprintf, if any, is active again)."
