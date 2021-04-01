#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "run it with Mokum login and password, like favbackup.sh user@email.com password"
    exit 1
fi

USER=$1
PASSWD=$2

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed. apt install curl may help' >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed. apt install jq may help' >&2
  exit 1
fi


CSRF=$(curl https://mokum.place/users/sign_in  --cookie-jar cookie |grep csrf-token|sed -e 's#<meta name="csrf-token" content="##'|sed -e 's#" />##')

auth=$(curl https://mokum.place/users/sign_in --data "user[email]=$USER" --data "user[password]=$PASSWD" --data "user[remember_me]=1" --data "authenticity_token=$CSRF" --cookie-jar cookie)

if [ "$auth" != '<html><body>You are being <a href="https://mokum.place/">redirected</a>.</body></html>' ]; then
	echo "authentication failed, probably wrong credentials"
	exit 1
fi

page="/filter/favs.json"

while :;
do
    mv cookie{,.old}
    sed -e s/#HttpOnly_// <cookie.old >cookie
    page=$( echo $page | sed -e s/\"//g )
    URL="https://mokum.place$page"

    contents=$(curl -b cookie -c cookie   -H "Content-Type: application/json" $URL )

    echo "$contents" > `basename $page`

    page=$(jq -e '.precise_older_entries_url' <<<"$contents")
    if jq -e '.older_entries_url | length == 0 ' >/dev/null; then 
       break
    fi <<< "$contents"
done
