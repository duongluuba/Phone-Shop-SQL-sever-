-- Tổng số tiền mà mỗi khách hàng bỏ ra để mua hàng ở quán .
Select u.UserID, u.UserName, sum(od.Quantity* od.Price) as [Total of money]
from [User] as u
full join [Order] as o on u.UserID = o.UserID
full join [OrderDetail] as od on o.OrderID = od.OrderID
left join [Phone] as p on od.PhoneID = p.PhoneID
group by u.UserID, u.UserName 
order by [Total of money] desc

-- Hiện ra số lượng bán của từng điện thoại
select PhoneID ,sum(Quantity) as [Total purchase amount] 
from OrderDetail 
group by PhoneID 
order by [Total purchase amount]


