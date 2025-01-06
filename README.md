rbuster

rbuster is a software tool for conducting audits and security assessments. It consists of four programs designed to perform different tasks related to scanning, checking, exploring, and brute-forcing.
Programs

    scan.sh: This program is used to scan a given IP range. It requires a file containing the IP ranges to be scanned. To scan the entire internet, create a file with a single line containing '0.0.0.0/0'. Each subnet to be scanned should be listed on a separate line.

    check.sh: The check.sh program is used to verify if there are any open rsync servers within the target IP addresses. It requires a file named "targets.txt" containing the list of target IP addresses.

    explore.sh: This program explores the open rsync servers identified in the previous step (using targets_873.txt) and performs further assessments. The output is saved in separate files for each server, named after their respective IP addresses.

    bruteforce.sh: The bruteforce.sh program is used for conducting brute-force attacks on a specific target server. It requires the target IP address, the username, and the path to a wordlist file.

Usage

To use rbuster and its programs, follow the instructions below:

    scan.sh:

./1-scan.sh file_containing_ip_range.txt

Example:

./1-scan.sh my_ip_ranges.txt

check.sh:

./2-check.sh targets.txt

Example:

./2-check.sh targets.txt

explore.sh:

./3-explore.sh targets_873.txt

Example:

./3-explore.sh targets_873.txt

bruteforce.sh:

php

./4-bruteforce.sh <target_ip> <username> <wordlist_path>

Example:

bash

    ./4-bruteforce.sh 1.1.1.1 root /usr/share/wordlists/top100-WillieStevenson.txt

Author

rbuster was created by TrustMe.
Version

Current version: 1.0

Feel free to explore and audit your systems using rbuster. Please ensure that you have the necessary permissions and authorization before conducting any security assessments or audits.
         
