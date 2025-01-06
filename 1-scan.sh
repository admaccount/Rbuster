#!/bin/bash
#
# author  : TrustMe
# version : 1.0 
# usage : ./1-scan.sh file_containing_ip_range.txt
# information : to scan internet create a file with a single line '0.0.0.0/0'
# you need to create a file with subnet you want scan, one by line only
#
# input  : file containing ip range 
# output : targets.txt

#
# ------------------ FUNCTIONS -----------------
#
scan() {
RHOSTS=$1
masscan --max-rate=30000000 -p 873 --range $RHOSTS --exclude 255.255.255.255 > hosts.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" hosts.txt >> targets.txt
rm hosts.txt  2>&1
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

#						   #
# ------------------------ MAIN --------------------
#                                                  #
if [[ $EUID -ne 0 ]]; then
    echo "Work like a true hacker ! run the script as ROOT !"
    exit 1
fi
check_text_file "$1"
check_package_installed "masscan"
# reading file line by line 
cat $1 |  while read output
do
 RHOST=$output
 echo "[+] RHOST = $output"
 scan $output
done

