#!bin/bash
#: Title	: Store Password
#: Version 	: 1.0
#: Description	: store password in a text.file
#: Options
# Users can set a password -p
# Users can set an email -e
# Users can set a service -s
# Users can set verbose mode with -v


usage() {
  echo "Store password into password.txt"
  echo "-p Specify your own password"
  echo "-e Required: Specify an email"
  echo "-s Required: Specify the service"
  echo "-l Specify length of generated password if you don't want to make your own"
  exit 1
}

email=""
service=""
length=""

while getopts ":p:e:s:v:l:" opt; do
	case "${opt}" in
	
	p)
	password=${OPTARG}
	;;
	e)
	email=${OPTARG}
	;;
	s)
	service=${OPTARG,,}
	;;
	l)
	length=${OPTARG}
	;;	
	:)
	echo "Error: -${OPTARG} requires an argument"
	exit 1
	;;
	?)
	usage
	exit 1
	;;
	esac
done

if [ -z "$email" ] || [ -z "$service" ]; then
	echo "Please have both arguments: -e Email and -s Service"
	exit 1
fi

# Generate Password from password generator script

if [ -z "$password" ]; then
	password=$(bash ./password_generator.sh -l $length)
	
else
	echo "User has their own password"
fi


# Generate a unique random ID
unique_id=$(($(date +%s%N) + $RANDOM))


formatted_string="$unique_id,$password,$email,$service"

echo "$formatted_string" >> password.txt
echo "Appending to File was successful"

exit 0
