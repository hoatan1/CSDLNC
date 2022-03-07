CREATE DATABASE QLMuaHang
GO 

USE QLMuaHang
GO

CREATE TABLE CUSTOMERS(
	MaKH VARCHAR(10) NOT NULL PRIMARY KEY,
	HoTen NVARCHAR(50),
	Email VARCHAR(50),
	Phone VARCHAR(30),
	DiaChi NVARCHAR(255)
)
GO

CREATE TABLE PRODUCTS(
	MaSP VARCHAR(10) NOT NULL PRIMARY KEY,
	TenSP NVARCHAR(50),
	MoTa NVARCHAR(255),
	GiaSP float,
	SoLuong INT
)
GO

CREATE TABLE ORDER_DETAIL(
	MaHD_De_id VARCHAR(10) NOT NULL,
	MaHD VARCHAR(10) NOT NULL,--khoá ngoại
	MaSP VARCHAR(10) NOT NULL,--khoá ngoại
	SLuongSPM INT,
	ThanhTien float,
	PRIMARY KEY(MaHD_De_id, MaHD, MaSP)
)
GO

CREATE TABLE PAYMENTSS(
	MaPTTT VARCHAR(10) NOT NULL PRIMARY KEY,
	TenPTTT NVARCHAR(50),
	PhiPTTT INT
)
GO

CREATE TABLE ORDERS(
	MaHD VARCHAR(10) NOT NULL primary key,
	MaKH VARCHAR(10) NOT NULL,--khoá ngoại
	NgayDH DATE,
	TrangThaiDH NVARCHAR(255),
	TongTien float,
	MaPTTT VARCHAR(10) NOT NULL --khóa ngoại
)
GO

-- liên kết khoá ngoại
	ALTER TABLE dbo.ORDER_DETAIL ADD FOREIGN KEY(MaSP) REFERENCES dbo.PRODUCTS(MaSP);
	ALTER TABLE dbo.ORDER_DETAIL ADD FOREIGN KEY(MaHD) REFERENCES dbo.ORDERS(MaHD);
	ALTER TABLE dbo.ORDERS ADD FOREIGN KEY(MaKH) REFERENCES dbo.CUSTOMERS(MaKH);
	ALTER TABLE dbo.ORDERS ADD FOREIGN KEY(MaPTTT) REFERENCES dbo.PAYMENTSS(MaPTTT);

-- chèn dữ liệu vào bảng
	INSERT INTO CUSTOMERS VALUES
	('MKH1',N'Huyền','nthuyen1904@gmail.com','039273733',N'Nghệ An'),
	('MKH2',N'Huy','nguyen@gmail.com','039273733',N'Đà Nẵng'),
	('MKH3',N'Hạnh','nthu4@gmail.com','03923333',N'Thanh Hoá'),
	('MKH4',N'Hòa','test@gmail.com','03927993',N'Quảng Nam'),
	('MKH5',N'Dương','duong@gmail.com','03927399',N'Quảng Nam');
	INSERT INTO PRODUCTS VALUES
	('SP1',N'Coca',N'ngon',10000,10),
	('SP2',N'Bò húc',N'ngon',25000,20),
	('SP3',N'Chanh leo',N'đỉnh',20000,30),
	('SP4',N'Tăng lực',N'ngon tuyệt',15000,40),
	('SP5',N'Nước Suối',N'ngon',35000,10);
	INSERT INTO PAYMENTSS VALUES
	('MPTTT1',N'Tiền măt',5500),
	('MPTTT2',N'Thẻ',5500),
	('MPTTT3',N'Trực tiếp',0),
	('MPTTT4',N'Ten 4',5500),
	('MPTTT5',N'Ten 5',5500);
	INSERT INTO ORDERS VALUES
	('MHD1','MKH2','2022-02-28',N'Đang chuẩn bị hàng',300000, 'MPTTT1'),
	('MHD2','MKH1','2022-02-12',N'Đang chuẩn bị hàng',350000, 'MPTTT4'),
	('MHD3','MKH2','2022-02-10',N'Đang chuẩn bị hàng',400000, 'MPTTT3'),
	('MHD4','MKH4','2022-02-8',N'Đã giao',900000, 'MPTTT4'),
	('MHD5','MKH3','2022-02-28',N'Đang giao',1000000, 'MPTTT3');
	INSERT INTO ORDER_DETAIL VALUES
	('MCT1','MHD2','SP3',3,60000),
	('MCT2','MHD3','SP2',5,125000),
	('MCT3','MHD5','SP3',9,180000),
	('MCT4','MHD4','SP5',4,140000),
	('MCT5','MHD2','SP1',3,30000);
 
