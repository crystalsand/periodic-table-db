#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if there is no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  # if argument is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    # find element by name or symbol
    OUTPUT=$($PSQL "SELECT properties.atomic_number,symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name LIKE '$1%' LIMIT 1")

  else
    # find element by atomic number
    OUTPUT=$($PSQL "SELECT properties.atomic_number,symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE properties.atomic_number = $1")

  fi

  # if argument does not exist
  if [[ -z $OUTPUT ]]
  then
    echo "I could not find that element in the database."

  else
    # if element is found
    echo $OUTPUT | while IFS="|" read ID SYM NAM TYP MAS MLT BOI
    do
      echo "The element with atomic number $ID is $NAM ($SYM). It's a $TYP, with a mass of $MAS amu. $NAM has a melting point of $MLT celsius and a boiling point of $BOI celsius."

    done

  fi

fi
