#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#run the script without argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #if argument input 
  #check if argument is number or not
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SELECTED_ELEMENTS=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    SELECTED_ELEMENTS=$($PSQL "SELECT * FROM elements WHERE name='$1' OR symbol='$1'")
  fi
  
  #check if argument input exist
  if [[ -z $SELECTED_ELEMENTS ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$SELECTED_ELEMENTS" | while read ATOMIC_ID BAR SYMBOL BAR NAME
    do      
      #get variables from proprieties table 
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_ID")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_ID")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_ID")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_ID")")
      #echo "$ATOMIC_ID $SYMBOL $NAME $MASS $MELTING_POINT $BOILING_POINT $TYPE"
      echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $(echo $TYPE | sed -r 's/^ *//g'), with a mass of $(echo $MASS | sed -r 's/^ *//g') amu. $NAME has a melting point of $(echo $MELTING_POINT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -r 's/^ *//g') celsius."
    done
  fi
fi