--VIEW_1
	-- khung nhìn: Tạo một khung nhìn có tên là view_KHACHHANG để lấy thông tin của tất cả khách hàng mã khách hàng, tên, email, địa chỉ,sdt, ngày hoá đơn, tổng số tiền và trạng thái hoá đơn khách hàng mua của khách hàng có địa chỉ ở' Quảng nam';

	CREATE VIEW view_KHACHHANG AS 
	SELECT CUSTOMERS.MaKH,CUSTOMERS.HoTen,CUSTOMERS.Email,CUSTOMERS.Phone,CUSTOMERS.DiaChi,ORDERS.MaHD,ORDERS.NgayDH,ORDERS.TongTien,ORDERS.TrangThaiDH
	FROM CUSTOMERS JOIN ORDERS ON CUSTOMERS.MaKH=ORDERS.MaKH WHERE CUSTOMERS.DiaChi=N'Quảng Nam';
	-- Sử dụng khung nhìn
	SELECT * FROM dbo.view_KHACHHANG;

--VIEW_2
	--Tạo một khung nhìn xem thông tin của các hóa đơn sẽ gồm những sản phẩm nào, giá của mỗi sản phẩm là bao nhiêu, số lượng mua bao nhiêu, tính tổng tiền của mỗi sản phẩm có trong hóa đơn
	CREATE VIEW view_HOADON 
	AS
		SELECT ct.MaHD, sp.TenSP, sp.GiaSP, ct.SLuongSPM, (sp.GiaSP * ct.SLuongSPM) as ThanhTien
		FROM ORDER_DETAIL as ct
		INNER JOIN PRODUCTS as sp on ct.MaSP = sp.MaSP;
	--Sử dụng khung nhìn
	SELECT * FROM dbo.view_HOADON ;

--VIEW_3
    --tạo một khung nhìn view_CTHD xem thông tin hoá đơn sẽ gồm mã hoá đơn, ngày đăng ký , tổng tiền và tên phương thức thanh toán của hoá đơn đó với phí thanh toán là bao nhiêu
	CREATE VIEW view_CTHD
	AS
	    SELECT hd.MaHD, hd.NgayDH, pm.MaPTTT,pm.TenPTTT,pm.PhiPTTT FROM ORDERS as hd 
		JOIN PAYMENTSS as pm ON pm.MaPTTT=hd.MaPTTT;
	  --sử dụng khung nhìn
	   SELECT*FROM dbo.view_CTHD;

