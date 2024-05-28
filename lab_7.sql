# 1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.

DROP PROCEDURE IF EXISTS get_short_books_info;

DELIMITER //

CREATE PROCEDURE get_short_books_info()
BEGIN
    SELECT price, name, categories.category, producers.producer, forms.form
    FROM set_of_books
             LEFT JOIN categories ON category_id = categories.id
             LEFT JOIN producers ON producer_id = producers.id
             LEFT JOIN forms ON form_id = forms.id;
END//

DELIMITER ;

CALL get_short_books_info();

# 2. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
DROP PROCEDURE IF EXISTS get_sorted_books_info;

DELIMITER //

CREATE PROCEDURE get_sorted_books_info(topic VARCHAR(255), category VARCHAR(255))
BEGIN
    SELECT name, categories.category, topics.topic, producers.producer
    FROM set_of_books
             LEFT JOIN categories ON category_id = categories.id
             LEFT JOIN topics ON topic_id = topics.id
             LEFT JOIN producers ON producer_id = producers.id
    WHERE topics.topic = topic
      AND categories.category = category;
END//

DELIMITER ;

CALL get_sorted_books_info('Використання ПК в цілому', 'Підручники');

# 3. Вивести книги видавництва 'BHV', видані після 2000 р
DROP PROCEDURE IF EXISTS get_books_by_producer_and_year;

DELIMITER //

CREATE PROCEDURE get_books_by_producer_and_year(producer VARCHAR(255))
BEGIN
    SELECT producers.producer, name
    FROM set_of_books
             LEFT JOIN producers ON producer_id = producers.id
    WHERE producers.producer = producer
      AND YEAR(date) > 2000;
END//

DELIMITER ;

CALL get_books_by_producer_and_year('Видавнича група BHV');

# 4. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій / зростанню кількості сторінок.

DROP PROCEDURE IF EXISTS get_total_pages_per_category;

DELIMITER //

CREATE PROCEDURE get_total_pages_per_category()
BEGIN
    SELECT SUM(pages) AS 'total pages', categories.category
    FROM set_of_books
             LEFT JOIN categories ON category_id = categories.id
    GROUP BY categories.category
    ORDER BY SUM(pages) DESC;
END//

DELIMITER ;

CALL get_total_pages_per_category();

# 5. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.

DROP PROCEDURE IF EXISTS get_avg_for_pc;

DELIMITER //

CREATE PROCEDURE get_avg_for_pc()
BEGIN
    SELECT categories.category, AVG(price) AS 'AVG price'
    FROM set_of_books
             LEFT JOIN topics ON topic_id = topics.id
             LEFT JOIN categories ON category_id = categories.id
    WHERE categories.category = 'Linux'
      AND topics.topic = 'Використання ПК в цілому'
    GROUP BY categories.category;
END//

DELIMITER ;

CALL get_avg_for_pc();

# 6.Вивести всі дані універсального відношення.
DROP PROCEDURE IF EXISTS get_universe_books_info;

DELIMITER //

CREATE PROCEDURE get_universe_books_info(topic VARCHAR(255), category VARCHAR(255))
BEGIN
    SELECT name, categories.category, topics.topic, producers.producer
    FROM set_of_books
             LEFT JOIN categories ON category_id = categories.id
             LEFT JOIN topics ON topic_id = topics.id
             LEFT JOIN producers ON producer_id = producers.id
    WHERE topics.topic = topic
      AND categories.category = category;
END//

DELIMITER ;

CALL get_universe_books_info('Використання ПК в цілому', 'Підручники');

/*--7. Вивести пари книг, що мають однакову кількість сторінок.*/

DROP PROCEDURE IF EXISTS get_books_with_same_pages;

DELIMITER //
CREATE PROCEDURE get_books_with_same_pages()
BEGIN
    SELECT books_a.Name AS FirstBookName,
           books_b.Name AS SecondBookName,
           books_a.Pages
    FROM set_of_books AS books_a,
         set_of_books AS books_b
    WHERE books_a.id <> books_b.id
      AND books_a.pages = books_b.pages;
END //
DELIMITER ;

CALL get_books_with_same_pages();

/*--8. Вивести тріади книг, що мають однакову ціну.*/

DROP PROCEDURE IF EXISTS get_books_with_same_price;

