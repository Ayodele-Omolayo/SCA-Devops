#!/bin/bash

echo "Welcome to the User Registration System"

# Function to create a new user
create_user() {
    local username=$1
    local pass=$2

    # Creating the user and setting the password
    sudo useradd -m "$username"
    echo "$username:$pass" | sudo chpasswd

    echo "User '$username' created successfully."
}

# Function to validate password
validate_password() {
    local pass=$1

    if [ ${#pass} -lt 8 ]; then
        echo "Password is too short, must be at least 8 characters."
        return 1
    fi

    return 0
}

# User input for username and password
read -p "Enter your username: " username
read -s -p "Enter your password: " password
echo

# Validate password
if validate_password "$password"; then
    create_user "$username" "$password"
else
    echo "Failed to create user, password too short!!!"
fi

