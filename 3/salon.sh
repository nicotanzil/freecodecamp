#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "My Salon Appointment "
echo -e "Welcome to My Salon, how can I help you?\n"

# Main menu
MAIN_MENU() {
    SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services")

    echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE
    do
    echo -e "$SERVICE_ID) $SERVICE"
    done

    read SERVICE_ID_SELECTED

    # check if service id is valid
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_NAME ]]
    # if not then return to main menu
        then
        MAIN_MENU “I could not find that service. What would you like today?”
    fi

    echo -e "What's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
        then
        echo "It looks like you are a new customer! What's your name?"
        read CUSTOMER_NAME
        INSERTED_CUSTOMER_ID=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE') RETURNING customer_id")
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    else
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    fi

    echo -e "When do you want to come in?"
    read SERVICE_TIME

    INSERTED_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') RETURNING appointment_id")

    echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 

    exit
}

MAIN_MENU