# Contributing to bash-cprintf

Thank you for your interest in contributing to bash-cprintf! This document provides guidelines and instructions for
contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Coding Standards](#coding-standards)
- [Documentation](#documentation)

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Keep discussions professional and on-topic

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/bash-cprintf.git
   cd bash-cprintf
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/antonjk/bash-cprintf.git
   ```

## Development Setup

### Prerequisites

- Bash 4.0 or higher
- Git
- A terminal with color support (for testing)

### Local Installation

Test your changes locally without system installation:

```bash
# Make scripts executable
chmod +x cprintf mdterm

# Test cprintf directly
./cprintf "<fg:red>Test</fg>\n"

# Test mdterm
./mdterm "# Heading\n**Bold** text"

# Or source as a library
source ./cprintf
cprintf "<fg:green>Success</fg>\n"
```

### Build System

The project uses a build script to create different cprintf variants:

```bash
# Build full version (default)
./scripts/build-cprintf full

# Build minimal core
./scripts/build-cprintf core

# Build library version
./scripts/build-cprintf lib

# Build all variants
./scripts/build-cprintf all

# Clean build artifacts
./scripts/build-cprintf clean

# Show help
./scripts/build-cprintf --help
```

## Making Changes

### Contribution Philosophy

We use **feature branches** with a focus on **small, fast iterations**:

- **Keep branches short-lived** (< 3 days preferred)
- **Make small PRs** (< 400 lines of changes)
- **Integrate frequently** (rebase from main daily)
- **One logical change per PR** (easier to review and merge)

**Why small PRs?**

- Faster code review
- Easier to understand and test
- Reduced merge conflicts
- Quicker feedback loop
- Lower risk of breaking changes

**For large features:**

- Break into multiple small PRs
- Use feature flags to hide incomplete work
- Submit incremental improvements
- Each PR should leave code in working state

### Branch Naming

Create a descriptive branch for your changes:

- `feat/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/what-changed` - Documentation updates
- `refactor/what-changed` - Code refactoring
- `test/what-added` - Test additions

Example:

```bash
git checkout -b feat/add-gradient-support
```

### Keeping Your Branch Current

**Rebase frequently** to avoid integration issues:

```bash
# Daily or before starting work
git fetch upstream
git rebase upstream/main

# If conflicts occur, resolve them immediately
git rebase --continue
```

**Why rebase instead of merge?**

- Cleaner commit history
- Easier to review changes
- Conflicts resolved incrementally
- No merge commits cluttering history

### Commit Messages

Follow the conventional commit format:

```
type: brief description

Detailed explanation of changes (if needed)

- Bullet points for specific changes
- Reference issues with #issue-number
```

**Types:**

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `perf:` - Performance improvements
- `style:` - Code style changes (formatting, etc.)

**Example:**

```
feat: Add gradient color support

- Implement gradient color interpolation
- Add <gradient> tag support
- Update documentation with gradient examples

Closes #42
```

## Testing

### Testing Philosophy

For bash-cprintf, we use a combination of:

- **Manual testing** - Visual verification of colors and formatting
- **Automated tests** - Unit tests for core functions (coming soon)
- **Integration tests** - End-to-end output verification

### Manual Testing

Test your changes with various scenarios:

**cprintf:**

```bash
# Basic functionality
./cprintf "<fg:red>Error</fg>\n"

# Color spaces
./cprintf "<fg:#FF0000>Hex color</fg>\n"
./cprintf "<fg:196>8-bit color</fg>\n"

# Modifiers
./cprintf "<fg:red!*_>Bold italic underline</fg>\n"

# Nested tags
./cprintf "<fg:red>Red <b>bold</b> text</fg>\n"

# Printf formatting
./cprintf "<fg:green>Count: %d</fg>\n" 42
```

**mdterm:**

```bash
# Test markdown rendering
./mdterm "# Heading 1\n## Heading 2\n**bold** *italic*"

# Test from file
./mdterm -f README.md

# Test code blocks
echo '```bash' > test.md
echo 'echo "hello"' >> test.md
echo '```' >> test.md
./mdterm -f test.md

# Test with custom bat args
./mdterm --bat-args "--theme=Dracula" -f test.md
```

### Automated Testing (Future)

We plan to add automated tests using **bats** (Bash Automated Testing System).

**Example test structure:**

```bash
#!/usr/bin/env bats

@test "basic color output" {
    result=$(./cprintf "<fg:red>test</fg>")
    expected=$'\033[31mtest\033[39m'
    [ "$result" = "$expected" ]
}

@test "nested tags" {
    result=$(./cprintf "<fg:red><b>test</b></fg>")
    # Verify ANSI codes are correct
    [[ "$result" =~ \033\[31m.*\033\[1m.*test ]]
}
```

**To run tests (when implemented):**

```bash
# Install bats
brew install bats-core # macOS
apt-get install bats # Ubuntu

# Run tests
bats tests/
```

### Integration Testing

Create test scripts that verify complete functionality:

```bash
#!/bin/bash
# tests/integration_test.sh

source ./cprintf

# Test 1: Basic color
output=$(cprintf "<fg:red>test</fg>")
if [[ ! "$output" =~ $'\033\[31m' ]]; then
    echo "FAIL: Basic color test"
    exit 1
fi

# Test 2: Hex colors
output=$(cprintf "<fg:#FF0000>test</fg>")
if [[ ! "$output" =~ $'\033\[38;2;255;0;0m' ]]; then
    echo "FAIL: Hex color test"
    exit 1
fi

echo "All tests passed!"
```

### Snapshot Testing

For visual output, capture and compare:

```bash
# Generate snapshot
./cprintf "<fg:red>test</fg>" >tests/snapshots/basic-red.txt

# Compare in tests
diff <(./cprintf "<fg:red>test</fg>") tests/snapshots/basic-red.txt
```

### Test Coverage Areas

**Core Functions:**

- `cprintf::colorize()` - Tag parsing
- `cprintf::add_color_effect()` - Color code conversion
- `cprintf::ansi_seq()` - ANSI sequence generation

**Color Notations:**

- Decimal (0-7, 16-255, 256+)
- Hex (#0-#F, #00-#FF, #RRGGBB)
- @ prefix (@0-@255, @256+)
- Aliases (red, Red, black, etc.)

**Modifiers:**

- Intensity (+/-)
- Effects (!, *, _, =, ~)
- Multiple modifiers combined

**Edge Cases:**

- Empty strings
- Unclosed tags
- Invalid color codes
- Nested tags
- HTML entities (&lt;, &gt;, &amp;)

### Test Different Terminals

Test in multiple terminal emulators:

- iTerm2 (macOS)
- Terminal.app (macOS)
- GNOME Terminal (Linux)
- Windows Terminal
- tmux/screen sessions

### Check Color Support

```bash
./cprintf --check-color-support
```

### Contributing Tests

When adding tests:

1. Create test file in `tests/` directory
2. Name tests descriptively: `test_hex_colors.bats`
3. Test both success and failure cases
4. Include edge cases
5. Document what each test verifies

## Submitting Changes

### PR Size Guidelines

**Ideal PR sizes:**

- **Tiny** (< 50 lines): Documentation, typos, small fixes - merge quickly
- **Small** (50-200 lines): Single feature or bug fix - preferred size
- **Medium** (200-400 lines): Complex feature - consider splitting
- **Large** (> 400 lines): Should be split into multiple PRs

**If your PR is large:**

1. Can it be split into smaller, independent changes?
2. Can you use feature flags to merge incomplete work?
3. Can you submit the refactoring separately from the feature?
4. Discuss with maintainers before investing too much time

### Before Submitting

1. **Update documentation** if needed
    - Update README.md for user-facing changes
    - Update man pages (doc/cprintf.1, doc/mdterm.1) for new features
    - Add examples to relevant files

2. **Test thoroughly**
    - Test all affected functionality
    - Verify backward compatibility
    - Check edge cases
    - Test both cprintf and mdterm if changes affect both

3. **Update CHANGELOG** (if applicable)

### Pull Request Process

1. **Sync with upstream** (do this frequently!):
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push to your fork**:
   ```bash
   git push origin your-branch-name
   # If you rebased, you may need to force push
   git push --force-with-lease origin your-branch-name
   ```

3. **Create Pull Request** on GitHub with:
    - Clear title describing the change
    - Detailed description of what and why
    - Reference related issues
    - Screenshots/examples for visual changes
    - Mention if this is part of a larger feature

4. **Respond to feedback**:
    - Address review comments promptly (within 24-48 hours)
    - Make requested changes in new commits (easier to review)
    - Keep discussion focused and professional
    - If you disagree, explain your reasoning respectfully

5. **After approval**:
    - Maintainer will merge (usually squash merge for clean history)
    - Delete your branch after merge
    - Celebrate! 🎉

### Stale Branches

Branches inactive for > 30 days may be closed:

- Comment if you're still working on it
- Rebase and update if you plan to continue
- No hard feelings if life gets busy!

## Coding Standards

### Bash Style Guide

- Use 3-space indentation
- Use `[[ ]]` for conditionals (not `[ ]`)
- Quote variables: `"${variable}"`
- Use `local` for function variables
- Prefer `$(command)` over backticks

### Function Documentation

Document functions with comment blocks:

```bash
#-----------------------------------------------------------------------------------------------------------------------
# Brief description of function.
#
# Detailed explanation of what the function does,
# how it works, and any important notes.
#
# Arguments:
#   $1 - Description of first argument
#   $2 - Description of second argument
#
# Returns:
#   Description of return value or output
#
# Examples:
#   function_name "arg1" "arg2"
#-----------------------------------------------------------------------------------------------------------------------
function function_name() {
    # Implementation
}
```

### Naming Conventions

- Functions: `cprintf::function_name` or `mdterm::function_name` (use namespace prefix)
- Variables: `snake_case` for local, `UPPER_CASE` for globals
- Style arrays: `MD_STYLE_*` prefix for mdterm styles
- Constants: `UPPER_CASE` with descriptive names
- Private functions: Prefix with `_` (e.g., `_internal_function`)

### Code Organization

- Keep functions focused and single-purpose
- Group related functions together
- Use meaningful variable names
- Add comments for complex logic
- Avoid deep nesting (max 3-4 levels)

## Documentation

### Project Structure

```
bash-cprintf/
├── cprintf                    # Main cprintf script (template)
├── mdterm                     # Markdown terminal renderer
├── cprintf-*.inc             # Core include modules
├── cprintf-opt-*.inc         # Optional feature modules
├── scripts/
│   └── build-cprintf         # Build system script
├── doc/
│   ├── cprintf.1             # cprintf man page
│   └── mdterm.1              # mdterm man page
├── examples/
│   ├── cprintf_demo.sh       # Demo script
│   ├── color-codes.txt       # Color reference
│   └── markdown.md           # Markdown examples
└── tests/                     # Test files (future)
```

### README Updates

Update README.md when adding:

- New features
- New tags or modifiers
- New color notation formats
- Installation changes

### Man Page Updates

Update man pages for:

**doc/cprintf.1:**
- New command-line options
- New markup tags
- New color notation formats
- Behavior changes

**doc/mdterm.1:**
- New markdown syntax support
- New command-line options
- Behavior changes

### Example Files

Add examples to appropriate files:

- `cprintf-opt-supported-tags.inc` - Tag examples
- `examples/color-codes.txt` - Color notation examples
- `examples/cprintf_demo.sh` - Demo script updates
- `examples/markdown.md` - Markdown rendering examples

### Inline Comments

Add comments for:

- Complex algorithms
- Non-obvious behavior
- Performance considerations
- Workarounds or hacks

## Areas for Contribution

### High Priority

- Performance optimizations
- Additional terminal compatibility
- More comprehensive testing
- Bug fixes
- mdterm markdown feature completeness

### Feature Ideas

**cprintf:**
- Gradient color support
- Animation/progress bar helpers
- Color scheme presets
- Template system
- Color palette management

**mdterm:**
- Additional markdown syntax (lists, tables, links)
- Custom style themes
- Export to HTML with colors
- Pager integration

### Documentation

- More examples
- Tutorial content
- Video demonstrations
- Translation to other languages

## Questions?

- Open an issue for questions
- Check existing issues and PRs
- Review documentation first

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to bash-cprintf! 🎨
