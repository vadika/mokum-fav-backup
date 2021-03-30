#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "run it with Mokum api key, like favbackup.sh xxxxx-xxxxx-xxxx-xxxx"
    echo "you may retreive your key at https://mokum.place/customize/apitokens"
    exit 1
fi

API_TOKEN=$1

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed. apt install curl may help' >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed. apt install jq may help' >&2
  exit 1
fi


for ((i=1; ; i+=1)); do
    contents=$(curl -H "Content-Type: application/json" -H "X-API-Token: $API_TOKEN" "https://mokum.plac
e/filter/favs.json?page=$i")
    echo "$contents" > $i.json
    if jq -e '.older_entries_url | length == 0' >/dev/null; then 
       break
    fi <<< "$contents"
done
