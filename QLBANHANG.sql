﻿DROP DATABASE qlbanhang
CREATE DATABASE QLBANHANG1
GO
use QLBANHANG1
go
set dateformat dmy;
go

--drop table KHACHHANG
go
create table KHACHHANG(
	MAKH varchar(5) not null primary key,
	TENKH	nvarchar(30) not null ,
	DIACHI	nvarchar(50),
	DT	nvarchar(11) constraint check_dt check (DT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
											 or DT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
						                     or DT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
											 or DT is null),
	EMAIL	varchar(30)

)

go

--drop table VATTU
go
create table VATTU(
	MAVT varchar(5) not null primary key,
	TENVT	nvarchar(30) not null ,
	DVT	nvarchar(20),
	GIAMUA	money not null check (GIAMUA >0),
	SLTON 	int check (SLTON>=0)
)

go

--drop table HOADON
go
create table HOADON (
	MAHD varchar(10) not null primary key,
	NGAY	smalldatetime check ((year(getdate()) - year(NGAY) >0)),
	MAKH	varchar(5),
	TONGTG	float 
)
go


--drop table CHITIETHOADON
go
create table CHITIETHOADON(
	MAHD	varchar(10),
	MAVT	varchar(5),
	SL	int check (SL>0),
	KHUYENMAI	float,
	GIABAN	float
)	
go

ALTER TABLE  HOADON 
ADD CONSTRAINT FK_HD 
FOREIGN KEY (MAKH ) 
REFERENCES  KHACHHANG (MAKH) 

 -- XÓA RÀNG BU?C 
--ALTER TABLE HOADON DROP CONSTRAINT FK_HD
ALTER TABLE CHITIETHOADON ADD CONSTRAINT FK_CTHD
FOREIGN KEY (MAHD)
REFERENCES HOADON (MAHD)

-- XÓA RÀNG BU?C
-- ALTER TABLE CHITIETHOADON DROP CONSTRAINT FK_CTHD
ALTER TABLE CHITIETHOADON ADD CONSTRAINT FK_CTHD_VT
FOREIGN KEY (MAVT)
REFERENCES VATTU(MAVT)

----===================NHAP LIEU CHO CAC TABLE ============-----------
--------- TABLE VATTU -----------------
insert into VATTU values ('VT01','XI MANG','BAO',50000,5000)
insert into VATTU values ('VT02','CAT','KHOI',45000,50000)
insert into VATTU values ('VT03','GACH ONG','VIEN',120,800000)
insert into VATTU values ('VT04','GACH THE','VIEN',110,800000)
insert into VATTU values ('VT05','DA LON','KHOI',25000,100000)
insert into VATTU values ('VT06','DA NHO','KHOI',33000,100000)
insert into VATTU values ('VT07','LAM GIO','CAI',15000,50000)

select * from VATTU
go
---------------------INSERT INTO TABLE KHACHHANG --------------
insert into KHACHHANG values ('KH01','NGUYEN THI BE','TAN BINH','38457895','bnt@yahoo.com')
insert into KHACHHANG values ('KH02','LE HOANG NAM','BINH CHANH','39878987','namlehoang@abc.com.vn')
insert into KHACHHANG values ('KH03','TRAN THI CHIEU','TAN BINH','38457895',null)
insert into KHACHHANG values ('KH04','MAI THI QUE ANH','BINH CHANH',null,null)
insert into KHACHHANG values ('KH05','LE VAN SANG','QUAN 10',null,'sanglv@hcm.vnn.vn')
insert into KHACHHANG values ('KH06','RAN HOANG','TAN BINH','38457897',null)
go

select * from KHACHHANG

go

-------------------- INSERT INTO HOADON ------------
insert into HOADON values ('HD001','12/05/2000','KH01',NULL)
insert into HOADON values ('HD002','25/05/2000','KH02',NULL)
insert into HOADON values ('HD003','25/05/2000','KH01',NULL)
insert into HOADON values ('HD004','25/05/2000','KH04',NULL)
insert into HOADON values ('HD005','26/05/2000','KH04',NULL)
insert into HOADON values ('HD006','02/06/2000','KH03',NULL)
insert into HOADON values ('HD007','22/06/2000','KH04',NULL)
insert into HOADON values ('HD008','25/06/2000','KH03',NULL)
insert into HOADON values ('HD009','15/08/2000','KH04',NULL)
insert into HOADON values ('HD010','30/09/2000','KH01',NULL)
go
select * from HOADON
go

