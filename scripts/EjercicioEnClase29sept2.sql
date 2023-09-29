
with datos_alquler as(    
    select
        rental_id,
        MONTH(rental_date) as mes,
        YEAR(rental_date) as anno,
        CONCAT(customer.first_name,' ', customer.last_name) as customer,
        title as film,
        store.store_id,
        CONCAT(district,', ', city) as store,
        CONCAT(staff.first_name,' ', staff.last_name) as staff
        from rental
            join customer using (customer_id)
            join inventory using (inventory_id)
            join film using (film_id)
            join staff using (staff_id)
            join store on inventory.store_id = store.store_id
            join address on store.address_id = address.address_id
            join city using (city_id)
        
),

datos_mes_film as (
    select
    store,
    film,
    mes,
    anno,
    count(*) as ventas
    from datos_alquler
    group by
    film,
    mes,
    anno,
    store
),

comparacion_film_mes as (

    select
        store,
        film,
        sum(case when anno=2005 and mes=5 then ventas else 0 end) as may2005,
        sum(case when anno=2005 and mes=6 then ventas else 0 end) as jun2005
    from datos_mes_film
    group by 
    store,
    film
),

datos_por_mes_comparativo_film as (
    select
    store,
    film,
    may2005,
    jun2005,
    (jun2005-may2005) as diff,
    ((jun2005 - may2005)/may2005)*100 as 'Var%'
       from
        comparacion_film_mes 
)

select *
    from datos_por_mes_comparativo_film 

    limit 5;