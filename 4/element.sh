#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
elif [ $# -gt 1 ]; then
    echo "Please provide only one element as an argument."
else
    PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c "

    # check if the given argument is a number, symbol, or name
    if [[ $1 =~ ^[0-9]+$ ]]; then
        ATOMIC_NUMBER=$($PSQL "SELECT BTRIM(CAST(atomic_number AS VARCHAR)) FROM elements WHERE atomic_number=$1")
    else
        ATOMIC_NUMBER=$($PSQL "SELECT BTRIM(CAST(atomic_number AS VARCHAR)) FROM elements WHERE symbol='$1' OR name='$1'")
    fi
    
    
    # check if the element is valid
    if [[ -z $ATOMIC_NUMBER ]]; then
        echo "I could not find that element in the database."
        exit
    fi

    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    MELTING_POINT=$($PSQL "SELECT LTRIM(CAST(melting_point_celsius AS VARCHAR)) FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    BOILING_POINT=$($PSQL "SELECT LTRIM(CAST(boiling_point_celsius AS VARCHAR)) FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")

    echo "The element with atomic number$ATOMIC_NUMBER is$NAME ($(echo "$SYMBOL" | tr -d '[:space:]')). It's a$TYPE, with a mass of$ATOMIC_MASS amu.$NAME has a melting point of$MELTING_POINT celsius and a boiling point of$BOILING_POINT celsius."
fi
