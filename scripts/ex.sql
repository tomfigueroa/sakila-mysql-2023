



with datos_pagos as (
    select
        store.store_id,
        MONTH(payment_date) as mes,
        YEAR(payment_date) as anno,
        SUM(amount) as amount
        from payment
            join staff using(staff_id)
            join store on staff.store_id = store.store_id
        group by 
        store.store_id,
        MONTH(payment_date),
        YEAR(payment_date)
),

datos_tiendas as (
    select 
    store.store_id,
    CONCAT(district,', ', city) as store,
    film_id,
    inventory_id
    from store
    join inventory using (store_id)
        join address on store.address_id = address.address_id
        join city using (city_id) 
),

datos_alquiler as (
    select
        store.store_id,
        CONCAT(district,', ', city) as store,
        MONTH(rental_date) as mes,
        YEAR(rental_date) as anno,
        count(*) as qty
    from rental
        join rental using (rental_id)
        join staff using (staff_id)
        join store using (store_id)
        join address on store.address_id = address.address_id
        join city using (city_id) 
    group by 
        store.store_id,
        MONTH(rental_date),
        YEAR(rental_date)
),

datos_alquiler_y_pagos as(
    select
        store,
        store_id,
        mes,
        anno,
        (amount/qty) as prom,
        qty,
        amount
        from datos_alquiler
        join datos_pagos using (store_id,mes,anno)
        group by 
        store_id,
        mes,
        anno
),

datos_por_columnas as(
    select
        store,
        sum(case when anno=2005 and mes=5 then prom else 0 end) as may2005,
        sum(case when anno=2005 and mes=6 then prom else 0 end) as jun2005,
        sum(case when anno=2005 and mes=7 then prom else 0 end) as jul2005

    from datos_alquiler_y_pagos
    group by store
), 

calculos as(
    select 
    store,
    may2005,
    jun2005,
    (jun2005-may2005) as diffmes1,
    ((jun2005 - may2005)/may2005)*100 as 'varmes1%',
    jul2005,
    (jul2005 - jun2005) as diffmes2,
    ((jul2005 - jun2005)/jun2005)*100 as 'varmes2%'
    from datos_por_columnas
)






select *
    from  calculos


    limit 40;