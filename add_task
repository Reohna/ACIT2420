#!/bin/bash
#: Title        : add_task
#: Version        : 1.0
#: Description        : Add a task to a txt file
#: Options
# Users can add a task -a
# Users can choose to add a due date -d
# Tasks have an ID generated as they're added


#######################################
# Print a Usage message.
# Arguments:
#   None
# Outputs:
#   Write a help message
#######################################

usage() {
    echo "Add a task to a task.txt"
    echo "Required: -a Add a task by name ex. 'Clean Washroom'"
    echo "Optional: -d Add an optional due date. format YYYY-MM-DD"
    exit 1
}


task=""
due_date=""




while getopts ":a:d:" opt; do
    case "${opt}" in
    a) 
    task=${OPTARG}
    ;;
    d)
    due_date="${OPTARG}"
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

if [ -z "$task" ]; then
    echo "Please enter Task Name"
    exit 1
fi


#Generate Random ID
id=$RANDOM

#If due_date is NOT empty
#Check if the string is in the right format
#Else:
#Format the string without a due_date

if  [ -n ${due_date} ] ; then
    if [[ $due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        formatted_string="${id},${task},${due_date}"
    fi
fi
if [ -z ${due_date} ] ;then
    formatted_string="${id},${task}"
fi




#Append stirng to tasks.txt

echo "$formatted_string" >> tasks.txt
echo "Appending to tasks.txt was successful"

exit 0