--DƯƠNG
--PROCEDURE_1
	--Tạo một thủ tục dùng để thêm vào bảng chi tiết hóa đơn sao cho khóa chính chưa tồn tại và các khóa ngoại hợp lệ
		--kiểm tra số lượng thêm có lớn hơn số lượng sp hiện có không
		--mỗi lần thêm là cập nhập số lượng của bảng SANPHAM
	CREATE PROCEDURE insert_ORDERDATAIL
	(@MaCT varchar(10), @MaHD varchar(10), @MaSP varchar(10), @SoLuongMua int)
	AS
		BEGIN
			if exists (select * from ORDER_DETAIL where MaHD_De_id = @MaCT) --kiểm tra id chi tiết hóa đơn
			begin
				print N'Mã chi tiết hóa đơn đã tồn tại.'
				return
			end

			if not exists (select * from ORDERS where MaHD = @MaHD)  --kiểm tra id hóa đơn
			begin
				print N'Mã hóa đơn chưa tồn tại.'
				return
			end

			if not exists (select * from PRODUCTS where MaSP = @MaSP)  --kiểm tra id sản phẩm
			begin
				print N'Mã sản phẩm chưa tồn tại.'
				return
			end

			declare @sl_hienco int
			select @sl_hienco = SoLuong
			from PRODUCTS 
			where MaSP = @MaSP

			if(@SoLuongMua > @sl_hienco)      --kiểm tra số lượng sản phẩm đang có
			begin
				print N'Số lượng không đủ để bán.'
				return
			end

			declare @gia_sp float    --lấy giá sản phẩm
			select @gia_sp = GiaSP
			from PRODUCTS
			where MaSP = @MaSP

			declare @thanhtien float
			set @thanhtien = @gia_sp * @SoLuongMua

			insert into ORDER_DETAIL       --thêm dl vào bảng chi tiết
			values(@MaCT, @MaHD, @MaSP, @SoLuongMua, @thanhtien)

			update PRODUCTS               --cập nhập lại số lượng sp
			set SoLuong = SoLuong - @SoLuongMua
			where MaSP = @MaSP
		END
	--lệnh chạy thủ tục
	insert_ORDERDATAIL 'MCT1', 'MHD1', 'SP4', 3;  --sai
	insert_ORDERDATAIL 'MCT6', 'MHD0', 'SP4', 3;  --sai
	insert_ORDERDATAIL 'MCT6', 'MHD1', 'SP6', 3;  --sai
	insert_ORDERDATAIL 'MCT6', 'MHD1', 'SP4', 5;  --đúng
--DUY
--PROCEDURE_2
--Tạo thủ tục có tên INSERT_SANPHAM để thêm sản phẩm vào với điều kiện phải hợp lệ. Những mã sản phẩm đã tồn tại rồi thì thông báo lỗi , Số lượng sản phẩm phải dương ngược lại sẽ thêm sản phẩm đó vào bảng sản phẩm
	CREATE PROCEDURE INSERT_SANPHAM(
		@MaSP varchar(50),
		@TenSP varchar(50),
		@MoTa varchar(50),
		@GiaTien int,
		@SoLuongSP int
	)
	AS
	BEGIN
		IF exists(SELECT*FROM PRODUCTS WHERE MaSP=@MaSP)--kieemr tra ma san pham da tồn tại hay chưa
		BEGIN
			PRINT'Ma San pham da ton tai'
		END
		ELSE
		BEGIN
			INSERT INTO PRODUCTS VALUES(@MaSP,@TenSP,@MoTa,@GiaTien,@SoLuongSP)
		END
	END
	--lệnh chạy
	INSERT_SANPHAM 'MaSP1' ,'PEPSI', 'téiuidu', 20000 ,2;
--NGUYỄN MINH HUY
--procedure 3;
--tạo procedure để insert vào bảng orders ,Kiểm tra xem MAHD có tồn tại chưa nếu tồn tại thì không cho insert
--, kiểm tra xem MaKH có tồn tại không, kiểm tra xem phương thức thanh toán có tồn tại không
--nếu cả 2 thỏa mãn điều kiện tồn tại thì cho insert và ngược lại

  CREATE procedure insert_orders(
    @MaHD VARCHAR(10),
	@MaKH VARCHAR(10) ,
	@NgayDH DATE,
	@TrangThaiDH NVARCHAR(255),
	@TongTien float,
	@MaPTTT VARCHAR(10) 
  )as
  begin
		if exists (select*from ORDERS where MaHD=@MaHD)
		begin
			print N'MaHD đã tồn tại'
			return
		end
		if not exists (select*from CUSTOMERS where MaKH=@MaKH)
		begin
			print N'Mã Khách hàng không tồn tại'
			return
		end
		if not exists (select*from PAYMENTSS where MaPTTT=@MaPTTT)
		begin
			print N'Mã PTTT không tồn tại'
			return
		end

		insert into ORDERS (MaHD,MaKH,NgayDH,TrangThaiDH,TongTien,MaPTTT) values
		(@MaHD,@MaKH,@NgayDH,@TrangThaiDH,@TongTien,@MaPTTT)

  end



