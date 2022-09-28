﻿USE MASTER 
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'QLSV')
	DROP DATABASE QLSV
GO
CREATE DATABASE QLSV
ON (NAME='QLSV_DATA' , FILENAME ='F:\DataSet\QLSV_DATABASE\QLSV.MDF')
LOG ON (NAME ='QLSV_LOG',FILENAME='F:\DataSet\QLSV_DATABASE\QLSV.LDF')
GO 
USE QLSV 
CREATE TABLE LOP(
	MALOP CHAR(7) PRIMARY KEY,
	TENLOP NVARCHAR(50),
	SISO TINYINT
)
GO 
CREATE TABLE MONHOC(
	MAMH CHAR(6) PRIMARY KEY,
	TENMH NVARCHAR(50),
	TCLT TINYINT,
	TCTH TINYINT
)
GO 
CREATE TABLE SINHVIEN(
	MSSV CHAR(6) PRIMARY KEY,
	HOTEN NVARCHAR(50),
	NTNS DATE ,
	PHAI BIT,
	MALOP CHAR(7)
	
	FOREIGN KEY (MALOP) REFERENCES LOP(MALOP) 
)
GO 
CREATE TABLE DIEMSV(
	MSSV CHAR(6) ,
	MAMH CHAR(6) ,
	DIEM DECIMAL(3,1)

	PRIMARY KEY (MSSV,MAMH) 
)
GO
ALTER TABLE DIEMSV 
	ADD CONSTRAINT FK_DIEMSV FOREIGN KEY(MSSV) REFERENCES SINHVIEN(MSSV)
ALTER TABLE DIEMSV 
	ADD CONSTRAINT FK_DIEMSV1 FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)
--CÂU 1 : THÊM MỘT DÒNG MỚI VÀO BẢNG SINHVIEN 
INSERT INTO SINHVIEN VALUES
	('190001',N'Đào Thị Tuyết Hoa','08/03/2001',0,'19DTH02')
--CÂU 2 : HÃY ĐỔI TÊN MÔN HỌC 'LÝ THUYẾT ĐỒ THỊ'THÀNH 'TOÁN RỜI RẠC'
UPDATE MONHOC
SET TENMH = N'Toán rời rạc'
WHERE TENMH = N'LÝ THUYẾT ĐỒ THỊ'
--CÂU 3 : HIỆN THỊ TÊN CÁC MÔN HỌC KHÔNG CÓ THỰC HÀNH 
SELECT TENMH
FROM MONHOC 
WHERE TCTH = 0
--CÂU 4 : HIỆN THỊ TÊN CÁC MÔN HỌC VỪA CÓ LÝ THUYẾT VỪA CÓ THỰC HÀNH
SELECT TENMH 
FROM MONHOC
WHERE TCTH <> 0 AND TCLT <> 0 
--CÂU 5 : IN RA TÊN CÁC MÔN HỌC CÓ KÝ TỰ ĐẦU CỦA TÊN ALF CHỮ 'C'
SELECT TENMH 
FROM MONHOC
WHERE TENMH LIKE('C%')
--CÂU 6 : LIỆT KÊ THÔNG TIN NHỮNG SINH VIÊN MÀ HỌ CHỨA CHỮ 'THỊ'
SELECT * 
FROM SINHVIEN
WHERE HOTEN LIKE (N'_%Thị%_')
--Câu 7 : IN RA 2 LỚP CÓ SĨ SỐ ĐÔNG NHẤT (BẰNG NHIỀU CÁCH) . HIỂN THỊ : MÃ LỚP , TÊN SỈ SỐ , NHẬN XET?
--CÁCH 1 : 
SELECT TOP 2 MALOP,TENLOP,SISO
FROM LOP
ORDER BY SISO DESC
--CÁCH 2 : 
SELECT TOP 2 MALOP ,TENLOP , SISO
FROM LOP
WHERE SISO = (SELECT MAX(SISO) FROM LOP) OR SISO =(SELECT MAX(L1.SISO)
													FROM LOP L1 
													WHERE L1.SISO  != (SELECT MAX(L2.SISO) 
																		FROM LOP L2 ))
