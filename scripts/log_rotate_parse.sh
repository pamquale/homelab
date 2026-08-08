#!/bin/bash

set -euo pipefail

LOG="/var/log/httpd/access_log"
LOG_ARCHIVE_DIR="/var/log/httpd/arcived_logs"
LOG_REPORT_DIR="/var/reports"
CURRENT_TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_FILE="${LOG_REPORT_DIR}/report_${CURRENT_TIMESTAMP}.txt"
RETENTION_DAYS=14

mkdir -p "$LOG_ARCHIVE_DIR"
mkdir -p "$LOG_REPORT_DIR"

if [ ! -s "$LOG" ]; then
echo "log is empty"
exit 0
fi
{
	# Top 5 IPs that recieves 404 (possible scanners)
	echo "========== Top 5 IPs by request that recieved 404 =========="
	awk '$9 == "404" {print $1}' "$LOG" | sort | uniq -c | sort -rn | head -5

	# Top of the response codes (to see potential rise of 500 or smth else)
	echo "========== Top list of the response codes =========="
	awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn

	# Sum of the 4x 5x codes
	echo "========== Amount of the 4x codes =========="
	awk '$9 ~ /^4/' "$LOG" | wc -l
	echo "========== Amount of the 5x codes =========="
	awk '$9 ~ /^5/' "$LOG" | wc -l

	# All of the requests
	echo "========== Amount of all the requests =========="
	wc -l < "$LOG"
} > "$REPORT_FILE"

mv "$LOG" "${LOG_ARCHIVE_DIR}/access_log"
systemctl reload httpd
gzip "${LOG_ARCHIVE_DIR}/access_log"
mv "${LOG_ARCHIVE_DIR}/access_log.gz" "${LOG_ARCHIVE_DIR}/access_log_${CURRENT_TIMESTAMP}.gz"

echo "Report: $REPORT_FILE"

find "$LOG_ARCHIVE_DIR" -mtime +"$RETENTION_DAYS" -delete 

find "$LOG_REPORT_DIR" -mtime +"$RETENTION_DAYS" -delete
