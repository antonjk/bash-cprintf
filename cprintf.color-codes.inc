#? Display the available color codes

cat "${SCRIPT_DIR}/examples/color-codes.txt" | (
      while IFS= read -r line; do
        cprintf "${line}\n"
      done
)
exit 0

