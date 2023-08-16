--Mục đích chính: trình kích hoạt sẽ kiểm tra tổng số lượng của một sản phẩm nhất định trong kho nếu nó bằng hoặc lớn hơn số lượng của Khách hàng đối với sản phẩm đó.
--Mô tả: Khi chèn vào bảng OrderDetails sẽ tự động thiết lập giá bán bằng đơn giá (trong bảng Sản phẩm) + 50
--drop trigger UpdateOrder

--Create tạo thêm 2 cột trong OrderDetail

alter table [dbo].[OrderDetail]
ADD Total_of_Price int,
	Total_of_Profit int;


create trigger UpdateOrderDetail on OrderDetail AFTER INSERT
as 
begin 
	TRANSACTION; 
	--Khai báo biến 
	DECLARE @PhoneID nvarchar(20); 
	DECLARE @Quantity int; 
	DECLARE @OrderID int; 
	DECLARE @ImportPrice int; 
	DECLARE @Price int; 
	DECLARE @Available int;
	--Lấy giá trị từ bảng inserted 
	SELECT	@PhoneID = Inserted.PhoneID, 
			@Quantity = Inserted.Quantity, 
			@OrderID = Inserted.OrderID FROM Inserted;
	--Lấy đơn giá từ bảng Phone theo PhoneID 
	SELECT @ImportPrice = ImportPrice FROM [Phone] WHERE PhoneID = @PhoneID ;
	--Thiết lập giá bán bằng đơn giá + 50 
	SET @Price = @ImportPrice + 50;
	--Lấy số lượng sản phẩm từ bảng Phone theo PhoneID 
	SELECT @Available = Quantity FROM [Phone] WHERE PhoneID = @PhoneID ;
	--Kiểm tra điều kiện 
	IF @Quantity > @Available 
		BEGIN 
		--In thông báo lỗi 
			PRINT N'Hết hàng'; 
		--Hủy bỏ giao dịch 
			ROLLBACK TRANSACTION; 
		END 
	ELSE 
		BEGIN 
			-- Cập nhập số lượng trong bảng Phone
			UPDATE Phone 
			SET Quantity = Phone.Quantity - (select inserted.Quantity from inserted 
											where inserted.PhoneID = Phone.PhoneID ) 
			from Phone join inserted on Phone.PhoneID = inserted.PhoneID
			--Cập nhật giá bán OrderDetail 
			UPDATE OrderDetail 
			SET Price = @Price WHERE OrderID = @OrderID AND PhoneID = @PhoneID;
			--Cập nhật tổng số tiền và lợi nhuận của đơn hàng trong bảng Order 
			UPDATE [OrderDetail] 
			SET [Total_of_Price]  = (@Price * @Quantity), 
				[Total_of_Profit] = (@Price - @ImportPrice)*@Quantity 
				WHERE OrderID = @OrderID AND PhoneID = @PhoneID;
			PRINT N'Đơn hàng đã đặt'
			--Xác nhận giao dịch 
			COMMIT TRANSACTION; 
END 


--DEMO
