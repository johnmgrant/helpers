#!/bin/bash

# 1. Ensure Homebrew is installed to fetch the utility
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Install 'duti' if it's missing
if ! command -v duti &> /dev/null; then
    echo "Installing 'duti' utility..."
    brew install duti
fi

# 3. Dynamic lookup for VS Code's bundle ID (Usually: com.microsoft.VSCode)
VSCODE_ID=$(osascript -e 'id of app "Visual Studio Code"' 2>/dev/null)

if [ -z "$VSCODE_ID" ]; then
    echo "Error: Visual Studio Code does not appear to be installed on this Mac."
    exit 1
fi

echo "Found VS Code Bundle ID: $VSCODE_ID"
echo "Reassigning development extensions away from Antigravity..."

# 4. Comprehensive array of common code/text extensions hijacked by IDE tools
EXTENSIONS=(
    "txt" "md" "json" "js" "jsx" "ts" "tsx" "css" "scss" "html" "htm"
    "py" "pyw" "rb" "sh" "bash" "zsh" "cfg" "conf" "ini" "yaml" "yml"
    "c" "cpp" "cc" "h" "hpp" "cs" "go" "rs" "php" "java" "kt" "swift"
    "sql" "xml" "lock" "gitignore" "dockerignore" "dockerfile"
)

# 5. Execute the reassignments
for ext in "${EXTENSIONS[@]}"; do
    # 'all' tells macOS to use VS Code for editing, viewing, and opening
    duti -s "$VSCODE_ID" "$ext" all
    echo "  [✓] Default for .$ext set to VS Code"
done

echo "--------------------------------------------------------"
echo "Done! macOS file associations have been updated."
echo "You may need to relaunch Finder (Killall Finder) to refresh icons."
