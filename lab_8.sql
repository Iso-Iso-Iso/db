# Кількість тем може бути в діапазоні від 5 до 10.
DROP TRIGGER IF EXISTS topics_validator;


DELIMITER //
CREATE TRIGGER topics_validator
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
    IF NEW.topic_id > 10 OR NEW.topic_id < 5
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Invalid value was provided for topic_id";
    END IF;
//
DELIMITER ;

# INSERT INTO set_of_books (price, topic_id)
# VALUES (2, 4);

# 2. Новинкою може бути тільки книга видана в поточному році.
DROP TRIGGER IF EXISTS book_year_validator;

DELIMITER //
CREATE TRIGGER book_year_validator
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
    IF YEAR(NOW()) != YEAR(NEW.date) AND New.new = '1'
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "You can mark book as new only if it realesed in current year!";
    END IF;
//
DELIMITER ;

# INSERT INTO set_of_books (price, numer, code, new, date)
# VALUES (2, 2, 2, '1', '2022-3-22');

# 3. Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
DROP TRIGGER IF EXISTS book_price_validator;

DELIMITER //
CREATE TRIGGER book_price_validator
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
    IF NEW.price > 10 AND NEW.pages < 100 OR NEW.price > 20 AND NEW.pages < 200 OR NEW.price > 30 AND NEW.pages < 300
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect price for current page amount!';
    END IF;
//
DELIMITER ;

# INSERT INTO set_of_books (price, numer, code, new, date, pages, name, circulation, topic_id, category_id, producer_id)
# VALUES (31, 2, 2, '0', '2022-3-22', 299, 'name - 1', 22, 5, 1, 1);

# 4. Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.

DROP TRIGGER IF EXISTS book_price_validator;

DELIMITER //
CREATE TRIGGER book_price_validator
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
    IF NEW.producer_id = 1 AND NEW.circulation < 5000 OR NEW.producer_id = 5 AND NEW.circulation < 10000
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect circulation for current producer!';
    END IF;
//
DELIMITER ;
#
# INSERT INTO set_of_books (price, numer, code, new, date, pages, name, circulation, topic_id, category_id, producer_id)
# VALUES (31, 2, 2, '0', '2022-3-22', 299, 'name - 1', 22, 5, 1, 1);

# 5. Книги з однаковим кодом повинні мати однакові дані.

DROP TRIGGER IF EXISTS book_name_validator;

DELIMITER //
CREATE TRIGGER book_name_validator
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
BEGIN
    SET @records_count = 0;

    SELECT COUNT(*)
    INTO @records_count
    FROM set_of_books
    WHERE code = NEW.code
      AND (
        NEW.new != set_of_books.new OR
        NEW.name != set_of_books.name OR
        NEW.price != set_of_books.price OR
        NEW.producer_id != set_of_books.producer_id OR
        NEW.pages != set_of_books.pages OR
        NEW.form_id != set_of_books.form_id OR
        NEW.date != set_of_books.date OR
        NEW.circulation != set_of_books.circulation OR
        NEW.topic_id != set_of_books.topic_id OR
        NEW.category_id != set_of_books.category_id);


    IF (@records_count != 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Books with the same names must had similar data!';
    END IF;

END //
DELIMITER ;

# INSERT INTO set_of_books (price, numer, code, new, date, pages, name, circulation, topic_id, category_id, producer_id)
# VALUES (31, 2, 2, '0', '2022-3-22', 299, 'name - 1', 22, 5, 1, 2);


# 6. При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.

DROP TRIGGER IF EXISTS user_access_validator;

DELIMITER //
CREATE TRIGGER user_access_validator
    BEFORE DELETE
    ON set_of_books
    FOR EACH ROW
BEGIN
    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^\@]+') != 'root') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You don\'t have access to proceed this action';
    ELSE
        SET @columns_count = 0;
        SELECT count(*)
        INTO @columns_count
        FROM information_schema.`COLUMNS`
        WHERE table_name = 'set_of_books'
          AND TABLE_SCHEMA = 'lab_1';
    END IF;
END
//
DELIMITER ;


# DELETE
# FROM set_of_books
# WHERE name = 'name - 1';
#
# SELECT @columns_count;

# 7. Користувач "dbo" не має права змінювати ціну книги.
DROP TRIGGER IF EXISTS user_price_access_validator;

DELIMITER //
CREATE TRIGGER user_price_access_validator
    BEFORE UPDATE
    ON set_of_books
    FOR EACH ROW
BEGIN
    SET @prev_price = 0;
    SELECT price INTO @prev_price FROM set_of_books WHERE id = NEW.id;

    IF (REGEXP_SUBSTR(TRIM(CURRENT_USER()), '^[^\@]+') = 'root') AND @prev_price <> NEW.price THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You don\'t have access to change price!';

    END IF;
END
//
DELIMITER ;

# UPDATE set_of_books
# SET price=2
# WHERE name = 'name - 1';

# 8. Видавництва ДМК і Еком підручники не видають.

DROP TRIGGER IF EXISTS producers_validation;

DELIMITER //
CREATE TRIGGER producers_validation
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
BEGIN
    IF ((NEW.producer_id IN (5, 7)) AND NEW.category_id = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current producers cannot publish textbooks!';
    END IF;
END //
DELIMITER ;

# INSERT INTO set_of_books (price, numer, code, new, date, pages, name, circulation, topic_id, category_id, producer_id)
# VALUES (31, 2, 2, '0', '2022-3-22', 299, 'name - 1', 10001, 5, 1, 5);

# 9. Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.

DROP TRIGGER IF EXISTS per_year_validation;

DELIMITER //
CREATE TRIGGER per_year_validation
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
BEGIN
    SET @publisher_novelties_count = 0;

    SELECT COUNT(*)
    INTO @publisher_novelties_count
    FROM set_of_books
    WHERE producer_id = NEW.producer_id
      AND YEAR(NOW()) = YEAR(NEW.date)
      AND MONTH(NOW()) = MONTH(NEW.date);

    IF (NEW.new AND @publisher_novelties_count IS NOT NULL AND @publisher_novelties_count > 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'You cannot publish more then 10 times per month for current producer!';
    END IF;
END //
DELIMITER ;

# 10. Видавництво BHV не випускає книги формату 60х88 / 16.

DROP TRIGGER IF EXISTS format_validation;

DELIMITER //
CREATE TRIGGER format_validation
    BEFORE INSERT
    ON set_of_books
    FOR EACH ROW
BEGIN
IF (NEW.producer_id = 1 AND NEW.form_id = 3) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current producer cannot use current format';
    END IF;
END //
DELIMITER ;

# INSERT INTO set_of_books (price, numer, code, new, date, pages, name, circulation, topic_id, category_id, producer_id, form_id)
# VALUES (31, 2, 2, '0', '2022-3-22', 299, 'name - 1', 10001, 5, 1, 1, 3);