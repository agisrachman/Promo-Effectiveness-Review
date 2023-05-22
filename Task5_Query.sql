CREATE TABLE promo_code_table (
	promo_id INT PRIMARY KEY,
	promo_name VARCHAR,
	price_deduction INT,
	description VARCHAR,
	duration INT 
);

CREATE TABLE Q3_Q4_Review as
SELECT 
	sl.purchase_date, 
	mp.category,
	mp.sub_category,
	sl.quantity,
	mp.price,
	COALESCE(pr.promo_name, 'NOT_USED') AS promo_code,
	(sl.quantity * mp.price) AS total_price,
	((sl.quantity * mp.price) - pr.price_deduction) AS sales_after_promo
FROM sales_table AS sl
LEFT JOIN marketplace_table AS mp 
    ON sl.item_id = mp.item_id	
LEFT JOIN promo_code_table AS pr
	ON sl.promo_id = pr.promo_id
WHERE purchase_date BETWEEN '2022-07-01' AND '2022-12-31'
ORDER BY purchase_date ASC;

CREATE TABLE shipping_summary as
SELECT 
	sh.shipping_date, 
	se.seller_name, 
	b.buyer_name, 
	b.address as buyer_address, 
	b.city as buyer_city, 
	b.zipcode as buyer_zipcode, 
	CONCAT(sh.shipping_id,'–', sh.purchase_date,'–', sh.shipping_date,'–',
		   b.buyer_id,'–', se.seller_id) as kode_resi
FROM shipping_table as sh
LEFT JOIN buyer_table as b 
    ON sh.buyer_id = b.buyer_id
LEFT JOIN seller_table as se
	ON sh.seller_id = se.seller_id
ORDER BY shipping_date ASC;