

begin tran
	declare @orderQuantity int ;
	set @orderQuantity = 3; -- nhập số lượng muốn mua 
	declare @PhoneID nvarchar(20);
	set @PhoneID = 'IP17' ; -- nhập mã máy muốn mua 
	insert into OrderDetail(OrderID, PhoneID, Quantity) values (1, @PhoneID, @orderQuantity)
	if @@ERROR <> 0
		begin
			print N'Lỗi tạo đơn hàng '
			rollback
		end
	else
		begin
			if (@orderQuantity <= (select Quantity from Phone where PhoneID = @PhoneID))
			begin
				if @@ERROR <> 0
					begin
						print 'Error on update Phone'
						rollback
					end
				else 
					print 'Add new order Successfully!'
				end

		end
commit



--select * from Phone
--select * from OrderDetail