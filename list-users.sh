#!/bin/bash

# Check if TOKEN environment variable is set
if [ -z "$TOKEN" ]; then
    echo "Error: GitHub token not set. Set the TOKEN environment variable."
    exit 1
fi

# Check if both REPO_OWNER and REPO_NAME are provided as command-line arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
    exit 1
fi

# Assign command-line arguments to variables
REPO_OWNER=$1
REPO_NAME=$2

# GitHub API URL
API_URL="https://api.github.com"

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators=$(curl -s -H "Authorization: token $TOKEN" "${API_URL}/${endpoint}" | jq -r '.[] | select(.permissions.pull == true) | .login')

    # Display the list of collaborators with read access
    if [ -z "$collaborators" ]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
