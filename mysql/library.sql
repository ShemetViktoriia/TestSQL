create database library character set utf8;

use library;

create table author
(
	id int primary key auto_increment,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    unique (first_name, last_name)
);

insert into author(first_name, last_name) values('Лев', 'Толстой');
insert into author(first_name, last_name) values('Алексей', 'Толстой');

alter table author add index(first_name);

create table book
(
	id int primary key auto_increment,
    title varchar(100) not null,
    page int    
);

create table author_book
(
	author_id int,
    book_id int,
    constraint fk_author foreign key(author_id) references author(id),
    constraint fk_book foreign key(book_id) references book(id)
);

insert into book(title) values('Война и мир');
insert into book(title) values('Аэлита');
insert into book(title) values('Анна Каренина');
insert into book(title) values('Гиперболоид инженера Гарина');

select * from book;
select * from author;

insert into author_book values(1, 1);
insert into author_book values(2, 2);
insert into author_book(author_id, book_id) values(1, 3);
insert into author_book(author_id, book_id) values(2, 4);

select * from author_book;

-- соединение 3х таблиц join
select a.first_name, a.last_name, b.title
from author as a
join author_book as ab
join book as b
on a.id=ab.author_id and ab.book_id=b.id;

-- соединение 3х таблиц декартовое представление
select a.first_name, a.last_name, b.title
from author as a, author_book as ab, book as b
where a.id=ab.author_id and ab.book_id=b.id;


-- соединение 3х таблиц join  подсчитать колличество книг у каждого автора
select a.first_name, a.last_name, b.title, count(a.id)
from author as a
join author_book as ab
join book as b
on a.id=ab.author_id and ab.book_id=b.id
group by(a.id);


-- соединение 3х таблиц декартовое представление подсчитать колличество книг у каждого автора
select a.id, a.first_name, a.last_name, b.title, count(a.id)
from author as a, author_book as ab, book as b
where a.id=ab.author_id and ab.book_id=b.id
group by (a.id);


-- представление
create view author_view as
select a.id as author_id, a.first_name, a.last_name, b.title, count(a.id)
from author as a, author_book as ab, book as b
where a.id=ab.author_id and ab.book_id=b.id
group by (a.id);

select * from author_view;

drop view author_view;

-- добавляем к представления ограничение
select *, count(author_id) from author_view group by(author_id);