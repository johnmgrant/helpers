#!/usr/bin/env zsh

set -euo pipefail

# Optional credentials (when empty, -u/-p are omitted)
MYSQL_USER="${MYSQL_USER:-}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"
OUTPUT_DIR="${OUTPUT_DIR:-$HOME/Desktop}"

typeset -a MYSQL_AUTH_ARGS
[[ -n "$MYSQL_USER" ]] && MYSQL_AUTH_ARGS+=( -u "$MYSQL_USER" )
[[ -n "$MYSQL_PASSWORD" ]] && MYSQL_AUTH_ARGS+=( "-p$MYSQL_PASSWORD" )

mkdir -p "$OUTPUT_DIR"

mysql "${MYSQL_AUTH_ARGS[@]}" -e "SHOW DATABASES;" \
    | grep -Ev "^(Database|information_schema|performance_schema|sys|mysql)$" \
    | while IFS= read -r db; do
            [[ -z "$db" ]] && continue
            output_file="$OUTPUT_DIR/$db.sql"
            echo "Exporting $db..."
            mysqldump "${MYSQL_AUTH_ARGS[@]}" "$db" > "$output_file"
            echo "Completed: $db saved to $output_file"
        done