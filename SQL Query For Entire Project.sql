--creating all the dimension tables

create table date_table
(
    date_id       serial primary key,
	rental_id     integer,
	rental_date   date,
	return_date   date
);

create table customer_table
(
	customer_id integer,
	first_name  varchar(45),
	last_name   varchar(45),
	email       varchar(50),
	address_id  integer references address(address_id),
	address     varchar(50),
	postal_code varchar(10),
	phone       character varying
);

create table store_table
(
	store_id    smallint not null primary key,
	manager_id  smallint not null,
	adress_id   integer,
	address     varchar(50) not null,
	district    varchar(28) not null,
	city_id     integer
);

create table film_table 
(
	film_id          smallint primary key,
	title            varchar(255),
	release_year     year,
	rental_rate      numeric(4,2),
	length           smallint,
	rating           varchar(5),
	special_features varchar(60),
	language_id      integer
);

--inserting data into date_table 

insert into date_table(rental_id,rental_date,return_date) 
select rental_id,rental_date,return_date from rental;

--inserting data into customer_table

insert into customer_table(customer_id,first_name,last_name,
email,address_id,address,postal_code,phone) 
select c.customer_id,c.first_name,c.last_name,
c.email,c.address_id,a.address,a.postal_code,a.phone
from customer c
join address a 
on (a.address_id=c.address_id);

--inserting data into store_table

insert into store_table 
select s.store_id,s.manager_staff_id,
s.address_id,a.address,a.district,a.city_id
from store s 
join address a 
on (a.address_id=s.address_id)
join city c 
on (c.city_id=a.city_id);

--inserting data into film_table

insert into film_table
select film_id,title,release_year,rental_rate,length,rating,
special_features,language_id from film;

--making schema of fact_sale_table

create table sale_fact_table
(
	sale_id      serial,
	film_id      integer references film(film_id),
    store_id     integer references store(store_id),
	customer_id  integer references customer(customer_id),
	payment_id   integer references payment(payment_id),
	date_id      integer references date_table(date_id),
	amount       numeric(5,2)
)

--inserting data into sale_fact_table

insert into sale_fact_table(film_id,store_id,customer_id,
payment_id,date_id,amount)
select f.film_id,s.store_id,c.customer_id,
p.payment_id,d.date_id,p.amount
from payment p
join rental r           on  (p.rental_id=r.rental_id)
join date_table d       on  (d.rental_id=r.rental_id)
join customer c         on  (c.customer_id=p.customer_id) 
join store s            on  (s.store_id=c.store_id)
join inventory i        on  (i.store_id=s.store_id)
join film f             on  (f.film_id=i.film_id)









