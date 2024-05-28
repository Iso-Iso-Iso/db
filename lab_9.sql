# 1. Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.
DROP FUNCTION IF EXISTS get_total_price_of_books;

DELIMITER //

CREATE FUNCTION IF NOT EXISTS get_total_price_of_books(year INT)
    RETURNS DECIMAL(10, 2)
    READS SQL DATA
BEGIN
    RETURN (SELECT SUM(set_of_books.price) FROM set_of_books WHERE YEAR(date) = year);
END //

DELIMITER ;

SELECT get_total_price_of_books(1970);

# 2. Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році.
# Нема підтримки в SQL - використав процедуру
DROP PROCEDURE IF EXISTS get_books_per_year;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS get_books_per_year(year INT)
BEGIN
    SELECT id, name, date
    FROM set_of_books
    WHERE YEAR(date) = year;
END //

CALL get_books_per_year(1970);

# 3. Розробити і перевірити функцію типу multi-statement, яка буде:
# a. приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ‘;’;
# b. виділяти з цього рядка назву видавництва;
# c. формувати нумерований список назв видавництв.


DROP FUNCTION IF EXISTS format_row;

DELIMITER //

CREATE FUNCTION IF NOT EXISTS format_row(raw_rows VARCHAR(255))
    RETURNS VARCHAR(255)
    NO SQL DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE list VARCHAR(255) DEFAULT '';

    WHILE raw_rows <> ''
        DO
            SET i = i + 1;
            SET @publisher_slice = SUBSTRING_INDEX(raw_rows, ';', 1);
            SET list = CONCAT(list, i, '. ', @publisher_slice, ' \n');
            SET raw_rows = SUBSTRING(raw_rows, LENGTH(@publisher_slice) + 2);
        END WHILE;

    RETURN list;
END //

DELIMITER ;

SELECT format_row('producer-1;producer-2;producer-3');

#4. Виконати набір операцій по роботі з SQL курсором: оголосити курсор;
# a. використовувати змінну для оголошення курсору;
# b. відкрити курсор;
# c. переприсвоїти курсор іншої змінної;
# d. виконати вибірку даних з курсору;
# e. закрити курсор;

DROP PROCEDURE IF EXISTS use_cursor;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS use_cursor()
BEGIN

    DECLARE done INT DEFAULT FALSE;

    DECLARE name VARCHAR(255);
    DECLARE price DECIMAL(8, 2);

    DECLARE pipe CURSOR FOR SELECT set_of_books.name, set_of_books.price FROM set_of_books LIMIT 3;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;


    OPEN pipe;

    read_loop:
    LOOP
        IF done THEN LEAVE read_loop; END IF;

        FETCH pipe INTO name, price;

        SELECT name;
    END LOOP;

    CLOSE pipe;
END//

DELIMITER ;

CALL use_cursor();

# 5. звільнити курсор. Розробити курсор для виводу списка книг виданих у визначеному році.


DROP PROCEDURE IF EXISTS get_list_with_cursor;

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS get_list_with_cursor(filter_year INT)
BEGIN

    DECLARE done INT DEFAULT FALSE;

    DECLARE name VARCHAR(255);
    DECLARE year_val INT;

    DECLARE pipe CURSOR FOR SELECT set_of_books.name, YEAR(set_of_books.date)
                            FROM set_of_books
                            WHERE YEAR(set_of_books.date) = filter_year LIMIT 3;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;


    OPEN pipe;

    read_loop:
    LOOP
        IF done THEN LEAVE read_loop; END IF;

        FETCH pipe INTO name, year_val;

        SELECT name, year_val;
    END LOOP;

    CLOSE pipe;

END//

DELIMITER ;

CALL get_list_with_cursor(1970);