--CÂU 8 : IN DANH SACH SV THEO TỪNG LỚP : MSSV ,HOTEN , NAMSINH , PHAI 
SELECT MSSV , HOTEN, NTNS ,PHAI,MALOP
FROM SINHVIEN 
ORDER BY MALOP 
--CÂU 9 : CHO BIẾT NHỮNG SINH VIÊN CÓ TUỔI >= 20 , THÔNG TIN GỒM : HỌ TÊN SINH VIÊN , NGÀY SINH , TUỔI
SELECT MSSV , HOTEN, NTNS , (2022-YEAR(NTNS)) AS TUOI
FROM SINHVIEN 
GROUP BY MSSV ,HOTEN,NTNS
HAVING (2022 -YEAR(NTNS))>= 20  
--CÂU 10 : LIỆT KÊ CÁC MÔN HỌC SV ĐÃ DỰ HTI NHỮNG CHƯA CÓ ĐIỂM 
SELECT M.TENMH 
FROM MONHOC M , DIEMSV D
WHERE M.MAMH = D.MAMH AND  D.DIEM IS NULL
--CÂU 11 :LIỆT KÊ KẾT QUẢ HỌC TẬP CỦA SV CÓ MÃ SỐ 170001 . HIỆN THỊ : MSSV ,HOTEN , TENMH , DIEM 
 SELECT S.MSSV ,S.HOTEN , M.TENMH , D.DIEM 
 FROM SINHVIEN S , DIEMSV D , MONHOC M 
 WHERE S.MSSV = D.MSSV  AND D.MAMH = M.MAMH AND S.MSSV = '170001'
 --CÂU 12 : LIỆT KÊ TÊN SINH VIÊN VÀ MÃ MÔN HỌC MÀ SV ĐÓ ĐĂNG KÝ VỚI ĐIỂM TRÊN 7 
 SELECT S.HOTEN , M.MAMH
 FROM SINHVIEN S 
 JOIN DIEMSV D ON D.MSSV = S.MSSV
 JOIN MONHOC M ON M.MAMH = D.MAMH
 WHERE D.DIEM > 7
 --CÂU 13 : LIỆT KE TÊN MÔN HỌC CÙNG SỐ LƯỢNG SV ĐÃ HỌC VÀ ĐÃ CÓ ĐIỂM 
 SELECT M.TENMH , COUNT (D.MAMH) AS SOLUONG_SV
 FROM MONHOC M 
 JOIN DIEMSV D ON D.MAMH = M.MAMH
 WHERE D.DIEM IS NOT NULL
 GROUP BY M.TENMH , D.MAMH
 HAVING COUNT(D.MAMH) IN (SELECT [SOLUONG] FROM (SELECT COUNT ( MSSV) AS [SOLUONG], M.TENMH FROM DIEMSV D INNER JOIN MONHOC M ON D.MAMH = M.MAMH WHERE D.DIEM IS NOT NULL GROUP BY M.TENMH)TB1
 GROUP BY [SOLUONG]
 HAVING COUNT([SOLUONG]) >1)
 --CÂU 14 : LIỆT KÊ TÊN SV VÀ ĐIỂM TRUNG BÌNH CỦA SINH VIÊN ĐÓ
 SELECT S.HOTEN , AVG(DIEM) AS DIEM_TRUNG_BINH
 FROM SINHVIEN S 
 JOIN DIEMSV D ON D.MSSV = S.MSSV
 GROUP BY S.HOTEN
 --CÂU 15  : LIỆT KÊ TÊN SINH VIÊN ĐẠT ĐIỂM CAO NHẤT CỦA MÔN HỌC 'KỸ THUẬT LẬP TRÌNH ' 
 SELECT S.HOTEN , D.DIEM
 FROM SINHVIEN S 
 JOIN DIEMSV D ON D.MSSV = S.MSSV
 WHERE D.DIEM = ALL (SELECT MAX(DIEM) FROM DIEMSV WHERE MAMH = (SELECT MAMH FROM MONHOC WHERE TENMH like N'%Kỹ thuật lập trình%'))
 GROUP BY S.HOTEN,D.DIEM
-- CÂU 16 : LIỆT KÊ SINH VIÊN CÓ ĐIỂM TRUNG BÌNH CAO NHẤT 
SELECT S.HOTEN , AVG(DIEM) AS DIEM_TRUNG_BINH
 FROM SINHVIEN S 
 JOIN DIEMSV D ON D.MSSV = S.MSSV
 GROUP BY S.HOTEN
 HAVING AVG(DIEM) = ALL (SELECT MAX(DIEM) FROM DIEMSV )
