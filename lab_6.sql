

/*1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з'єднання, застосовуючи where.*/
SELECT books.Name, books.Price, p.producer
FROM set_of_books AS books
INNER JOIN producers AS p ON books.producer_id = p.id
WHERE books.producer_id = p.id;

/*2. Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з'єднання, застосовуючи inner join.*/
SELECT books.Name, c.category
FROM set_of_books AS books
INNER JOIN categories AS c ON books.category_id = c.id;

/*3. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.*/
SELECT books.Name, books.Price, p.Producer, books.form_id
FROM set_of_books AS books
INNER JOIN producers AS p ON books.producer_id = p.id;

/*4. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.*/
SELECT t.topic, c.category, books.Name, p.Producer
FROM set_of_books AS books
INNER JOIN topics AS t ON books.topic_id = t.id
INNER JOIN categories AS c ON books.category_id = c.id
INNER JOIN producers AS p ON books.producer_id = p.id;

/*5. Вивести книги видавництва 'BHV', видані після 2000 р*/
SELECT books.Name
FROM set_of_books AS books
INNER JOIN producers AS p ON books.producer_id = p.id
WHERE p.producer = 'Видавнича група BHV' AND books.Date > '2000-01-01';

/*6. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій кількості сторінок.*/
SELECT c.category, SUM(books.Pages) AS TotalPages
FROM set_of_books AS books
INNER JOIN categories AS c ON books.category_id = c.id
GROUP BY c.category
ORDER BY TotalPages DESC;

/*7. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.*/
SELECT AVG(books.Price) AS AvgPrice
FROM set_of_books AS books
INNER JOIN topics AS t ON books.topic_id = t.id
INNER JOIN categories AS c ON books.category_id = c.id
WHERE t.topic = 'Використання ПК в цілому' AND c.category = 'Підручники'; /*Linux*/


/*8. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи where.*/
SELECT
    books.*,
    p.producer,
    t.topic,
    c.category
FROM
    set_of_books AS books,
    producers AS p,
    topics AS t,
    categories AS c
WHERE
    books.producer_id = p.id AND
    books.topic_id = t.id AND
    books.category_id = c.id;

/*9. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи inner join.*/
SELECT
    books.*,
    p.producer,
    t.topic,
    c.category
FROM
    set_of_books AS books
INNER JOIN producers AS p ON books.producer_id = p.id
INNER JOIN topics AS t ON books.topic_id = t.id
INNER JOIN categories AS c ON books.category_id = c.id;

/*10. Вивести всі дані універсального відношення. Використовувати зовнішнє з'єднання, застосовуючи left join / rigth join.*/
SELECT
    books.*,
    p.producer,
    t.topic,
    c.category
FROM
    set_of_books AS books
LEFT JOIN producers AS p ON books.producer_id = p.id
LEFT JOIN topics AS t ON books.topic_id = t.id
LEFT JOIN categories AS c ON books.category_id = c.id;

/*11. Вивести пари книг, що мають однакову кількість сторінок. Використовувати само об’єднання і аліаси (self join).*/
SELECT q.Name AS Book1, books.Name AS Book2
FROM set_of_books AS q
JOIN set_of_books AS books ON q.Pages = books.Pages AND q.Numer < books.Numer;

/*12. Вивести тріади книг, що мають однакову ціну. Використовувати самооб'єднання і аліаси (self join).*/
SELECT
    books1.Name,
    books1.Numer,
    books2.Name,
    books2.Numer,
    books3.Name,
    books3.Numer,
    books1.Price
FROM
    set_of_books AS books1
INNER JOIN set_of_books AS books2 ON books1.Price = books2.Price AND books1.Numer < books2.Numer
INNER JOIN set_of_books AS books3 ON books1.Price = books3.Price AND books2.Numer < books3.Numer
ORDER BY
    books1.Price, books1.Name;

/*13. Вивести всі книги категорії 'C ++'. Використовувати підзапити (subquery).*/
SELECT Name FROM set_of_books AS books
WHERE category_id IN (SELECT id FROM categories WHERE category = 'C&C++');

/*14. Вивести книги видавництва 'BHV', видані після 2000 р Використовувати підзапити (subquery).*/
SELECT books.Name
FROM set_of_books AS books
WHERE books.producer_id IN (
    SELECT p.id FROM producers AS p WHERE p.producer = 'Видавнича група BHV'
) AND books.Date > '2000-01-01';

/*15. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов'язані підзапити (correlated subquery).*/
SELECT DISTINCT p.producer
FROM producers AS p
WHERE EXISTS (
    SELECT 1 FROM set_of_books AS books WHERE books.producer_id = p.id AND books.Pages > 400
);

/*16. Вивести список категорій в яких більше 3-х книг. Використовувати пов'язані підзапити (correlated subquery).*/
SELECT c.category
FROM categories AS c
WHERE (
    SELECT COUNT(*) FROM set_of_books AS books WHERE books.category_id = c.id
) > 3;

/*17. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.*/
SELECT books.Name
FROM set_of_books AS books
WHERE EXISTS (
    SELECT 1
    FROM producers AS p
    WHERE p.id = books.producer_id AND p.producer = 'Видавнича група nBHV'
);

/*18. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. Використовувати not exists.*/
SELECT books.Name
FROM set_of_books AS books
WHERE NOT EXISTS (
    SELECT 1
    FROM producers AS p
    WHERE p.id = books.producer_id AND p.producer = 'Видавнича група BHV'
);


/*19. Вивести відсортований загальний список назв тем і категорій. Використовувати union.*/
SELECT topic AS Description
FROM topics AS t
UNION
SELECT category
FROM categories
ORDER BY Description;

/*20. Вивести відсортований в зворотному порядку загальний список перших слів, назв книг і категорій що не повторюються. Використовувати union.*/
SELECT DISTINCT SUBSTRING_INDEX(Name, ' ', 1) AS FirstWord
FROM set_of_books AS books
UNION
SELECT SUBSTRING_INDEX(category, ' ', 1)
FROM categories
ORDER BY FirstWord DESC;