----------------Insert into CHITIETHOADON------------------
insert into CHITIETHOADON values ('HD001','VT01',5,null,52000)
insert into CHITIETHOADON values ('HD001','VT05',10,null,30000)
insert into CHITIETHOADON values ('HD002','VT03',10000,null,150)
insert into CHITIETHOADON values ('HD003','VT02',20,null,55000)
insert into CHITIETHOADON values ('HD004','VT03',50000,null,150)
insert into CHITIETHOADON values ('HD004','VT04',20000,null,120)
insert into CHITIETHOADON values ('HD005','VT05',10,null,30000)
insert into CHITIETHOADON values ('HD005','VT06',15,null,35000)
insert into CHITIETHOADON values ('HD005','VT07',20,null,17000)
insert into CHITIETHOADON values ('HD006','VT04',10000,null,120)
insert into CHITIETHOADON values ('HD007','VT04',20000,null,150)
insert into CHITIETHOADON values ('HD008','VT01',100,null,55000)
insert into CHITIETHOADON values ('HD008','VT02',20,null,47000)
insert into CHITIETHOADON values ('HD009','VT02',25,null,48000)
insert into CHITIETHOADON values ('HD010','VT01',25,null,57000)
go
select * from HOADON
--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng,
-- tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
create view view_cau1 as
select *
from KHACHHANG
where DIACHI like N'%TAN BINH%' 

select * from view_cau1 
--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng
--, địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.
-- Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ Email gồm mã khách hàng, tên khách hàng, địa chỉ.
create view view_cau2 as 
select *
from KHACHHANG
WHERE DT is null

select * from view_cau2
--3.	Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã khách hàng,
-- tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
create view view_cau3 as
select * 
from KHACHHANG
where DT is not null and EMAIL is not null

select * from view_cau3
--4.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.
create view view_cau4 as 
select MAVT , TENVT , GIAMUA
from VATTU
where DVT like N'%CAI%'

select * from view_cau4

--5.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua trên 25000.
create view view_cau5 as
select MAVT , TENVT , DVT , GIAMUA
from VATTU
where GIAMUA > 25000

select * from view_cau5
--6.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, đơn vị tính và giá mua.
create view view_cau6 as
select MAVT , TENVT , DVT , GIAMUA
from VATTU
where TENVT like '%GACH%'

select * from view_cau6
--7.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua nằm trong khoảng từ 20000 đến 40000.
--giamua>=20 and giamua<=40;  giamua beween 20 and 40
create view view_cau7 as
select MAVT , TENVT , DVT , GIAMUA
from VATTU
where GIAMUA >= 20000 and GIAMUA <=40000 

select * from view_cau7
--8.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại.
create view view_cau8 as
select d.MAHD , d.NGAY , k.TENKH , k.DIACHI , k.DT 
from HOADON d 
inner join KHACHHANG k on d.MAKH = k.MAKH 

select * from view_cau8
--9.	Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của ngày 25/5/2010.
create view view_cau9 as
select d.MAHD ,k.TENKH , k.DIACHI , k.DT 
from HOADON d 
inner join KHACHHANG k on d.MAKH = k.MAKH 
where d.NGAY = '25/5/2000'
select * from view_cau9
--10.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của những hóa đơn trong tháng 6/2010.
create view view_cau10 as
select d.MAHD ,d.NGAY,k.TENKH , k.DIACHI , k.DT 
from HOADON d 
inner join KHACHHANG k on d.MAKH = k.MAKH 
where MONTH(d.NGAY) = 6 and YEAR(d.NGAY) = 2000 
select * from view_cau10
--11.	Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại) đã mua hàng trong tháng 6/2010.
create view view_cau11 as
select k.TENKH , k.DIACHI , k.DT 
from HOADON d 
inner join KHACHHANG k on d.MAKH = k.MAKH 
where MONTH(d.NGAY) = 6 and YEAR(d.NGAY) = 2000 

select * from view_cau11
--12.	Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm các thông tin tên khách hàng, địa chỉ, số điện thoại.


create view view_cau12 as
select k.TENKH , k.DIACHI,k.DT
from KHACHHANG k
except
select k.TENKH , k.DIACHI , k.DT 
from HOADON d 
inner join KHACHHANG k on d.MAKH = k.MAKH 
where MONTH(d.NGAY) = 6 and YEAR(d.NGAY) = 2000 

select * from view_cau12
--13.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng).
create view view_cau13 as
select c.MAHD , c.MAVT , v.TENVT , v.DVT , c.GIABAN , v.GIAMUA , c.SL , (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban]
from CHITIETHOADON c
inner join VATTU v on v.MAVT = c.MAVT 

select * from view_cau13
--14.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.
create view view_cau14 as
select c.MAHD , c.MAVT , v.TENVT , v.DVT , c.GIABAN , v.GIAMUA , c.SL , (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban]
from CHITIETHOADON c
inner join VATTU v on v.MAVT = c.MAVT 
where c.GIABAN >= v.GIAMUA

select * from view_cau14
--15.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) và cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn SL lớn hơn 100.
create view view_cau15 as
select c.MAHD , c.MAVT , v.TENVT , v.DVT , c.GIABAN , v.GIAMUA , c.SL , (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban],(case when c.SL > 100 then 10
																															else NULL end) as [KHUYEN MAI]
