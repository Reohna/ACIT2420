#!/bin/bash
#: Title     : list_tasks
#: Version   : 1.0
#: Description: lists all tasks
# Users can search for tasks due this week -w
# Users can search for tasks due within 3 days -d

# Function to display usage instructions
usage(){
    echo "List tasks"
    echo "-a List all tasks"
    echo "-w List all tasks due this week"
    echo "-d List all tasks due within specified days"
    echo "-n Delete task with specified ID"
    echo "-v Display output in verbose mode"
    exit 1
}

# Function to log messages in verbose mode
log(){
    local MESSAGE="${@}"
    if [[ "${VERBOSE}" = 'true' ]]; then
        echo "${MESSAGE}"
    fi
}

# Initialize variables
all_tasks=false
week=false
days=""
delete=""
CURRENTWEEK=$(date +"%U")
CURRENTDAY=$(date +"%s")
seconds_in_days=86400

# Parse command line options
while getopts "awvd:n:" opt; do
    case "${opt}" in
    a)
        all_tasks=true
        ;;
    d)
        days="${OPTARG}"
        ;;
    w)
        week=true
        ;;
    n)
        delete="${OPTARG}"
        ;;
    v)
        VERBOSE='true'
        log 'Verbose mode on'
        ;;
    *)
        usage
        ;;
    esac
done

# Counter for skipping header line in tasks.txt
counter=0

# Loop through tasks.txt file
while IFS= read -r line; do
    IFS="," read -ra tasks <<< "$line"

    # Delete task if -n option is provided and task ID matches
    if [ -n "$delete" ]; then
        if [ "$delete" != "${tasks[0]}" ]; then
            echo "Success"
            echo $line >> tmp.txt
        fi
    fi

    # Skip header line in tasks.txt
    if [ $counter -eq 0 ]; then
        ((counter++))
        continue
    fi

    # Display all tasks if -a option is provided
    if $all_tasks == true && [ -n "$line" ]; then
        echo $line
    fi

    # Display tasks due this week if -w option is provided
    # Tasks with not Dates are included because they are mostly likely RECENT if they're added without a date
    if $week == true; then
        if [ "$CURRENTWEEK" == "$(date -d "${tasks[2]}" +"%U")" ] && [ -n "$line" ]; then
            echo $line
        fi
    fi

    # Display tasks due within specified days if -d option is provided
    if [ -n "$days" ]; then
        days_in_seconds=$(($days * $seconds_in_days))
        INPUTDATE=$(($CURRENTDAY + $days_in_seconds))
        formatted_date=$(date -d "${tasks[2]}" +"%Y-%m-%d")
        formatted_Seconds=$(date -d "$formatted_date" "+%s")
        
        if ((INPUTDATE >= formatted_Seconds)) && ((formatted_Seconds > CURRENTDAY)); then
            echo "${tasks[1]}"
        fi
    fi
done < "tasks.txt"

# If delete option is provided, move the modified tmp.txt back to tasks.txt
if [ -n "$delete" ]; then
    mv tmp.txt tasks.txt
fi
