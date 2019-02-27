
#Question 1
select c.customer_id, c.first_name, c.last_name, sum(p.amount) as 'TOTAL SPENT'
from customer as c
join payment as p
	on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name, sum(p.amount);

#Question 2
select a.district, c.city
from address as a
join city as c
	on a.city_id = c.city_id
where a.postal_code is null or a.postal_code = ''
group by a.district;

#Question 3
select title
from film
where title like '%DOCTOR%' or title like '%fire%';

#Question 4
select a.actor_id, a.first_name, a.last_name, count(fa.film_id) as 'NUMBER OF MOVIES'
from actor as a
join film_actor as fa
	on a.actor_id = fa.film_id
group by a.actor_id
order by a.last_name, count(fa.film_id);

#Question 5
select c.name, avg(f.length)
from category as c
join film_category as fc
	on fc.category_id = c.category_id
join film as f
	on f.film_id = fc.category_id
group by c.name
order by avg(f.length);

#Question 6
select st.store_id, sum(p.amount)
from payment as p
join staff as s
	on s.staff_id = p.staff_id
join store as st
	on st.store_id = s.store_id
group by st.store_id
order by sum(p.amount) desc;

#Question 7
select c.first_name, c.last_name, c.email, sum(p.amount)
from customer as c
join address as a
	on a.address_id = c.address_id
join city as ct
	on ct.city_id = a.address_id
join country as cn
	on cn.country_id = ct.country_id
join payment as p
	on p.customer_id = c.customer_id
where cn.country = 'Canada'
group by c.customer_id;

#Question 8
start transaction;

insert into rental(rental_date, inventory_id, customer_id, staff_id)
value(now(), 
	(select min(i.inventory_id)
     from inventory as i
     join film as f
		on f.film_id = i.film_id
	 where f.title = 'HUNGER ROOF' and i.store_id = 2),
     (select customer_id
     from customer
     where first_name = 'MATHEW' and last_name = 'BOLIN'),
     (select staff_id
     from staff
     where first_name = 'JON' and last_name = 'STEPHENS'));
     
insert into payment(customer_id, staff_id, rental_id, amount, payment_date)
value((select customer_id
     from customer
     where first_name = 'MATHEW' and last_name = 'BOLIN'),
     (select staff_id
     from staff
     where first_name = 'JON' and last_name = 'STEPHENS'),
     (select max(rental_id)
     from rental), 2.99, now());

select *
from rental
order by rental_id desc;

select *
from payment
order by payment_id desc;
    
rollback;

#Questino 9
start transaction;
update rental as r
join customer as c
	on r.customer_id = c.customer_id	
join inventory as i
	on i.inventory_id = r.inventory_id
join film as f
	on f.film_id = i.film_id	
set r.return_date = now()
where c.first_name = 'TRACY' and c.last_name = 'COLE' and f.title = 'ALI FOREVER';

select *
from rental as r
join customer as c
	on r.customer_id = c.customer_id	
join inventory as i
	on i.inventory_id = r.inventory_id
join film as f
	on f.film_id = i.film_id	
where c.first_name = 'TRACY' and c.last_name = 'COLE' and f.title = 'ALI FOREVER';

#Question 10
start transaction;

UPDATE film as f
join film_category as fc
	on fc.film_id = f.film_id
join category as c
	on c.category_id = fc.category_id
join language as l
	on l.language_id = f.language_id
SET f.language_id = 3
WHERE c.name = 'ANIMATION';

select f.language_id, c.name
from film as f
join film_category as fc
	on fc.film_id = f.film_id
join category as c
	on c.category_id = fc.category_id;


