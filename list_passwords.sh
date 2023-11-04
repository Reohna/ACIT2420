#!/bin/bash
#: Title:	 List Passwords
#: Version 	: 1.0
#Users can search for a password with a specific service -s
#Users can search for all passwords within the text.file
#Users can specify which file they want to search for passwords as long as the txt file follows the format UID,password,email,service
#Users can set verbose mode with -v

#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################

usage() {
    echo "List passwords from password.txt"
    echo "-p : find all passwords'"
    echo "-s : search for passwords based on service"
    echo "-v : Verbose Mode = True "
    exit 1
}

#Variables used in the functions

specific_service=""
file="password.txt"
find_password=false

while getopts "pvf:s:" opt; do
        case $opt in
	p)
	find_password=true
	;;
        s)
        specific_service="${OPTARG,,}"
        ;;
        v)
        VERBOSE='true'
	;;
	f)
	file=${OPTARG}
	;;
       	:)
       	echo "Error : -${OPTARG} requires an argument"
	exit 1
        ;;
	?)
	usage
	exit 1
	;;
esac
done



#Read by lines from txt file to print all passwords
# Reads a file, line by line
# Split the line by "," to create the indexes uid,password,email,service
# The code skips the first line of the iteration which the name of the "columns".
counter=0
while IFS= read -r line; do
	IFS="," read -ra fields<<< "$line"
	if $find_password == true; then
		for field in fields; do
			if [ $counter -eq 1 ]; then
				echo "${fields[1]}"
				((counter++))
			elif [ $counter -gt 1 ]; then
			      echo "${fields[1]}"
			fi
		((counter++))
		done
	fi

# Checks if you want to find passwords based on a specific service. 
# Counter is used to skip the first line again
# compares every 
	
	if [ "$specific_service" != "" ]; then
		counter=0
		for field in "${fields[@]}";do
			if [ $counter -eq 1 ]; then
				((counter++))
				continue
			fi
			if [ "$specific_service" == $field ]; then
				echo ${fields[1]}
				break

			fi
			((counter++))
		done
	fi
done< $file
