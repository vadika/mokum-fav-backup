# mokum-fav-backup

Script to backup mokum.place fav's 


Requires curl and jq to be installed on the system

Debian-based - apt install curl jq, otherwise check https://github.com/stedolan/jq/wiki/Installation to deal with installation of jq.

Run it with Mokum api key, like  bash ./favbackup.sh xxxxx-xxxxx-xxxx-xxxx"

You may retreive your key at https://mokum.place/customize/apitokens"


another script version with user/passwd authentication to deal with 128 pages API limit -- ./favbackup-user.sh user@email passwd
