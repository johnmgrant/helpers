#!/usr/bin/env zsh

set -euo pipefail
setopt null_glob

# Prompt for runtime configuration
DEFAULT_FOLDER_PATH="${FOLDER_PATH:-$HOME/Desktop/mysql_backups}"

echo "MySQL import configuration"
print -n "MySQL username (leave empty to omit -u): "
read -r MYSQL_USER

print -n "MySQL password (leave empty to omit -p): "
read -rs MYSQL_PASSWORD
echo

print -n "Folder path with .sql files [$DEFAULT_FOLDER_PATH]: "
read -r INPUT_FOLDER_PATH

FOLDER_PATH="${INPUT_FOLDER_PATH:-$DEFAULT_FOLDER_PATH}"

typeset -a MYSQL_AUTH_ARGS
[[ -n "$MYSQL_USER" ]] && MYSQL_AUTH_ARGS+=( -u "$MYSQL_USER" )
[[ -n "$MYSQL_PASSWORD" ]] && MYSQL_AUTH_ARGS+=( "-p$MYSQL_PASSWORD" )

typeset -a SQL_FILES
SQL_FILES=("$FOLDER_PATH"/*.sql)

if [[ ${#SQL_FILES[@]} -eq 0 ]]; then
    echo "No .sql files found in $FOLDER_PATH"
    exit 0
fi

# Run the loop
for file in "${SQL_FILES[@]}"; do

    # Extract the database name from the file name (e.g., "blog.sql" becomes "blog")
    db_name=$(basename "$file" .sql)

    echo "------------------------------------------------"
    echo "Starting: $db_name"
    echo "------------------------------------------------"

    # Step A: Create the database if it doesn't already exist
    echo "Creating database '$db_name' (if needed)..."
    mysql "${MYSQL_AUTH_ARGS[@]}" -e "CREATE DATABASE IF NOT EXISTS \`$db_name\`;"

    # Step B: Import the data
    echo "Importing data into '$db_name'..."
    if mysql "${MYSQL_AUTH_ARGS[@]}" "$db_name" < "$file"; then
        echo "✅ Successfully imported: $db_name"
    else
        echo "❌ Failed to import: $db_name"
    fi
done

echo "🎉 All done! Check the output above for any errors."