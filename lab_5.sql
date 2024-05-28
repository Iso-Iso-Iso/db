/*Проаналізувати приклад універсального відношення. З'ясувати які його колонки містять надлишкові дані. Виконати нормалізацію універсального
відношення, розбивши його на кілька таблиць.*/

DROP TABLE IF EXISTS set_of_books_table;
DROP TABLE IF EXISTS producers_table;
DROP TABLE IF EXISTS forms_table;
DROP TABLE IF EXISTS topics_table;
DROP TABLE IF EXISTS categories_table;


/*Скласти SQL-script, що виконує:
a. Створення таблиць бази даних. Команди для створення таблиці повинні містити головний ключ, обмеження типу null / not null, default, check,
створення зв'язків з умовами посилальної цілісності
*/


CREATE TABLE IF NOT EXISTS producers
(
    id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    producer VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS forms
(
    id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    form VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS topics
(
    id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    topic VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS categories
(
    id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS set_of_books
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    numer       INT                                     NOT NULL,
    code        INT                                     NOT NULL,
    new         BOOLEAN                                 NOT NULL,
    name        varchar(255)                            NOT NULL,
    price       decimal(5, 2) DEFAULT ('default value') NULL,
    pages       INT                                     NOT NULL,
    date        DATE          DEFAULT NULL,
    circulation INT                                     NOT NULL,
    topic_id    INT UNSIGNED                            NOT NULL,
    category_id INT UNSIGNED                            NOT NULL,
    producer_id INT UNSIGNED                            NOT NULL,
    form_id     INT UNSIGNED  DEFAULT NULL,

    FOREIGN KEY (producer_id) REFERENCES producers(id),
    FOREIGN KEY (form_id) REFERENCES forms(id),
    FOREIGN KEY (topic_id) REFERENCES topics(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)

);

/*b. Завантаження даних в таблиці*/

INSERT INTO producers(producer)
SELECT DISTINCT Producer FROM lab_1.library
WHERE Producer IS NOT NULL;

INSERT INTO topics(topic)
SELECT DISTINCT Topic FROM lab_1.library
WHERE Topic IS NOT NULL;

INSERT INTO categories(category)
SELECT DISTINCT Category FROM lab_1.library
WHERE Category IS NOT NULL;

INSERT INTO forms(form)
SELECT DISTINCT Form FROM lab_1.library
WHERE Form IS NOT NULL;

/*
Побудувати діаграму зв'язків таблиць бази даних використовуючи інструмент Designer.
4. Створити зв’язки в базі даних між таблицями.
a. Вивчити роботу створення зв’язків між таблицями в полі Designer
b. Створити майстром e Designer кілька варіантів зв’язків у базі даних
c. Проаналізувати і пояснити особливості зв’язків, створених Designer
d. Порівняти з тими, що написані самостійно.
e. Зробити висновки
*/

INSERT INTO set_of_books (numer, code, new, name, price, pages, date, circulation, producer_id, form_id, topic_id, category_id)
SELECT
	lab_1.library.Numer,
    lab_1.library.Code,
    lab_1.library.New,
    lab_1.library.Name,
    lab_1.library.Price,
	lab_1.library.Pages,
    lab_1.library.Date,
    lab_1.library.Circulation,
    producers.id,
    forms.id,
    topics.id,
    categories.id
FROM
    lab_1.library
LEFT JOIN
    producers ON lab_1.library.Producer = producers.producer
LEFT JOIN
    forms ON lab_1.library.Form = forms.form
LEFT JOIN
    topics ON lab_1.library.Topic = topics.topic
LEFT JOIN
    categories ON lab_1.library.Category = categories.category;



/*Створити і перевірити представлення для отримання універсального відношення з набору нормалізованих таблиць бази даних.*/

CREATE VIEW UniversalView AS
SELECT
    books.numer,
    books.code,
    books.new,
    books.name,
    books.price,
    books.pages,
    books.date,
    books.circulation,
    p.producer,
    f.form,
    t.topic,
    c.category
FROM
    set_of_books AS books
	LEFT JOIN
    producers AS p ON books.producer_id = p.id
	LEFT JOIN
    topics AS t ON books.producer_id = t.id
	LEFT JOIN
    categories AS c ON books.producer_id = c.id
    LEFT JOIN
    forms AS f ON books.form_id = f.id;