--CÂU 17 :  LIỆT KÊ SINH VIÊN CHƯA HỌC MÔN 'TOÁN RỜI RẠC'
SELECT MSSV ,HOTEN 
FROM SINHVIEN 
WHERE MSSV != ALL (SELECT S.MSSV
FROM SINHVIEN S 
JOIN DIEMSV D ON D.MSSV = S.MSSV            
WHERE D.MAMH =(SELECT MAMH FROM MONHOC WHERE TENMH LIKE N'%Toán rời rạc%'))
--CÂU 18 : CHO BIẾT SINH VIÊN CÓ NĂM SINH CÙNG VỚI SINH VIÊN TÊN ' DANH '
SELECT HOTEN,YEAR(NTNS) 
FROM SINHVIEN 
WHERE HOTEN NOT LIKE '%DANH%' AND YEAR(NTNS) = ALL (SELECT YEAR(NTNS) FROM SINHVIEN WHERE HOTEN LIKE '%DANH%')
--CÂU 19 : CHO BIẾT TỔNG SINH VIÊN VÀ TỔNG SỐ SINH VIÊN NỮ 
SELECT COUNT(MSSV) AS TONG_SINHVIEN , SUM(CASE PHAI WHEN 0 THEN 1 END) AS SL_SINHVIEN_NU
FROM SINHVIEN
--CÂU 20 : CHO BIẾT DANH SÁCH CÁC SINH VIÊN RỚT ÍT NHẤT 1 MÔN (TEST LẠI)
SELECT S.MSSV, S.HOTEN ,M.TENMH,D.DIEM 
FROM SINHVIEN S , DIEMSV D , MONHOC M 
WHERE S.MSSV = D.MSSV AND D.MAMH = M.MAMH AND D.DIEM <= 9
GROUP BY S.MSSV , S.HOTEN , M.TENMH , D.DIEM
HAVING COUNT(D.DIEM)  = 1
--CÂU 21 : CHO BIẾT MSSV , HOTENSV ĐÃ HỌC VÀ CÓ ĐIỂM ÍT NHẤT BA MÔN 
SELECT S.MSSV , S.HOTEN
FROM SINHVIEN S , DIEMSV D
WHERE S.MSSV = D.MSSV AND D.DIEM > 0
GROUP BY S.MSSV , S.HOTEN 
HAVING COUNT(S.MSSV) >= 3 
--CÂU 22 : IN DANH SÁCH SINH VIÊN CÓ ĐIỂM MÔN 'KĨ THUẬT LẬP TRÌNH' CAO NHẤT THEO TỪNG LỚP 
--CÁCH 1 : 
SELECT HOTEN,TENLOP,DIEM 
FROM (
SELECT S.HOTEN,L.TENLOP,D.DIEM,ROW_NUMBER() OVER (PARTITION BY L.TENLOP ORDER BY D.DIEM DESC ) AS RANK
FROM DIEMSV D 
JOIN SINHVIEN S ON D.MSSV = S.MSSV 
JOIN MONHOC M ON M.MAMH = D.MAMH 
JOIN LOP L ON L.MALOP = S.MALOP 
WHERE M.TENMH = N'Kỹ thuật lập trình'
)DIEM WHERE RANK = 1
--CÁCH 2 
SELECT * 
FROM SINHVIEN S , DIEMSV D , MONHOC M 
WHERE S.MSSV = D.MSSV AND M.MAMH = D.MAMH AND M.TENMH =N'Kỹ thuật lập trình' 
AND D.DIEM = (SELECT MAX(DIEM) 
			FROM SINHVIEN S1 , DIEMSV D1 , MONHOC M1 
			WHERE S1.MSSV = D1.MSSV  AND M1.MAMH = D1.MAMH AND M1.TENMH = N'Kỹ thuật lập trình' AND S.MALOP = S1.MALOP )
 --CÂU 23 : IN DANH SÁCH SINH VIÊN CÓ ĐIỂM CAO NHẤT THEO TỪNG MÔN , TỪNG LỚP 
 --CÁCH 1 :
 SELECT HOTEN,TENLOP,TENMH,DIEM 
 FROM ( 
 SELECT S.HOTEN,L.TENLOP,D.DIEM,M.TENMH,ROW_NUMBER() OVER (PARTITION BY L.TENLOP,M.TENMH ORDER BY D.DIEM DESC) AS RANK 
 FROM DIEMSV D 
 JOIN SINHVIEN S ON D.MSSV = S.MSSV
 JOIN MONHOC M ON M.MAMH = D.MAMH
 JOIN LOP L ON L.MALOP = S.MALOP
 )DIEM WHERE RANK = 1 AND DIEM >= 0
 --CÁCH 2 : 
 SELECT * 
 FROM SINHVIEN S , DIEMSV D , MONHOC M 
 WHERE S.MSSV =D.MSSV AND M.MAMH = D.MAMH  
 AND D.DIEM = (SELECT MAX(DIEM) 
				FROM SINHVIEN S1 , DIEMSV D1 , MONHOC M1 
				WHERE S1.MSSV = D1.MSSV AND M1.MAMH = D1.MAMH AND S.MALOP = S1.MALOP )
 --CÂU 24: CHO BIẾT SINH VIÊN ĐẠT ĐIỂM CAO NHẤT TỪNG MÔN 
 SELECT HOTEN ,TENMH , DIEM 
 FROM(
 SELECT S.HOTEN,D.DIEM,M.TENMH,ROW_NUMBER() OVER (PARTITION BY M.TENMH ORDER BY D.DIEM DESC) AS RANK 
 FROM DIEMSV D 
 JOIN SINHVIEN S ON D.MSSV = S.MSSV 
 JOIN MONHOC M ON M.MAMH =D.MAMH 
 JOIN LOP L  ON L.MALOP =S.MALOP
 )DIEM WHERE RANK =1  AND DIEM >= 0
 --CÂU 25 : CHO BIẾT MSSV , HOTEN SV CHƯA ĐĂNG KÝ HỌC MÔN NÀO 
 SELECT MSSV ,HOTEN 
 FROM SINHVIEN
 WHERE MSSV NOT IN (SELECT MSSV FROM DIEMSV ) 
 GROUP BY MSSV , HOTEN
 --CACH 2 : 
 SELECT S.MSSV,S.HOTEN 
 FROM SINHVIEN S 
 LEFT JOIN DIEMSV D ON S.MSSV = D.MSSV 
 WHERE D.MAMH IS NULL
 --CÂU 26 : DANH SÁCH SINH VIÊN CÓ TẤT CẢ CÁC ĐIỂM ĐỀU 10 
 SELECT S.MSSV , S.HOTEN 
 FROM SINHVIEN S , DIEMSV D 
 WHERE S.MSSV = D.MSSV AND D.DIEM = 10 
 GROUP BY S.MSSV ,S.HOTEN
 HAVING COUNT(MAMH) = ALL (SELECT COUNT(MAMH) FROM MONHOC)
 --CÂU 27 :  ĐẾM SỐ SINH VIÊN NAM , NỮ THEO TỪNG LỚP 
 SELECT MALOP , COUNT(CASE WHEN PHAI = 1 THEN 1 END) AS 'SINHVIENNAM',
			COUNT(CASE WHEN PHAI = 0 THEN 0 END) AS 'SINHVIENNU'
