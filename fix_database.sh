#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# You should rename the weight column to atomic_mass
RENAME_THE_WEIGHT_COLUMN=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
echo "RENAME_THE_WEIGHT_COLUMN                    : $RENAME_THE_WEIGHT_COLUMN"

# You should rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
RENAME_THE_MELTING_COLUMN=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
RENAME_THE_BOILING_COLUMN=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
echo "RENAME_THE_MELTING_COLUMN                   : $RENAME_THE_MELTING_COLUMN"
echo "RENAME_THE_BOILING_COLUMN                   : $RENAME_THE_BOILING_COLUMN"

# Your melting_point_celsius and boiling_point_celsius columns should not accept null values
MELTING_NOT_ACCEPT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
BOILING_NOT_ACCEPT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
echo "MELTING_NOT_ACCEPT_NULL                     : $MELTING_NOT_ACCEPT_NULL"
echo "BOILING_NOT_ACCEPT_NULL                     : $BOILING_NOT_ACCEPT_NULL"

# You should add the UNIQUE constraint to the symbol and name columns from the elements table
ADD_UNIQUE_TO_SYMBOL_COLUMN=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
ADD_UNIQUE_TO_NAME_COLUMN=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
echo "ADD_UNIQUE_TO_SYMBOL_COLUMN                 : $ADD_UNIQUE_TO_SYMBOL_COLUMN"
echo "ADD_UNIQUE_TO_NAME_COLUMN                   : $ADD_UNIQUE_TO_NAME_COLUMN"

# Your symbol and name columns should have the NOT NULL constraint
SYMBOL_COLUMN_HAVE_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
NAME_COLUMN_HAVE_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
echo "SYMBOL_COLUMN_HAVE_NOT_NULL                 : $SYMBOL_COLUMN_HAVE_NOT_NULL"
echo "NAME_COLUMN_HAVE_NOT_NULL                   : $NAME_COLUMN_HAVE_NOT_NULL"
 
# You should set the atomic_number column from the properties table as a foreign key that references the column of the same name in the elements table
SET_ATOMIC_NUMBER_AS_FOREIGN=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);")
echo "SET_ATOMIC_NUMBER_AS_FOREIGN                : $SET_ATOMIC_NUMBER_AS_FOREIGN"
 
# You should create a types table that will store the three types of elements
CREATE_TYPES_TABLE=$($PSQL "CREATE TABLE types();")
echo "CREATE_TYPES_TABLE                          : $CREATE_TYPES_TABLE"

# //Your types table should have a type_id column that is an integer and the primary key 
TYPES_TABLE_HAVE_TYPE_ID_COLUMN=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;")
echo "TYPES_TABLE_HAVE_TYPE_ID_COLUMN             : $TYPES_TABLE_HAVE_TYPE_ID_COLUMN"

# Your types table should have a type column that's a VARCHAR and cannot be null. It will store the different types from the type column in the properties table
ADD_TYPE_COLUMN_IN_TYPE=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;")
echo "ADD_TYPE_COLUMN_IN_TYPE                     : $ADD_TYPE_COLUMN_IN_TYPE"

# You should add three rows to your types table whose values are the three different types from the properties table
ADD_THREE_PROPERTIES_DATA=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;")
echo "ADD_THREE_PROPERTIES_DATA                   : $ADD_THREE_PROPERTIES_DATA"

# //Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
ADD_TYPE_ID_COLUMN_IN_PROPERTIES=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
PROPERTIES_TYPE_ID_REFERENCES_TYPES=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);")
echo "ADD_TYPE_ID_COLUMN_IN_PROPERTIES            : $ADD_TYPE_ID_COLUMN_IN_PROPERTIES"
echo "PROPERTIES_TYPE_ID_REFERENCES_TYPES         : $PROPERTIES_TYPE_ID_REFERENCES_TYPES"

# Each row in your properties table should have a type_id value that links to the correct type from the types table
TYPE_ID_VALUE_LINKS_TYPES_TABLE=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);")
ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
echo "TYPE_ID_VALUE_LINKS_TYPES_TABLE             : $TYPE_ID_VALUE_LINKS_TYPES_TABLE"
echo "ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL    : $ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL"

# You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
CAPITALIZE_ELEMENTS_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol);")
echo "CAPITALIZE_ELEMENTS_SYMBOL                  : $CAPITALIZE_ELEMENTS_SYMBOL"

# You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. 
# The final values they should be are in the atomic_mass.txt file
ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(9);")
TRAILING_ZEROS_OF_ATOMIC_MASS=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT);")
echo "ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS        : $ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS"
echo "TRAILING_ZEROS_OF_ATOMIC_MASS               : $TRAILING_ZEROS_OF_ATOMIC_MASS"

# You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, 
# boiling point is -188.1, and it's a nonmetal
ADD_F_ELEMENT_TO_ELEMENTS=$($PSQL "INSERT INTO elements(atomic_number,name,symbol) VALUES(9,'Fluorine','F');")
TYPE_ID=$($PSQL "SELECT type_id FROM types WHERE type='nonmetal';")
ADD_F_ELEMENT_TO_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type_id,atomic_mass,melting_point_celsius,boiling_point_celsius,type) VALUES(9,$TYPE_ID,18.998,-220,-188.1,'nonmetal');")
echo "ADD_F_ELEMENT_TO_ELEMENTS                   : $ADD_F_ELEMENT_TO_ELEMENTS"
echo "ADD_F_ELEMENT_TO_PROPERTIES                 : $ADD_F_ELEMENT_TO_PROPERTIES"


# You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, 
# boiling point is -246.1, and it's a nonmetal
ADD_N_ELEMENT_TO_ELEMENTS=$($PSQL "INSERT INTO elements(atomic_number,name,symbol) VALUES(10,'Neon','Ne');")
ADD_N_ELEMENT_TO_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type_id,atomic_mass,melting_point_celsius,boiling_point_celsius,type) VALUES(10,$TYPE_ID,20.18,-248.6,-246.1,'nonmetal');")
echo "ADD_N_ELEMENT_TO_ELEMENTS                   : $ADD_N_ELEMENT_TO_ELEMENTS"
echo "ADD_N_ELEMENT_TO_PROPERTIES                 : $ADD_N_ELEMENT_TO_PROPERTIES"

# You should delete the non existent element, whose atomic_number is 1000, from the two tables
DELETE_ATOMIC_FROM_PROPERTIES=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
DELETE_ATOMIC_FROM_ELEMENTS=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
echo "DELETE_ATOMIC_FROM_PROPERTIES                 : $DELETE_ATOMIC_FROM_PROPERTIES"
echo "DELETE_ATOMIC_FROM_ELEMENTS                 : $DELETE_ATOMIC_FROM_ELEMENTS"

# Your properties table should not have a type colum
DROP_TYPE_COLUMN_IN_PROPERTIES=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
echo "DROP_TYPE_COLUMN_IN_PROPERTIES              : $DROP_TYPE_COLUMN_IN_PROPERTIES"
