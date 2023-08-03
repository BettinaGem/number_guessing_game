#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER

USERSQL=$($PSQL "SELECT user_id FROM users WHERE username='$USER'")

GUESS_MENU(){
echo "Guess the secret number between 1 and 1000:"
read GUESSEDNUMMER

if [[ ! $GUESSEDNUMMER =~ [0-9]+ ]]
then
 echo "That is not an integer, guess again:"
 read GUESSEDNUMMER
else
 if [[ -z $GAMESPLAYED ]]
 then
  NUMBER_OF_GAME=0
 else
  NUMBER_OF_GAME=$GAMESPLAYED
 fi
 SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $SECRET_NUMBER
NUMBER_OF_GUESSES=1;
 GUESS_GAME
fi

}

GUESS_GAME(){
while [[  $GUESSEDNUMMER != $SECRET_NUMBER ]]
do
if [[ $GUESSEDNUMMER > $SECRET_NUMBER ]]
then 
  echo "It's higher than that, guess again:"
  NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
  read GUESSEDNUMMER
fi
if [[ $GUESSEDNUMMER < $SECRET_NUMBER  ]]
then
  echo "It's lower than that, guess again:"
  NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
  read GUESSEDNUMMER
fi
done
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
 INSERT_NUMBER_OF_GUESS=$($PSQL "INSERT INTO games(guesses,user_id) VALUES($NUMBER_OF_GUESSES,$USER_ID)")
 NUMBER_OF_GAME=$(( $NUMBER_OF_GAME + 1 ))
 INSERT_NUMBER_OF_GAME=$($PSQL "UPDATE users SET games_played = '$NUMBER_OF_GAME' ")
}

if [[ -z $USERSQL ]]
then
 echo "Welcome, $USER! It looks like this is your first time here."
 INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USER')")
 USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER'")
 GUESS_MENU
else
 USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER'")
 GAMESPLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id='$USER_ID'")
 BESTPLAYED=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id='$USERSQL'")
 echo "Welcome back, $USER! You have played $GAMESPLAYED games, and your best game took $BESTPLAYED guesses."
 GUESS_MENU
fi