FROM SINHVIEN 
GROUP BY MALOP
--CÂU 28 : CHO BIẾT NHỮNG SINH VIÊN ĐÃ HỌC TẤT CẢ CÁC MÔN NHƯNG KHÔNG RỚT MÔN NÀO 
SELECT S.MSSV , S.HOTEN 
FROM SINHVIEN S , DIEMSV D
WHERE S.MSSV = D.MSSV AND S.MSSV NOT IN (SELECT MSSV FROM DIEMSV WHERE DIEM IS NULL) 
GROUP BY S.MSSV , S.HOTEN
HAVING MIN(D.DIEM) >= 5 
--CÂU 29 : XÓA TẤT CẢ SINH VIÊN CHƯA DỰ THI MÔN NÀO 
DELETE
FROM SINHVIEN 
WHERE MSSV NOT IN (SELECT DISTINCT S.MSSV FROM SINHVIEN S , DIEMSV D WHERE S.MSSV = D.MSSV AND D.DIEM IS NOT NULL)

--CÂU 30 : TẤT CẢ MÔN ĐÃ ĐƯỢC TẤT CẢ CÁC SINH VIÊN ĐĂNG KÝ HỌC 
SELECT TENMH 
FROM MONHOC M , DIEMSV D 
WHERE M.MAMH = D.MAMH 
GROUP BY TENMH 
HAVING COUNT(D.MAMH) = (SELECT COUNT(MSSV) FROM SINHVIEN)