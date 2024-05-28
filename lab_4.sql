
/* 1. Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну -------------*/
SELECT COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library;


/* 2. Вивести загальну кількість всіх книг без урахування книг з непроставленою ціною */
SELECT 
COUNT(*) AS 'Загальна кількість книг'
FROM lab_1.library 
WHERE price IS NOT NULL AND price != 0;

/* 3. Вивести статистику (див. 1) для книг новинка / не новинка */
SELECT New,
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
GROUP BY New;

/* 4. Вивести статистику (див. 1) для книг за кожним роком видання */
SELECT Year(Date) AS 'Рік видання',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
GROUP BY Year(Date);

/* 5. Змінити п.4, виключивши з статистики книги з ціною від 10 до 20 */
SELECT Year(Date) AS 'Рік видання',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
WHERE price <= 10 OR price >= 20
GROUP BY Year(Date);

/* 6. Змінити п.4. Відсортувати статистику по спадаючій кількості */
SELECT Year(Date) AS 'Рік видання',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
GROUP BY year(Date)
ORDER BY COUNT(*) DESC;

/* 7. Вивести загальну кількість кодів книг і кодів книг що не повторюються */
SELECT COUNT(*) AS 'Загальна кількість кодів книг',
       COUNT(DISTINCT Numer) AS 'Кількість унікальних кодів книг'
FROM lab_1.library;

/* 8. Вивести статистику: загальна кількість і вартість книг по першій букві її назви*/
SELECT LEFT(Name, 1) AS 'Перша літера',
       COUNT(*) AS 'Всього книг',
       SUM(price) AS 'Всього ціна'
FROM lab_1.library
GROUP BY LEFT(Name, 1);

/* 9. Змінити п. 8, виключивши з статистики назви що починаються з англ. букви або з цифри */
SELECT UPPER(LEFT(Name, 1)) AS 'Перша буква назви',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг'
FROM lab_1.library
WHERE LEFT(Name, 1) REGEXP '[а-яА-Я]'  
GROUP BY UPPER(LEFT(Name, 1));


/* 10. Змінити п. 9 так щоб до складу статистики потрапили дані з роками більшими за 2000 */
SELECT UPPER(LEFT(Name, 1)) AS 'Перша буква назви',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг'
FROM lab_1.library
WHERE LEFT(Name, 1) REGEXP '[а-яА-Я]'  
  AND year(Date) > 2000
GROUP BY UPPER(LEFT(Name, 1));


/* 11. Змінити п. 10. Відсортувати статистику по спадаючій перших букв назви */
SELECT UPPER(LEFT(Name, 1)) AS 'Перша буква назви',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг'
FROM lab_1.library
WHERE LEFT(Name, 1) REGEXP '[а-яА-Я]'  
  AND year(Date) > 2000
GROUP BY UPPER(LEFT(Name, 1))
ORDER BY UPPER(LEFT(Name, 1)) DESC;


/* 12. Вивести статистику (див. 1) по кожному місяцю кожного року */
SELECT year(Date) AS 'Рік',
       month(Date) AS 'Місяць',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
GROUP BY year(Date), month(Date);

/* 13. Змінити п. 12 так щоб до складу статистики не увійшли дані з незаповненими датами */
SELECT year(Date) AS 'Рік',
       month(Date) AS 'Місяць',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
WHERE Date IS NOT NULL  -- Filter out records with NULL publication date
GROUP BY year(Date), month(Date);

/* 14. Змінити п. 12. Фільтр по спадаючій року і зростанню місяця */

SELECT year(Date) AS 'Рік',
       month(Date) AS 'Місяць',
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
WHERE Date IS NOT NULL
GROUP BY year(Date), month(Date)
ORDER BY year(Date) DESC, month(Date) ASC;

/* 15. Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро. Колонкам запиту дати назви за змістом */
SELECT New,
	   COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна ціна',
       SUM(price / 39) AS 'Загальна ціна в USD (приблизно)',
       SUM(price / 42) AS 'Загальна ціна в Євро (приблизно)',  
       SUM(price) AS 'Загальна ціна в грн (приблизно)'
FROM lab_1.library
GROUP BY New;


/* 16. Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна */
SELECT New,
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна ціна',
       ROUND(SUM(price / 39)) AS 'Загальна ціна в USD (приблизно)',
       ROUND(SUM(price / 42)) AS 'Загальна ціна в Євро (приблизно)',  
       ROUND(SUM(price)) AS 'Загальна ціна в грн (приблизно)'
FROM lab_1.library
GROUP BY New;



/* 17. Вивести статистику (див. 1) по видавництвам */
SELECT Producer,
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
GROUP BY Producer;


/* 18. Вивести статистику (див. 1) за темами і видавництвами. Фільтр по видавництвам */
SELECT Producer, Topic,
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
/*WHERE Producer IS NOT NULL AND Topic IS NOT NULL*/
WHERE Producer IN ('ДМК')
GROUP BY Producer, Topic;


/* 19. Вивести статистику (див. 1) за категоріями, темами і видавництвами. Фільтр по видавництвам, темах, категоріям */
SELECT Producer, Category, Topic,
       COUNT(*) AS 'Загальна кількість книг',
       SUM(price) AS 'Загальна вартість книг',
       AVG(price) AS 'Середня вартість книги',
       MIN(price) AS 'Мінімальна ціна книги',
       MAX(price) AS 'Максимальна ціна книги'
FROM lab_1.library
WHERE Producer IN ('ДМК')
  AND Topic IN ('Програмування')
  AND Category IN ('C&C++')
GROUP BY Producer, Category, Topic;


/* 20. Вивести список видавництв, у яких округлена до цілого ціна однієї сторінки більше 10 копійок ------------*/

SELECT Producer,
COUNT(*) AS 'Кількість книг у яких сторінка коштує дорожче 10 копійок'
FROM lab_1.library
WHERE ROUND(Price / Pages, 0) > 0.1
GROUP BY Producer




