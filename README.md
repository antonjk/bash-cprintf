# bash-cprintf

Bash script that provides printf-like functionality with XML-style markup for colors and text formatting.

![Screenshot1](images/Screenshot1.png)

## Features

- Printf-compatible formatting with color markup
- XML-style tags for colors and text effects
- Supports nested tags and inline modifiers
- 256-color and true color support
- Reads from stdin or command line arguments
- Can be used as a library (sourced)

## Installation

### Quick Install

```bash
curl -sSL https://tinyurl.com/mbzv9ex9 | sudo bash
```

### Manual Install

```bash
wget https://github.com/antonjk/bash-cprintf/archive/refs/heads/main.zip
unzip main.zip
cd bash-cprintf-main
sudo make install
```

### From Source

```bash
git clone https://github.com/antonjk/bash-cprintf.git
cd bash-cprintf
chmod +x cprintf
```

## Usage

```bash
# Basic usage
./cprintf "<fg:red>Error:</fg> <b>%s</b>\n" "File not found"

# Pipe input
echo "<fg:blue>Hello World</fg>" | ./cprintf

# Nested tags
./cprintf "<fg:red><b>Bold Red</b></fg>\n"

# Use as library
source ./cprintf
cprintf "<fg:green>Success:</fg> %s\n" "Operation completed"
```

## Supported Tags

- `<fg:color></fg>` - Foreground color
- `<bg:color></bg>` - Background color  
- `<b></b>` - Bold text
- `<i></i>` - Italic text
- `<u></u>` - Underlined text
- `<dim></dim>` - Dim text
- `<inv></inv>` - Inverted colors

## Color Modifiers

- `!` - Bold effect
- `*` - Italic effect
- `_` - Underline effect
- `~` - Invert effect
- `+` - High intensity
- `-` - Low intensity

Example: `<fg:red!*>Bold italic red</fg>`

## License

MIT License - see LICENSE file for details.