DELIMITER //
CREATE PROCEDURE get_books_with_same_price()
BEGIN
    SELECT Books_a.numer AS first_number,
           Books_b.numer AS second_number,
           Books_c.numer AS third_number,
           Books_a.Name  AS FirstBookName,
           Books_b.Name  AS SecondBookName,
           Books_c.Name  AS ThirdBookName,
           Books_a.Price AS Price
    FROM set_of_books AS Books_a,
         set_of_books AS Books_b,
         set_of_books AS Books_c
    WHERE Books_a.id <> Books_b.id
      AND Books_b.id <> Books_c.id
      AND Books_c.id <> Books_a.id
      AND Books_a.Price = Books_b.Price
      AND Books_b.Price = Books_c.Price;
END //
DELIMITER ;

CALL get_books_with_same_price();
/*--9. Вивести всі книги категорії 'C++'.*/
DROP PROCEDURE IF EXISTS get_books_by_category_cpp;

DELIMITER //
CREATE PROCEDURE get_books_by_category_cpp()
BEGIN
    SELECT books.Name,
           c.category
    FROM set_of_books AS books
             JOIN
         categories AS c ON books.category_id = c.id
    WHERE c.category = 'C&C++';
END //
DELIMITER ;

CALL get_books_by_category_cpp();

/*--10. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.*/
DROP PROCEDURE IF EXISTS get_publishers_with_large_books;

DELIMITER //
CREATE PROCEDURE get_publishers_with_large_books()
BEGIN
    SELECT DISTINCT p.producer
    FROM producers AS p
             JOIN set_of_books AS books ON p.id = books.producer_id
    WHERE books.Pages > 400;
END //
DELIMITER ;

CALL get_publishers_with_large_books();
/*--11. Вивести список категорій, за якими більше 3-х книг.*/
DROP PROCEDURE IF EXISTS get_categories_with_multiple_books;

DELIMITER //
CREATE PROCEDURE get_categories_with_multiple_books()
BEGIN
    SELECT c.category, COUNT(books.Numer) AS BookCount
    FROM categories AS c
             JOIN set_of_books AS books ON c.id = books.category_id
    GROUP BY c.category
    HAVING COUNT(books.Numer) > 3;
END //
DELIMITER ;

CALL get_categories_with_multiple_books();
/*--12 Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.*/
DROP PROCEDURE IF EXISTS get_books_if_bhv_exists;

DELIMITER //
CREATE PROCEDURE get_books_if_bhv_exists()
BEGIN
    DECLARE bhv_exists INT;

    SELECT COUNT(*)
    INTO bhv_exists
    FROM set_of_books AS books
             JOIN producers AS p ON books.producer_id = p.id
    WHERE p.producer = 'Видавича група nBHV';

    IF bhv_exists > 0 THEN
        SELECT books.Name
        FROM set_of_books AS books
                 JOIN producers AS p ON books.producer_id = p.id
        WHERE p.producer = 'Видавича група nBHV';
    END IF;
END //
DELIMITER ;

CALL get_books_if_bhv_exists();

/*--13. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.*/
DROP PROCEDURE IF EXISTS check_bhv_books;

DELIMITER //

CREATE PROCEDURE check_bhv_books()
BEGIN
    DECLARE bhv_exists INT;

    SELECT COUNT(*)
    INTO bhv_exists
    FROM set_of_books AS books
             JOIN producers AS p ON books.producer_id = p.id
    WHERE p.producer = 'BHV';

    IF bhv_exists = 0 THEN
        SELECT 'Жодної книги видавництва BHV не знайдено';
    ELSE
        SELECT 'У видавництві BHV є книги';
    END IF;
END //

DELIMITER ;

CALL check_bhv_books();
/*--14. Вивести відсортований загальний список назв тем і категорій.*/
DROP PROCEDURE IF EXISTS get_sorted_themes_and_categories;

DELIMITER //

CREATE PROCEDURE get_sorted_themes_and_categories()
BEGIN
    SELECT Description
    FROM (SELECT topic AS Description
          FROM topics
          UNION
          SELECT category
          FROM categories) AS combined
    ORDER BY Description;
END //

DELIMITER ;

CALL get_sorted_themes_and_categories();

/*--15. Вивести відсортований в зворотному порядку загальний список перших слів назв книг і категорій, що не повторюються.*/

DROP PROCEDURE IF EXISTS get_sorted_first_words;

DELIMITER //
CREATE PROCEDURE get_sorted_first_words()
BEGIN
    SELECT FirstWord
    FROM (SELECT DISTINCT SUBSTRING_INDEX(books.Name, ' ', 1) AS FirstWord
          FROM set_of_books AS books
          UNION
          SELECT DISTINCT SUBSTRING_INDEX(c.category, ' ', 1)
          FROM categories AS c) AS combined
    ORDER BY FirstWord DESC;
END //
DELIMITER ;

CALL get_sorted_first_words()