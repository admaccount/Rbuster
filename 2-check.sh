#!/bin/bash
#
# author  : TrustMe
# version : 1.0 
# usage : ./2-check.sh targets.txt
# informations : you must have a file targets.txt containing ip of rsync opened servers
#
# input  : targets.txt
# output : targets_873.txt
#------------------ FUNCTIONS -----------------------#

check_access () {
amap -C 1 -T 1 -t 1 -B $RHOST 873 > /tmp/24373ff2-6975-4b46-ba23-46c8035f5396.txt 2>&1
str="@RSYNCD"
if grep -qF "$str" /tmp/24373ff2-6975-4b46-ba23-46c8035f5396.txt;then
	echo "RSYNC IS BROWSABLE!"
	echo $RHOST >> targets_873.txt
else
	echo "error!"
fi
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


#------------- MAIN -----------#

#check_text_file "$1"
check_package_installed "amap"

FILE=$1
if [ -f "$FILE" ]; then
 cat $FILE |  while read output
 do
	 RHOST=$output
	 echo "[+] RHOST = $output"
	 check_access $output
 done
else
 echo "[ERROR] - $FILE does not exist."
 exit 2
fi

