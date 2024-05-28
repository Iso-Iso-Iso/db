SELECT * FROM lab_1.library;

/*1. Вивести книги у яких не введена ціна або ціна дорівнює 0*/
SELECT * FROM lab_1.library WHERE Price IS NULL OR Price = 0;

/*2. Вивести книги у яких введена ціна, але не введений тираж*/
SELECT * FROM lab_1.library WHERE Price IS NOT NULL AND Circulation IS NULL;

/*3. Вивести книги, про дату видання яких нічого не відомо.*/
SELECT * FROM lab_1.library WHERE Date IS NULL;

/*4. Вивести книги, з дня видання яких пройшло не більше року.----------*/ 
SELECT * FROM lab_1.library WHERE Date >= DATE_SUB(NOW(), INTERVAL 1 YEAR);

/*5. Вивести список книг-новинок, відсортованих за зростанням ціни*/
SELECT * FROM lab_1.library WHERE New = "1" ORDER BY Price ASC;

/*6. Вивести список книг з числом сторінок від 300 до 400, відсортованих в зворотному алфавітному порядку назв*/
SELECT * FROM lab_1.library WHERE Pages BETWEEN 300 AND 400 ORDER BY Name DESC;

/*7. Вивести список книг з ціною від 20 до 40, відсортованих за спаданням дати*/
SELECT * FROM lab_1.library WHERE Price BETWEEN 20 AND 40 ORDER BY Date DESC;

/*8. Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій*/
SELECT * FROM lab_1.library ORDER BY Name ASC, Price DESC;

/*9. Вивести книги, у яких ціна однієї сторінки < 10 копійок.*/
SELECT * FROM lab_1.library WHERE Price / Pages < 0.1 AND Price / Pages != 0;

/*10. Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами*/
SELECT LENGTH(Name), UPPER(LEFT(Name, 20)) FROM lab_1.library;

/*11. Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...'*/
SELECT CONCAT(LEFT(LOWER(Name), 10), '...', RIGHT(LOWER(Name), 10)) FROM lab_1.library;

/*12. Вивести значення наступних колонок: назва, дата, день, місяць, рік*/
SELECT Name, Date, DAY(Date), MONTH(Date), YEAR(Date) FROM lab_1.library;

/*13. Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'------------*/
SELECT Name, Date, DATE_FORMAT(Date, '%d / %M / %Y') as "Requested data format" FROM lab_1.library;

/*14. Вивести значення наступних колонок: код, ціна, ціна в грн., ціна в євро.*/
SELECT Code, Price, 
	Price AS price_in_uah,
    ROUND((Price / 42.08), 2) AS price_in_eur
FROM lab_1.library;

/*15. Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок округлена*/
SELECT Code, Price, 
	ROUND(Price) AS price_in_uah, /*eg. ROUND(135.375) 135.38*/
    FLOOR(Price) AS rounded_price_in_uah /*eg. FLOOR(25.75) = 25*/
FROM lab_1.library;

/*16. Додати інформацію про нову книгу (всі колонки)*/
INSERT INTO lab_1.library (Numer, Code, New, Name, Price, Producer, Pages, Form, Date, Circulation, Topic, Category) 
VALUES (5675,4667456,1,'new random book', NULL ,'Producer',
456,'170х240/16','2023-10-18',450,'Програмування','programming language');

/*17. Додати інформацію про нову книгу (колонки обов'язкові для введення)*/
INSERT INTO lab_1.library (Numer, Code, New, Name, Price, Producer, Pages, Form, Date, Circulation, Topic, Category) 
VALUES (5675,4667456,1,'new random book', 345.34 ,'Producer',
456,'170х240/16','2023-10-18',450,'Програмування','programming language');

/*18. Видалити книги, видані до 1990 року-----*/
DELETE FROM lab_1.library WHERE Date <= '1990-01-01';
DELETE FROM lab_1.library WHERE YEAR(Date) <= 1990;

/*19. Проставити поточну дату для тих книг, у яких дата видання відсутня*/
UPDATE lab_1.library SET Date = CURRENT_DATE() WHERE Date IS NULL;

/*20. Установити ознаку новинка для книг виданих після 2005 року*/
UPDATE lab_1.library SET New = 1 WHERE Date >= "2005-01-01";







/*14:10:45	DELETE FROM lab_1.library WHERE Date < '1980-01-01'	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
 To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec*/

