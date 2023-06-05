-- You should rename the weight column to atomic_mass
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

-- You should rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

-- Your melting_point_celsius and boiling_point_celsius columns should not accept null values
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

-- You should add the UNIQUE constraint to the symbol and name columns from the elements table
ALTER TABLE elements ADD CONSTRAINT symbol_unique UNIQUE (symbol);
ALTER TABLE elements ADD CONSTRAINT name_unique UNIQUE (name);

-- Your symbol and name columns should have the NOT NULL constraint
ALTER TABLE elements 
ALTER COLUMN symbol SET NOT NULL,
ALTER COLUMN name SET NOT NULL;

-- You should set the atomic_number column from the properties table as a 
-- foreign key that references the column of the same name in the elements table
ALTER TABLE properties ADD CONSTRAINT atomic_number_fk FOREIGN KEY (atomic_number) REFERENCES elements (atomic_number);

-- You should create a types table that will store the three types of elements
-- Your types table should have a type_id column that is an integer and the primary key
-- Your types table should have a type column that's a VARCHAR and cannot be null. 
-- It will store the different types from the type column in the properties table
CREATE TABLE types (
    type_id INTEGER PRIMARY KEY,
    type VARCHAR NOT NULL
);


-- You should add three rows to your types table whose values are the three different types from the properties table
INSERT INTO types (type_id, type)
VALUES (1, 'nonmetal'),
       (2, 'metal'),
       (3, 'metalloid');


-- Your properties table should have a type_id foreign key column that references the type_id column from the types table. It should be an INT with the NOT NULL constraint
ALTER TABLE properties ADD COLUMN type_id INTEGER NOT NULL REFERENCES types (type_id) DEFAULT 1;

-- Each row in your properties table should have a type_id value that links to the correct type from the types table
UPDATE properties
SET type_id = (SELECT type_id FROM types WHERE type = properties.type);

-- You should capitalize the first letter of all the symbol values in the elements table. Be careful to only capitalize the letter and not change any others
UPDATE elements
SET symbol = CONCAT(UPPER(LEFT(symbol, 1)), SUBSTRING(symbol, 2));


-- You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this.
ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR;
-- remove the trailing zeros
UPDATE properties 
SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass);
UPDATE properties
SET atomic_mass = TRIM(TRAILING '.' FROM atomic_mass);

-- You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal
INSERT INTO elements (atomic_number, name, symbol)
VALUES (9, 'Fluorine', 'F');

INSERT INTO properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (9, 18.998, -220, -188.1, 1);

-- You should add the element with atomic number 10 to your database. Its name is Neon, symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1, and it's a nonmetal
INSERT INTO elements (atomic_number, name, symbol)
VALUES (10, 'Neon', 'Ne');

INSERT INTO properties (atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (10, 20.18, -248.6, -246.1, 1);

-- Your properties table should not have a type column
ALTER TABLE properties DROP COLUMN type;

-- You should delete the non existent element, whose atomic_number is 1000, from the two tables
DELETE FROM elements
WHERE atomic_number = 1000;
DELETE FROM properties
WHERE atomic_number = 1000;