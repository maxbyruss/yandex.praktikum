SELECT 
	T.week_number,
	T.ticket_amount,
	T.festival_week,
	T.festival_name
FROM 
(
(SELECT
		EXTRACT (week FROM flights.departure_time) AS week_number,
		COUNT(ticket_flights.ticket_no) AS ticket_amount
	FROM 
		airports
	INNER JOIN 
		flights 
	ON 
		airports.airport_code = flights.arrival_airport
	INNER JOIN 
		ticket_flights 
	ON 
		flights.flight_id = ticket_flights.flight_id
	WHERE 
		airports.city = 'Москва' 
		AND CAST(flights.departure_time AS date) BETWEEN '2018-07-23' AND '2018-09-30'
	GROUP BY
		week_number
) t
LEFT JOIN 
(SELECT 		
		festival_name,	
		EXTRACT (week FROM festivals.festival_date) AS festival_week
	FROM 
		festivals
	WHERE
		festival_city = 'Москва'
	  AND CAST(festivals.festival_date AS date) BETWEEN '2018-07-23' AND '2018-09-30'
) t2 
ON 
	t.week_number = t2.festival_week
) AS T;