from CHITIETHOADON c
inner join VATTU v on v.MAVT = c.MAVT 

select * from view_cau15
--16.	Tìm ra những mặt hàng chưa bán được.
create view view_cau16 as
select *  
from VATTU v 
where  v.MAVT not in(select distinct MAVT from CHITIETHOADON c) 

select * from view_cau16
--17.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
create view view_cau17 as
select h.MAHD , h.NGAY , k.TENKH , k.DIACHI , k.DT , v.TENVT , v.DVT , v.GIAMUA , c.GIABAN , c.SL ,  (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT 

select * from view_cau17
--18.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
create view view_cau18 as
select h.MAHD , h.NGAY , k.TENKH , k.DIACHI , k.DT , v.TENVT , v.DVT , v.GIAMUA , c.GIABAN , c.SL ,  (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT 
where MONTH(h.NGAY) = 5 and YEAR(h.NGAY) = 2000 

select * from view_cau18
--19.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
create view view_cau19 as
select h.MAHD , h.NGAY , k.TENKH , k.DIACHI , k.DT , v.TENVT , v.DVT , v.GIAMUA , c.GIABAN , c.SL ,  (v.GIAMUA*c.SL) [tri gia mua] , (c.GIABAN * c.SL) [tri gai ban]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT 
where MONTH(h.NGAY) = 1 or MONTH(h.NGAY) = 2 or MONTH(h.NGAY) = 3 and YEAR(h.NGAY) = 2000

select * from view_cau19
--20.	Lấy ra danh sách các hóa đơn gồm các thông tin: mã hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của  hóa đơn.= sum(sl*giaban)
create view view_cau20 as
select h.MAHD , h.NGAY , k.TENKH , k.DIACHI , (c.GIABAN*c.SL) [gia tri hoa don]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT
select * from view_cau20
--21.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
create view view_cau21 as
select top 1 with ties h.MAHD , h.NGAY , k.TENKH , k.DIACHI , (c.GIABAN*c.SL) [gia tri hoa don]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT
order by [gia tri hoa don] desc

select * from view_cau21
--22.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
create view view_cau22 as
select top 1 with ties h.MAHD , h.NGAY , k.TENKH , k.DIACHI , (c.GIABAN*c.SL) [gia tri hoa don]
from HOADON h 
inner join KHACHHANG k on k.MAKH = h.MAKH
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT 
where MONTH(h.NGAY) = 5 and YEAR(h.NGAY) = 2000 
order by [gia tri hoa don] desc

select * from view_cau22
--23.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn
create view view_cau23 as
select k.MAKH , count(h.MAHD)[so hoa don] 
from HOADON h
inner join KHACHHANG k on k.MAKH = h.MAKH
group by k.MAKH 

select * from view_cau23
--24.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.
create view view_cau24 as
select k.MAKH , MONTH(h.NGAY) as[thang] , count(h.MAHD)[so hoa don] 
from HOADON h
inner join KHACHHANG k on k.MAKH = h.MAKH
group by k.MAKH ,  MONTH(h.NGAY)

select * from view_cau24
--25.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
create view view_cau25 as
select top 1 with ties k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL , count(h.MAHD)[so hoa don] 
from HOADON h
inner join KHACHHANG k on k.MAKH = h.MAKH
group by k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL
order by [so hoa don] desc
 
select * from view_cau25
--26.	Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.
create view view_cau26 as
select top 1 with ties k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL , sum(c.SL)[so luong mua] 
from HOADON h
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join KHACHHANG k on k.MAKH = h.MAKH
group by k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL
order by [so luong mua] desc
 
select * from view_cau26
--27.	Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.
create view view_cau27 as
select top 1 with ties v.MAVT , v.TENVT , v.DVT , count(c.MAHD)[so hoa don] 
from HOADON h
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT
group by v.MAVT , v.TENVT , v.DVT 
order by [so hoa don] desc

select * from view_cau27
--28.	Lấy ra các thông tin về các mặt hàng mà được bán sl nhiều nhất.
create view view_cau28 as
select top 1 with ties v.MAVT , v.TENVT , v.DVT , sum(c.SL)[so luong] 
from HOADON h
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join VATTU v on v.MAVT = c.MAVT
group by v.MAVT , v.TENVT , v.DVT 
order by [so luong] desc

select * from view_cau28
--29.	Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ, số lượng hóa đơn đã mua (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn để trống)
create view view_cau29 as
select k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL , case when count(c.MAHD) > 0 then count(c.MAHD) 
																			else '' end as [so luong hoa don da mua]
from HOADON h
inner join CHITIETHOADON c on c.MAHD = h.MAHD
inner join KHACHHANG k on k.MAKH = h.MAKH
group by k.MAKH , k.TENKH , k.DIACHI , k.DT , k.EMAIL

select * from view_cau29