drop procedure insert_orders
--lệnh chạy
insert_orders 'MHD5','MKH1','2021-12-12','Đã giao',130000,'MPTTT1'--sai MaHD đã tồn tại
insert_orders 'MHD6','MKH7','2021-12-12','Đã giao',130000,'MPTTT1'--sai MaKH không tồn tại
insert_orders 'MHD6','MKH5','2021-12-12','Đã giao',130000,'MPTTT7'--sai MaPTTT không tồn tại
insert_orders 'MHD6','MKH5','2021-12-12','Đã giao',130000,'MPTTT1'--đúng
-- ĐOÀN NGỌC HỘI
	--PROCEDURE_4
	-- Tăng 10% cho giá của các sản phẩm
	CREATE PROC Tang_GiaSP
	AS
		UPDATE PRODUCTS SET GiaSP = GiaSP * 1.1
	GO
	-- Lệnh chạy thủ tục
	EXEC Tang_GiaSP
	SELECT*FROM PRODUCTS;

	--PROCEDURE_5
	--Đếm tổng số lượng của sản phẩm
	CREATE PROC In_so_luong_sp @depid int = NULL
	AS
		DECLARE @Dem int   
		SELECT @Dem = SUM(SoLuong)
		FROM dbo.PRODUCTS
		WHERE SoLuong = @depid OR @depid IS NULL
		PRINT N'Tổng Số lượng sản phẩm: ' + STR(@Dem)
	GO
	-- Lệnh chạy thu tuc
	EXEC In_so_luong_sp


--HUYỀN
--FUNCTION_1
	--  Viết hàm funct_HOADON()  để đếm số hoá đơn trong năm 2022 ,chỉ đếm đối với những sản phẩm có tên là 'Coca'  
	CREATE FUNCTION funct_HOADON()
	RETURNS int
	AS
	   BEGIN 
			DECLARE @sohoadon int
			SELECT @sohoadon = COUNT(MaHD)
			FROM ORDERS WHERE NgayDH BETWEEN '2022-01-01' AND '2022-12-01'
					 AND MaHD IN(SELECT MaHD FROM ORDER_DETAIL WHERE MaSP IN (SELECT MaSP FROM PRODUCTS WHERE TenSP= N'Coca'));
			RETURN @sohoadon
	   END
	--Lệnh chạy hàm
	select [dbo].[funct_HOADON] ()
	--
	SELECT*FROM PRODUCTS;
	SELECT*FROM ORDER_DETAIL;
	SELECT*FROM ORDERS;
--DƯƠNG
--FUNCTION_2
	--Viết hàm tính tổng tiền cho 1 hóa đơn với mã hóa đơn là tham số đầu vào
	create function tinhTien(@MaHD varchar(10))
	returns float
	as
		begin
			if not exists(select * from ORDERS where @MaHD = MaHD)
			begin
				return 0
			end

			declare @tongtien float
			select @tongtien = sum(ThanhTien)
			from ORDER_DETAIL
			where MaHD = @MaHD

			return @tongtien
		end
	--lệnh chạy hàm
	select [dbo].[tinhTien] ('MHD7') as TongTien
	select [dbo].[tinhTien] ('MHD2') as TongTien

--HOÀ
--FUNCTION3
  -- Viết hàm đếm tổng số hoá đơn đã oder
     CREATE FUNCTION TONGHDD()
	 RETURNS int AS
	   BEGIN 
      DECLARE @tongHD int
			
			SELECT @tongHD =  COUNT(HD.MaHD)
			FROM ORDERS HD
			RETURN @tongHD
	   END
	   --Lệnh chạy hàm
	select [dbo].[TONGHDD] () as TổngHD
	--Kiểm tra kết quả
	SELECT COUNT(MaHD) as TổngHD FROM ORDERS 

--FUNCTION4
	--Tính tổng tiền tất cả của hóa đơn 
	create function TONGTIENHD()
	returns int
	as
		begin

			declare @tongtien float
			select @tongtien = sum(ThanhTien)
			from ORDER_DETAIL
			return @tongtien
		end
	--lệnh chạy hàm
	select [dbo].[TONGTIENHD] () as TongTien