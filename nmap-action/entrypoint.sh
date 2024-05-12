#!/bin/sh

today=$(date +"%d-%m-%Y")
results_file="/tmp/scan-results-on-$today.txt"
anonymous_ip="xXx.xXx.xXx.xXx"

# Run nmap and export results into a file
/usr/bin/nmap \
    --min-rate 4500 \
    --max-rtt-timeout 1500ms \
    -Pn \
    -n \
    -p- \
    -oN "$results_file" \
    "$INPUT_IP_ADDRESS" 2>&1 > /dev/null

# Replace newlines and replace IP address
results=$(sed ':a;N;$!ba;s/\n/\\n/g' "$results_file" | sed "s/$INPUT_IP_ADDRESS/$anonymous_ip/g")

# Create issue
curl -XPOST "https://api.github.com/repos/$INPUT_GITHUB_REPO/issues" \
     -H "Authorization: token $INPUT_GITHUB_TOKEN" \
     -H "Content-Type: application/vnd.github.v3+json" \
     -d "{
  \"title\": \"Scan results on $today\",
  \"body\": \"\`\`\`\\n$results\\n\`\`\`\"
}" \
     --silent \
     --output /dev/null
