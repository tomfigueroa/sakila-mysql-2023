---source /scripts/ejercicio22sept.sql
use sakila;

select *
    from payment
limit 5;

desc payment;


with datos_tienda as(
    select
        st.store_id,
        ad.address,
        ad.district,
        ci.city,
        co.country
    from store as st
        join address as ad using (address_id)
        join city as ci using(city_id)
        join country as co using(country_id)
        
),
datos_pagos as (
    select
        pa.payment_id,
        pa.amount,
        pa.payment_date,
        CONCAT(emp.first_name,' ',emp.last_name) as staff,
        emp.store_id
        from payment as pa
        join staff as emp using (staff_id)
),

datos_combinados as (
    select
    CONCAT(district,', ',city) as store,
    country,
    year(payment_date) as year,
    month(payment_date) as month,
    amount
from datos_pagos
    join datos_tienda using (store_id)
),
datos_por_mes as (
    select
        store,
        year,
        month,
        sum(amount) as amount
    from datos_combinados
    group by 
    store,
    year,
    month
),

datos_por_mes_columnas as(
    select
        store,
        sum(case when year=2005 and month=5 then amount else 0 end) as may2005,
        sum(case when year=2005 and month=6 then amount else 0 end) as jun2005
    from datos_por_mes
    group by store
),

datos_por_mes_comparativo as (
    select
    store,
    may2005
    jun2005,
    (jun2005-may2005) as diff,
    ((jun2005 - may2005)/may2005)*100 as 'Var%'
       from
        datos_por_mes_columnas
)






select *
    from datos_por_mes_comparativo
    limit 3
    ;