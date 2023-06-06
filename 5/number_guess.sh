#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

GUESSES=0
USERNAME=""

MAIN() {
    echo "Enter your username:"
    read USERNAME

    CHECK_USERNAME=$($PSQL "SELECT id FROM users WHERE username='$USERNAME'")
    if [[ -z $CHECK_USERNAME ]]
    then
        # not existed
        # insert to database
        INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
        echo "Welcome, $USERNAME! It looks like this is your first time here."
    else
        # existed
        GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id='$CHECK_USERNAME'")
        BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id='$CHECK_USERNAME'")
        echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    fi

    RANDOM_NUMBER=$((1 + RANDOM % 1000))
    echo "Guess the secret number between 1 and 1000:"
    READ_GUESS $RANDOM_NUMBER
}

READ_GUESS()  {
    read GUESS
    GUESSES=$((GUESSES + 1))

    # check if not a number
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
        echo "That is not an integer, guess again:"
        READ_GUESS $RANDOM_NUMBER
    elif [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
        echo "It's lower than that, guess again:"
        READ_GUESS $RANDOM_NUMBER
    elif [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
        echo "It's higher than that, guess again:"
        READ_GUESS $RANDOM_NUMBER
    else
        echo "You guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
        USER_ID=$($PSQL "SELECT id FROM users WHERE username='$USERNAME'")
        INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES('$USER_ID', $GUESSES)")
        exit
    fi
}

MAIN