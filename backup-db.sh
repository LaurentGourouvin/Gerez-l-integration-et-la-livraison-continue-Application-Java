#!/usr/bin/env bash
set -euo pipefail

# Configuration
BACKUP_DIR="./backups"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DUMP_FILE="${BACKUP_DIR}/workshopsdb_${TIMESTAMP}.dump"

# Credentials DB
DB_USER="workshops_user"
DB_NAME="workshopsdb"

mkdir -p "${BACKUP_DIR}"

docker compose exec -T db pg_dump \
  -U "${DB_USER}" \
  -d "${DB_NAME}" \
  -Fc > "${DUMP_FILE}"

if [[ ! -s "${DUMP_FILE}" ]]; then
  echo "ERREUR : dump vide !" >&2
  exit 1
fi

find "${BACKUP_DIR}" -name "*.dump" -mtime +${RETENTION_DAYS} -delete

echo "Backup OK : ${DUMP_FILE} ($(du -h "${DUMP_FILE}" | cut -f1))"
