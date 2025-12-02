use QLNhanVienDB;
go

if object_id('V_NhanVienNu_6Thang', 'V') is not null drop view V_NhanVienNu_6Thang;
go

create view V_NhanVienNu_6Thang
as
select nv.*
from NhanVien nv
join HopDong hd ON nv.MaNV = hd.MaNV
where nv.GioiTinh = N'Nữ'	
	and datediff(month, hd.NgayBatDau, getdate()) >= 6;
go

create index IX_NhanVien_GioiTinh on NhanVien(GioiTinh);
create index IX_HopDong_NgayBatDau on HopDong(NgayBatDau);
create index IX_HopDong_MaNV on HopDong(MaNV);
go

if object_id('V_SapHetHanHopDong', 'V') is not null drop view V_SapHetHanHopDong;
go

create view V_SapHetHanHopDong 
as
select nv.MaNV, nv.HoTen, hd.MaHD, hd.NgayKetThuc
from NhanVien nv
join HopDong hd on nv.MaNV = hd.MaNV
where datediff(month, getdate(), hd.NgayKetThuc) = 1;
go

create index IX_HopDong_NgayKetThuc on HopDong(NgayKetThuc);
go

if object_id('V_Luong_TheoPhong', 'V') is not null drop view V_Luong_TheoPhong;
go

create view V_Luong_TheoPhong
as
select pb.MaPB, pb.TenPB, nv.MaNV, nv.HoTen, nv.ChucVu, l.LuongCoBan, l.HeSoPhuCap, (l.LuongCoBan * l.HeSoPhuCap) as TongLuong
from NhanVien nv
join PhongBan pb on nv.MaPhongBan = pb.MaPB
join Luong l on nv.BacLuong = l.BacLuong;
go

create index IX_NhanVien_MaPhongBan on NhanVien(MaPhongBan);
create index IX_Luong_BacLuong on Luong(BacLuong);
go

if object_id('V_SoNhanVien_TheoLoaiHD', 'V') is not null drop view V_SoNhanVien_TheoLoaiHD;
go

create view V_SoNhanVien_TheoLoaiHD
as
select LoaiHD, count(*) as SoNhanVien
from HopDong
group by LoaiHD;
go

if object_id('V_QuyLuong_Phong', 'V') is not null drop view V_QuyLuong_Phong;
go

create view V_QuyLuong_Phong
as
select pb.MaPB, pb.TenPB,
	sum(l.LuongCoBan * l.HeSoPhuCap) as QuyLuong
from NhanVien nv
join Luong l on nv.BacLuong = l.BacLuong
join PhongBan pb on nv.MaPhongBan = pb.MaPB
group by pb.MaPB, pb.TenPB;
go

if object_id('V_Phong_QuyLuong_Max', 'V') is not null drop view V_Phong_QuyLuong_Max;
if object_id('V_Phong_QuyLuong_Min', 'V') is not null drop view V_Phong_QuyLuong_Min;
go

create view V_Phong_QuyLuong_Max
as
select top 1 *
from V_QuyLuong_Phong
order by QuyLuong desc;
go

create view V_Phong_QuyLuong_Min
as
select top 1 *
from V_QuyLuong_Phong
order by QuyLuong asc;
go

if object_id('V_NVNam_Tuoi27', 'V') is not null drop view V_NVNam_Tuoi27;
GO

create view V_NVNam_Tuoi27
as
select nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, nv.SDT, nv.DiaChi, nv.ChucVu,
       nv.BacLuong, nv.MaPhongBan
from NhanVien nv
where nv.GioiTinh = N'Nam'
  and datediff(year, nv.NgaySinh, getdate()) <= 27;
go

if object_id('V_ThamNien_2Nam', 'V') is not null drop view V_ThamNien_2Nam;
go

create view V_ThamNien_2Nam
as
select nv.MaNV, nv.HoTen, nv.NgaySinh, nv.GioiTinh, nv.SDT, nv.DiaChi, nv.ChucVu,
       nv.BacLuong, nv.MaPhongBan, hd.NgayBatDau
from NhanVien nv
join HopDong hd on nv.MaNV = hd.MaNV
where datediff(year, hd.NgayBatDau, getdate()) >= 2;
go