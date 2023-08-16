
create function fnTotalOfPrice1
(@OrderID int)
returns  int 
as
begin 
	declare @TotalPrice int
	select @TotalPrice = (select SUM([Total Price]) as [Total Price of Order] 
						from (SELECT od.OrderID, p.PhoneName, od.Quantity, 
								(od.Price * od.Quantity) AS [Total Price], 
								(od.Price - p.ImportPrice) * od.Quantity AS [Total Profit] 
								FROM OrderDetail od JOIN Phone p ON od.PhoneID = p.PhoneID) 
						as d where d.OrderID = @OrderID) 											
	return @TotalPrice 
end 


-- demo orderID = 2, hiển thị OrderID và các sản phẩm mua, 
--Và cột cuối tổng số tiền mua của đơn hàng ý trên tất cả sản phẩm 
select OrderID, phoneID, dbo.fnTotalOfPrice1(OrderID) as [Total price of Order] 
from OrderDetail where OrderID = 2


