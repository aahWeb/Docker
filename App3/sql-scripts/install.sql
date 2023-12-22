CREATE DATABASE IF NOT EXISTS yams;

use yams;

DROP TABLE IF EXISTS`pastries` ;

CREATE TABLE `pastries` (
    `id` INT,
    `name` VARCHAR(20),
    `price` DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_id PRIMARY KEY (`id`)
    ) ENGINE=InnoDB ;

DELETE FROM pastries;

INSERT INTO pastries (id, name, price) VALUES
    (1, 'Croissant', 2.50),
    (2, 'Eclair', 3.0),
    (3, 'Chocolate Croissant', 2.75),
    (4, 'Fruit Tart', 5.50),
    (5, 'Donut', 1.75);