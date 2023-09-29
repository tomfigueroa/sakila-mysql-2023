select 
    customer_id,
    first_name,
    last_name,
    count(*)
    from rental
    join customer using (customer_id)
    group by    
        customer_id,
        first_name,
        last_name
    limit 5;

    select
        rental_id,
        rental_date,
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
        limit 5;
