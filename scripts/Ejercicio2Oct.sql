



with datos_pagos as (
    select
        MONTH(payment_date) as mes,
        YEAR(payment_date) as anno,
        SUM(amount) as amount
        from payment
        group by 
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
        store,
        MONTH(rental_date) as mes,
        YEAR(rental_date) as anno,
        count(*) as qty
    from rental
        join datos_tiendas using (inventory_id)
    group by 
        store,
        MONTH(rental_date),
        YEAR(rental_date)
),

datos_alquiler_y_pagos as(
    select
        store,
        mes,
        anno,
        qty,
        amount
        from datos_alquiler
        join datos_pagos using (mes,anno)
)





select *
    from  datos_alquiler_y_pagos

    limit 20;