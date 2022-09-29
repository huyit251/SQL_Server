﻿USE MASTER 
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'QLCB')
	DROP DATABASE QLCB
GO
CREATE DATABASE QLCB
ON (NAME='QLCB_DATA' , FILENAME ='F:\DataSet\QLCB_DATABASE\QLCB.MDF')
LOG ON (NAME ='QLCB_LOG',FILENAME='F:\DataSet\QLCB_DATABASE\QLCB.LDF')
GO
use QLCB
create table maybay(
	mamb int primary key,
	loai varchar(50),
	tambay int
)
go
create table chuyenbay(
	macb char(5) primary key ,
	gadi varchar(50),
	gaden varchar(50),
	dodai int , 
	giodi time,
	gioden time,
	chiphi int,
	mamb int 

	foreign key (mamb) references maybay(mamb)
)
go
create table nhanvien(
	manv char(9) primary key,
	ten nvarchar(50),
	luong int
)
go
create table chungnhan(
	manv char(9) ,
	mamb int 
	
	primary key (manv,mamb)
)
go
alter table chungnhan
	add constraint fk_chungnhan foreign key (manv) references nhanvien(manv)
alter table chungnhan 
	add constraint fk_chungnhan2 foreign key (mamb) references maybay(mamb)
-- CHỌN VÀ KẾT
--1)	Cho biết các chuyến bay đi Đà Lạt (DAD).
select * 
from chuyenbay 
where gaden = 'DAD'
--2)	Cho biết các loại máy bay có tầm bay lớn hơn 10,000km.
select *
from maybay
where tambay > 10000
--3)	Tìm các nhân viên có lương nhỏ hơn 10,000.
select *
from nhanvien 
where luong < 10000
--4)	Cho biết các chuyến bay có độ dài đường bay nhỏ hơn 10.000km và lớn hơn 8.000km.
select *
from chuyenbay 
where dodai between 8000 and 10000
--5)	Cho biết các chuyến bay xuất phát từ Sài Gòn (SGN) đi Ban Mê Thuộc (BMV).
select *
from chuyenbay 
where gadi = 'SGN' and gaden = 'BMV'
--6)	Có bao nhiêu chuyến bay xuất phát từ Sài Gòn (SGN).
select count(gadi) as [Số lượng chuyến bay xuất phát từ Sài gon]
from chuyenbay 
where gadi = 'SGN'
group by gadi
--7)	Có bao nhiêu loại máy báy Boeing.
select *
from maybay 
where loai like '%Boeing %'
--8)	Cho biết tổng số lương phải trả cho các nhân viên.
select sum(luong) as [ Tống số lương phải trả cho nhân viên]
from nhanvien 
--9)	Cho biết mã số của các phi công lái máy báy Boeing.
select n.manv , n.ten , n.luong , m.mamb, m.loai , m.tambay
from nhanvien n , maybay m , chungnhan c 
where n.manv = c.manv and m.mamb = c.mamb and c.mamb in (select mamb from maybay where loai like '%Boeing%')
--10)	Cho biết các nhân viên có thể lái máy bay có mã số 747.
select  n.manv , n.ten,c.mamb
from nhanvien n , chungnhan c
where n.manv = c.manv  and c.mamb = 747
--11)	Cho biết mã số của các loại máy bay mà nhân viên có họ Nguyễn có thể lái.
select n.manv , n.ten , c.mamb
from nhanvien n , chungnhan c 
where n.manv = c.manv and n.ten like N'%Nguyễn%'
--12)	Cho biết mã số của các phi công vừa lái được Boeing vừa lái được Airbus.
select distinct n.manv , n.ten 
from nhanvien n , chungnhan c1 , chungnhan c2
where n.manv = c1.manv and n.manv = c2.manv and c1.mamb in (select mamb from maybay m1 where m1.loai like '%Boeing%') and c2.mamb in (select mamb from maybay m2 where m2.loai like '%Airbus%') 
--13)	Cho biết các loại máy bay có thể thực hiện chuyến bay VN280.
select m.loai , cb.macb
from maybay m , chuyenbay cb
where m.mamb = cb.mamb and cb.macb = 'VN280'
--14)	Cho biết các chuyến bay có thể được thực hiện bởi máy bay Airbus A320.
select *
from chuyenbay cb 
where cb.mamb in (select mamb from maybay where loai like '%Airbus A320%')
--15)	Cho biết tên của các phi công lái máy bay Boeing.
select distinct n.ten as [ten phi cong]
from nhanvien n , chungnhan c 
where n.manv = c.manv and c.mamb in (select mamb from maybay where loai like '%Boeing%')
--16)	Với mỗi loại máy bay có phi công lái cho biết mã số, loại máy báy và tổng số phi công có thể lái loại máy bay đó.
select c.mamb , m.loai , count(c.mamb) as [tong so phi cong lai ]
from chungnhan c , maybay m
where c.mamb = m.mamb 
group by c.mamb , m.loai 
--17)	Giả sử một hành khách muốn đi thẳng từ ga A đến ga B rồi quay trở về ga A. Cho biết các đường bay nào có thể đáp ứng yêu cầu này.
select *
from chuyenbay cb1 , chuyenbay cb2 
where cb1.gaden = cb2.gadi and cb2.gaden = cb1.gadi
--GOM NHÓM
--18)	Với mỗi ga có chuyến bay xuất phát từ đó cho biết có bao nhiêu chuyến bay khởi hành từ ga đó.
select cb1.gadi , count(gadi) as [so chuyen bay khoi hanh] 
from chuyenbay cb1 
group by gadi 
--19)	Với mỗi ga có chuyến bay xuất phát từ đó cho biết tổng chi phí phải trả cho phi công lái các chuyến bay khởi hành từ ga đó.
select gadi , sum(chiphi) as [chi phi tra cho phi cong]
from chuyenbay 
group by gadi
--20)	Với mỗi địa điểm xuất phát cho biết có bao nhiêu chuyến bay có thể khởi hành trước 12:00.
select gadi , count(giodi) as [so chuyen bay khoi hanh truoc 12:00]
from chuyenbay
where time(giodi) <= 12
group by gadi
--21)	Cho biết mã số của các phi công chỉ lái được 3 loại máy bay.
select c.manv , count(m.mamb) as [so luong may bay phi cong co the lai]
from chungnhan c , maybay m
where  c.mamb = m.mamb 
group by c.manv 
having count(m.mamb) = 3
--22)	Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số phi công và tầm bay lớn nhất của các loại máy bay mà phi công đó có thể lái.
select c.manv ,max(m.tambay) as [tam bay lon nhat], count(m.mamb) as [so luong may bay phi cong co the lai]
from chungnhan c , maybay m
where  c.mamb = m.mamb 
group by c.manv 
having count(m.mamb) > 3
--23)	Với mỗi phi công cho biết mã số phi công và tổng số loại máy bay mà phi công đó có thể lái.
select c.manv , count(m.mamb) as [so luong may bay phi cong co the lai]
from chungnhan c , maybay m
where  c.mamb = m.mamb 
group by c.manv 
--24)	Cho biết mã số của các phi công có thể lái được nhiều loại máy bay nhất.
select top 1 c.manv , count(m.mamb) as [so loai may bay]
from chungnhan c , maybay m
where  c.mamb = m.mamb 
group by c.manv 
order by [so loai may bay] desc
--25)	Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất.
select  c.manv , count(m.mamb) as [so loai may bay]
from chungnhan c , maybay m
where  c.mamb = m.mamb 
group by c.manv 
having count(m.mamb) in (select top 1 count(m1.mamb) from chungnhan c1 , maybay m1 where c1.mamb = m1.mamb group by c1.manv order by count(m1.mamb) asc)
-- TRUY VẤN LỒNG 
--26)	Tìm các nhân viên không phải là phi công.
select n.ten , n.manv 
from nhanvien n
where n.manv not in (select c.manv from chungnhan c )
--27)	Cho biết mã số của các nhân viên có lương cao nhất.
select n.manv , n.ten
from nhanvien n 
where n.luong >= all( select top 1 n1.luong from nhanvien n1 order by n1.luong desc)
--28)	Cho biết tổng số lương phải trả cho các phi công.
select sum(n.luong) as [tong so luong tra cho phi cong]
from nhanvien n 
where n.manv in (select c.manv from chungnhan c)
--29)	Tìm các chuyến bay có thể được thực hiện bởi tất cả các loại máy bay Boeing.
select * 
from chuyenbay cb 
where cb.mamb in (select m.mamb from maybay m where m.loai like '%Boeing%')
--30)	Cho biết mã số của các máy bay có thể được sử dụng để thực hiện chuyến bay từ Sài Gòn (SGN) đến Huế (HUI).
select  m.mamb , m.tambay
from maybay m
where m.tambay >= (select cb.dodai from chuyenbay cb where cb.gadi = 'SGN' and cb.gaden ='HUI')
--31)	Tìm các chuyến bay có thể được lái bởi các phi công có lương lớn hơn 100,000.
select *
from chuyenbay cb 
where cb.mamb in (select m.mamb from maybay m where m.mamb in 
				(select distinct c.mamb from chungnhan c where c.manv in 
				(select n.manv from nhanvien n where n.luong >100000)))
--32)	Cho biết tên các phi công có lương nhỏ hơn chi phí thấp nhất của đường bay từ Sài Gòn (SGN) đến Buôn Mê Thuộc (BMV).
--33)	Cho biết mã số của các phi công có lương cao nhất.
--34)	Cho biết mã số của các nhân viên có lương cao thứ nhì.
--35)	Cho biết mã số của các nhân viên có lương cao thứ nhất hoặc thứ nhì.
--36)	Cho biết tên và lương của các nhân viên không phải là phi công và có lương lớn hơn lương trung bình của tất cả các phi công.
--37)	Cho biết tên các phi công có thể lái các máy bay có tầm bay lớn hơn 4,800km nhưng không có chứng nhận lái máy bay Boeing.
--38)	Cho biết tên các phi công lái ít nhất 3 loại máy bay có tầm bay xa hơn 3200km.
