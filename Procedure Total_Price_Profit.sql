
create procedure Total_Price_Profit
as 
begin
	with a as 
	(   
	SELECT ROW_NUMBER() OVER (ORDER BY p.PhoneName)as [ROW], 
	p.PhoneName, t.Quantity,(t.ImportPrice * t.Quantity) as[TotalImportPrice] ,(t.Price * t.Quantity) as[TotalPrice], 
	(t.Price - p.ImportPrice)*t.Quantity as [TotalProfit]
	from [Phone] as p
	join(	
		select p1.PhoneID, p1.PhoneName, p1.ImportPrice , 
		sum(p1.Quantity) as [Quantity of Order], 
		sum(o.Quantity) as [Quantity], o.Price
		from OrderDetail as o 
		left join Phone as p1 on o.PhoneID = p1.PhoneID
		group by p1.PhoneID, p1.PhoneName, p1.ImportPrice, o.Price
		) as t on p.PhoneID = t.PhoneID
	)
	select * from a
	union
	SELECT (select count(*) + 1 from a),'Total ', SUM(Quantity) ,Sum([TotalImportPrice]), SUM([TotalPrice]) ,SUM([TotalProfit])  from a
end 


exec Total_Price_Profit

