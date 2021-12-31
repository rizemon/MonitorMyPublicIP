#!/bin/sh

today=$(date +"%d-%m-%Y")
results_file="/tmp/scan-results-on-$today.txt"
anonymous_ip="xXx.xXx.xXx.xXx"

# Run nmap and export results into a file
/usr/bin/nmap -n -p- "$IP_ADDRESS" -oN "$results_file" 2>&1 > /dev/null

# Replace newlines and replace IP address
results=$(sed ':a;N;$!ba;s/\n/\\n/g' "$results_file" | sed "s/$IP_ADDRESS/$anonymous_ip/g")

# Create issue
curl -XPOST "https://api.github.com/repos/$GITHUB_REPO/issues" \
     -H "Authorization: token $GITHUB_TOKEN" \
     -H "Content-Type: application/vnd.github.v3+json" \
     -d "{
  \"title\": \"Scan results on $today\",
  \"body\": \"\`\`\`\\n$results\\n\`\`\`\"
}" \
     --silent \
     --output /dev/null
